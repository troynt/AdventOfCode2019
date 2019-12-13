
require_relative 'care_package'

describe 'CarePackage', :day13 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join('').split(',').map(&:to_i)

    CarePackage.new(nums)
  end

  it 'should be able to handle example data for part one' do
    ex = CarePackage.new([])
    [1,2,3,6,5,4].each do |out|
      ex.process_output(out)

    end
    expect(ex.tile_count).to eq({3 => 1, 4 => 1})
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_one).to eq(355)
  end


  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_two).to eq(18371)
  end
end
