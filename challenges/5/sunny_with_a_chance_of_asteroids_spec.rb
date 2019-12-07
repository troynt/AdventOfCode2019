require_relative '../../challenges/2/program_alarm'

describe 'SunnywithaChanceofAsteroid', :day5, :computer do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join('').split(',').map(&:to_i)

    ProgramAlarm.new(mem: nums)
  end

  it 'should be able to handle example data for part one' do
    ex = with_data('fixtures/example.txt')
    ex.run!
    expect(ex.mem[4]).to eq(99)
  end


  it 'should be able to handle example2 data for part one' do
    ex = with_data('fixtures/example2.txt')
    ex.run!
    expect(ex.outputs).to eq([1])
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    ex.run!
    expect(ex.outputs.last).to eq(12234644)
  end

  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    ex.on_input do
      5
    end
    ex.run!
    expect(ex.outputs.last).to eq(3508186)
  end
end
