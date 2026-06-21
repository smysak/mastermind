# frozen_string_literal: true

require 'io/console'
require 'colorize'

$stdout.sync = true

# creates a code of four random numbers from 1-6
class Code
  attr_reader :first, :second, :third, :fourth

  def initialize(first, second, third, fourth)
    @first = first || rand(1..6).to_s
    @second = second || rand(1..6).to_s
    @third = third || rand(1..6).to_s
    @fourth = fourth || rand(1..6).to_s
  end
end

MENU = {
  '1' => -> { start_1p },
  '2' => -> { start_2p },
  '3' => -> { start_vs_cpu },
  '4' => lambda {
    puts "\nGoodbye."
    exit
  }
}.freeze

def hide_cursor
  print "\e[?25l"
end

def show_cursor
  print "\e[?25h"
end

def type_ui(text, speed = 0.3)
  puts
  text.each_char do |char|
    print char
    sleep speed
  end
  puts
end

def pause_ui
  sleep 1
  type_ui('...', 0.5)
  sleep 1
  puts
end

def game_menu
  sleep 1
  puts "\n1. One-Player Game\n2. Two-Player Game\n3. Game Vs CPU\n4. Exit"
  menu_loop
end

def menu_loop
  show_cursor
  loop do
    input = $stdin.getch
    next unless MENU.key?(input)

    hide_cursor
    MENU[input].call
  end
end

def start_1p
  code = Code.new(nil, nil, nil, nil)
  puts "\nGenerating code..."
  pause_ui
  puts "\nCode generated!\nYou have twelve chances."
  begin_game(code)
  game_menu
end

def input_code
  sleep 0.5
  puts "\nInput the code now:"
  Code.new(*collect_player_input.chars)
end

def start_2p
  puts "\nDecide who shall set the code.\nNo peeking!"
  begin_game(input_code)
  game_menu
end

def start_vs_cpu
  sleep 1
  puts "\nI'll show you how it's done."
  begin_cpu_game(input_code)
  puts "\nThere it is!"
  game_menu
end

CPU_THREE_GUESSES = %w[1122 3344 5566].freeze

def begin_cpu_game(code)
  hide_cursor
  pause_ui
  begin_cpu_guessing(code)
end

def begin_cpu_guessing(code)
  cracked_early = CPU_THREE_GUESSES.each do |guess|
    break true if evaluate_guess(guess.chars, code, is_cpu: true)

    sleep 0.5
  end
  return if cracked_early == true

  pause_ui
  cpu_algorithm(code)
end

def cpu_algorithm(code)
  target = [code.first, code.second, code.third, code.fourth]
  red_hits = [nil, nil, nil, nil]
  yellow_hits = [[nil, nil, nil, nil], [nil, nil, nil, nil], [nil, nil, nil, nil]]

  CPU_THREE_GUESSES.each_with_index do |guess, three_guesses|
    temp_target = target.dup
    4.times do |i|
      if guess[i] == target[i]
        red_hits[i] = guess[i]
        temp_target[i] = nil
      end
    end
    4.times do |i|
      next if guess[i] == target[i]

      match_idx = temp_target.index(guess[i])
      if match_idx
        temp_target[match_idx] = nil
        yellow_hits[three_guesses][i] = guess[i]
      end
    end
  end
  cpu_logic(red_hits, yellow_hits)
end

def cpu_logic(red_hits, yellow_hits)
  next_left_guess = cpu_logic_left(red_hits, yellow_hits)
  next_right_guess = cpu_logic_right(red_hits, yellow_hits)
  next_guess = (next_left_guess + next_right_guess).join
  p next_guess
end

def cpu_logic_left(red_hits, yellow_hits)
  left_slots = red_hits[0, 2]
  return left_slots if left_slots.compact.length == 2

  right_yellows = yellow_hits.map { |turn| turn[2..3] }.flatten.compact
  left_slots.map! do |slot|
    slot || right_yellows.shift || red_hits[2, 2].compact.first
  end
end

def cpu_logic_right(red_hits, yellow_hits)
  right_slots = red_hits[2, 2]
  return right_slots if right_slots.compact.length == 2

  left_yellows = yellow_hits.map { |turn| turn[0..1] }.flatten.compact
  right_slots.map! do |slot|
    slot || left_yellows.shift || red_hits[0, 2].compact.first
  end
end

def begin_game(code)
  puts "The code consists of four numbers, ranging from 1 to 6\nInput numbers 1-6 only."
  12.times do
    guess = collect_player_input.chars
    return if evaluate_guess(guess, code)
  end
  hide_cursor
  puts "\nThe code was #{code.first} #{code.second} #{code.third} #{code.fourth}."
end

def collect_player_input
  show_cursor
  guess = String.new

  while guess.length < 4
    input = $stdin.getch
    next unless input.match?(/[1-6]/)

    print '*'
    guess << input
  end
  puts
  guess
end

def win_message
  hide_cursor
  sleep 1
  puts "\nYou are a mastermind!"
end

def evaluate_guess(guess, code, is_cpu: false)
  target = [code.first, code.second, code.third, code.fourth]
  display_elements = build_feedback(guess, target)
  display_elements.each { |element| print element }
  puts
  if guess == target
    win_message unless is_cpu
    true
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
  return char.on_red if char == target_char

  match_idx = temp_target.index(char)
  return char unless match_idx

  temp_target[match_idx] = nil
  char.on_yellow
end

hide_cursor
type_ui("\nloading\n")
puts 'M'.on_red + 'esta'.on_yellow + 'r'.on_red + 'inm'.on_yellow + 'd'.on_red
pause_ui
puts 'Mastermind'.on_red
game_menu
