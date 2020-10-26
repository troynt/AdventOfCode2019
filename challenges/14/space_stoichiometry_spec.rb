
require_relative 'space_stoichiometry'

describe 'SpaceStoichiometry', :day14 do
  def with_data(file_path)
    cur_dir = File.dirname(__FILE__)
    f = File.open(File.join(cur_dir, file_path))
    reactions = f.readlines.map(&:strip).reject(&:nil?)

    SpaceStoichiometry.new(reactions)
  end

  it 'should be able to merge reactions' do
    a = SpaceStoichiometry.new([
      "1 d, 1 e => 2 a",
      "1 a, 1 b, 2 e => 1 c"
    ])

    a.merge_reactions(a.reactions.first, a.reactions.last)

    expect(a.reactions.length).to eq(1)

    expect(a.reactions.first).to eq([
      {'b' => 1, 'd' => 0.5, 'e' => 2.5},
      'c'
    ])
  end

  it 'should be able to handle example data for part one' do
    ex = with_data('fixtures/example.txt')

    expect(ex.reactions_by_input("ORE").length).to eq(5)
    expect(ex.calc_part_one).to eq(0)
  end

  skip 'should be able to handle input data for part one' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_one).to eq(0)
  end

  skip 'should be able to handle example data for part two' do
    ex = with_data('fixtures/example.txt')
    expect(ex.calc_part_one).to eq(0)
  end

  skip 'should be able to handle input data for part two' do
    ex = with_data('fixtures/input.txt')
    expect(ex.calc_part_two).to eq(0)
  end
end
