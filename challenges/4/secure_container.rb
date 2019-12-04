# https://adventofcode.com/2019/day/4
class SecureContainer
  def initialize(range)
    @range = range
  end

  def has_increasing_nums(num)
    digits = num.digits.reverse # digits are reversed, so reverse them again for proper order.
    digits == digits.sort
  end

  # assumes digits are sorted, not bothering with reversing because it does not matter here.
  def has_group_of_at_least_two_repeating_nums(num)
    num.digits.group_by { |i| i }.any? { |c, values| values.length > 1 }
  end

  # assumes digits are sorted, not bothering with reversing because it does not matter here.
  def has_group_of_at_most_two_repeating_nums(num)
    num.digits.group_by { |i| i }.any? { |c, values| values.length == 2 }
  end

  def calc_part_one
    @range.count do |x|
      has_increasing_nums(x) && has_group_of_at_least_two_repeating_nums(x)
    end
  end

  def calc_part_two
    @range.count do |x|
      has_increasing_nums(x) && has_group_of_at_most_two_repeating_nums(x)
    end
  end
end
