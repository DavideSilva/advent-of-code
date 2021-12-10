INPUT = File.read(ARGV[0]).split

def part1
  scores = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
}

  score = 0
  INPUT.each do |line|
    stack = []
    line.chars.each do |c|
      case c
      when "("; stack.push ")"
      when "["; stack.push "]"
      when "{"; stack.push "}"
      when "<"; stack.push ">"

      when ")", "]", "}", ">"
        if stack.last == c
          stack.pop
        else
          # puts "Expected: #{stack.last} - Got: #{c}"
          score += scores[c]
          break
        end
      end
    end
  end
  puts score
end

def is_corrupted?(line)
  stack = []
  corrupted = false

  line.chars.each do |c|
    case c
    when "("; stack.push ")"
    when "["; stack.push "]"
    when "{"; stack.push "}"
    when "<"; stack.push ">"

    when ")", "]", "}", ">"
      if stack.last == c
        stack.pop
      else
        corrupted = true
        break
      end
    end
  end

  corrupted
end

def part2
  incomplete = INPUT.filter do |line|
    !is_corrupted?(line)
  end

  scores = {
      ')' => 1,
      ']' => 2,
      '}' => 3,
      '>' => 4
  }

  string_scores = incomplete.map do |line|
    stack = []
    line.chars.each do |c|
      case c
      when "("; stack.push ")"
      when "["; stack.push "]"
      when "{"; stack.push "}"
      when "<"; stack.push ">"

      when ")", "]", "}", ">"
        if stack.last == c
          stack.pop
        end
      end
    end
    stack.reverse.reduce(0) do |score, c|
      score = score * 5 + scores[c]
    end
  end
  puts string_scores.sort[string_scores.size / 2]
end

part1()
part2()
