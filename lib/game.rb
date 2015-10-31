class Game
  attr_accessor :player1, :player2

  def initialize
    @player1, @player2 = nil, nil
  end

  def add_player(player)
    @player1 ? @player2 = player : @player1 = player unless has_two_players?
  end

  private
  
  def has_two_players?
    !!@player2
  end
end
