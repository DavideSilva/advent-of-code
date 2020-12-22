# frozen_string_literal: true

INPUT = File.read(ARGV.first).split.map(&:chars)

def in_bounds?(input, row, column, x, y, multiplier = 1)
  size = input.size

  row + (x * multiplier) >= 0 && row + (x * multiplier) < size && column + (y * multiplier) >= 0 && column + (y * multiplier) < size
end

def count_adjacent_seats(input, row, column)
  directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  directions.select do |x, y|
    in_bounds?(input, row, column, x, y) && input[row + x][column + y] == '#'
  end.size
end

def count_visible_seats(input, row, column)
  directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  directions.select do |x, y|
    multiplier = 1
    multiplier += 1 while in_bounds?(input, row, column, x, y, multiplier) && input[row + x * multiplier][column + y * multiplier] == '.'

    in_bounds?(input, row, column, x, y, multiplier) && input[row + x * multiplier][column + y * multiplier] == '#'
  end.size
end

def solve(input, limit)
  new_input = input.dup.map(&:dup)
  previous = 0
  while true
    input.each_with_index do |rows, i|
      rows.each_with_index do |_, j|
        occupied = count_visible_seats(input, i, j)
        new_input[i][j] = '#' if occupied.zero? && input[i][j] == 'L'
        new_input[i][j] = 'L' if occupied >= limit && input[i][j] == '#'
      end
    end
    current_occupied_seats = new_input.join.count('#')
    break if previous == current_occupied_seats

    previous = current_occupied_seats
    input = new_input.dup.map(&:dup)
  end
  current_occupied_seats
end

puts "Part 1: #{solve(INPUT, 4)}"
puts "Part 2: #{solve(INPUT, 5)}"
