
require_relative 'the_tyranny_of_the_rocket_equation'

describe 'TheTyrannyOfTheRocketEquation', :day1 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.map(&:to_i)

    TheTyrannyOfTheRocketEquation.new(nums)
  end

  it 'should be able to handle example data' do
    expect(with_data('fixtures/input.txt').calc_part_one).to eq(3160932)
  end

  it 'should be able to handle example data for part two' do
    expect(with_data('fixtures/input.txt').calc_part_two).to eq(4738549)
  end
end
