namespace :hikes do
  desc "Create a hike from HEIC images with waste and distance data"
  task :create_from_images, [:input_path, :waste, :distance] => :environment do |t, args|
    unless args[:input_path]
      puts "Please provide an input path for HEIC images"
      puts "Usage: rake hikes:create_from_images[path/to/images, waste_amount, distance]"
      exit
    end

    waste = args[:waste].to_f
    distance = args[:distance].to_f

    if waste <= 0 || distance <= 0
      puts "Please provide valid waste and distance values (must be greater than 0)"
      exit
    end

    # Process the image and get the associated greenspace
    greenspace = ImageProcessor.process_heic(args[:input_path])
    
    if greenspace
      # Create the hike
      hike = Hike.create!(
        greenspace: greenspace,
        waste: waste,
        distance: distance,
        date: Date.today
      )

      puts "Successfully created hike for #{greenspace.name}"
      puts "Hike ID: #{hike.id}"
      puts "Waste: #{waste}"
      puts "Distance: #{distance}"
    else
      puts "Failed to process image or find associated greenspace"
    end
  end
end 