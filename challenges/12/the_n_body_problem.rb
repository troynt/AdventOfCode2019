
require 'awesome_print'
require 'pry'
require 'matrix'

class Moon
  attr_reader(
    :pos,
    :vel,
    :orig_pos,
    :steps_to_reach_original_pos
  )

  def initialize(pos)
    @orig_pos = pos.dup.freeze
    @pos = pos
    @vel = Vector[0, 0, 0]
  end

  def self.from_str(str)
    Moon.new(Vector[*str.scan(/-?\d+/m).map(&:to_i)])
  end

  def apply_vel!
    @pos += @vel
  end

  def inspect
    "pos=<#{@pos.to_a}>, vel=<#{@vel.to_a}>"
  end

  def energy
    @pos.to_a.map(&:abs).reduce(:+) * @vel.map(&:abs).to_a.reduce(:+)
  end
end

# https://adventofcode.com/2019/day/12
class TheNBodyProblem
  attr_reader(
    :moons
  )

  def initialize(positions)
    @moons = []
    positions.each do |pos|
      @moons << Moon.from_str(pos)
    end
  end

  def energy
    @moons.inject(0) do |acc, m|
      acc + m.energy
    end
  end

  def apply_gravity(a, b)
    (0..2).each do |axis|
      next if a.pos[axis] == b.pos[axis]

      if a.pos[axis] < b.pos[axis]
        a.vel[axis] += 1
        b.vel[axis] -= 1
      else
        a.vel[axis] -= 1
        b.vel[axis] += 1
      end
    end
  end

  def moon_pairs
    @moon_pairs ||= @moons.combination(2)
  end

  def simulate!
    moon_pairs.each do |a, b|
      apply_gravity(a, b)
    end
    @moons.each(&:apply_vel!)
  end

  def calc_part_one(steps)
    steps.times do |i|

      simulate!

      #puts "After step #{i + 1}"
      #ap @moons

    end
  end

  def dimension_key(dim_idx)
    ret = []
    @moons.each do |x|
      ret << x.pos[dim_idx]
      ret << x.vel[dim_idx]
    end

    ret
  end

  def calc_part_two

    found = (0..2).map do |dim_idx|
      history = {}
      dim_repeated_at = 1000000.times do |t|
        simulate!
        k = dimension_key(dim_idx)
        if history.has_key?(k)
          break t
        end
        history[k] = t
      end

      raise "Missing dimension #{dim_idx}" if dim_repeated_at.nil?

      dim_repeated_at
    end

    found.reduce(1, :lcm)
  end
end

