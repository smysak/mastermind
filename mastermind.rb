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
  '1' => -> { start_1p },
  '4' => lambda {
    puts "\nGoodbye."
    exit
  }
}.freeze

def type_ui(text, speed = 0.3)
  puts
  text.each_char do |char|
    print char
    $stdout.flush
    sleep speed
  end
  puts
end

def pause_ui
  sleep 1
  type_ui('...', 0.5)
  sleep 1
  $stdout.flush
  puts
end

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

def start_1p
  code = Code.new
  puts "\nGenerating code..."
  pause_ui
  puts "\nCode generated!\nYou have twelve guesses."
  guess(code)
  puts "\n1. One-Player Game\n4. Exit"
end

type_ui("\nloading\n")
puts 'M'.on_red + 'esta'.on_yellow + 'r'.on_red + 'inm'.on_yellow + 'd'.on_red
pause_ui
puts 'Mastermind'.on_red
sleep 1
game_menu
