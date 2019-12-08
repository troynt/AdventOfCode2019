
require_relative 'space_image_format'

describe 'SpaceImageFormat', :day8 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join.strip.chars

    SpaceImageFormat.new(nums)
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_one).to eq(1088)
  end

  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    out = ex.calc_part_two
    expect(out).to eq("\n1     11  1   11  1 111  \n1    1  1 1   11  1 1  1 \n1    1     1 1 1111 111  \n1    1 11   1  1  1 1  1 \n1    1  1   1  1  1 1  1 \n1111  111   1  1  1 111  \n".gsub("1", "\u2588"))
  end
end
