# frozen_string_literal: true

WORDS = []

# class for computer
class Hangman
  attr_reader :word_to_guess

  def initialize
    get_words('google-10000-english-no-swears.txt')
    @word_to_guess = WORDS.sample.chomp
  end

  def get_words(file)
    word_data = File.readlines(file)
    word_data.each do |word|
      next unless word.length > 5 && word.length < 12

      WORDS << word
    end
  end
end

# class for gameplay
class Gameplay
  attr_accessor :hangman, :game_over, :turn_number

  def initialize
    @turn_number = 0
    @game_over = false
    @hangman = Hangman.new
  end
end

game = Gameplay.new
p game.hangman.word_to_guess


