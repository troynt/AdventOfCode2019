class HaltError < StandardError
end

class NoOpError < StandardError
end

class ProgramAlarm
  ERROR = 'error'
  ADD = 1
  MULTIPLY = 2
  HALT = 99

  def initialize(nums)
    @nums = nums
    @orig = nums.dup
  end

  def noun=(noun)
    @nums[1] = noun
  end

  def verb=(verb)
    @nums[2] = verb
  end

  def reset!
    @nums = @orig.dup
  end

  def calc_part_one!
    cursor = 0
    loop do
      # takes the next 4 numbers and passes them to exec using splat "*" operator
      exec!(*@nums[cursor..cursor + 3])
      cursor += 4
    end
  rescue HaltError => e
    @nums[0]
  end

  def calc_part_two!
    # ranges here are a guess.
    (0..100).each do |n|
      (0..100).each do |v|
        reset!

        self.noun = n
        self.verb = v

        solution = calc_part_one!
        if solution == 19690720
          return 100 * n + v
        end
      end
    end

  end

  def exec!(op, a, b, out)

    @nums[out] = case op
                 when ADD
                   @nums[a] + @nums[b]
                 when MULTIPLY
                   @nums[a] * @nums[b]
                 when HALT
                   raise HaltError, "got halt"
                 else
                   raise NoOpError, "missing op #{op}"
                 end
  end
end
