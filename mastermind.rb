# frozen_string_literal: true

require 'io/console'
require 'colorize'

# creates a code of four random numbers from 1-6
class Code
  attr_reader :first, :second, :third, :fourth

  def initialize
    @first = rand(1..6).to_s
    @second = rand(1..6).to_s
    @third = rand(1..6).to_s
    @fourth = rand(1..6).to_s
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
  puts "\nCode generated!\nYou have twelve chances."
  begin_guessing(code)
  puts "\n1. One-Player Game\n4. Exit"
end

def begin_guessing(code)
  puts "The code consists of four numbers, ranging from 1 to 6\nInput numbers 1-6 only."
  12.times do
    guess = collect_player_guess.chars
    return if evaluate_guess(guess, code)
  end
  puts "\nThe code was #{code.first} #{code.second} #{code.third} #{code.fourth}."
end

def collect_player_guess
  guess = String.new

  while guess.length < 4
    input = $stdin.getch
    next unless input.match?(/[1-6]/)

    print '*'
    $stdout.flush
    guess << input
  end
  puts
  guess
end

def evaluate_guess(guess, code)
  target = [code.first, code.second, code.third, code.fourth]
  display_elements = build_feedback(guess, target)
  display_elements.each { |element| print element }
  puts
  if guess == target
    (puts "\nYou are a mastermind!"
     true)
  else
    false
  end
end

def build_feedback(guess, target)
  temp_target = target.dup
  4.times { |i| temp_target[i] = nil if guess[i] == target[i] }
  4.times.map { |i| color_character(guess[i], target[i], temp_target) }
end

def color_character(char, target_char, temp_target)
  if char == target_char
    char.on_red
  elsif (match_idx = temp_target.index(char))
    temp_target[match_idx] = nil
    char.on_yellow
  else
    char
  end
end

type_ui("\nloading\n")
puts 'M'.on_red + 'esta'.on_yellow + 'r'.on_red + 'inm'.on_yellow + 'd'.on_red
pause_ui
puts 'Mastermind'.on_red
sleep 1
game_menu
