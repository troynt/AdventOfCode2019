
require 'awesome_print'
require 'pry'
require 'matrix'

require_relative '../2/program_alarm'

class OxygenFound < StandardError

end

class Tile
  attr_reader(
      :dist,
      :adj
  )

  attr_accessor(
      :tile_id
  )

  def open?
    !wall?
  end

  def wall?
    tile_id == "#"
  end

  def add_adj(tile)
    raise "cant add self as adj" if tile == self
    @adj << tile
    @explored = @adj.length == 4 unless explored?
  end

  def explored?
    @explored
  end

  def initialize(tile_id, dist)
    @tile_id = tile_id
    @dist = dist
    @adj = Set.new
    @explored = false
  end

  def inspect
    "#{object_id} explored? #{explored?}"
  end

  def ascii
    tile_id == "#" ? "\u2588" : tile_id
  end
end

# https://adventofcode.com/2019/day/15
class OxygenSystem
  DIRS = {
      1 => Vector[0, -1], # north
      2 => Vector[0, 1], # south
      3 => Vector[-1, 0], # east
      4 => Vector[1, 0] # west
  }.freeze

  def adjacent_tiles
    dist = cur_tile.dist + 1
    DIRS.map do |k, v|
      [k, tile_at(v + @drone_pos) || Tile.new(".", dist)]
    end
  end

  def tile_at(pos)
    x, y = pos.to_a
    @panels[y] ||= {}
    @panels[y][x]
  end

  def initialize(nums)
    @program = ProgramAlarm.new(mem: nums)

    @tiles = []
    @last_input = nil

    @program.on_input do
      possible_tiles = adjacent_tiles.select { |dir, tile| !tile.wall? }

      choice, tile = possible_tiles.shuffle.first

      @last_input = DIRS[choice]
      choice
    end

    @program.on_output do |out|
      process_output(out)
    end

    @panels = {}
    @drone_pos = Vector[0, 0]
    create_tile(@drone_pos, '.', 0)
    @oxygen_pos = nil
  end

  # TODO make this actually explore the entire map...
  def build_map!
    @program.run!
  rescue OxygenFound
    return
  end

  def create_tile(pos, tile_id, dist)
    x, y = pos.to_a

    @panels[y] ||= {}
    if @panels[y][x].nil?
      @panels[y][x] = Tile.new(tile_id, dist)
      @tiles << @panels[y][x]
    end

    @panels[y][x]
  end

  def cur_tile
    tile_at(@drone_pos)
  end

  def create_adj(a, b)
    raise "should not create adj if tiles are the same" if a == b

    a.add_adj(b)
    b.add_adj(a)
  end

  """
  0: The repair droid hit a wall. Its position has not changed.
  1: The repair droid has moved one step in the requested direction.
  2: The repair droid has moved one step in the requested direction; its new position is the location of the oxygen system.
  """
  def process_output(out)
    dist = cur_tile.dist + 1

    case out
    when 0
      # puts "hit wall"
      wall_pos = @drone_pos + @last_input
      a = create_tile(wall_pos, '#', dist)
      create_adj(a, cur_tile)

    when 1
      # puts "successfully moved"
      a = create_tile(@drone_pos + @last_input, ".", dist)
      create_adj(a, cur_tile)
      @drone_pos += @last_input
    when 2
      # puts "successfully moved and oxygen found"
      a = create_tile(@drone_pos + @last_input, "o", dist)
      create_adj(a, cur_tile)
      @drone_pos += @last_input
      @oxygen_pos = @drone_pos
      raise OxygenFound
    else
      raise "bad output"
    end

  end

  def x
    @drone_pos[0]
  end

  def y
    @drone_pos[1]
  end

  def yminmax
    (@panels.keys + [y]).minmax
  end

  def xminmax

    xvals = [x]
    @panels.each do |y, v|
      xvals += v.keys
    end
    xvals.minmax
  end


  def draw
    print "\n"
    ymin, ymax = yminmax
    xmin, xmax = xminmax
    (ymin..ymax).step(1).each do |y|
      (xmin..xmax).step(1).each do |x|
        if self.x == x && self.y == y
          print "D"
        elsif x == 0 && y == 0
          print "S"
        else
          print (@panels.fetch(y, {})[x] || Tile.new(".", nil)).ascii
        end
      end
      print "\n"
    end
    puts ""
  end

  def calc_part_one
    build_map!
    cur_tile.dist
  end

  def calc_part_two
    build_map!

    other_tile_count = @tiles.reject(&:wall?).length
    all_oxy_tiles = [tile_at(@oxygen_pos)]
    cur_gen_oxy_tiles = all_oxy_tiles.dup

    if all_oxy_tiles.reject(&:nil?).length == 0
      raise "no oxygen?"
    end


    gen_cnt = 0
    until all_oxy_tiles.length == other_tile_count do
      next_gen_oxy_tiles = []

      cur_gen_oxy_tiles.each do |o|
        o.tile_id = "o"
        next_gen_oxy_tiles.concat o.adj.select { |x| x.open? && x.tile_id != "o" }
        all_oxy_tiles << o
      end

      cur_gen_oxy_tiles = next_gen_oxy_tiles
      gen_cnt += 1
    end


    gen_cnt
  end
end
