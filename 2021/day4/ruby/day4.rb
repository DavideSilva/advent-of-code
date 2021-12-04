INPUT = File.read(ARGV[0]).split("\n\n")

numbers, *boards = INPUT
numbers = numbers.split(",").map(&:to_i)

boards = boards.map do |board|
  board.split.map(&:to_i).each_slice(5).reduce([]) do |acc, number|
    acc << number
  end
end

def part1(numbers, boards)
  numbers = numbers.reduce([]) do |drawn_numbers, new_draw|
    drawn_numbers << new_draw
    break drawn_numbers if check_winning_board(drawn_numbers, boards)

    drawn_numbers
  end
end

def part2(numbers, boards)
  numbers = numbers.reduce([]) do |drawn_numbers, new_draw|
    drawn_numbers << new_draw
    boards = last_winning_board(drawn_numbers, boards)
    break drawn_numbers if boards.nil?

    drawn_numbers
  end
end

def check_lines(numbers_drawn, rows, columns)
  winning_row = rows.any? do |row|
    all_match = row.all? do |number|
      numbers_drawn.flatten.include? number
    end
  end

  winning_column = columns.any? do |column|
    winner = column.all? do |number|
      numbers_drawn.flatten.include? number
    end
  end

  winning_row || winning_column
end

def calculate_score(numbers_drawn, winning_board)
  numbers = numbers_drawn.flatten
  last_number = numbers.last

  puts "Sum of unmarked numbers: #{(winning_board.flatten - numbers).sum}"
  puts "Last number drawn: #{last_number}"
  puts "Score: #{(winning_board.flatten - numbers).sum * last_number}"
end

def last_winning_board(numbers_drawn, boards)
  if check_winning_board(numbers_drawn, boards)
    winning_board = boards.filter do |board|
      check_lines(numbers_drawn, board, board.transpose)
    end

    calculate_score(numbers_drawn, winning_board)

    return boards - winning_board
  end

  boards

end

def check_winning_board(numbers_drawn, boards)
  boards.any? do |board|
    winner = check_lines(numbers_drawn, board, board.transpose)
    if winner
      calculate_score(numbers_drawn, board)
    end
    winner
  end
end

# part1(numbers, boards)
part2(numbers, boards)
