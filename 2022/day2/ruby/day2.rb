INPUT = File.read(ARGV[0]).split("\n")

game_points = {
  "A X" => 4,
  "A Y" => 8,
  "A Z" => 3,
  "B X" => 1,
  "B Y" => 5,
  "B Z" => 9,
  "C X" => 7,
  "C Y" => 2,
  "C Z" => 6
}

results = INPUT.map do |play|
  game_points[play]
end

puts results.sum

game_points_revised = {
  "A X" => 3,
  "A Y" => 4,
  "A Z" => 8,
  "B X" => 1,
  "B Y" => 5,
  "B Z" => 9,
  "C X" => 2,
  "C Y" => 6,
  "C Z" => 7
}

results = INPUT.map do |play|
  game_points_revised[play]
end

puts results.sum
