
class TheTyrannyOfTheRocketEquation
  def initialize(nums)
    @nums = nums
  end

  def calc_part_one
    r = 0
    @nums.each do |x|
      r += calc(x)
    end
    r
  end

  def calc_part_two
    r = 0
    @nums.each do |x|
      c = x
      loop do
        c = calc(c)
        if c <= 0
          break
        end
        r += c
      end

    end
    r
  end

  """
  mass, divide by three, round down, and subtract 2.

  For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
  For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
  For a mass of 1969, the fuel required is 654.
  For a mass of 100756, the fuel required is 33583.
  """
  def calc(mass)
    (mass / 3).floor - 2
  end
end
