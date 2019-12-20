
require 'awesome_print'
require 'pry'
require 'matrix'

require_relative '../2/program_alarm'

# https://adventofcode.com/2019/day/19
class TractorBeam

  def initialize(mem:)
    @program = ProgramAlarm.new(mem: mem)
  end

  def is_in_beam(pos)

    @program.reset!

    inputs = pos.to_a
    @program.on_input do
      inputs.shift
    end

    @output = nil

    @program.on_output do |out|
      @output = out == 1
    end

    @program.run!

    @output
  end

  def calc_part_one
    size = 50

    count = 0
    size.times do |y|
      size.times do |x|
        count += 1 if is_in_beam(Vector[x, y])
      end
    end
    count
  end

  def calc_part_two
    bottom_left = Vector[0, 5] # skip couple lines because blank lines
    square_width = 100
    w = square_width - 1

    loop do
      if is_in_beam(bottom_left)
        top_right = bottom_left[0] + w, bottom_left[1] - w
        if is_in_beam(top_right)
          top_left = Vector[bottom_left[0], bottom_left[1] - w]
          return 10_000 * top_left[0] + top_left[1]
        end
        bottom_left += Vector[0, 1] # move down
      else
        bottom_left += Vector[1, 0] # move right
      end
    end
  end
end
