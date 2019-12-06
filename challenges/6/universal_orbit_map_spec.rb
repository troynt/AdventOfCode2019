
require_relative 'universal_orbit_map'

describe 'UniversalOrbitMap', :day6 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    orbits = f.readlines.map(&:strip!).reject(&:nil?).map { |x| x.split(")").reverse }

    UniversalOrbitMap.new(orbits)
  end

  it 'should be able to handle example data for part one' do
    ex = with_data('fixtures/example.txt')
    expect(ex.count(0, "L")).to eq(7)
    expect(ex.labels.to_a.sort).to eq(%w(B C COM D E F G H I J K L))
    expect(ex.path_to_root("C")).to eq(%w(C B))
    expect(ex.shortest_path_to("C", "D")).to eq(%w())
    expect(ex.shortest_path_to("G", "K")).to eq(%W(B C D E J))
    expect(ex.calc_part_one).to eq(42)
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_one).to eq(273985)
  end

  it 'should be able to handle example data for part two' do
    ex = with_data('fixtures/example2.txt')
    expect(ex.shortest_path_to("YOU", "SAN")).to eq(%w(K J E D I))
    expect(ex.calc_part_two).to eq(4)
  end

  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_two).to eq(460)
  end
end
