INPUT = File.read(ARGV[0]).split

def prep_board
  INPUT.map do |board|
    board.chars.map(&:to_i)
  end
end

def adjacents(board, row, column)
  adjacents = []

  # top
  adjacents << {x: row - 1, y: column} if row > 0
  # bottom
  adjacents << {x: row + 1, y: column} if row < board.size - 1
  # left
  adjacents << {x: row, y: column - 1} if column > 0
  # right
  adjacents << {x: row, y: column + 1} if column < board[row].size - 1

  # up left
  adjacents << {x: row - 1, y: column - 1} if row > 0 && column > 0
  # up right
  adjacents << {x: row - 1, y: column + 1} if row > 0 && column < board[row].size - 1
  # down left
  adjacents << {x: row + 1, y: column - 1} if row < board.size - 1 && column > 0
  # down right
  adjacents << {x: row + 1, y: column + 1} if row < board.size - 1 && column < board[row].size - 1

  adjacents
end


def flash(board, x, y, flashers)
  if board[x][y] > 9 && !flashers.include?({x: x, y: y})
    flashers.push({x: x, y: y})
    neighbors = adjacents(board, x, y)
    neighbors.each do |adj|
      nx = adj[:x]
      ny = adj[:y]
      board[nx][ny] += 1
      flash(board, nx, ny, flashers)
    end
  end
end

def increase_energy_level(board)
  board.map do |row|
    row.map do |level|
      level += 1
    end
  end
end

def reset_energy_level(board)
  board.map do |row|
    row.map do |level|
      level = level > 9 ? 0 : level
    end
  end
end

def count_flashes(board)
  board.reduce(0) do |flashes, row|
    flashes += (row.filter do |level| level > 9 end).count
  end
end

def all_simultaneous?(board)
  board.all? do |row|
    row.all? do |level|
      level == 0
    end
  end
end

def part1
  board = prep_board
  total_flashes = 0

  (0...100).each do
    flashers = []
    board = increase_energy_level(board)

    board.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        flash(board, row_idx, col_idx, flashers)
      end
    end

    total_flashes += count_flashes(board)

    board = reset_energy_level(board)
  end
  puts "Total flashes: #{total_flashes}"
end

def part2
  board = prep_board
  step = 0

  while !all_simultaneous?(board)
    flashers = []
    board = increase_energy_level(board)

    board.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        flash(board, row_idx, col_idx, flashers)
      end
    end

    board = reset_energy_level(board)
    step += 1
  end

  puts "First step all simultaneous: #{step}"
end

part1()
part2()
