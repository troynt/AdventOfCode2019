class HaltError < StandardError
end

class SuspendError < StandardError
end

class ProgramAlarm
  OPS = {
    1 => { method: :add, param_count: 3 },
    2 => { method: :multiply,  param_count: 3 },
    3 => { method: :input, param_count: 1  },
    4 => { method: :output,  param_count: 1 },
    5 => { method: :jtrue, param_count: 2 },
    6 => { method: :jfalse, param_count: 2 },
    7 => { method: :less_than, param_count: 3 },
    8 => { method: :equal_to, param_count: 3 },
    9 => { method: :adjust_relative_base, param_count: 1 },
    99 => { method: :halt!, param_count: 0 }
  }.each_value(&:freeze).freeze

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
    @orig = mem.map(&:to_i).each_with_index.to_h { |x, i| [i, x] }.tap { |h| h.default = 0 }
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

  def exec!
    opcode = mem[@ip]

    op = opcode % 100
    modes = [(opcode / 100) % 10, (opcode / 1000) % 10, (opcode / 10000) % 10]

    resolved_op = OPS[op]

    if resolved_op.nil?
      raise "Unknown OP #{op} for code #{opcode}"
    end

    param_count = ((resolved_op[:param_count] || 0) + 1)
    params = []
    param_count.times do |i|
      params << index(i, modes)
    end

    params.shift # drop op

    step(param_count)

    # ap({method: resolved_op[:method], :params => params })
    self.send(resolved_op[:method], *params)
  end

  def halt!
    @halted = true
    raise HaltError, "#{inspect} got halt"
  end

  def add(a, b, out)
    puts "@mem[#{out}] = #{mem[a]} + #{mem[b]}" if verbose
    @mem[out] = mem[a] + mem[b]
  end

  def multiply(a, b, out)
    puts "@mem[#{out}] = #{mem[a]} * #{mem[b]}" if verbose
    @mem[out] = mem[a] * mem[b]
  end

  def input(out)
    @mem[out] = @on_input.call
  end

  def output(out)
    @on_output.call(mem[out])
  end

  def jtrue(a, new_ip)
    unless mem[a] == 0
      @ip = mem[new_ip]
    end
  end

  def jfalse(a, new_ip)
    if mem[a] == 0
      @ip = mem[new_ip]
    end
  end

  def less_than(a, b, out)
    @mem[out] = mem[a] < mem[b] ? 1 : 0
  end

  def equal_to(a, b, out)
    @mem[out] = mem[a] == mem[b] ? 1 : 0
  end

  def adjust_relative_base(adj)
    @relative_base += mem[adj]
  end
end
