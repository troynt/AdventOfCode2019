require_relative 'secure_container'
require 'ruby-prof'

describe 'SecureContainer', :day4 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join('').split('-').map(&:to_i)

    SecureContainer.new(Range.new(*nums))
  end

  it 'should be able to tell if number has repeating digits' do
    a = SecureContainer.new(100000..100001)

    expect(a.has_group_of_at_most_two_repeating_nums(1233)).to eq(true)
    expect(a.has_group_of_at_most_two_repeating_nums(1234)).to eq(false)
  end

  it 'should be able to tell if number has increasing digits' do
    a = SecureContainer.new(100000..100001)

    expect(a.has_increasing_nums(1000)).to eq(false)
    expect(a.has_increasing_nums(1222)).to eq(true)
    expect(a.has_increasing_nums(1234)).to eq(true)
  end

  it 'should be able to tell if number has repeating digits that are not part of larger group' do
    a = SecureContainer.new(100000..100001)
    expect(a.has_group_of_at_most_two_repeating_nums(112233)).to eq(true)
    expect(a.has_group_of_at_most_two_repeating_nums(123444)).to eq(false)
    expect(a.has_group_of_at_most_two_repeating_nums(111122)).to eq(true)

  end

  it 'should be able to handle example data' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_one).to eq(1873)
  end

  it 'should be able to handle example data for part two' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_two).to eq(1264)
  end
end
