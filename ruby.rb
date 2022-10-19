# frozen_string_literal: true
require 'yaml'


WORDS = []

# class for computer
class Hangman
  attr_reader :word_to_guess

  def initialize
    get_words('google-10000-english-no-swears.txt')
    select_word
  end

  def get_words(file)
    word_data = File.readlines(file)
    word_data.each do |word|
      next unless word.length > 5 && word.length < 12

      WORDS << word
    end
  end

  def select_word
    WORDS.sample.chomp
  end

end

# class for gameplay
class Gameplay
  attr_accessor :hangman, :game_over, :guesses_left, :computer_word, :board, :guessed

  def initialize
    @guesses_left = 5
    @guessed = []
    @game_over = false
    @hangman = Hangman.new
    @computer_word = hangman.select_word
    @board = '_' * computer_word.length
    play_game
  end

  def play_game
    until @game_over
      p computer_word
      p board
      check_for_save
      player_input = player_guess
      guessed << player_input
      p guessed
      compare_guess_to_word(player_input, computer_word)
      turn_countdown(guesses_left)
    end
  end

  def check_for_save
    p "Press 's' to save the game"
    saving = gets.chomp
    return unless saving == 's'

    output = File.new('hangman.yml', 'w')
    output.puts YAML.dump(Gameplay)
    output.close
    @game_over == true
  end

  def player_guess
    p 'What is your guess?'
    gets.chomp.downcase
  end

  def compare_guess_to_word(player_input, computer_word)
    return unless computer_word.include? player_input

    puts 'Thats in there.'

    computer_word.split('').each_with_index do |letter, index|
      next unless player_input == letter

      board.split('')
      board[index] = letter
      p board
    end
  end

  def turn_countdown(guesses_left)
    p @guesses_left += -1
    return unless guesses_left.zero?

    @game_over = true

  end
end

Gameplay.new

