let animalData = [
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
];

function weighsTheSameAs(amount) {
  let closestAnimal = 999;
  for (let i = 0; i < animalData.length; i++) {
    let animal = animalData[i];
    if(animal.weight*0.93 <= amount){
      closestAnimal = i;
      break;
    }
  }
  if( closestAnimal == 999 ) return `couldn't find something as big as ${initialAmount}`;

  let target = {}
  let minimum = amount;
  let a = animalData[closestAnimal];
  let animals = {a:a};
  list =       [{a: 1}, {a: 2}]
  let b = animalData[closestAnimal+1];

  if(b != undefined ){
    animals.b=b;
    list.push({b: 2});
    list.push({b: 3});
    list.push({b: 1, a:1});
  }
  let c = animalData[ closestAnimal+2 ];
  if(c != undefined ){
    animals.c = c;
    list.push({c: 1, b: 1});
    list.push({c: 1, a:1});
 }
 for (let i = 0; i < list.length; i++) {
  let delta = combinationToDelta(list[i],animals,amount);
  if(delta < minimum){
    minimum = delta
    target = list[i];
  }
 }
 return  stringsFromHash(target, animals, amount);

  // console.log(Object.keys(combinations).sort());
  // console.log(minumum);
  // let closest = combinations[minimum];
  // console.log(closest);


    
  // let rtn = combinations[closest]
  // rtn.names=[a.name,b.name,c.name].join(', ');
  // return rtn;
  // let weighedAnimals = combinations[closest];
  // for (const key of Object.keys(weighedAnimals)) {
  //   animal = weighedAnimals[key];

  //   let count = weighedAnimals[i];
  //   let name = animalData[i].name;
  //   strings.push(` ${count} ${name}`)
  // }
  // if(strings.length == 0){
  //   return weighedAnimals;
  //   //return `couldn't find something as big as ${initialAmount}`
  // }else if(strings.length == 1){
  //   return `${response} ${strings[0]}.`
  // }else{
  //   let last = strings.pop();
  //   console.log( strings );
  //   response += strings.join(',');
  //   response += `and ${last}.`;
  // }
}
function stringsFromHash(hash,animals, amount){
  let response = `${amount}g weights about the same as`;

  let strings  = [];
  for (const key of Object.keys(hash).sort()) {
    console.log(key);
    console.log(animals);
    let count = hash[key];
    strings.push(animalsToString(animals[key], count));
  }

  if(strings.length === 2){
    return `${response} ${strings[0]} and ${strings[1]}`;
  }else{
    return `${response} ${strings[0]}`;
  }

}
function animalsToString(animal, count){
  console.log(`ats ${count}`)
  let name = animal.name;
  let singular = count == 1;

  return `${ singular ? "a" : count} ${name}${singular ? "" : "s"}`

}
  
function combinationToDelta(combo, animals, amount){
  let weight = 0;
  for (const key of Object.keys(combo)) {
    weight += combo[key] * animals[key].weight;
  }
  
  return Math.abs(weight - amount );
}