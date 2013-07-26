require 'rspec'
# require 'player'
load 'player.rb'

describe Player do
  subject(:player) { Player.new(100) }

  describe '::buy_in' do
    it 'should create a player' do
      Player.buy_in(100).should be_a(Player)
    end

    it 'should set the players bankroll' do
      Player.buy_in(100).bankroll.should == 100
    end
  end

  describe '#deal_in' do
    let(:hand) { double ('hand') }

    it 'should set the players hand' do
      player.deal_in(hand)
      player.hand.should == hand
    end
  end

  describe '#take_bet' do
    it 'should decrement the players bankroll by the bet amount' do
      expect do
        player.take_bet(10)
      end.to change { player.bankroll }.by(-10)
    end

    it 'should return the amount deducted' do
      player.take_bet(10).should == 10
    end

    it 'should raise an error if the bet is more than the bankroll' do
      expect do
        player.take_bet(1000)
      end.to raise_error 'not enough money'
    end
  end

  describe '#receive_winnings' do
    it 'should increment the players bankroll by the amount won' do
      expect do
        player.receive_winnings(10)
      end.to change { player.bankroll }.by(10)
    end
  end

  describe '#return_cards' do
    let(:hand) { double('hand') }
    let(:cards) { double('cards') }

    before(:each) do
      player.deal_in(hand)
      hand.stub(:cards) { cards }
    end

    it 'should return the players cards' do
      player.return_cards.should == cards
    end

    it 'should set the players hand to nil' do
      player.return_cards
      player.hand.should be_nil
    end
  end

  describe '#fold' do
    it 'should set folded? to true' do
      player.fold
      player.should be_folded
    end
  end

  describe '#fold' do
    it 'should set folded? to false' do
      player.unfold
      player.should_not be_folded
    end
  end

  describe '#folded?' do
    let(:broke_player) { Player.new(0) }
    let(:flush_player) { Player.new(1000) }

    it 'should return true if player has no money' do
      broke_player.should be_folded
    end

    it 'should return false otherwise' do
      flush_player.should_not be_folded
    end
  end
end