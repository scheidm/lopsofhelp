
module PageHelper
  def animal_data
    return [
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
  end

  def weight_matching(park_id: nil, formula: "* 2.20462 / 1000",round:0)
    matching = activities_matching("select SUM(waste) #{formula}", park_id).flatten.reduce(:sum)
    return 0 if matching.nil?

    matching.round round
  end

  def distance_matching(park_id: nil, formula:"* 0.621371 / 1000", round:0)
    matching = activities_matching("select SUM(distance) #{formula}", park_id).flatten.reduce(:sum)
    return 0 if matching.nil?

    matching.round round
  end

  def last_visit park_id = nil
    @db = SQLite3::Database.new "bunny.db" if @db.nil?
    where = park_id.nil? ? '' : "where park_id = #{park_id}"
    sql = "select date from activities #{where} order by date desc limit 1"
    visits = @db.execute sql
    return Time.parse(visits[0][0]) if visits.length > 0

    nil
  end

  def activities_matching query,park_id = nil
    @db = SQLite3::Database.new "bunny.db"
    sql = "#{query} from activities"
    sql += " where park_id = #{park_id}" unless park_id.nil?
    puts sql;
    @db.execute(sql)
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

  def weight_the_same_string park_id:nil
    strings = weighs_the_same_as(weight_matching park_id:, formula: nil ).map{ |a| animals_to_string(a) }
    if strings.length > 1
      strings[-1]="and #{strings[-1]}"
    end
    strings.join ", "
  end

  def weighs_the_same_as(amount)
    closest_animal = 999
    animal_data.each_with_index do |animal, i|
      if animal[:weight] * 0.9 <= amount
        closest_animal = i
        break
      end
    end
    if closest_animal == 999
      return [];
    end

    target = {}
    minimum = amount
    a = animal_data[closest_animal]
    animals = {a:a}
    if combination_to_delta({a: 1},animals,amount) <= 0.10 * amount
      a[:count] = 1
      return [a]
    end

    list =       [{a: 1}, {a: 2}]
    b = animal_data[closest_animal+1]

    unless b.nil?
      animals[:b] = b
      list.push({b: 2})
      list.push({b: 3})
      list.push({b: 1, a:1})
    end
    c = animal_data[ closest_animal+2 ]
    unless c.nil?
      animals[:c] = c
      list.push({c: 1, b: 1})
      list.push({c: 1, a:1})
    end
    list.each do |animal|
      delta = combination_to_delta(animal,animals,amount)
      if delta < minimum
        minimum = delta
        target = animal
      end
    end
    target.each do |key, count|
      animals[key][:count] = count
    end
    animals.keys.reject{|k| target.keys.index(k)}.each do |key|
      animals.delete key
    end
    return animals.values
  end

  def strings_from_hash(hash,animals, amount)
    response = "weights about the same as"

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
  def animals_to_string(animal)
    name = animal[:name]
    count = animal[:count]
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
