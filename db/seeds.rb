# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


%w[Lithonia
Stockbridge
McDonough
Jonesboro
Atlanta
Hampton
Morrow
Stonecrest].each do |name|
    City.find_or_create_by!(name:)
end


["Clark Community Park",
"Doll's Head Trail",
"Clayton Connects",
"Reynold's Nature Preserve",
"Reeves Creek Trail",
"Bud Kelley Park",
"Arabia Mountain Meadow Loop",
"Pates Creek Nature Preserve",
"JP Mosley Park",
"Panola Mountain Greenway",
"Memorial Park",
"Clayton County International Park",
"Private Neighborhood A",
"Alexander Park West",
"Heritage Park",
"Wickery Bridge",
"Newman Wetlands Center"
].each do |name|
    Greenspace.find_or_create_by!(name:)
end
