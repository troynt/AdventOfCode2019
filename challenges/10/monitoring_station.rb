
require 'awesome_print'
require 'pry'

class Astroid
  HALF_PIE = Math::PI / 2

  attr_reader(
    :pos
  )
  attr_accessor(
    :visible_to
  )
  def initialize(pos)
    @pos = pos
    @visible_to = Set.new
  end

  def visible_count
    @visible_to.length
  end

  def inspect
    "(#{x},#{y})"
  end

  def x
    @pos[0]
  end

  def y
    @pos[1]
  end

  def distance(other)
    Math.sqrt((other.x - x)**2.0 + (other.y - y)**2.0)
  end

  # 0 points north
  def radians(other)
    Math.atan2(other.y - y, other.x - x) + (Math::PI / 2)
  end

  def degrees(other)
    ret = (radians(other) * 180.0 / Math::PI)
    if ret < 0
      ret = ret + 360
    end

    ret
  end
end

# https://adventofcode.com/2019/day/10
class MonitoringStation
  def initialize(map:)
    @astroid_map = map.map(&:strip).map(&:chars).freeze
  end

  def asteroids
    @asteroids ||= begin
                  asteroids = []
                  @astroid_map.each_with_index do |row, y|
                    row.each_with_index do |char, x|
                      asteroids << Astroid.new([x, y]) if char == "#"
                    end
                  end
                  asteroids
                end
  end

  def calc_part_two
    station = calc_part_one
    angles = asteroids.reject { |x| x == station }.group_by {|b| station.degrees(b) }.transform_values { |asteroids| asteroids.sort_by {|a| station.distance(a) }}
    angles = angles.sort_by { |k, v| k }.to_h

    death_order = []
    until death_order.length == 200 || angles.empty?
      angles.each do |deg, asteroids|
        death_order << asteroids.shift
        angles.delete(deg) if asteroids.length == 0
      end
    end

    death_order
  end

  def calc_part_one
    asteroids.each do |a|
      ret = Set.new
      angles = asteroids.reject { |x| x == a }.group_by {|b| a.degrees(b) }

      angles.each do |line, asteroids_on_line|
        ret.add asteroids_on_line.min_by { |c| a.distance(c) }
      end

      a.visible_to = ret
    end

    asteroids.max_by {|a| a.visible_to.length }
  end

  def astroid(x, y)
    asteroids.find { |a| a.x == x && a.y == y }
  end

  def ymax
    @asteroids.max_by {|a| a.y }.y
  end

  def xmax
    @asteroids.max_by {|a| a.x }.x
  end

  def draw
    (0..ymax).each do |y|
      (0..xmax).each do |x|
        found = astroid(x,y)
        print found ? found.visible_count : '.'
      end
      print "\n"
    end
  end

end
