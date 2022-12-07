INPUT = File.read(ARGV[0]).split

contains = 0
overlaps = 0

INPUT.each do |line|
  sections = line.split(',')

  first_elf = sections[0].split('-').map(&:to_i)
  second_elf = sections[1].split('-').map(&:to_i)

  a = first_elf[0]..first_elf[1]
  b = second_elf[0]..second_elf[1]

  contains += 1 if a.cover?(b) || b.cover?(a)
  overlaps += 1 if a.to_a & b.to_a != []
end

puts "PART1: #{contains}"
puts "PART2: #{overlaps}"
