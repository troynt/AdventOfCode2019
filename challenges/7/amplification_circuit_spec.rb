
require_relative 'amplification_circuit'

describe 'AmplificationCircuit', :day7, :computer do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join.split(',').map(&:to_i)

    AmplificationCircuit.new(mem: nums)
  end

  it 'should be able to handle example data for part one' do
    ex = with_data('fixtures/example.txt')
    expect(ex.run_with([4,3,2,1,0])).to eq(43210)

    expect(ex.calc_part_one).to eq(max_output: 43210, phase_settings: [4, 3, 2, 1, 0])

    # expect(ex.calc_part_one).to eq(0)
  end

  it 'should be able to handle example2 data for part one' do
    ex = with_data('fixtures/example2.txt')
    expect(ex.calc_part_one).to eq(max_output: 54321, phase_settings: [0,1,2,3,4])

    # expect(ex.calc_part_one).to eq(0)
  end

  it 'should be able to handle example3 data for part two' do
    ex = with_data('fixtures/example3.txt')
    expect(ex.run_part2_with([9,8,7,6,5])).to eq(139629729)
    expect(ex.calc_part_two).to eq(max_output: 139629729, phase_settings: [9,8,7,6,5])
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_one).to eq(max_output: 116680, phase_settings: [3, 2, 4, 1, 0])
  end

  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_two).to eq(max_output: 89603079, phase_settings: [7, 6, 5, 8, 9])
  end
end
