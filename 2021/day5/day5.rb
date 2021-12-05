INPUT = File.read(ARGV[0]).split("\n")

def part1()
  lines = INPUT.map do |line| line.split(" -> ") end
  map = Array.new(1000){ Array.new(1000, 0)}

  lines.each do |line|
    line.map! do |coords|
      coords.split(",")
    end
  end.flatten.map(&:to_i).each_slice(4) do |slice|
    x1 = slice[0]
    y1 = slice[1]
    x2 = slice[2]
    y2 = slice[3]

    next unless x1 == x2 || y1 == y2

    map = draw_line(map, {x: x1, y: y1}, {x: x2, y: y2})
  end

  overlap_count = map.flatten.filter do |e| e >= 2 end.count

  puts "Part1: #{overlap_count}"
end

def part2()
  lines = INPUT.map do |line| line.split(" -> ") end
  map = Array.new(1000){ Array.new(1000, 0)}

  lines.each do |line|
    line.map! do |coords|
      coords.split(",")
    end
  end.flatten.map(&:to_i).each_slice(4) do |slice|
    x1 = slice[0]
    y1 = slice[1]
    x2 = slice[2]
    y2 = slice[3]

    map = draw_line_with_diagonals(map, {x: x1, y: y1}, {x: x2, y: y2})
  end

  overlap_count = map.flatten.filter do |e| e >= 2 end.count

  puts "Part2: #{overlap_count}"
end

def draw_line_with_diagonals(map, starting_point, end_point)
  return draw_column(map, starting_point, end_point) if starting_point[:x] == end_point[:x]
  return draw_row(map, starting_point, end_point) if starting_point[:y] == end_point[:y]

  draw_diagonal(map, starting_point, end_point)

  map
end

def draw_line(map, starting_point, end_point)
  starting_point[:x] == end_point[:x] ?
    draw_column(map, starting_point, end_point) :
    draw_row(map, starting_point, end_point)

  map
end

def draw_column(map, starting_point, end_point)
  steps = starting_point[:y] < end_point[:y] ?
    end_point[:y] - starting_point[:y] :
    starting_point[:y] - end_point[:y]

  starting_point[:y] < end_point[:y] ?
    (0..steps).each do |i|
      update_point(map, starting_point[:x], starting_point[:y] + i)
    end
  :
    (0..steps).each do |i|
      update_point(map, starting_point[:x], starting_point[:y] - i)
    end

  map
end

def draw_row(map, starting_point, end_point)
  steps = starting_point[:x] < end_point[:x] ?
    end_point[:x] - starting_point[:x] :
    starting_point[:x] - end_point[:x]

  starting_point[:x] < end_point[:x] ?
    (0..steps).each do |i|
      update_point(map, starting_point[:x] + i, starting_point[:y])
    end
  :
    (0..steps).each do |i|
      update_point(map, starting_point[:x] - i, starting_point[:y])
    end

  map
end

def draw_diagonal(map, starting_point, end_point)
  steps = starting_point[:x] < end_point[:x] ?
    end_point[:x] - starting_point[:x] :
    starting_point[:x] - end_point[:x]

  vec_x, vec_y = [1,1] if starting_point[:x] < end_point[:x] && starting_point[:y] < end_point[:y]
  vec_x, vec_y = [1,-1] if starting_point[:x] < end_point[:x] && starting_point[:y] > end_point[:y]
  vec_x, vec_y = [-1,1] if starting_point[:x] > end_point[:x] && starting_point[:y] < end_point[:y]
  vec_x, vec_y = [-1,-1] if starting_point[:x] > end_point[:x] && starting_point[:y] > end_point[:y]

  (0..steps).each do |i|
    update_point(map, starting_point[:x] + vec_x * i, starting_point[:y] + vec_y * i)
  end

  map
end

def update_point(map, x, y)
  if map[x][y] == 0
    map[x][y] = 1
    return map
  end

  map[x][y] += 1

  map
end

part1()
part2()
