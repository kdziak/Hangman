# frozen_string_literal: true

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
  attr_accessor :hangman, :game_over, :guesses_left

  def initialize
    @guesses_left = 5
    @game_over = false
    @hangman = Hangman.new
    play_game
  end

  def play_game
    until @game_over
      computer_word = hangman.select_word
      create_board(computer_word)
      player_guess
      @game_over = true

    end
  end

  def create_board(computer_word)
    p "_" * computer_word.length
    p "You have #{guesses_left} guesses left"
  end

  def player_guess
    p "What is your guess?"
    player_input = gets.chomp.downcase

  end
end

Gameplay.new

# game = Gameplay.new
# p game.hangman.word_to_guess


