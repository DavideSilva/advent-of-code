# frozen_string_literal: true

INPUT = File.read(ARGV.first).split
REGEX = /(\w)(\d+)/.freeze

def part1(input = INPUT)
  direction = 'E'
  north_south = 0
  east_west = 0

  input.reduce do |action|
    instruction, amount = *action.match(REGEX).captures

    north_south, east_west = move(direction, north_south, east_west, amount) if instruction == 'F'
    north_south, east_west = move(instruction, north_south, east_west, amount) if %w[N S E W].include? instruction
    direction = rotate(direction, instruction, amount) if %w[L R].include? instruction
  end
end

def move(direction, north_south, east_west, amount)
  north_south += amount if direction == 'N'
  north_south -= amount if direction == 'S'
  east_west += amount if direction == 'E'
  east_west -= amount if direction == 'W'

  [north_south, east_west]
end

def rotate(direction, instruction, amount)

end
