INPUT = File.read(ARGV[0]).chomp

def binary
  INPUT.to_i(16).to_s(2)
end

def packet_version(binary)
  binary.slice!(0, 3).to_i(2)
end

def packet_type_id(binary)
  binary.slice!(0, 3).to_i(2)
end

def parse_literal(binary)
  output = ""
  counter = 0
  binary.chars.each_slice(5) do |group|
    output << group[1..4].join("")
    counter += 1
    break if group[0] == "0"
  end

  return {
    version_sum: 0,
    value: output.to_i(2),
    remainder: binary[5 * counter..]
  }
end

def parse_packet(binary)
  version = packet_version(binary)
  type_id = packet_type_id(binary)

  puts version
  puts type_id

  case type_id
  when 4
    result = parse_literal(binary)
  when 2
    mode = binary.slice(0)
    puts "OPERATOR"
    puts mode
  else
  end

  result
end

def part1
  puts binary
  parse_packet(binary)
end

part1
