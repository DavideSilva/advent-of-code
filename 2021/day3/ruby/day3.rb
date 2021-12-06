INPUT = File.read(ARGV[0]).split("\n")

def calculate_frequencies(input)
  input.map(&:chars).transpose.map(&:tally)
end

def calculate_oxygen_rating(input, frequencies, bit)
  if (input.size == 1)
    return input.first
  else
    drop_bit = frequencies[bit]["0"] > frequencies[bit]["1"] ? "0" : "1"
    drop_bit = "1" if frequencies[bit]["0"] == frequencies[bit]["1"]

    new_input = input.sort.filter do |line|
      line[bit] == drop_bit
    end

    new_frequencies = calculate_frequencies(new_input)
    bit += 1

    calculate_oxygen_rating(new_input, new_frequencies, bit)
  end
end

def calculate_co2_rating(input, frequencies, bit)
  if (input.size == 1)
    return input.first
  else
    drop_bit = frequencies[bit]["0"] > frequencies[bit]["1"] ? "1" : "0"
    drop_bit = "0" if frequencies[bit]["0"] == frequencies[bit]["1"]

    new_input = input.sort.filter do |line|
      line[bit] == drop_bit
    end

    new_frequencies = calculate_frequencies(new_input)
    bit += 1

    calculate_co2_rating(new_input, new_frequencies, bit)
  end
end

def part_1(input)
  gamma = calculate_frequencies(input).map do |f| f.max_by do |k,v| v end end.transpose.first.join
  epsilon = gamma.chars.map(&:to_i).map do |i| i ^= 1 end.join

  puts "Gamma: #{gamma} - #{gamma.to_i(2)}"
  puts "Epsilon: #{epsilon} - #{epsilon.to_i(2)}"

  puts "Power consumption: #{gamma.to_i(2) * epsilon.to_i(2)}"
end

def part_2(input)
  bit = 0
  frequencies = calculate_frequencies(input)

  oxygen = calculate_oxygen_rating(input, frequencies, bit)
  co2 = calculate_co2_rating(input, frequencies, bit)

  puts "Final oxygen: #{oxygen} - #{oxygen.to_i(2)}"
  puts "Final co2: #{co2} - #{co2.to_i(2)}"

  puts "Life support rating: #{oxygen.to_i(2) * co2.to_i(2)}"
end

part_1(INPUT)
puts ""
part_2(INPUT)
