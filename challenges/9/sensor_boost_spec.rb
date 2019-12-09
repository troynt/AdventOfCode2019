
require_relative 'sensor_boost'
require_relative '../2/program_alarm'

describe 'SensorBoost', :day9, :computer do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join('').split(',').map(&:to_i)

    ProgramAlarm.new(mem: nums)
  end

  def with_text_data(str)
    nums = str.split(',').map(&:to_i)
    ProgramAlarm.new(mem: nums)
  end


  it 'should be able to handle example data for part one' do
    input = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
    ex = with_text_data([109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99].join(","))
    ex.run!
    expect(ex.outputs).to eq(input)
  end

  it 'should be able to handle example2 data for part one' do
    ex = with_data('fixtures/example2.txt')
    ex.run!
    expect(ex.outputs.first).to eq(1219070632396864)
  end

  it 'should be able to handle example3 data for part one' do
    ex = with_data('fixtures/example3.txt')
    ex.run!
    expect(ex.outputs.first).to eq(1125899906842624)
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    ex.on_input do
      1
    end
    ex.run!
    expect(ex.outputs).to eq([2406950601])
  end

  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    ex.on_input do
      2
    end
    ex.run!
    expect(ex.outputs).to eq([83239])
  end
end
