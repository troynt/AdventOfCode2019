
require_relative 'the_n_body_problem'
require 'ruby-prof'
describe 'TheN-BodyProblem', :day12 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    positions = f.readlines.reject(&:nil?)

    TheNBodyProblem.new(positions)
  end

  it 'should be able to apply gravity' do
    a = TheNBodyProblem.new(["0 0 0", "1 0 0"])
    a.calc_part_one(1)
  end

  it 'should be able to handle example data for part one' do
    ex = with_data('fixtures/example.txt')
    expect(ex.moons.length).to eq(4)
    ex.calc_part_one(10)

    expect(ex.energy).to eq(179)
  end

  it 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    expect(ex.moons.length).to eq(4)
    ex.calc_part_one(1000)

    expect(ex.energy).to eq(6678)
  end

  it 'should be able to handle example2 data for part two' do
    ex = with_data('fixtures/example2.txt')
    expect(ex.moons.length).to eq(4)

    expect(ex.calc_part_two).to eq(4686774924)
  end

  it 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_two).to eq(496734501382552)
  end
end
