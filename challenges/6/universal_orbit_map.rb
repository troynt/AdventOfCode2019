# https://adventofcode.com/2019/day/6
class UniversalOrbitMap
  def initialize(edges)
    @parents = Hash[edges]
  end

  def labels
    Set.new(@parents.keys) + Set.new(@parents.values)
  end

  def count(acc, obj)
    if @parents[obj]
      count(acc + 1, @parents[obj])
    else
      acc
    end

  end

  def calc_part_one
    labels.reduce(0) do |acc, label|
      acc + count(0, label)
    end
  end

  def parent(child)
    @parents[child]
  end

  def calc_part_two
    a = shortest_path_to("YOU", "SAN")
    a.length - 1
  end

  def path_to_root(a)
    cur = parent(a)
    path = [a]
    loop do
      path << cur
      cur = parent(cur)
      break if cur == "COM"
    end

    path
  end

  # Does not include first and last node.
  def shortest_path_to(a, b)
    a_path = path_to_root(a)
    b_path = path_to_root(b)

    path = []

    a_path.each_with_index do |node, idx|
      shared_root_idx = b_path.index(node)
      if shared_root_idx.nil?
        path << node
      else
        path.concat(b_path.slice(0, shared_root_idx + 1).reverse)
        return path.slice(1,path.length-2) # remove first and last element
      end
    end

  end
end
