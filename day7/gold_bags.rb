# frozen_string_literal: true

INPUT = File.read('input.txt').split("\n")
BAGS = /(\w+\s\w+)\sbag/.freeze

# part 1
def find_bags(list)
  return [] if list == []

  lines = INPUT.select do |line|
    list.any? { |bag| line.include?(bag) }
  end

  bags = lines.reduce([]) do |acc, line|
    acc << line.match(BAGS)[1]
  end

  bags + find_bags(bags - list)
end

# part 2
def count_bags_inside(bag)
  line = INPUT.select { |lines| lines.match?(/^#{bag}/) }.first
  return 1 if line.match?('contain no other bags')

  matches = line.scan(/(\d+)\s(\w+\s\w+)/)

  matches.reduce(1) do |acc, bag_info|
    acc + bag_info[0].to_i * count_bags_inside(bag_info[1])
  end
end

puts "Part 1: #{find_bags(['shiny gold']).uniq.count - 1}"
puts "Part 2: #{count_bags_inside('shiny gold') - 1}"
