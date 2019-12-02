
require_relative 'program_alarm'

describe 'ProgramAlarm', :day2 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join('').split(',').map(&:to_i)

    ProgramAlarm.new(nums)
  end

  it 'should be able to handle example data' do
    expect(with_data('fixtures/example.txt').calc_part_one!).to eq(3500)
  end

  it 'should be able to handle input data' do
    program = with_data('fixtures/input.txt')
    program.noun = 12
    program.verb = 2

    expect(program.calc_part_one!).to eq(3716293)
  end

  it 'should be able to handle input data' do
    program = with_data('fixtures/input.txt')
    expect(program.calc_part_two!).to eq(6429)
  end

end
