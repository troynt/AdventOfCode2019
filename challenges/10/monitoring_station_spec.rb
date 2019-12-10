
require_relative 'monitoring_station'

describe 'MonitoringStation', :day10 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    MonitoringStation.new(map: f.readlines)
  end

  it 'should be able to handle example data for part one' do
    ex = with_data('fixtures/example.txt')

    expect(ex.asteroids.map(&:pos)).to eq([[1, 0], [4, 0], [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [4, 3], [3, 4], [4, 4]])
    found = ex.calc_part_one

    expect(found.pos).to eq([3,4])
    expect(found.visible_to.length).to eq(8)

    expect(ex.astroid(2,2).visible_to.length).to eq(7)

  end

  it 'should be able to handle example2 data for part one' do
    ex = with_data('fixtures/example2.txt')
    found = ex.calc_part_one
    expect(found.pos).to eq([5,8])
  end

  it 'should be able to handle example3 data for part one' do
    ex = with_data('fixtures/example3.txt')
    found = ex.calc_part_one
    expect(found.pos).to eq([11,13])
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    found = ex.calc_part_one
    expect(found.visible_to.length).to eq(256)
  end

  it 'should be able to handle example3 data for part two' do
    ex = with_data('fixtures/example3.txt')
    found = ex.calc_part_one
    expect(found.pos).to eq([11,13])

    deaths = ex.calc_part_two

    expect(deaths[0].pos).to eq([11,12])
    expect(deaths[1].pos).to eq([12,1])
    expect(deaths[2].pos).to eq([12,2])
    expect(deaths[10 - 1].pos).to eq([12,8])
    expect(deaths[20 - 1].pos).to eq([16,0])
    expect(deaths[50 - 1].pos).to eq([16,9])
    expect(deaths[100 - 1].pos).to eq([ 10,16])
    expect(deaths[199 - 1].pos).to eq([9,6])
    expect(deaths[200 - 1].pos).to eq([8,2])
    expect(deaths[201 - 1].pos).to eq([10,9])
    expect(deaths[299 - 1].pos).to eq([11,1])
  end


  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    deaths = ex.calc_part_two
    found = deaths[200 - 1]
    expect(found.x * 100 + found.y).to eq(1707)
  end
end
