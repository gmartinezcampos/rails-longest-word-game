require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @letters = params[:letters].split(' ')
    @words = params[:word]
    @is_english_word = english_word?(@words)
    @is_match_word = match_words?(@words, @letters)
    @generate_message = message(@is_match_word, @is_english_word)
  end
  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)

    return user["found"]
  end

  def match_words?(attempt, sample_grid)
    attempt.chars.all? do |letter|
      sample_grid.count(letter.upcase) >= attempt.upcase.chars.count(letter.upcase)
    end
  end

  def message(is_in_grid, is_english_word)
    return "well done" if is_in_grid && is_english_word
    return "not an english word" if is_in_grid && !is_english_word
    return "not in the grid" unless is_in_grid
  end
end
