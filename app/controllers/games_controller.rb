require "open-uri"
require "json"

class GamesController < ApplicationController
  URL = "https://dictionary.lewagon.com/"
  DICTIONNARY_SERIALIZED = URI.parse(URL).read
  DICTIONNAIRE = JSON.parse(DICTIONNARY_SERIALIZED)

  def generate_grid(grid_size)
    # TODO: generate random array of letters
    grid = Array.new(0)
    grid_size.times do
      grid << ("a".."z").to_a[rand(26)]
    end
    grid
  end
  def new
    if Rails.env.test?
      @letters = %w[C A T X Y Z E R S T]
    else
      @letters = generate_grid(10)
    end
    session[:letters] = @letters
    @start_time = Time.now
    session[:start_time] = @start_time
  end

  def call_api(attempt)
      url = "https://dictionary.lewagon.com/#{attempt}"
      result_serialized = URI.parse(url).read
      JSON.parse(result_serialized)
  end

  def attempt_in_grid?(grid, attempt)
    grid = grid.map { |car| car.downcase }
    in_grid = false
    attempt.chars.each do |car|
      if grid.include?(car)
        in_grid = true
        grid.delete_at(grid.index(car))
      else
        in_grid = false
        break
      end
    end
    in_grid
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    time = end_time - start_time
    score = ((attempt.length * 100) / time).round(2)
    hash_attempt = call_api(attempt)
    if attempt_in_grid?(grid, attempt)
      if hash_attempt["found"] == true && attempt.length > 1
        score += hash_attempt["length"]
        message = "Well Done !"
      else
        score = 0
        message = "Not an english word !"
      end
    else
      score = 0
      message = "Letters are not in the grid"
    end
    { time: end_time - start_time, score: score, message: message, length: attempt.length }
  end

  def try
    @attempt = params["attempt"]
    @score = run_game(@attempt, session[:letters], Time.parse(session[:start_time]), Time.now)
    render :attempt
  end
end
