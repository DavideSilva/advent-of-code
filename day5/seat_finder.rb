# frozen_string_literal: true

lines = File.read('input.txt').split("\n")

highest_seat = 0

seats_ids = []

lines.each do |line|
  lower = 0
  higher = 127

  lefty = 0
  righty = 7

  line.chars.each do |char|
    higher -= (lower..higher).count / 2 if char == 'F'
    lower = lower + (higher - lower) / 2 + 1 if char == 'B'

    righty -= (lefty..righty).count / 2 if char == 'L'
    lefty = lefty + (righty - lefty) / 2 + 1 if char == 'R'
  end

  # puts "'VALID' #{line}" if higher == lower && lefty == righty
  current_seat = lower * 8 + lefty

  highest_seat = current_seat if current_seat > highest_seat

  seats_ids << current_seat

  # puts "#{current_seat} #{line}"
end

seats_ids.sort!

puts seats_ids.first
puts seats_ids.last
puts seats_ids.count

puts seats_ids.inspect

# puts highest_seat
