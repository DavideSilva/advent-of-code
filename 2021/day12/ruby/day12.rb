INPUT = File.read(ARGV[0]).split

def graph
  graph = {}

  INPUT.each do |line|
    origin, destination = line.split("-")

    graph.key?(origin) ? graph[origin].push(destination) : graph[origin] = [destination]
    graph.key?(destination) ? graph[destination].push(origin) : graph[destination] = [origin]
  end

  graph
end

def find_paths(node, visited, all_paths, dup_node = nil)
  return all_paths << visited + ["end"] if node == "end"
  graph[node].each do |adj|
    if visited.include?(adj) && adj == adj.downcase
      next unless adj == dup_node && visited.count(adj) == 1
    end
    find_paths(adj, visited + [node], all_paths, dup_node)
  end

  all_paths
end

def part1
  paths = find_paths("start", [], []).map do |path| path.join(",") end
  puts paths
  puts paths.size
end

def part2
  paths = []
  graph.keys.select { |node| node == node.downcase && !["start", "end"].include?(node) }.each do |dup_node|
    paths += find_paths("start", [], [], dup_node)
  end
  puts paths.uniq.size
end

part2()
