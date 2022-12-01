INPUT = File.read(ARGV[0]).split.map(&:chars).map do |l| l.map(&:to_i) end

def each_neighbour(matrix, (x, y))
  yield [x, y - 1] if y > 0
  yield [x + 1, y] if x + 1 < matrix[y].size
  yield [x, y + 1] if y + 1 < matrix.size
  yield [x - 1, y] if x > 0
end

def shortest_path(matrix, start_pos, end_pos)
  visited = {}
  initial = [start_pos, 0]
  queue = [initial]

  until queue.empty?
    queue = queue.sort_by do |elem| elem.last end
    position, risk = queue.shift

    next if visited.key?(position)
    visited[position] = true

    return risk if position == end_pos

    each_neighbour(matrix, position) do |x,y|
      queue.push([[x,y], risk + matrix[y][x]])
    end
  end
end

def part1
  start_pos = [0,0]
  end_pos = [INPUT[0].size - 1, INPUT.size - 1]
  puts shortest_path(INPUT, start_pos, end_pos)
end

def part2
  full_map = 5.times.flat_map { |ny|
    INPUT.map { |row|
      5.times.flat_map { |nx|
        row.map { |risk|
          new_risk = risk + ny+nx
          new_risk -= 9 while new_risk > 9
          new_risk
        }
      }
    }
  }
  start_pos = [0,0]
  end_pos = [full_map[0].size - 1, full_map.size - 1]
  puts shortest_path(full_map, start_pos, end_pos)
end

part1
part2
