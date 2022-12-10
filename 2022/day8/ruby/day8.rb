INPUT = File.read(ARGV[0]).split("\n")

map = INPUT.map(&:chars)
map_transposed = map.transpose

visible = 0
score = []

map.each.with_index do |row, row_idx|
  row.each.with_index do |col, col_idx|
    if row_idx == 0 || col_idx == 0 || row_idx == map.size - 1 || col_idx == map.size - 1
      visible += 1
    else
      tree = map[row_idx][col_idx]
      left = row[0...col_idx]
      right = row[col_idx+1..]
      top = map_transposed[col_idx][0...row_idx]
      bottom = map_transposed[col_idx][row_idx+1..]

      visible += 1 if tree > left.max || tree > right.max ||
                      tree > top.max || tree > bottom.max

      left_score = left.reverse.take_while do |t| t < tree end.count
      left_score += 1 if left_score < left.size

      right_score = right.take_while do |t| t < tree end.count
      right_score += 1 if right_score < right.size

      top_score = top.reverse.take_while do |t| t < tree end.count
      top_score += 1 if top_score < top.size

      bottom_score = bottom.take_while do |t| t < tree end.count
      bottom_score += 1 if bottom_score < bottom.size

      score.push(left_score * right_score * top_score * bottom_score)
    end
  end
end

puts visible
puts score.max
