# frozen_string_literal: true

require 'io/console'
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

MENU = {
  '1' => -> { one_player_start },
  '4' => lambda {
    puts "\nGoodbye."
    exit
  }
}.freeze

def game_menu
  puts "\n1. One-Player Game\n4. Exit"
  $stdin.ioflush
  menu_loop
end

def menu_loop
  loop do
    input = $stdin.getch
    next unless MENU.key?(input)

    MENU[input].call
  end
end

puts "\n"
puts 'M'.on_red + 'esta'.on_yellow + 'r'.on_red + 'inm'.on_yellow + 'd'.on_red
sleep 1
3.times do
  sleep 0.5
  print '.'
  $stdout.flush
end
puts ''
sleep 1
puts 'Mastermind'.on_red
sleep 1
game_menu
