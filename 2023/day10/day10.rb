#!/usr/bin/env ruby
# frozen_string_literal: true

print 'enter for input, ex for example: '
INPUT = "inputs/10#{gets.chomp}".freeze
print 'part 1 or 2: '
PART = gets.chomp

SYMBOLS = { '|' => %i[north south], '-' => %i[east west],
            'L' => %i[north east], 'J' => %i[north west],
            'F' => %i[south east], '7' => %i[south west],
            '.' => %i[] }.freeze
DIRECTION_OFFSETS = { south: [1, 0], north: [-1, 0], east: [0, 1], west: [0, -1] }.freeze
DIRECTION_OPPOSITES = { south: :north, north: :south, east: :west, west: :east }.freeze

def pipe_array
  pipes = []
  start = [0, 0]
  File.foreach(INPUT).with_index do |line, i|
    start = [i, line =~ /S/] if line =~ /S/
    pipes.push line.chars
  end
  [start, pipes]
end

def next_pipe(from, pipe)
  (SYMBOLS[pipe] - [from])[0]
end

# rubocop:disable Metrics
def get_start_pipe(start, pipes)
  i, j = start
  if SYMBOLS[pipes[i][j + 1]].include? :west
    [[i, j + 1], :east]
  elsif SYMBOLS[pipes[i][j - 1]].include? :east
    [[i, j - 1], :west]
  elsif SYMBOLS[pipes[i + 1][j]].include? :north
    [[i + 1, j], :south]
  else
    [[i - 1, j], :north]
  end
end
# rubocop:enable Metrics

def pipe_loop(pipes, start, direction)
  loop_coords = []
  i, j = start
  loop_coords.push([i, j])
  loop do
    direction = next_pipe(DIRECTION_OPPOSITES[direction], pipes[i][j])
    i += DIRECTION_OFFSETS[direction][0]
    j += DIRECTION_OFFSETS[direction][1]
    loop_coords.push([i, j])
    return loop_coords if pipes[i][j] == 'S'
  end
end

def pipe_area(loop)
  sum = 0
  loop.push(loop[0])
  loop.each_cons(2) do |n1, n2|
    x1, y1 = n1
    x2, y2 = n2
    sum += x1 * y2 - x2 * y1
  end
  (sum / 2).abs - (loop.length / 2) + 1
end

start, pipes = pipe_array
start_pipe, direction = get_start_pipe(start, pipes)

puts pipe_loop(pipes, start_pipe, direction).length / 2 if PART == '1'
puts pipe_area(pipe_loop(pipes, start_pipe, direction)) if PART == '2'
