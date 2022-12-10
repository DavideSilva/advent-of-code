class Point
  attr_accessor :x, :y

  def initialize(a, b)
    @x = a
    @y = b
  end

  def move(dir)
    case dir
    when "R"
      @x += 1
    when "L"
      @x -= 1
    when "U"
      @y += 1
    when "D"
      @y -= 1
    end
  end

  def adjacent?(point)
    (@x - point.x).abs <= 1 && (@y - point.y).abs <= 1
  end

  def overlap?(point)
    @x == point.x && @y == point.y
  end

  def follow(point)
    return if adjacent?(point)

    a = point.x - @x
    b = point.y - @y

    a = a/2 if a.abs == 2
    b = b/2 if b.abs == 2

    @x += a
    @y += b
  end

  def to_s
    "#{@x}:#{@y}"
  end
end

def solve(input, knots: 2)
  segments = Array.new(knots) { Point.new(0,0) }
  visited = {}

  input.each do |line|
    dir, steps = line.split
    head = segments.first
    tail = segments.last

    steps.to_i.times do |_|
      head.move(dir)
      segments.each_cons(2) do |h,t|
        t.follow(h)
      end

      visited[tail.to_s] = 1
    end
  end

  puts visited.size
end

input = File.read("input").split("\n")

solve(input, knots: 2)
solve(input, knots: 10)
