INPUT = File.read(ARGV[0])

template, instructions = INPUT.split("\n\n")
rules = instructions.split("\n").map do |i| i.split(" -> ") end.to_h

def part1(template, rules)
  10.times do
    template = template.chars.each_cons(2).map do |pair|
      [pair.first, rules[pair.join]].join
    end.join + template.chars.last
  end

  tally = template.chars.tally
  puts "Part 1: #{tally.values.max - tally.values.min}"
end

def part2(template, rules)
  pairs = Hash.new(0)
  single_element = Hash.new(0)

  template.chars.each_cons(2) do |pair| pairs[pair.join] += 1 end
  template.chars.each do |e| single_element[e] += 1 end

  40.times do
    pairs.clone.each do |pair, pair_count|
      new_element = rules[pair]
      single_element[new_element] += pair_count
      pairs[pair] -= pair_count
      pairs[pair[0] + new_element] += pair_count
      pairs[new_element + pair[1]] += pair_count
    end
  end

  min, max = single_element.minmax_by do |_k, v| v end
  puts "part 2: #{max[1] - min[1]}"
end

part1(template, rules)
part2(template, rules)

