INPUT = File.read(ARGV[0]).split("\n").map(&:to_i)

res = 0
INPUT.each_cons(2) do |a,b|
  res += 1 if b > a
end
puts "PART 1: #{res}"

res = 0
INPUT.each_cons(3).map do |three_measures|
  three_measures.sum
end.each_cons(2) do |a,b|
  res += 1 if b > a
end
puts "PART 2: #{res}"
