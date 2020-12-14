# frozen_string_literal: true

INPUT = File.read(ARGV.first).split.map(&:to_i)

# PART 1
def bad_value(input = INPUT)
  original = input

  input[25..-1].each do |value|
    preamble = original.take(25).combination(2).to_a.map do |pair|
      pair[0].to_i + pair[1].to_i
    end

    puts "Part 1: #{value}" unless preamble.include?(value.to_i)

    input = input.drop(1)
    original = original.drop(1)
  end
end

# 31161678

# PART 2
def find_subarray(input = INPUT)
  target = 31_161_678
  i = 2

  while i < 100
    input.each_cons(i) do |p|
      if p.inject(&:+) == target
        p p.sort!
        p p.first + p.last
        break
      end
    end
    i += 1
  end
end

bad_value
find_subarray
