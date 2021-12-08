INPUT = File.read(ARGV[0]).split("\n")

# 1 - 2 signals
# 4 - 4 signals
# 7 - 3 signals
# 8 - 7 signals

def part1()
  puts (INPUT.map do |line|
    line.split("|").last.split.map(&:size).filter do |digit|
      [2,3,4,7].include? digit
    end
  end.flatten.count)
end

# 2 - 5 signals
# 3 - 5 signals
# 5 - 5 signals

# 6 - 6 signals
# 9 - 6 signals
# 0 - 6 signals

# 9 - size 6 && includes 4
# 0 - size 6 && includes 1
# 6 - size 6 && last

# 3 - size 5 && includes 7
# 5 - size 5 && substring 6
# 2 - size 5 && last

def identify_numbers(signals)
  h = {}

  signals = signals.sort_by(&:size)

  h[1] = signals.first
  h[8] = signals.last
  h[7] = signals[1]
  h[4] = signals[2]

  sixes = signals.filter do |s| s.size == 6 end
  fives = signals.filter do |s| s.size == 5 end

  sixes.each do |six|
    if h[4].chars.all? do |f| six.chars.include? f end
      h[9] = six
    end
  end

  sixes = sixes - [h[9]]

  sixes.each do |six|
    if h[1].chars.all? do |f| six.chars.include? f end
      h[0] = six
    end
  end

  sixes = sixes - [h[0]]

  h[6] = sixes.first

  fives.each do |five|
    if h[7].chars.all? do |f| five.chars.include? f end
      h[3] = five
    end
  end

  fives = fives - [h[3]]

  fives.each do |five|
    if (h[6].chars - five.chars).count == 1
        h[5] = five
    end
  end

  fives = fives - [h[5]]

  h[2] = fives.first

  h.transform_values! do |v| v.chars.sort.join end
  h
end

def calculate_output(numbers_hash, digits)
  digits.map do |d|
    numbers_hash.key(d.chars.sort.join)
  end.join.to_i
end

def part2()
  puts (INPUT.map do |line|
    signals, digits = line.split("|")

    numbers = identify_numbers(signals.split)
    calculate_output(numbers, digits.split)
  end.sum)
end

part1()
part2()
