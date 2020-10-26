
require_relative 'monitoring_station'

describe 'MonitoringStation', :day10 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.map(&:to_i)

    MonitoringStation.new(nums)
  end

  skip 'should be able to handle example data for part one' do
    ex = with_data('fixtures/example.txt')
    expect(ex.calc_part_one).to eq(0)
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_one).to eq(0)
  end

  skip 'should be able to handle example data for part two' do
    ex = with_data('fixtures/example.txt')
    expect(ex.calc_part_one).to eq(0)
  end

  skip 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_two).to eq(0)
  end
end
