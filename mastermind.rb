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

puts 'M'.on_red + 'esta'.on_yellow + 'r'.on_red + 'inm'.on_yellow + 'd'.on_red
sleep 0.5
3.times do
  sleep 0.5
  print '.'
  $stdout.flush
end
puts ''
sleep 0.5
puts 'Mastermind'.on_red
