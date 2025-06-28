require 'mini_magick'
require 'exifr/jpeg'
require 'fileutils'

class ImageProcessor
  MAX_DIMENSION = 1440

  def self.process_heic(input_path, output_dir = 'app/assets/images/greenspaces')
    return unless File.exist?(input_path)
    
    # Set default output directory if none provided
    output_dir ||= File.dirname(input_path)
    FileUtils.mkdir_p(output_dir)

    begin
      # Load and process the image
      image = MiniMagick::Image.new(input_path)
      
      # Get GPS coordinates from EXIF data
      gps_data = extract_gps_data(image)
      return unless gps_data

      # Find closest address
      closest_address = Geo.find_closest(lat: gps_data[:latitude], lon: gps_data[:longitude])
      return unless closest_address&.greenspace

      # Generate output filename based on greenspace name
      base_filename = closest_address.greenspace.name.parameterize
      timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
      output_filename = "#{base_filename}_#{timestamp}.jpg"
      output_path = File.join(output_dir, output_filename)

      # Resize image maintaining aspect ratio
      if image.width > MAX_DIMENSION || image.height > MAX_DIMENSION
        image.resize "#{MAX_DIMENSION}x#{MAX_DIMENSION}>"
      end

      # Convert to JPEG and save
      image.format 'jpg'
      image.write output_path

      output_path
      puts "Error processing #{input_path}: #{e.message}"
      nil
      closest_address&.greenspace
    end
  end

  def self.process_directory(input_dir, output_dir = nil)
    output_dir ||= File.join(input_dir, 'processed')
    FileUtils.mkdir_p(output_dir)

    Dir.glob(File.join(input_dir, '*.{HEIC,heic}')).each do |file|
      process_heic(file, output_dir)
    end
  end

  private

  def self.extract_gps_data(image)
    begin
      # Get EXIF data
      exif = image.exif
      return nil unless exif

      # Extract GPS coordinates
      gps_latitude = exif['GPSLatitude']
      gps_latitude_ref = exif['GPSLatitudeRef']
      gps_longitude = exif['GPSLongitude']
      gps_longitude_ref = exif['GPSLongitudeRef']

      return nil unless gps_latitude && gps_longitude

      # Convert GPS coordinates to decimal degrees
      latitude = convert_gps_to_decimal(gps_latitude, gps_latitude_ref)
      longitude = convert_gps_to_decimal(gps_longitude, gps_longitude_ref)

      { latitude: latitude, longitude: longitude }
    rescue => e
      puts "Error extracting GPS data: #{e.message}"
      nil
    end
  end

  def self.convert_gps_to_decimal(coordinate, ref)
    return nil unless coordinate && ref

    # Parse the coordinate string (format: "degrees, minutes, seconds")
    parts = coordinate.split(',').map(&:to_f)
    return nil if parts.size != 3

    degrees, minutes, seconds = parts
    decimal = degrees + (minutes / 60.0) + (seconds / 3600.0)

    # Apply the reference (N/S or E/W)
    decimal *= -1 if ['S', 'W'].include?(ref.upcase)
    decimal
  end
end 