stacks = File.read("input").split("\n").take(8).reverse

stack = [[1,2,3,4,5,6,7,8,9],[],[],[],[],[],[],[],[],[]]

stacks.each do |boxes|
  stack[1] << boxes[1] if boxes[1] != " "
  stack[2] << boxes[5] if boxes[5] != " "
  stack[3] << boxes[9] if boxes[9] != " "
  stack[4] << boxes[13] if boxes[13] != " "
  stack[5] << boxes[17] if boxes[17] != " "
  stack[6] << boxes[21] if boxes[21] != " "
  stack[7] << boxes[25] if boxes[25] != " "
  stack[8] << boxes[29] if boxes[29] != " "
  stack[9] << boxes[33] if boxes[33] != " "
end

ops = File.read("input").split("\n").drop(10)

# ops.each do |op|
#   quantity, origin, destination = op.match(/move\s(\d+)\sfrom\s(\d+)\sto\s(\d+)/).captures
#
#   quantity.to_i.times do
#     stack[destination.to_i].push(stack[origin.to_i].last)
#     stack[origin.to_i].pop
#   end
# end

# PART 2

stack = [[1,2,3,4,5,6,7,8,9],[],[],[],[],[],[],[],[],[]]

ops.each do |op|
  quantity, origin, destination = op.match(/move\s(\d+)\sfrom\s(\d+)\sto\s(\d+)/).captures
  stack[destination.to_i].push(stack[origin.to_i].pop(quantity.to_i)).flatten!
end

require "pry"; binding.pry
