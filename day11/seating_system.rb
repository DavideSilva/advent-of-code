# frozen_string_literal: true
# rubocop:disable all

INPUT = File.read(ARGV.first).split

def count_neighbors(input, row, column)
  max_row = input.size
  max_column = input[0].size
  count = 0

  count += 1 if column + 1 < max_column && input[row][column + 1] == '#'
  count += 1 if column + 1 < max_column && row + 1 < max_row && input[row + 1][column + 1] == '#'
  count += 1 if row + 1 < max_row && input[row + 1][column] == '#'
  count += 1 if row + 1 < max_row && column - 1 >= 0 && input[row + 1][column - 1] == '#'
  count += 1 if row - 1 >= 0 && input[row - 1][column] == '#'
  count += 1 if column - 1 >= 0 && row - 1 >= 0 && input[row - 1][column - 1] == '#'
  count += 1 if column - 1 >= 0 && input[row][column - 1] == '#'
  count += 1 if row - 1 >= 0 && column + 1 < max_row && input[row - 1][column + 1] == '#'

  count
end

def in_bounds?(input, row, column, x, y)
  size = input.size

  row + x >= 0 && row + x < size && column + y >= 0 && column + y < size
end

def count_seats(input, row, column)
  directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  directions.select do |x, y|
    in_bounds?(input, row, column, x, y) && input[row + x][column + y] == '#'
  end.size
end

def part1(input = INPUT)
  new_input = input.dup.map(&:dup)
  previous = 0
  while true
    i = 0
    while i < input.size
      j = 0
      while j < input.size
        occupied = count_seats(input, i, j)
        new_input[i][j] = '#' if occupied.zero? && input[i][j] == 'L'
        new_input[i][j] = 'L' if occupied >= 4 && input[i][j] == '#'
        j += 1
      end
      i += 1
    end
    current_occupied_seats = new_input.join.count('#')
    break if previous == current_occupied_seats
    previous = current_occupied_seats
    input = new_input.dup.map(&:dup)
  end
  puts new_input.join("\n")
  puts current_occupied_seats
end

part1
