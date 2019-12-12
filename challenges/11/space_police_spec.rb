
require_relative 'space_police'

describe 'SpacePolice', :day11 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    nums = f.readlines.join.split(',').map(&:to_i)

    SpacePolice.new(mem: nums)
  end

  skip 'should be able to handle example' do
    ex = with_data('fixtures/input.txt')
    expect(ex.on_black?).to eq(true)


    ex.process_output(1) # paint white
    ex.process_output(0) # turn left
    ex.draw

    puts "-----------"
    ex.process_output(0) # paint black
    ex.process_output(0) # turn left
    ex.draw

    puts "-----------"
    ex.process_output(1) # paint black
    ex.process_output(0) # turn left
    ex.draw

    puts "-----------"
    ex.process_output(1) # paint black
    ex.process_output(0) # turn left
    ex.draw
    puts "-----------"

    %w(0 1 1 0 1 0).map(&:to_i).each do |out|
      ex.process_output(out)

      ex.draw
      puts "-----------"
    end

    ex.draw

    ap ex.panels
    expect(ex.painted_panels_count).to eq(6)

  end


  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    expect(ex.on_black?).to eq(true)
    expect(ex.calc_part_one).to eq(2319)
    # ex.draw

  end

  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    ex.calc_part_two
    ex.draw

  end
end
