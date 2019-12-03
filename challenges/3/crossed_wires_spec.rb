
require_relative 'crossed_wires'

describe 'CrossedWire', :day3 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    wires = f.readlines

    CrossedWire.new(wires)
  end

  it 'should be able to calculate dimensions' do
    ex = CrossedWire.new(["U2,L2,D2,R2", "R2"])
    # ex.draw
    expect(ex.xminmax).to eq([-2, 2])
    expect(ex.yminmax).to eq([-2, 0])
  end

  it 'should be able to handle small example data for part one' do
    ex = with_data('fixtures/small_example.txt')
    # ex.draw
    expect(ex.intersections).to eq([[6, -5, 30], [3, -3, 40]])
    expect(ex.calc_part_one).to eq(6)
  end

  it 'should be able to handle example data for part one' do
    ex = with_data('fixtures/example.txt')
    # ex.draw
    expect(ex.calc_part_one).to eq(159)
  end

  it 'should be able to handle example2 data for part one' do
    expect(with_data('fixtures/example2.txt').calc_part_one).to eq(135)
  end

  it 'should be able to handle input data for part one' do
    expect(with_data('fixtures/input.txt').calc_part_one).to eq(1225)
  end


  it 'should be able to handle small example data for part two' do#
    ex = with_data('fixtures/small_example.txt')
    expect(ex.calc_part_two).to eq(30)
  end


  it 'should be able to handle example data for part two' do#
    ex = with_data('fixtures/example.txt')
    expect(ex.calc_part_two).to eq(610)
  end

  it 'should be able to handle input data for part two' do
    expect(with_data('fixtures/input.txt').calc_part_two).to eq(107036)
  end
end
