
require 'awesome_print'
require 'pry'

# https://adventofcode.com/2019/day/14
class SpaceStoichiometry
  attr_reader(
    :reactions
  )

  def initialize(reactions)
    @reactions = reactions.map do |str|
      input_str, output = str.split(' => ').map(&:strip)

      inputs = input_str.split(', ')

      out_qty, out_elm = output.split(' ')
      out_qty = out_qty.to_f

      inputs_hash = {}
      inputs.each do |input|
        elm, qty = input.split(' ').reverse
        inputs_hash[elm] = qty.to_f / out_qty
      end



      [inputs_hash, out_elm]
    end

  end

  # d, e => a
  # a, b => c
  #
  # d, e, b => c

  def merge_reactions(a, b)
    ainputs, aoutputs = a
    binputs, boutputs = b

    binputs.merge!(ainputs) do |key, a, b|
      a + (b * (binputs[aoutputs] || 1) )
    end

    binputs.delete(aoutputs)

    @reactions.delete(a)
    @reactions.delete(b)
    @reactions << [binputs, boutputs]
  end

  def find_reaction_by_input(element)
    @reactions.find {|inputs, out| inputs.has_key?(element) }
  end

  def reactions_by_input(element)
    @reactions.select {|inputs, out| inputs.has_key?(element) }
  end

  def reactions_by_output(element)
    @reactions.select {|_, out| out == element }
  end

  def fuel_reaction
    reactions_by_output("FUEL").first
  end

  def calc_part_one

    while fuel_reaction[0].keys.length > 1
      fuel_reaction[0].dup.each do |elm, qty|

        first_found_reaction = find_reaction_by_input(elm)

        next if first_found_reaction.nil?
        merge_reactions(first_found_reaction, fuel_reaction)

      end

      ap @reactions
    end

  end

  def calc_part_two

  end
end
