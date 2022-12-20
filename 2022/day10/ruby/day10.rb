INPUT = File.read(ARGV[0]).split("\n")

register_values = INPUT.each_with_object([1]) do |line, x|
  x.push x.last
  x.push(x.last + line.split.last.to_i) if line.start_with? "addx"
end

puts 20.step(by: 40, to: 220)
       .sum { |i| i * register_values[i - 1] }


240.times
   .map { |i| [i % 40, (register_values[i] - 1).upto(register_values[i] + 1)] }
   .map { |i, j| j.include?(i) ? '#' : '.' }
   .each_slice(40) { |i| puts i.join }
