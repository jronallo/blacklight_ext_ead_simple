def env_data
  @env_data ||= File.read 'config/environment.rb'
end

unless File.exists? 'vendor/plugins/blacklight'
  puts "The Blacklight Simple EAD Plugin requires that Blacklight be installed first"
  if yes?("Install Blacklight from a template ?")
    load_template "http://github.com/projectblacklight/blacklight/raw/master/template.rb"
  else
    puts "****ERROR: The Blacklight Simple EAD Plugin requires that Blacklight be installed first"
    exit 0
  end  
end
puts "\n* Blacklight Extension for Simple EAD Rails Template \n\n"

plugin_dirname = 'blacklight_ext_ead_simple'

tag = nil

plugin 'blacklight_ext_ead_simple', :git => 'git://github.com/jronallo/blacklight_ext_ead_simple.git'

if env_data.scan("config.gem 'nokogiri'").empty?
  gem 'nokogiri'
end

if yes?('Index sample EADs (you must start solr first) ?')
  rake("solr:index:ead_sample_data")
end





