module CatalogHelper

  def ead_increment_start(start)
    number = start[1,5].to_i + 1
    start_number = "%02d" % number
    'c' + start_number
  end

  def eadsax(doc)
    ead_xml = doc['xml_display'].first
    Eadsax::Ead.parse(ead_xml)
  end

end

