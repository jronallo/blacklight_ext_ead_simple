namespace :eads do
  desc 'delete all from solr'
  task :delete_solr => :environment do
    docs = Blacklight.solr.find_all_eadids
    docs.each do |doc|
      doc_id = doc['id']
      puts doc_id
      pp Blacklight.solr.delete_by_id(doc_id)
    end
    pp Blacklight.solr.commit
  end


  desc "fetch all updated ead xml for each ead"
  task :fetch_all => :environment do
    eads = Ead.all
    eads.each do |ead|
      ENV['EADID'] = ead.eadid
      Rake::Task["eads:fetch"].invoke
      Rake::Task["eads:fetch"].reenable
    end
    Blacklight.solr.commit
  end

  desc "fetch updated ead xml for each ead"
  task :fetch => :environment do
    (puts 'no EADID'; exit) if !ENV['EADID']
    ENV['NOSOLRCOMMIT'] = 'true'
    ead = Ead.find(ENV['EADID'])
    puts; puts ead.eadid
    if ead.save!
      puts "saved: " + ead.eadid
    else
      puts "NOT SAVED: " + ead.eadid
    end
  end


end

namespace :solr do
  def fetch_env_file
    f = ENV['FILE']
    raise "Invalid file. Set the location of the file by using the FILE argument." unless f and File.exists?(f)
    f
  end


  namespace :index do
    #ripped directly from Blacklight demo application
    desc "index a directory of ead files"
    task :ead_dir=>:environment do
      input_file = ENV['FILE']
      if input_file =~ /\*/
        files = Dir[input_file].collect
      else
        files = [input_file]
      end
      files.each_with_index do |f,index|
        puts "indexing #{f}"
        ENV['FILE'] = f
        Rake::Task["solr:index:ead"].invoke
        Rake::Task["solr:index:ead"].reenable
      end
      pp Blacklight.solr.commit
    end

    desc "index ead sample data from NCSU"
    task :ead_sample_data => :environment do
      ENV['FILE'] = "#{RAILS_ROOT}/vendor/plugins/blacklight_ext_ead_simple/data/*"
      Rake::Task["solr:index:ead_dir"].invoke
    end

    # TODO Change this to index all the ua collection guides as well as manuscript
    # collections referred to within the db
    desc "Index an EAD file at FILE=<location-of-file>."
    task :ead=>:environment do
      require 'nokogiri'

      raw = File.read(fetch_env_file)
      # remove the default namespace,
      # otherwise every query needs a "default:" prefix,
      # and a namespace option
      raw.gsub!(/xmlns=".*"/, '')

      xml = Nokogiri::XML(raw)

      dao_value = xml.xpath('//dao').empty? ? false : true

      #gather subject fields splitting on --
      subject_fields = ['corpname','famname','occupation','persname', 'subject']
      subject = subject_fields.map do |field|
        xml.xpath('/ead/archdesc/controlaccess/' + field).map do |field_value|
          field_value.text.split('--').map do |value|
            value.strip.sub(/\.$/, '')
          end
        end
      end

      title = xml.at('//eadheader/filedesc/titlestmt/titleproper').text.gsub("\n",'').gsub(/\s+/, ' ').strip
      num = xml.at('//eadheader/filedesc/titlestmt/titleproper/num').text
      title.sub!(num, '(' + num + ')')
      title.sub!('Guide to the ', '')
      title.sub!('Preliminary Inventory of the ','')
      title.sub!('Preliminary Inventory to the ', '')
      title.sub!(/^North Carolina State University,\s/, '')

      solr_doc = {
        :format => 'ead',
        #:asset_type => 'Collection Guide',
        :format_facet => 'EAD',       
        :title_display => title,
        :institution_t => xml.at('//publicationstmt/publisher').text,
        #:language_facet => xml.at('//profiledesc/langusage/language').text.gsub(/\.$/, ''),
        :ead_filename_s => xml.at('//eadheader/eadid').text,
        :id => xml.at('/ead/eadheader/eadid').text.gsub(/\.xml/, ''),
        :xml_display => xml.to_xml,
        :text => xml.text,
        :dao_b => dao_value,
        :subject_topic_facet => subject.flatten.uniq
      }
      require 'pp'
      pp solr_doc[:title_display]
      if !solr_doc[:title_display].blank?
        response = Blacklight.solr.add solr_doc
        pp response; puts
      end
    end
  end
end

