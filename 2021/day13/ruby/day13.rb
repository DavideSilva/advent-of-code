INPUT = File.read(ARGV[0])

dots, instructions = INPUT.split("\n\n")
dots = dots.split

dots = dots.map do |dot|
  dot.split(",")
end.map do |dot|
  dot.map(&:to_i)
end

instructions = instructions.split("\n").map do|fold_line|
  fold_line.split("fold along ").last.split("=")
end


def get_paper_size(dots)
  dots.transpose.map(&:max)
end

def build_paper(dots)
  paper = []
  x, y = get_paper_size(dots)

  (y+1).times do paper << Array.new((x+1), '.') end

  dots.each do |dot| paper[dot.last][dot.first] = '#' end

  paper
end

def fold_vertically(paper, position)
  x_size = paper.size
  y_size = paper[0].size
  size_of_each_half = y_size / 2 - 1

  folded_paper = []
  (x_size).times do folded_paper << Array.new(size_of_each_half, '.') end

  cut = paper.map do |line|
    line.partition.with_index do |_, index|
      index < position
    end
  end

  left = cut.reduce([]) do |fold, splits| fold << splits.first end
  right = cut.reduce([]) do |fold, splits| fold << splits.last end

  right = right.transpose.drop(1).transpose

  left.each_with_index do |line, row|
    line.each_with_index do |dot, col|
      right_dot = right[row][size_of_each_half - col]
      if dot == '.' && right_dot == '.'
        folded_paper[row][col] = '.'
      else
        folded_paper[row][col] = '#'
      end
    end
  end

  folded_paper
end

def fold_horizontally(paper, position)
  x_size = paper.size
  y_size = paper[0].size
  size_of_each_half = x_size / 2 - 1

  folded_paper = []
  (size_of_each_half + 1).times do folded_paper << Array.new(y_size, '.') end

  top, bottom = paper.partition.with_index do |_, index| index < position end

  bottom = bottom.drop(1)

  top.each_with_index do |line, row|
    line.each_with_index do |dot, col|
      bottom_dot = bottom[size_of_each_half - row][col]
      if dot == '.' && bottom_dot == '.'
        folded_paper[row][col] = '.'
      else
        folded_paper[row][col] = '#'
      end
    end
  end

  folded_paper
end

def fold(paper, orientation, position)
  case orientation
  when "x"
    paper = fold_vertically(paper, position)
  when "y"
    paper = fold_horizontally(paper, position)
  end
  paper
end

def part1(dots, instructions)
  paper = build_paper(dots)

  orientation, position = instructions.first

  paper = fold(paper, orientation, position.to_i)

  visible = paper.map do |l| l.count('#') end.sum
  puts visible
end

def part2(dots, instructions)
  paper = build_paper(dots)

  instructions.each do |orientation, position|
    paper = fold(paper, orientation, position.to_i)

  end

  puts paper.map(&:join)
end

part1(dots, instructions)
part2(dots, instructions)
