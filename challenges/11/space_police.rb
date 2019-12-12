
require 'awesome_print'
require 'pry'

require_relative '../2/program_alarm'

class PaintHistory
  def initialize
    @history = [0]
  end

  def color
    @history.last
  end

  def inspect
    ascii
  end

  def ascii
    color == 0 ? '.' : "\u2588"
  end

  def paint(color)
    @history << color
    #puts "painting #{ascii}"
  end
end

# https://adventofcode.com/2019/day/11
class SpacePolice

  attr_reader(
    :panels
  )

  DIRS = {
      u: [0, -1],
      r: [1, 0],
      d: [0, 1],
      l: [-1,0]
  }.each_value(&:freeze).freeze

  def initialize(mem:)
    @panels = {}
    @brain = ProgramAlarm.new(mem: mem)
    @pos = [0, 0]
    @facing = :u
    @output_cnt = 0

    @brain.on_input do
      on_black? ? 0 : 1
    end

    @brain.on_output do |out|
      process_output(out)
    end

  end


  def turn_right!
    @facing = {
        u: :r,
        r: :d,
        d: :l,
        l: :u
    }[@facing]
  end

  def turn_left!
    @facing = {
        u: :l,
        r: :u,
        d: :r,
        l: :d
    }[@facing]
  end

  def x
    @pos[0]
  end

  def y
    @pos[1]
  end

  def move_facing!
    dx, dy = DIRS[@facing]
    @pos = [x + dx, y + dy]
  end

  def cur_block
    @panels[y] ||= Hash.new
    @panels[y][x] ||= PaintHistory.new
    @panels[y][x]
  end

  def on_black?
    cur_block.color == 0
  end

  def process_output(out)
    if @output_cnt % 2 == 0
      cur_block.paint(out)
    else
      if out == 1
        turn_right!
      else
        turn_left!
      end
      move_facing!
    end
    @output_cnt += 1
  end

  def painted_panels_count
    @panels.values.map(&:values).flatten!.length
  end

  def calc_part_one
    @brain.run!

    # guess 2318 was too low...
    painted_panels_count
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

  def ascii
    { u: '^', r: '>', d: 'V', l: '<'}[@facing]
  end

  def draw
    print "\n"
    ymin, ymax = yminmax
    xmin, xmax = xminmax
    (ymin..ymax).step(1).each do |y|
      (xmin..xmax).step(1).each do |x|
        if self.x == x && self.y == y
          print ascii
        else
          print (@panels.fetch(y, {})[x] || PaintHistory.new).ascii
        end
      end
      print "\n"
    end
    puts ""
  end

  def calc_part_two
    cur_block.paint(1)
    @brain.run!
  end
end