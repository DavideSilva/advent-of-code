INPUT = File.read(ARGV[0]).split("\n")

h_pos = 0
depth = 0
INPUT.each do |line|
  cmd, units = line.split
  case cmd
  when "forward"
    h_pos += units.to_i
  when "down"
    depth += units.to_i
  when "up"
    depth -= units.to_i
  end
end

puts "Part 1: #{h_pos * depth}"

h_pos = 0
depth = 0
aim = 0
INPUT.each do |line|
  cmd, units = line.split
  case cmd
  when "forward"
    h_pos += units.to_i
    depth += aim * units.to_i
  when "down"
    aim += units.to_i
  when "up"
    aim -= units.to_i
  end
end

puts "Part 2: #{h_pos * depth}"
