# frozen_string_literal: true

require 'set'

INPUT = File.read(ARGV.first).split("\n")

def accumulator(input = INPUT)
  acc = 0
  visited = Set.new
  i = 0

  while i < input.size
    return false, acc unless visited.add?(i)

    instruction, offset = input[i].split

    i += offset.to_i - 1 if instruction == 'jmp'

    acc += offset.to_i if instruction == 'acc'
    i += 1
  end

  [true, acc]
end

def corrupted(input = INPUT)
  input.each_with_index do |line, index|
    tokens = line.split

    new_instructions = []
    new_instructions = input[0...index] + ['jmp ' + tokens[1]] + input[index + 1..-1] if tokens[0] == 'nop'
    new_instructions = input[0...index] + ['nop ' + tokens[1]] + input[index + 1..-1] if tokens[0] == 'jmp'

    if new_instructions != []
      resolved = accumulator(new_instructions)
      return resolved[1] if resolved[0]
    end
  end
end

puts "Part 1: #{accumulator[1]}"
puts "Part 2: #{corrupted}"
