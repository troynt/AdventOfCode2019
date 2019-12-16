
require_relative 'flawed_frequency_transmission'

describe 'FlawedFrequencyTransmission', :day16 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join.split('').map(&:to_i)

    FlawedFrequencyTransmission.new(nums)
  end

  def pattern_for_digit(place)
    ret = []
    pattern = [0, 1, 0, -1]
    pattern.each_with_index do |p|
      (place + 1).times do
        ret << p
      end
    end

    ret
  end

  it 'should be able to calc index for 1' do


    3.times do |j|
      a = pattern_for_digit(j)

      a.length.times do |i|
        # puts "testing #{j} pattern for #{i} element"
        expect(a[i]).to eq(Pattern.get(j,i))
      end
    end

  end

  it 'should be able to handle example data for part one' do
    ex = with_data('fixtures/example.txt')
    expect(ex.calc_part_one(4)).to eq([0, 1, 0, 2, 9, 4, 9, 8])
  end

  it 'should be able to handle example2 data for part one' do
    ex = with_data('fixtures/example2.txt')
    expect(ex.calc_part_one(100)).to eq([2, 4, 1, 7, 6, 1, 7, 6, 4, 8, 0, 9, 1, 9, 0, 4, 6, 1, 1, 4, 0, 3, 8, 7, 6, 3, 1, 9, 5, 5, 9, 5])
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_one(100).take(8).join("")).to eq("52611030")
  end

  it 'should be able to handle example3 data for part two' do
    ex = with_data('fixtures/example3.txt')
    expect(ex.calc_part_two).to eq("84462026")
  end

  it 'should be able to handle example4 data for part two' do
    ex = with_data('fixtures/example4.txt')
    expect(ex.calc_part_two).to eq("78725270")
  end


  it 'should be able to handle example5 data for part two' do
    ex = with_data('fixtures/example5.txt')
    expect(ex.calc_part_two).to eq("53553731")
  end


  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_two).to eq("52541026")
  end
end
