require 'sinatra/base'
require './data_mapper_setup'
require 'sinatra/flash'
require 'pusher'

require 'dotenv'
Dotenv.load

Pusher.app_id = ENV['PUSHER_ID']
Pusher.key = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']

class RPS < Sinatra::Base
  use Rack::MethodOverride
  enable :sessions
  set :session_secret, 'secret'
  register Sinatra::Flash
  helpers do
    def current_user
      @current_user = User.get(session[:user_id])
    end

    # def opponent
    #   @opponent = session[:challengee] if current_user.name == session[:challenger]
    #   @opponent = session[:challenger] if current_user.name == session[:challengee]
    # end
  end
  get '/' do
    erb :index
  end

  get '/sign_up' do
    erb :sign_up
  end

  post '/sign_up' do
    redirect to('/no_name') if params[:username] == ''
    user = User.new(name: params[:name],
                    password: params[:password],
                    password_confirmation: params[:password_confirmation])
    if user.save
      session[:user_id] = user.id
      redirect to('/welcome')
    elsif params[:password] != params[:password_confirmation]
      flash.now[:alert] = 'Password and Confirmation do not match'
      erb :sign_up
    else
      flash.now[:alert] = 'Name is already taken'
      erb :sign_up
    end
  end

  get '/welcome' do
    current_user
    erb :welcome
  end

  get '/sign_in' do
    erb :sign_in
  end

  post '/sign_in' do
    user = User.authenticate(params[:name], params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/welcome')
    else
      flash.now[:alert] = 'invalid email or password'
      erb :sign_in
    end
  end

  delete '/sign_out' do
    session[:user_id] = nil
    redirect to('/sign_in')
  end

  post '/auth' do
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => current_user.id, # => required
      :user_info => {
        :name => current_user.name
      }
    })
    content_type :json
    response.to_json
  end

  get '/vs_computer' do
    erb :vs_computer
  end

  post '/challenge' do
    session[:challengee] = params[:challengee]
    session[:challenger] = params[:challenger]
    user = User.first(name: params[:challengee])
    Pusher.trigger("#{user.name}_channel", 'challenge', {challengee: params[:challengee], challenger: params[:challenger]})
  end

  post '/accept_challenge' do
    challenger = User.first(name: params[:challenger])
    challengee = User.first(name: params[:challengee])
    game = Game.new(player1_id: challenger.id, player2_id: challengee.id)
    opponent = session[:challengee] if current_user.name == session[:challenger]
    opponent = session[:challenger] if current_user.name == session[:challengee]
    session[:opponent] = opponent
    if game.save
      session[:game_id] = game.id
      Pusher.trigger("#{challenger.name}_channel", 'start_game', {game_id: game.id})
      Pusher.trigger("#{challengee.name}_channel", 'start_game', {game_id: game.id})
    else
      redirect to('/welcome')
      console.log('not accepted?')
    end
  end

  post '/vs_computer' do

    # session[:rps] = params[:rps].to_sym
    # session[:result] = player.compare(session[:rps], player.random_rps)
    # redirect to('/result')
  end

  get "/vs_friends" do
    session[:game_id] = params[:game_id]
    erb :vs_friends
  end

  post "/vs_friends" do
    game = Game.get(session[:game_id])
    player1 = User.get(game.player1_id)
    player2 = User.get(game.player2_id)
    if current_user == player1
      game.player1_choice = player1.choose(params[:rps].to_sym)
    else
      game.player2_choice = player2.choose(params[:rps].to_sym)
    end
    game.save
    if game.player1_choice && game.player2_choice
      p game.player1_choice
      p game.player2_choice
      p game.compare(game.player1_choice.to_sym, game.player2_choice.to_sym)
      p game.compare(game.player2_choice.to_sym, game.player1_choice.to_sym)
      Pusher.trigger("#{player1.name}_result_channel", 'result', {player1_choice: game.player1_choice, player2_choice: game.player2_choice, result: game.compare(game.player1_choice.to_sym, game.player2_choice.to_sym)})
      Pusher.trigger("#{player2.name}_result_channel", 'result', {player1_choice: game.player1_choice, player2_choice: game.player2_choice, result: game.compare(game.player2_choice.to_sym, game.player1_choice.to_sym)})
    end
  end

  get '/play_again' do

  end

  get '/results' do
    game = Game.get(session[:game_id])
    if current_user.id == game.player1_id
      opponent = User.get(game.player2_id)
      session[:opponent] = opponent.name
      session[:your_choice] = params[:player1_choice]
      session[:opponent_choice] = params[:player2_choice]
    else
      opponent = User.get(game.player1_id)
      session[:opponent] = opponent.name
      session[:your_choice] = params[:player2_choice]
      session[:opponent_choice] = params[:player1_choice]
    end

    session[:result] = params[:result]
    erb :results
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
