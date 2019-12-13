
require 'awesome_print'
require 'pry'

require_relative '../2/program_alarm'

class Tile

  attr_reader(
      :tile_id
  )
  def initialize(tile_id)
    @tile_id = tile_id
  end

  def inspect
    ascii
  end

  def to_s
    ascii
  end

  def ascii
    """0 is an empty tile. No game object appears in this tile.
1 is a wall tile. Walls are indestructible barriers.
2 is a block tile. Blocks can be broken by the ball.
3 is a horizontal paddle tile. The paddle is indestructible.
4 is a ball tile. The ball moves diagonally and bounces off objects."""

    {
        0 => " ",
        1 => "#",
        2 => "*",
        3 => "=",
        4 => "o"
    }[@tile_id]
  end
end

# https://adventofcode.com/2019/day/13
class CarePackage
  attr_reader(
      :panels
  )
  def initialize(nums)
    @program = ProgramAlarm.new(mem: nums, verbose: false)
    @get_input = :x
    @joystick_pos = 0
    @program.on_output do |out|
      process_output(out)
    end
    @program.on_input do
      # draw
      @joystick_pos
    end
    @x = nil
    @y = nil
    @tile_id = nil
    @segment_display = nil
    @panels = {}
    @ball_pos = nil
    @paddle_x = nil
  end

  def ball_x
    @ball_pos[0]
  end

  def adjust_input!
    return if @paddle_x.nil?
    if @paddle_x > ball_x
      @joystick_pos = -1
    elsif @paddle_x < ball_x
      @joystick_pos = 1
    else
      @joystick_pos = 0
    end
  end

  def process_output(out)
    case @get_input
    when :x
      @x = out
      @get_input = :y
    when :y
      @y = out
      @get_input = :tile_id
    when :tile_id
      if  @x == -1 && @y == 0
        @segment_display = out
      else
        @tile_id = out
        if @tile_id == 4
          @ball_pos = Vector[@x, @y]
          adjust_input!
        end
        if @tile_id == 3
          @paddle_x = @x
        end
        @panels[@y] ||= {}
        @panels[@y][@x] = Tile.new(@tile_id)
      end

      @get_input = :x

    end
  end

  def calc_part_one
    @program.run!

    tile_count[2]
  end

  def calc_part_two
    @program.quarters = 2
    @program.run!

    @segment_display
  end

  def yminmax
    (@panels.keys).minmax
  end

  def xminmax

    xvals = []
    @panels.each do |y, v|
      xvals += v.keys
    end
    xvals.minmax
  end


  def tile_count
    ret = {}
    ymin, ymax = yminmax
    xmin, xmax = xminmax
    (ymin..ymax).step(1).each do |y|
      (xmin..xmax).step(1).each do |x|

        found = @panels.fetch(y, {})[x]
        if found
          ret[found.tile_id] ||= 0
          ret[found.tile_id] += 1
        end

      end
    end

    ret
  end

  def draw
    puts "Score: #{@segment_display}"
    ymin, ymax = yminmax
    xmin, xmax = xminmax
    (ymin..ymax).step(1).each do |y|
      (xmin..xmax).step(1).each do |x|

        print (@panels.fetch(y, {})[x] || Tile.new(0)).ascii

      end
      print "\n"
    end
    puts ""
  end
end
