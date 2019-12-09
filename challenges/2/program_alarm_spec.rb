
require_relative 'program_alarm'

describe 'ProgramAlarm', :day2, :computer do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join('').split(',').map(&:to_i).freeze

    ProgramAlarm.new(mem: nums)
  end

  def with_text_data(str)
    nums = str.split(',').map(&:to_i).freeze
    ProgramAlarm.new(mem: nums)
  end

  def assert_program(str, expected)
    ex = with_text_data(str)
    ex.run!
    expect(ex.mem.values.join(",")).to eq(expected)
  end

  it 'should be able to halt' do
    ex = with_data('fixtures/example.txt')
    ex.halt! rescue nil
    expect(ex.halted?).to eq(true)
  end


  it 'should be able to handle example data' do
    expect(with_data('fixtures/example.txt').run!).to eq(3500)
  end

  it 'should be able to handle input data' do
    program = with_data('fixtures/input.txt')
    program.noun = 12
    program.verb = 2

    expect(program.run!).to eq(3716293)
  end

  it 'should be able to handle sample programs' do
    assert_program("1,0,0,0,99", "2,0,0,0,99")
    assert_program("2,3,0,3,99", "2,3,0,6,99")
    assert_program("2,4,4,5,99,0", "2,4,4,5,99,9801")
    assert_program("1,1,1,4,99,5,6,0,99", "30,1,1,4,2,5,6,0,99")
  end

  it 'should be able to handle input data' do
    program = with_data('fixtures/input.txt')
    expect(program.search_for_noun_verb(19690720)).to eq(6429)
  end
end
