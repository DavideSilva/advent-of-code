INPUT = File.read(ARGV[0]).split(",").map(&:to_i)

def simulate(input, days)
  fish = input.tally

  days.times do
    new_fish = Hash.new(0)
    fish.each do |age, count|
      if age == 0
        new_fish[6] += count
        new_fish[8] += count
      else
        new_fish[age - 1] += count
      end
    end
    fish = new_fish
  end

  fish.values.sum
end

def part1(input)
  puts "#{simulate(input, 80)} after 80 days"
end

def part2(input)
  puts "#{simulate(input, 256)} after 256 days"
end

part1(INPUT)
part2(INPUT)
