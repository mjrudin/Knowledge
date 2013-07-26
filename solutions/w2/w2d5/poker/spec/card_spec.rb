require 'rspec'
require 'card'

describe Card do
  describe '#initialize' do
    subject(:card) { Card.new(:spades, :ten) }
    its(:suit) { should == :spades }
    its(:value) { should == :ten }

    it 'raises an error with an invalid suit' do
      expect do
        Card.new(:test, :ten)
      end.to raise_error
    end

    it 'raises an error with an invalid value' do
      expect do
        Card.new(:spades, :test)
      end.to raise_error
    end
  end

  describe '#<=>' do
    it 'should return 0 when cards are the same' do
      (Card.new(:spades, :ten) <=> Card.new(:spades, :ten)).should == 0
    end

    it 'should return 1 when card has higher value' do
      (Card.new(:spades, :ace) <=> Card.new(:spades, :ten)).should == 1
    end

    it 'should return 1 when card has same value but higher suit' do
      (Card.new(:spades, :ace) <=> Card.new(:hearts, :ace)).should == 1
    end

    it 'should return -1 when card has lower value' do
      (Card.new(:spades, :ten) <=> Card.new(:spades, :ace)).should == -1
    end

    it 'should return -1 when card has same value but lower suit' do
      (Card.new(:hearts, :ace) <=> Card.new(:spades, :ace)).should == -1
    end
  end
end