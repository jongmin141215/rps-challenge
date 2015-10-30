describe Rps do
  let(:rps) { Class.new { include Rps }.new }

  describe '#compare' do

    context 'when a is rock' do
      it 'returns :win when b is :scissors' do
        expect(rps.compare(:rock, :scissors)).to eq(:win)
      end

      it 'returns :lose when b is :paper' do
        expect(rps.compare(:rock, :paper)).to eq(:lose)
      end

      it 'returns :draw when b is :rock' do
        expect(rps.compare(:rock, :rock)).to eq(:draw)
      end
    end

    context 'when a is scissors' do
      it 'returns :win when b is :paper' do
        expect(rps.compare(:scissors, :paper)).to eq(:win)
      end

      it 'returns :lose when b is :rock' do
        expect(rps.compare(:scissors, :rock)).to eq(:lose)
      end

      it 'returns :draw when b is :scissors' do
        expect(rps.compare(:scissors, :scissors)).to eq(:draw)
      end
    end

    context 'when a is paper' do
      it 'returns :win when b is :paper' do
        expect(rps.compare(:paper, :rock)).to eq(:win)
      end

      it 'returns :lose when b is :rock' do
        expect(rps.compare(:paper, :scissors)).to eq(:lose)
      end

      it 'returns :draw when b is :scissors' do
        expect(rps.compare(:paper, :paper)).to eq(:draw)
      end
    end
  end
end
