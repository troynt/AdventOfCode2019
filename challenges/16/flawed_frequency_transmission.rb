
require 'awesome_print'
require 'pry'
require 'matrix'

class Pattern
  PATTERN = [0, 1, 0, -1].freeze

  def self.index(digit, i)
    (i / (digit + 1)) % PATTERN.length
  end

  def self.get(digit, i)
    PATTERN[index(digit, i)]
  end
end


# https://adventofcode.com/2019/day/16
class FlawedFrequencyTransmission

  def initialize(nums)
    @nums = nums
    @pattern = [0, 1, 0, -1]
    @pattern_for_digit = {}
  end

  def calc_digit(j, nums)
    sum = 0
    i = 0
    while i < nums.length
      n = nums[i]
      sum += n * Pattern.get(j, i + 1)
      i += 1
    end
    sum.abs % 10
  end

  def phase(digits)
    ret = []

    digits.length.times do |i|
      if i == 0
        bench do
          ret << calc_digit(i, digits)
        end
      else
        ret << calc_digit(i, digits)
      end
    end

    ret
  end

  def calc_part_one(rounds)
    ret = @nums
    rounds.times do
      ret = phase(ret)
    end

    ret
  end

  def phase2(nums)
    i = nums.length
    while i > 0
      nums[i - 1] = (nums[i-1] + (nums[i] || 0)) % 10
      i -= 1
    end
  end

  def calc_part_two
    ret = []
    10_000.times do
      ret.concat @nums
    end

    message_offset = ret.take(7).join("").to_i

    ret.shift(message_offset)

    100.times do |i|
      phase2(ret)
    end

    ret.take(8).join("")
  end
end
