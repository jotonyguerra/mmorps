require "sinatra"
require "pry"

set :bind, '0.0.0.0'  # bind to all interfaces

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

def computer_selection
  @computer_selection = ["rock", "paper", "scissors"].sample
end

def computer_win?(player_selection)
   (player_selection == "rock" && computer_selection == "paper") ||
   (player_selection == "paper" && computer_selection == "scissors") ||
   (player_selection == "scissors" && computer_selection == "rock")
end

def player_win?(player_selection)
  (player_selection == "rock" && computer_selection == "scissors") ||
  (player_selection == "scissors" && computer_selection == "paper") ||
  (player_selection == "paper" && computer_selection == "rock")
end

get "/" do
  if !session[:visit_count].nil?
    session.clear
  end

  if session[:visit_count].nil?
    session[:visit_count] = 1
    session[:player_score] = 0
    session[:computer_score] = 0
  else
    session[:visit_count] += 1
  end
  erb :index
end

post "/results" do
  if computer_win?(params[:operation])
    session[:computer_score] += 1
    @game_state = "Computer chose: #{@computer_selection}, Player Chose:#{params[:operation]}. Computer wins"
  elsif player_win?(params[:operation])
    session[:player_score] += 1
    @game_state = "Computer chose: #{@computer_selection}, Player Chose:#{params[:operation]}.Player wins"
  else
    @game_state = "Computer chose: #{@computer_selection}, Player Chose:#{params[:operation]}. Tie!"
  end
  @player_score = session[:player_score]
  @computer_score = session[:computer_score]

  if @player_score == 2
    @winner = "Player wins best 2 of 3"
  elsif @computer_score == 2
    @winner = "Computer wins best 2 of 3"
  end

  erb :index
end

get '/reset' do
  session.clear
  redirect '/'
end
