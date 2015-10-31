describe Player do
  subject(:player) { described_class.new }

  it 'can choose :rock' do
    expect(player.choose(:rock)).to eq(:rock)
  end

  it 'can choose :scissors' do
    expect(player.choose(:scissors)).to eq(:scissors)
  end

  it 'can choose :paper' do
    expect(player.choose(:paper)).to eq(:paper)
  end
end
