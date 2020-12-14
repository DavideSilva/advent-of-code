# frozen_string_literal: true

INPUT = File.read(ARGV.first).split.map(&:to_i).sort!

max_joltage = INPUT.max + 3
INPUT.prepend(0)
INPUT.append(max_joltage)

def adapter_chain(input = INPUT)
  difference = proc do |pair| pair.reverse.inject(&:-) end
  differences = input.each_cons(2).map(&difference)
  differences.tally[1] * differences.tally[3]
end

TRIBONACCISEQUENCE = [1, 1, 2, 4, 7, 13, 24, 44, 81, 149].freeze
def get_tribonacci(num)
  throw "No tribonacci number for #{num}" if num > TRIBONACCISEQUENCE.size

  TRIBONACCISEQUENCE[num - 1]
end

def distinct_chains(input = INPUT)
  multiplier = 1
  current_run = 1

  input.each do |joltage|
    if input.include?(joltage + 1)
      current_run += 1
    else
      multiplier *= get_tribonacci(current_run)
      current_run = 1
    end
  end

  multiplier
end

puts "Part 1: #{adapter_chain}"
puts "Part 2: #{distinct_chains}"
