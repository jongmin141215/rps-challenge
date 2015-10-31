describe Game do

  subject(:game) { described_class.new }
  let(:player1) { double :player1 }
  let(:player2) { double :player2 }
  let(:player3) { double :player3 }

  it 'can add the first player' do
    game.add_player(player1)
    expect(game.player1).to eq(player1)
  end

  it 'can add the second player' do
    game.add_player(player1)
    game.add_player(player2)
    expect(game.player2).to eq(player2)
  end

end
