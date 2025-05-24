class Geo < ApplicationRecord
  belongs_to :greenspace, optional: true
  acts_as_taggable_on :amenities

  def self.load_from_xml save:false, file:nil
    return if file.nil?

    begin
      xml_str = File.read(file)
      return if xml_str.nil?

      xml = Nokogiri::XML(xml_str)
      gpx_list = xml.at('gpx//trk//trkseg').search("trkpt")
      gpx_list.map{ |x| Geo.new(lat: x['lat'], lon: x['lon'])}
    rescue Errno::ENOENT
      puts file
    end
  end
end
