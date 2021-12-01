# frozen_string_literal: true

lines = File.read('input.txt').split("\n")

path = []
x = 0

lines.each_slice(2) do |slice|
  x = x % 31
  path << slice[1][x] if slice[1]
  x += 1
end

puts path.inspect
puts path.count
puts path.count('#')
