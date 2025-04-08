module PageHelper

  def history_overview
    require 'sqlite3'
    db = SQLite3::Database.new "/bunny.db"

    db.execute("select SUM(waste) * 2.20462,SUM(distance) * 0.621371 / 1000 from activities")
  end

  def link_to_page(page)
    link_to page.data.fetch("title", page.request_path), page.request_path
  end

  def link_to_if_current(text, page, active_class: "active")
    if page == current_page
      link_to text, page.request_path, class: active_class
    else
      link_to text, page.request_path
    end
  end

    @animal_data = [
    {name: "Stag White Tail Deer", weight:225000, url: "https://www.inaturalist.org/taxa/42223-Odocoileus-virginianus"},
    {name: "Doe White Tail Deer", weight:65000, url: "https://www.inaturalist.org/taxa/42223-Odocoileus-virginianus"},
    {name: "Common Raccoon", weight:15000, url: "https://www.inaturalist.org/taxa/41663-Procyon-lotor"},
    {name: "Common Snapping Turtle", weight:6000, url: "https://www.inaturalist.org/taxa/39682-Chelydra-serpentina"},
    {name: "Nine-banded Armadillo", weight:4500, url: "https://www.inaturalist.org/taxa/47075-Dasypus-novemcinctus"},
    {name: "Great Blue Heron", weight:2700, url: "https://www.inaturalist.org/taxa/4956-Ardea-herodias"},
    {name: "Virginia Opossum", weight:2100, url: "https://www.inaturalist.org/taxa/42652-Didelphis-virginiana"},
    {name: "Eastern Cottontail", weight:1400, url: "https://www.inaturalist.org/taxa/43111-Sylvilagus-floridanus"},
    {name: "Barred Owl", weight:800, url: "https://www.inaturalist.org/taxa/19893-Strix-varia"},
    {name: "Red Shouldered Hawk", weight:550, url: "https://www.inaturalist.org/taxa/5206-Buteo-lineatus"},
    {name: "♀ Common Watersnake", weight:275, url: "https://www.inaturalist.org/taxa/29305-Nerodia-sipedon"},
    {name: "♂ Common Watersnake", weight:110, url: "https://www.inaturalist.org/taxa/29305-Nerodia-sipedon"},
    {name: "Yellow-bellied Sapsucker", weight:50, url: "https://www.inaturalist.org/taxa/18463-Sphyrapicus-varius"},
    {name: "Carolina Wren", weight:20, url: "https://www.inaturalist.org/taxa/7513-Thryothorus-ludovicianus"},
    {name: "Green Anole", weight:5, url: "https://www.inaturalist.org/taxa/36514-Anolis-carolinensis"}
  ]

  def weighs_the_same_as(amount)
    closest_animal = 999
    @animal_data.each_with_index do |animal, i|
      if animal[:weight] * 0.9 <= amount
        closest_animal = i
        break
      end
    end
    if closest_animal == 999
      return "couldn't find something as big as #{initialAmount}"
    end

    target = {}
    minimum = amount
    a = @animal_data[closest_animal]
    animals = {a:a}
    if combination_to_delta({a: 1},animals,amount) <= 0.10 * amount
      return  strings_from_hash({a: 1}, animals, amount)
    end

    list =       [{a: 1}, {a: 2}]
    b = @animal_data[closest_animal+1]

    unless b.nil?
      animals[:b] = b
      list.push({b: 2})
      list.push({b: 3})
      list.push({b: 1, a:1})
    end
    c = @animal_data[ closest_animal+2 ]
    unless c.nil?
      animals[:c] = c
      list.push({c: 1, b: 1})
      list.push({c: 1, a:1})
    end
    list.each do |animal|
      delta = combination_to_delta(animal,animals,amount)
      if delta < minimum
        minimum = delta
        target = list[i]
      end
    end
    strings_from_hash(target, animals, amount)
  end

  def strings_from_hash(hash,animals, amount)
    response = "#{amount}g weights about the same as"

    strings  = []
    hash.each do |key, count|
      strings.push animals_to_string(animals[key], count)
    end

    if strings.length === 2
      return "#{response} #{strings[0]} and #{strings[1]}"
    else
      return "#{response} #{strings[0]}"
    end

  end
  def animals_to_string(animal, count)
    name = animal[:name]
    singular = count == 1

    return "#{ singular ? "a" : count} #{name}#{singular ? "" : "s"}"

  end

  def combination_to_delta(combo, animals, amount)
    weight = 0
    combo.each do |key, count|
      weight += count * animals[key][:weight]
    end
    return (weight - amount ).abs
  end
end
