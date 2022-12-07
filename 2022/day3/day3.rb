INPUT = File.read(ARGV[0]).split

part1 = INPUT.reduce(0) do |acc, rucksack|
  size = rucksack.size
  first_compartment = rucksack[0...size/2]
  second_compartment = rucksack[size/2..]

  common = first_compartment.chars & second_compartment.chars

  acc + common.reduce(0) do |acc, c|
    c.ord >= 97 ? acc + c.ord - 96 : acc + c.ord - 38
  end
end

puts part1


part2 = INPUT.each_slice(3).reduce(0) do |acc, group|
  badges = group[0].chars & group[1].chars & group[2].chars

  acc + badges.reduce(0) do |acc, c|
    c.ord >= 97 ? acc + c.ord - 96 : acc + c.ord - 38
  end
end

puts part2
