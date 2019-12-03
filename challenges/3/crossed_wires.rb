require 'awesome_print'
require 'pry'
require 'ostruct'

class Pt
  attr_accessor(
    :wire,
    :steps,
    :ascii
  )

  def initialize(wire, steps, ascii)
    @wire = wire
    @ascii = ascii
    @steps = steps
  end

  def to_s
    ascii
  end

end

class CrossedWire
  attr_accessor(
      :board,
      :intersections,
      :verbose
  )

  def initialize(wires, verbose = false)
    self.board = {}
    self.intersections = []
    @verbose = verbose
    wires.map do |wire|
      # puts wire
      self.add_wire(wire)
    end
    add_pt('origin', 0, 0, 0, 'o')
  end

  def manhattan_dist(x, y)
    x.abs + y.abs
  end

  def add_line(wire, sx, sy, dir, length, steps)
    if verbose
      puts "#{sx}, #{sy}, #{dir}, #{length}"
    end

    case dir
    when 'U'
      yend = sy-length
      (sy..yend).step(-1).each do |y|
        steps += 1
        add_pt(wire, steps, sx, y, '|', y != sy)
      end
      return [sx, yend]
    when 'R'
      xend = sx+length
      (sx..xend).each do |x|
        steps += 1
        add_pt(wire, steps, x, sy, '-', x != sx)
      end
      return [xend, sy]
    when 'D'
      yend = sy+length
      (sy..yend).each do |y|
        steps += 1
        add_pt(wire, steps, sx, y, '|', y != sy)
      end
      return [sx, yend]
    when 'L'
      xend = sx-length
      (sx..xend).step(-1).each do |x|
        steps += 1
        add_pt(wire, steps, x, sy, '-', x != sx)
      end
      return [xend, sy]
    else
      raise "Could not determine direction"
    end

  end

  def add_pt(wire, steps, x, y, ascii, record_intersection = false)

    self.board ||= {}
    self.board[y] ||= {}

    found_pt = self.board[y][x]

    if found_pt && !(x == 0 && y == 0)
      if record_intersection && found_pt.wire != wire
        puts "found intersection @ #{x} #{y} with #{self.board[y][x]}" if verbose
        intersections.push [x, y, found_pt.steps + steps]
        found_pt.ascii = "X"
      else
        found_pt.ascii = '+'
      end
    else
      self.board[y][x] = Pt.new(wire, steps, ascii)
    end

    [x, y]
  end

  def add_wire(wire)
    cx, cy = 0, 0
    steps = -1
    wire.split(',').each do |line|
      matches = line.match(/\d+/)
      length = matches[0].to_i
      dir = line[0]
      cx, cy = add_line(wire, cx, cy, dir, length, steps)
      steps += length
    end

  end

  def yminmax
    self.board.keys.minmax
  end

  def xminmax
    ret_xmin = 0
    ret_xmax = 0
    Range.new(*yminmax).each do |y|
      xmin, xmax = (self.board[y] || {}).keys.minmax
      unless xmin.nil?
        ret_xmin = [xmin, ret_xmin].min
        ret_xmax = [xmax, ret_xmax].max
      end
    end

    [ret_xmin, ret_xmax]
  end

  def draw
    xmin, xmax = self.xminmax
    ymin, ymax = self.yminmax

    (ymin..ymax).each do |y|
      (xmin..xmax).each do |x|
        print (self.board[y] || {})[x] || " "
      end
      print "\n"
    end
  end

  def calc_part_one
    possible_answers = intersections.map { |x,y| manhattan_dist(x,y) }.sort
    if verbose
      puts "intersections:"
      intersections.sort_by { |x,y| manhattan_dist(x, y) }.map do |x,y|
        puts "#{x} #{y} #{manhattan_dist(x, y)}"
      end
    end
    possible_answers.first
  end

  def calc_part_two
    a = intersections.sort_by { |x,y,steps| steps  }.first

    a[2]
  end
end
