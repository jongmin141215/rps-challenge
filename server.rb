require 'sinatra/base'
require './data_mapper_setup'
require 'sinatra/flash'

class RPS < Sinatra::Base
  use Rack::MethodOverride
  enable :sessions
  set :session_secret, 'secret'
  register Sinatra::Flash
  helpers do
    def current_user
      @current_user = User.get(session[:user_id])
    end
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

  get '/vs_computer' do
    erb :vs_computer
  end

  post '/vs_computer' do
    player = Player.new
    session[:rps] = params[:rps].to_sym
    session[:result] = player.compare(session[:rps], player.random_rps)
    redirect to('/result')
  end

  get '/vs_friends' do
    erb :vs_friends
  end

  post '/vs_friends' do
    if session[:player1_rps].nil?
      session[:player1_rps] = params[:rps]
      redirect to('player1_result')
    else
      session[:player2_rps] = params[:rps]
      redirect to('player2_result')
    end
  end

  get '/play_again' do
    session[:player1_rps] = nil
    session[:player2_rps] = nil
    redirect to('/vs_friends')
  end

  get '/player1_result' do
    @player = Player.new
    if session[:player1_rps] && session[:player2_rps]
      @result = @player.compare(session[:player1_rps].to_sym,
        session[:player2_rps].to_sym)
    end
    erb :player1_result
  end

  get '/player2_result' do
    @player = Player.new
    if session[:player1_rps] && session[:player2_rps]
      @result = @player.compare(session[:player2_rps].to_sym,
        session[:player1_rps].to_sym)
    end
    erb :player2_result
  end

  get '/result' do
    erb :result
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
