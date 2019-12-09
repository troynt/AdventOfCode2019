
require 'awesome_print'
require 'pry'
require 'active_support'

require_relative '../2/program_alarm'

# https://adventofcode.com/2019/day/7
class AmplificationCircuit

  attr_accessor(
    :verbose
  )
  def initialize(mem:, verbose: false)
    @mem = mem
    @verbose = verbose
  end

  def possible_phase_settings
    (0..4).to_a.permutation
  end

  def possible_phase_settings2
    (5..9).to_a.permutation
  end

  def run_with(phase_settings, given_amp_output = 0)
    amp_output = given_amp_output
    input_buffers = {}

    phase_settings.map do |setting|
      a = ProgramAlarm.new(mem: @mem.dup)
      input_buffers[a] = [setting, amp_output]
      a.on_input do
        input_buffers[a].shift
      end

      a.run!

      outputs = a.outputs

      amp_output = outputs.last
    end

    amp_output
  end

  def calc_part_one
    max_output = nil
    with_settings = nil
    possible_phase_settings.each do |settings|
      output = run_with(settings)
      if max_output.nil? || output > max_output
        max_output = output
        with_settings = settings
      end
    end

    {
        phase_settings: with_settings,
        max_output: max_output
    }
  end

  def run_part2_with(phase_settings)
    last_input = {}
    input_buffers = {}
    idx = 0
    amps = phase_settings.map do |setting|
      label = "#{("A".ord + idx).chr} (#{setting})"
      idx += 1
      a = ProgramAlarm.new(mem: @mem.dup, id: label)
      input_buffers[a] = [setting]

      a.on_input do
        ret = input_buffers[a].shift
        if ret.nil?
          # raise SuspendError
          return last_input[a]
        else
          last_input[a] = ret
        end

        ret
      end
      a
    end

    input_buffers[amps.first] << 0

    # ap input_buffers

    amps.each_cons(2).to_a.each do |a, b|
      a.on_output do |out|
        input_buffers[b] << out
        puts "#{a.inspect} adding #{out} to input buffer #{b.inspect}. #{input_buffers[b]}" if @verbose
        raise SuspendError
      end
    end

    final_output = nil

    first_amp = amps.first
    last_amp = amps.last

    last_amp.on_output do |out|
      input_buffers[first_amp] << out
      final_output = out

      puts "#{amps.last.inspect} adding #{out} to input buffer #{first_amp.inspect}. #{input_buffers[first_amp]}" if @verbose
      raise SuspendError
    end

    amps.cycle do |cur|
      break if last_amp.halted?

      next if cur.halted?

      puts "#{cur.inspect} halted: #{cur.halted?} input buffer: #{input_buffers[cur]}" if @verbose

      loop do
        should_break = false
        begin
          cur.exec!
        rescue SuspendError, HaltError
          should_break = true
        end
        break if should_break
      end
    end

    final_output
  end

  def calc_part_two
    max_output = nil
    with_settings = nil
    possible_phase_settings2.each do |settings|
      output = run_part2_with(settings)
      if max_output.nil? || output > max_output
        max_output = output
        with_settings = settings
      end
    end

    {
        phase_settings: with_settings,
        max_output: max_output
    }
  end
end