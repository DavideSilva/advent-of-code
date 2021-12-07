INPUT = File.read(ARGV[0]).split(",").map(&:to_i)

min = INPUT.min
max = INPUT.max

fuel_cost = (min..max).map do |n|
  INPUT.map do |c|
    (n-c).abs
  end.sum
end

p fuel_cost.min

fuel_cost = (min..max).map do |n|
  INPUT.map do |c|
    d = (n-c).abs
    d * (d + 1) / 2
  end.sum
end

p fuel_cost.min
