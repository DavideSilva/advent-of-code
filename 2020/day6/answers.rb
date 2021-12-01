# frozen_string_literal: true

groups = File.read('input.txt').split("\n\n")

# part 1
anyone = groups.reduce(0) do |count, group|
  count + group.gsub("\n", '').chars.uniq.size
end

puts anyone

# part 2
everyone = groups.reduce(0) do |count, group|
  count + group.split("\n").map(&:chars).reduce(&:&).count
end

puts everyone
