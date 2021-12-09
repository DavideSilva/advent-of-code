INPUT = File.read(ARGV[0]).split.map(&:chars)

def low_point?(row, column)
  point = INPUT[row][column]

  top = row == 0 || point < INPUT[row-1][column]
  right = column == INPUT[row].size - 1 || point < INPUT[row][column+1]
  bottom = row == INPUT.size - 1 || point < INPUT[row+1][column]
  left = column == 0 || point < INPUT[row][column-1]

  top && right && bottom && left
end

def part1
  sum = 0
  INPUT.each_with_index do |row, row_idx|
    row.each_with_index do |val, col_idx|
      sum += val.to_i + 1 if low_point?(row_idx, col_idx)
    end
  end
  puts sum
end

def low_points
  low_points = []
  INPUT.each_with_index do |row, row_idx|
    row.each_with_index do |val, col_idx|
      low_points << { x: row_idx, y: col_idx } if low_point?(row_idx, col_idx)
    end
  end
  low_points
end

def neighbors(point)
  queue = []
  visited = []
  basin = []

  queue << point
  visited << point

  while queue.any?
    current_point = queue.shift
    adjacents(current_point[:x], current_point[:y]).each do |adjacent_neighbor|
      next if visited.include?(adjacent_neighbor)
      queue << adjacent_neighbor
      visited << adjacent_neighbor
      basin << adjacent_neighbor
    end
  end

  basin
end

def adjacents(row, column)
  adjacents = []

  # top
  adjacents << {x: row - 1, y: column} if row > 0 && INPUT[row - 1][column] != "9"
  # bottom
  adjacents << {x: row + 1, y: column} if row < INPUT.size - 1 && INPUT[row + 1][column] != "9"
  # left
  adjacents << {x: row, y: column - 1} if column > 0 && INPUT[row][column - 1] != "9"
  # right
  adjacents << {x: row, y: column + 1} if column < INPUT[row].size - 1 && INPUT[row][column + 1] != "9"

  adjacents
end

def basin_from(low_point)
  [low_point].push(*neighbors(low_point))
end

def part2
  three_largest_basins_size = low_points.map do |low_point|
    basin_from(low_point)
  end.map(&:size).sort.reverse.take(3).inject(&:*)

  puts three_largest_basins_size
end

part1()
part2()
