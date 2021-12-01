# frozen_string_literal: true

lines = File.read('input.txt').split("\n")

path = []
x = 0

lines.each do |line|
  x = x % 31
  path << line[x]
  x += 3
end

puts path.inspect
puts path.count
puts path.count('#')
