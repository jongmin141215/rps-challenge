require_relative 'rps'
class Game
  include DataMapper::Resource
  attr_accessor :player1, :player2

  include Rps
  property :id, Serial
  property :player1_id, Integer
  property :player2_id, Integer
  property :player1_choice, String
  property :player2_choice, String
end
