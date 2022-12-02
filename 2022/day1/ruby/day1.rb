INPUT = File.read(ARGV[0]).split("\n\n").map(&:split).map do |calories|
  calories.map(&:to_i)
end

sum = INPUT.map do |calories|
  calories.sum
end

part1 = sum.max

puts "PART1: #{part1}"

part2 = sum.sort.reverse[0..2].sum

puts "PART2: #{part2}"
