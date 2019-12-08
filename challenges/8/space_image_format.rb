
require 'awesome_print'
require 'pry'

# https://adventofcode.com/2019/day/8
class SpaceImageFormat
  attr_reader(
    :layers
  )

  def initialize(nums)
    @layers = nums.each_slice(25 * 6).to_a
  end

  def calc_part_one

    smallest_layer = layers.min_by do |layer|
      layer.count("0")
    end

    smallest_layer.count("1") * smallest_layer.count("2")
  end

  def get_pixel(layer, x, y)
    layer[(25 * y) + x]
  end

  def search_pixel(x,y)
    layers.each do |l|
      px = get_pixel(l, x, y)
      return px if px != "2"
    end
  end

  def calc_part_two
    output = "\n"
    (0..5).each do |y|
      (0..24).each do |x|
        output <<  search_pixel(x, y)
      end
      output << "\n"
    end

    output.gsub("0", " ").gsub("1", "\u2588")
  end
end
