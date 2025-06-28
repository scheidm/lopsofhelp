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

  def self.find_closest(lat:, lon:)
    # Earth's radius in kilometers
    earth_radius = 6371

    # Convert latitude and longitude to radians
    lat_rad = lat.to_f * Math::PI / 180
    lon_rad = lon.to_f * Math::PI / 180

    # Haversine formula to calculate distance
    closest = Geo.where.not(street_address: nil).min_by do |geo|
      geo_lat_rad = geo.lat.to_f * Math::PI / 180
      geo_lon_rad = geo.lon.to_f * Math::PI / 180

      dlon = geo_lon_rad - lon_rad
      dlat = geo_lat_rad - lat_rad

      a = Math.sin(dlat/2)**2 + Math.cos(lat_rad) * Math.cos(geo_lat_rad) * Math.sin(dlon/2)**2
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      earth_radius * c
    end

    closest
  end

  def self.calculate_distance(lat1:, lon1:, lat2:, lon2:)
    earth_radius = 6371 # Earth's radius in kilometers

    lat1_rad = lat1.to_f * Math::PI / 180
    lon1_rad = lon1.to_f * Math::PI / 180
    lat2_rad = lat2.to_f * Math::PI / 180
    lon2_rad = lon2.to_f * Math::PI / 180

    dlon = lon2_rad - lon1_rad
    dlat = lat2_rad - lat1_rad

    a = Math.sin(dlat/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon/2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    earth_radius * c
  end

  def self.organize_gpx_points(file:, max_distance: 4, dry_run: false)
    return {} if file.nil?

    begin
      xml_str = File.read(file)
      return {} if xml_str.nil?

      xml = Nokogiri::XML(xml_str)
      gpx_list = xml.at('gpx//trk//trkseg').search("trkpt")

      # Initialize a hash to store points grouped by their closest address
      organized_points = Hash.new { |h, k| h[k] = [] }
      count=0
      discarded=0
      gpx_list.each do |point|
        lat = point['lat'].to_f
        lon = point['lon'].to_f

        # Find the closest address
        closest_address = find_closest(lat: lat, lon: lon)
        next if closest_address.nil?

        # Calculate distance to closest address
        distance = calculate_distance(
          lat1: lat,
          lon1: lon,
          lat2: closest_address.lat,
          lon2: closest_address.lon
        )
        
        # Only include points within max_distance
        if distance <= max_distance
          count+=1
          if dry_run
            puts "Adding point to #{closest_address.street_address} at distance #{distance} #{lat}, #{lon}"
          else
            Geo.create(lat: lat, lon: lon, greenspace: closest_address)
          end
        else
          discarded+=1
          puts "Point too far from #{closest_address.street_address} at distance #{distance} #{lat}, #{lon}"
        end
      end
      puts "Added #{count} points, discarded #{discarded} points"
      organized_points
    rescue Errno::ENOENT
      puts "Error reading file: #{file}"
      {}
    end
  end
end
