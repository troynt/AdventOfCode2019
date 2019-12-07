class HaltError < StandardError
end

class SuspendError < StandardError
end

class NoOpError < StandardError
end

class ProgramAlarm
  # OP Codes
  ADD = 1
  MULTIPLY = 2
  GET_INPUT = 3
  STORE = 4
  JTRUE =  5
  JFALSE = 6
  LT = 7
  EQ = 8
  HALT = 99

  ERROR = 'error'

  POSITION_MODE = 0
  IMMEDIATE_MODE = 1

  attr_reader(
      :outputs,
      :verbose,
      :mem,
      :ip # instruction pointer
  )

  def initialize(mem:, id: "", verbose: false)
    @orig = mem
    @verbose = verbose
    @on_input = Proc.new do
      1
    end

    @id = id
    @halted = false
    @on_output = Proc.new do |out|
      @outputs << out
    end

    reset!
  end

  def inspect
    @id
  end

  def on_input(&block)
    @on_input = block
  end

  def on_output(&block)
    @on_output = block
  end

  def noun=(noun)
    @mem[1] = noun
  end

  def verb=(verb)
    @mem[2] = verb
  end

  def reset!
    @mem = @orig.dup
    @ip = 0
    @outputs = []
    @halted = false
  end

  def read!(parameter, mode)
    loc = parameter + @ip
    puts "reading #{loc} with mode #{mode}..." if verbose

    if mode == IMMEDIATE_MODE
      ret = @mem[loc]
    else
      ret = @mem[@mem[loc]]
    end

    puts "got #{ret}" if verbose

    ret
  end

  def write(offset, value)
    location = @ip + offset
    @mem[@mem[location]] = value
  end

  def halted?
    @halted
  end

  def run!
    loop do
      # takes the next 4 numbers and passes them to exec using splat "*" operator
      exec!
    end
  rescue HaltError => e
    @mem[0]
  end

  def search_for_noun_verb(needle)
    # ranges here are a guess.
    (0..100).each do |n|
      (0..100).each do |v|
        reset!

        self.noun = n
        self.verb = v

        solution = run!
        if solution == needle
          return 100 * n + v
        end
      end
    end

  end

  def step(amount)
    @ip += amount
  end

  # returns true if output
  def exec!

    op = read!(0, 1)

    if op == nil
      return
    else
      puts "op #{op}" if verbose
    end

    mode3, mode2, mode1, *rest = op.to_s.rjust(5, "0").chars.map(&:to_i)
    op = rest.join.to_i

    case op
      when HALT
        @halted = true
        raise HaltError, "#{inspect} got halt"
      when ADD
        a = read!(1, mode1)
        b = read!(2, mode2)
        write(3, a + b)
        step(4)
      when MULTIPLY
        a = read!(1, mode1)
        b = read!(2, mode2)
        write(3, a * b)
        step(4)
      when GET_INPUT
        inp = @on_input.call
        write(1, inp)
        step(2)
      when STORE
        out = read!(1, POSITION_MODE)
        step(2)
        @on_output.call(out)
        return true
      when JTRUE
        a = read!(1, mode1)
        if a == 0
          step(3)
        else
          @ip = read!(2, mode2)
        end
      when JFALSE
        a = read!(1, mode1)
        if a == 0
          @ip = read!(2, mode2)
        else
          step(3)
        end
      when LT
        a = read!(1, mode1)
        b = read!(2, mode2)
        write(3, a < b ? 1 : 0)
        step(4)
      when EQ
        a = read!(1, mode1)
        b = read!(2, mode2)
        write(3, a == b ? 1 : 0)
        step(4)
     else
      raise "Unknown OP"
    end

    false
  end
end
