module CatalogHelper
  def ead_link_id(element, xpath)
    element.attribute('id') || xpath.split('/').last
  end

  def ead_increment_start(start)
    number = start[1,5].to_i + 1
    start_number = "%02d" % number
    'c' + start_number
  end

  def ead_xpaths
    [
      ['Abstract', '/ead/archdesc/did/abstract', :text ],
      ["Biography/History",'/ead/archdesc/bioghist', :bioghist ],
      ['Scope and Content', '/ead/archdesc/scopecontent', :p],
      ['Arrangement', '/ead/archdesc/arrangement', :p],
      ['Collection Inventory', '/ead/archdesc/dsc', :dsc]
    ]
  end

  def ead_list(list)
    ol = ['<ol>']
    list.xpath('item').map do |item|
      ol << '<li>' + item.text + '</li>'
    end
    ol << '</ol>'
    ol.join('')
  end

  def ead_paragraphs(element)
    if element
      element.xpath('p').map do |p|
        if !p.xpath('list').blank?
          p.xpath('list').map do |list|
            '<p>' + ead_list(list) + '</p>'
          end
        else
          '<p>' +  p.text + '</p>'
        end

      end
    end
  end

  def ead_text(element, xpath)
    first = element.xpath(xpath).first
    if first
      first.text
    end
  end

  def ead_contents(document)
    xml = ead_xml(document)
    xpaths = ead_xpaths
    links = []
    xpaths.each do |pair|
      element = xml.xpath(pair[1]).first
      if element
        link_target = element.attribute('id') || pair[1].split('/').last
        #TODO add digital content
        links << link_to(pair[0], '#' + link_target) if link_target
      end
    end
    return links
  end

  def ead_xml(document)
    xml_doc = document['xml_display'].first
    xml_doc.gsub!(/xmlns=".*"/, '')
    xml_doc.gsub!('ns2:', '')
    Nokogiri::XML(xml_doc)
  end

  def dao(did, limit=4)
    dao = did.xpath('../dao')[0]
    if dao
      href = dao.attribute('href').text
      regex = /http:\/\/insight.+?Classification%20Number%7C1%7C((UA|MC|ua|mc)([0-9]{3}.){2}[0-9]{3}).+?gc=0/
      if href.match(regex)
        thumbnails, number_of_docs = classification_number_thumbnails($1, :limit => limit)
        if thumbnails
          return_string = '<div class="dao">' + thumbnails
          return_string << classification_see_more_link($1) if number_of_docs > limit
          return_string << '</div>'
        end
      else
        return ''
      end
    else
      return ''
    end
  end
  
end