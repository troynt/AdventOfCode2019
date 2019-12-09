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
  SET_RELATIVE_BASE = 9
  HALT = 99

  ERROR = 'error'

  POSITION_MODE = 0
  IMMEDIATE_MODE = 1
  RELATIVE_MODE = 2

  attr_accessor(
      :verbose
  )

  attr_reader(
      :outputs,
      :mem,
      :ip # instruction pointer
  )

  def initialize(mem:, id: "", verbose: false)
    @orig = mem.each_with_index.to_h { |x, i| [i, x] }.tap { |h| h.default = 0 }
    @verbose = verbose
    @on_input = Proc.new do
      1
    end

    @id = id
    @halted = false
    @on_output = Proc.new do |out|
      puts "outputting #{out}" if verbose
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
    @relative_base = 0
  end

  def index(offset, modes)
    mode = modes[offset - 1]
    mem_idx = case mode
              when IMMEDIATE_MODE
                offset + @ip
              when RELATIVE_MODE
                @relative_base + @mem[offset + @ip]
              when POSITION_MODE
                @mem[offset + @ip]
              else
                raise "Invalid mode. #{mode}"
              end

    if mem_idx < 0
      raise "Attempting to access negative memory address."
    end

    mem_idx
  end

  def read!(parameter, modes)
    mem_idx = index(parameter, modes)

    ret = @mem[mem_idx]

    puts "got #{ret}" if verbose

    if ret.nil?
      ret = 0
      puts "using 0 instead." if verbose
    end

    ret
  end

  def write(offset, value, modes)
    location = index(offset, modes)

    raise "Attempting to write to negative address." if location < 0

    @mem[location] = value
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

    opcode = mem[@ip]

    op = opcode % 100
    modes = [(opcode / 100) % 10, (opcode / 1000) % 10, (opcode / 10000) % 10]

    puts "op #{op}" if verbose

    case op
      when HALT
        @halted = true
        raise HaltError, "#{inspect} got halt"
      when ADD
        a = read!(1, modes)
        b = read!(2, modes)
        write(3, a + b, modes)
        step(4)
      when MULTIPLY
        a = read!(1, modes)
        b = read!(2, modes)
        write(3, a * b, modes)
        step(4)
      when GET_INPUT
        inp = @on_input.call
        write(1, inp, modes)
        step(2)
      when STORE
        out = read!(1, modes)
        step(2)
        @on_output.call(out)
        return true
      when JTRUE
        a = read!(1, modes)
        if a == 0
          step(3)
        else
          @ip = read!(2, modes)
        end
      when JFALSE
        a = read!(1, modes)
        if a == 0
          @ip = read!(2, modes)
        else
          step(3)
        end
      when LT
        a = read!(1, modes)
        b = read!(2, modes)
        write(3, a < b ? 1 : 0, modes)
        step(4)
      when EQ
        a = read!(1, modes)
        b = read!(2, modes)
        write(3, a == b ? 1 : 0, modes)
        step(4)
      when SET_RELATIVE_BASE
        @relative_base += read!(1, modes)
        step(2)
      else
        raise "Unknown OP #{op} for code #{opcode}"
    end

    false
  end
end
