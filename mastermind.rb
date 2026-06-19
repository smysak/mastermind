# frozen_string_literal: true

require 'colorize'

# creates a code of four random numbers from 1-6
class Code
  attr_reader :first, :second, :third, :fourth

  def initialize
    @first = rand(1..6)
    @second = rand(1..6)
    @third = rand(1..6)
    @fourth = rand(1..6)
  end
end

test_code = Code.new
p [test_code.first, test_code.second, test_code.third, test_code.fourth]
