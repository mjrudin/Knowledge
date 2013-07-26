require 'rspec'
require 'deck'

describe Deck do
  describe "::all_cards" do
    subject(:all_cards) { Deck.all_cards }

    its(:count) { should == 52 }

    it "returns all cards without duplicates" do
      all_cards.map { |card| [card.suit, card.value] }
        .uniq.count.should == all_cards.count
    end
  end

  let(:cards) do
    cards = [
      Card.new(:spades, :king),
      Card.new(:spades, :queen),
      Card.new(:spades, :jack)
    ]
  end

  describe "#initialize" do
    it "by default fills itself with 52 cards" do
      deck = Deck.new
      deck.count.should == 52
    end

    it "can be initialized with an array of cards" do
      deck = Deck.new(cards)
      deck.count.should == 3
    end
  end

  let(:deck) do
    Deck.new(cards.dup)
  end

  it "should not expose its cards" do
    deck.should_not respond_to(:cards)
  end

  describe "#take" do
    # **use the front of the cards array as the top**
    it "takes cards off the top of the deck" do
      deck.take(1).should == cards[0..0]
      deck.take(2).should == cards[1..2]
    end

    it "removes cards from deck on take" do
      deck.take(2)
      deck.count.should == 1
    end

    it "doesn't allow you to take more cards than are in the deck" do
      expect do
        deck.take(4)
      end.to raise_error("not enough cards")
    end
  end

  describe "#return" do
    let(:more_cards) do
      [ Card.new(:hearts, :four),
        Card.new(:hearts, :five),
        Card.new(:hearts, :six) ]
    end

    it "should return cards to the deck" do
      deck.return(more_cards)
      deck.count.should == 6
    end

    it "should not destroy the passed array" do
      more_cards_dup = more_cards.dup
      deck.return(more_cards_dup)
      more_cards_dup.should == more_cards
    end

    it "should add new cards to the bottom of the deck" do
      deck.return(more_cards)
      deck.take(3) # toss 3 cards away

      deck.take(1).should == more_cards[0..0]
      deck.take(1).should == more_cards[1..1]
      deck.take(1).should == more_cards[2..2]
    end
  end

  describe '#shuffle' do
    it 'should shuffle the cards' do
      cards = deck.take(3)
      deck.return(cards)

      (1..5).all? do
        deck.shuffle
        shuffled = deck.take(3)
        deck.return(shuffled)

        order_match = ((0..2).all? { |i| shuffled[i] == cards[i] })
      end.should_not be_true
    end
  end

  describe '#deal_hand' do
    let(:deck) { Deck.new }

    it 'should return a new hand' do
      hand = deck.deal_hand
      hand.should be_a(Hand)
      hand.cards.count.should == 5
    end

    it 'should take cards from the deck' do
      expect do
        deck.deal_hand
      end.to change{ deck.count }.by(-5)
    end
  end
end
