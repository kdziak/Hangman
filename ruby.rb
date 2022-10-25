# frozen_string_literal: true

require 'yaml'

WORDS = []

# module for saving and loading game states
module SaveLoad
  def check_for_load
    p 'press (L) to load a game'
    loading = gets.chomp
    return unless loading == 'L'

    yml = YAML.load_file('hangman.yml')
    @word = yml[:word_to_guess]
    @board = yml[:board]
    @guesses_left = yml[:guesses_left]
    p @word
    p @board
    p @guesses_left
  end

  def check_for_save
    p "Press 's' to save the game"
    saving = gets.chomp
    return unless saving == 's'

    p 'saving'
    output = File.open('hangman.yml', 'w')
    output.puts YAML.dump(@game_info)
    output.close
  end
end

# module for playing the game
module Game
  def player_guess
    p 'What is your guess?'
    gets.chomp.downcase
  end

  def noload
    @word = @game_info[:word_to_guess]
    @board = @game_info[:board]
    @guesses_left = @game_info[:guesses_left]
    p @word
    p @board
    p @guesses_left
  end

  def compare_guess_to_word
    player_input = player_guess
    p @word
    return unless @word.include? player_input

    puts 'Thats in there.'

    @word.split('').each_with_index do |letter, index|
      next unless player_input == letter

      @board.split('')
      @board[index] = letter
      p @board 
      @game_info[:board] = @board
      @game_info[:word_to_guess] = @word
      @game_info[:guesses_left] = @guesses_left
    end
  end

  def turn_countdown
    p @guesses_left += -1
    return unless @guesses_left.zero?

    @game_over = true
  end

  def play_round
    check_for_load
    noload
    until @game_over
      check_for_save
      compare_guess_to_word
      @game_info[:guesses_left] = @guesses_left
      turn_countdown
    end
  end
end

# class for computer
class Hangman
  include SaveLoad
  include Game

  attr_accessor :game_info

  def initialize
    get_words('google-10000-english-no-swears.txt')
    word_to_guess = select_word
    board = '_' * word_to_guess.length
    @game_info = {}
    guesses_left = 10
    @game_info.store(:word_to_guess, word_to_guess)
    @game_info.store(:guesses_left, guesses_left)
    @game_info.store(:board, board)
    @game_info.store(:game_over, false)
    p @game_info
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

game = Hangman.new
game.play_round
