INPUT = File.read(ARGV[0]).split("\n")

tree = Hash.new(0)
pwd = "/"

INPUT.each do |line|
  next if (line =~ /\$ cd \//) == 0

  if line.start_with?("$ cd")
    dir = line.match(/\$ cd (\w+|\.\.)/).captures.first
    dir == ".." ? pwd = pwd.rpartition("/").first : pwd += dir + "/"
    next
  end

  unless line.start_with?("$ ls")
    unless line.start_with?("dir")
      filesize = line.match(/(\d+)/).captures.first
      tree["/"] += filesize.to_i
      pwd.split("/").reject(&:empty?).reduce("/") do |acc, dirname|
        dir = acc + dirname + "/"
        tree[dir] += filesize.to_i

        dir
      end
    end
  end
end

puts (tree.values.reject do |v| v > 100000 end).sum

total_disk_size = 70000000
update_space = 30000000

used_space = total_disk_size - tree["/"]
needed_space = update_space - used_space

puts (tree.values.select do |v| v >= needed_space end).min
