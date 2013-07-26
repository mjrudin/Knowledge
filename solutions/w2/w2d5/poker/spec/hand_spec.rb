require 'rspec'
require 'hand'

describe Hand do
  let(:cards) {[
                Card.new(:spades, :ten),
                Card.new(:hearts, :five),
                Card.new(:hearts, :ace),
                Card.new(:diamonds, :two),
                Card.new(:hearts, :two)
              ]}

  subject(:hand) { Hand.new(cards) }
  its(:cards) { should =~ cards }

  describe '#initialize' do
    it 'raises an error if not five cards' do
      expect do
        Hand.new(cards[0..3])
      end.to raise_error 'must have five cards'
    end
  end

  describe '#trade_cards' do
    let!(:take_cards) { hand.cards[0..1] }
    let!(:new_cards) { [Card.new(:spades, :five), Card.new(:clubs, :three)] }

    it 'discards specified cards' do
      hand.trade_cards(take_cards, new_cards)
      hand.cards.should_not include(*take_cards)
    end

    it 'takes specified cards' do
      hand.trade_cards(take_cards, new_cards)
      hand.cards.should include(*new_cards)
    end

    it 'raises an error if trade does not result in five cards' do
      expect do
        hand.trade_cards(hand.cards[0..0], new_cards)
      end.to raise_error 'must have five cards'
    end

    it 'raises an error if trade tries to discard unowned card' do
      expect do
        hand.trade_cards([Card.new(:hearts, :ten)], new_cards[0..0])
      end.to raise_error 'cannot discard unowned card'
    end
  end

  describe 'poker hands' do
    let(:royal_flush) do
      Hand.new([
        Card.new(:spades, :ace),
        Card.new(:spades, :king),
        Card.new(:spades, :queen),
        Card.new(:spades, :jack),
        Card.new(:spades, :ten)
      ])
    end

    let(:straight_flush) do
      Hand.new([
        Card.new(:spades, :eight),
        Card.new(:spades, :seven),
        Card.new(:spades, :six),
        Card.new(:spades, :five),
        Card.new(:spades, :four)
      ])
    end

    let(:four_of_a_kind) do
      Hand.new([
        Card.new(:spades, :ace),
        Card.new(:hearts, :ace),
        Card.new(:diamonds, :ace),
        Card.new(:clubs, :ace),
        Card.new(:spades, :ten)
      ])
    end

    let(:full_house) do
      Hand.new([
        Card.new(:spades, :ace),
        Card.new(:clubs, :ace),
        Card.new(:spades, :king),
        Card.new(:hearts, :king),
        Card.new(:diamonds, :king)
      ])
    end

    let(:flush) do
      Hand.new([
        Card.new(:spades, :four),
        Card.new(:spades, :seven),
        Card.new(:spades, :ace),
        Card.new(:spades, :two),
        Card.new(:spades, :eight)
      ])
    end

    let(:straight) do
      Hand.new([
        Card.new(:hearts, :king),
        Card.new(:hearts, :queen),
        Card.new(:diamonds, :jack),
        Card.new(:clubs, :ten),
        Card.new(:spades, :nine)
      ])
    end

    let(:three_of_a_kind) do
      Hand.new([
        Card.new(:spades, :three),
        Card.new(:diamonds, :three),
        Card.new(:hearts, :three),
        Card.new(:spades, :jack),
        Card.new(:spades, :ten)
      ])
    end

    let(:two_pair) do
      Hand.new([
        Card.new(:hearts, :king),
        Card.new(:diamonds, :king),
        Card.new(:spades, :queen),
        Card.new(:clubs, :queen),
        Card.new(:spades, :ten)
      ])
    end

    let(:one_pair) do
      Hand.new([
        Card.new(:spades, :ace),
        Card.new(:spades, :ace),
        Card.new(:hearts, :queen),
        Card.new(:diamonds, :jack),
        Card.new(:hearts, :ten)
      ])
    end

    let(:high_card) do
      Hand.new([
        Card.new(:spades, :two),
        Card.new(:hearts, :four),
        Card.new(:diamonds, :six),
        Card.new(:spades, :nine),
        Card.new(:spades, :ten)
      ])
    end

    let(:hand_ranks) do
      [
        :royal_flush,
        :straight_flush,
        :four_of_a_kind,
        :full_house,
        :flush,
        :straight,
        :three_of_a_kind,
        :two_pair,
        :one_pair,
        :high_card
      ]
    end

    let!(:hands) do
      [
        royal_flush,
        straight_flush,
        four_of_a_kind,
        full_house,
        flush,
        straight,
        three_of_a_kind,
        two_pair,
        one_pair,
        high_card
      ]
    end

    describe 'rank' do
      it 'should correctly identify the hand rank' do
        hands.each_with_index do |hand, i|
          (hand.rank == hand_ranks[i]).should be_true
        end
      end

      context 'when straight' do
        let(:ace_straight) do
          Hand.new([
            Card.new(:hearts, :ace),
            Card.new(:spades, :two),
            Card.new(:hearts, :three),
            Card.new(:hearts, :four),
            Card.new(:hearts, :five)
          ])
        end

        it 'should allow ace as the low card' do
          ace_straight.rank.should == :straight
        end
      end
    end

    describe '#<=>' do
      it 'returns 1 for a hand with a higher rank' do
        (royal_flush <=> straight_flush).should == 1
      end

      it 'returns -1 for a hand with a lower rank' do
        (straight_flush <=> royal_flush).should == -1
      end

      it 'returns 0 for identical hands' do
        (straight_flush <=> straight_flush).should == 0
      end

      context 'when hands have the same rank (tie breaker)' do
        context 'when royal flush' do
          let(:hearts_royal_flush) do
            Hand.new([
              Card.new(:hearts, :ace),
              Card.new(:hearts, :king),
              Card.new(:hearts, :queen),
              Card.new(:hearts, :jack),
              Card.new(:hearts, :ten)
            ])
          end

          let(:spades_royal_flush) do
            Hand.new([
              Card.new(:spades, :ace),
              Card.new(:spades, :king),
              Card.new(:spades, :queen),
              Card.new(:spades, :jack),
              Card.new(:spades, :ten)
            ])
          end

          it 'compares based on suit' do
            (hearts_royal_flush <=> spades_royal_flush).should == -1
            (spades_royal_flush <=> hearts_royal_flush).should == 1
          end
        end

        context 'straight flush' do
          let(:straight_flush_eight) do
            Hand.new([
              Card.new(:spades, :eight),
              Card.new(:spades, :seven),
              Card.new(:spades, :six),
              Card.new(:spades, :five),
              Card.new(:spades, :four)
            ])
          end

          let(:straight_flush_nine) do
            Hand.new([
              Card.new(:spades, :nine),
              Card.new(:spades, :eight),
              Card.new(:spades, :seven),
              Card.new(:spades, :six),
              Card.new(:spades, :five)
            ])
          end

          let(:hearts_flush_nine) do
            Hand.new([
              Card.new(:hearts, :nine),
              Card.new(:hearts, :eight),
              Card.new(:hearts, :seven),
              Card.new(:hearts, :six),
              Card.new(:hearts, :five)
            ])
          end

          it 'compares based on high card' do
            (straight_flush_nine <=> straight_flush_eight).should == 1
            (straight_flush_eight <=> straight_flush_nine).should == -1
          end

          it 'compares based on suit when high card is the same' do
            (straight_flush_nine <=> hearts_flush_nine).should == 1
            (hearts_flush_nine <=> straight_flush_nine).should == -1
          end
        end

        context 'when four of a kind' do
          let(:ace_four) do
            Hand.new([
              Card.new(:spades, :ace),
              Card.new(:hearts, :ace),
              Card.new(:diamonds, :ace),
              Card.new(:clubs, :ace),
              Card.new(:spades, :ten)
            ])
          end

          let(:king_four) do
            Hand.new([
              Card.new(:spades, :king),
              Card.new(:hearts, :king),
              Card.new(:diamonds, :king),
              Card.new(:clubs, :king),
              Card.new(:spades, :ten)
            ])
          end

          it 'compares based on four of a kind value' do
            (ace_four <=> king_four).should == 1
            (king_four <=> ace_four).should == -1
          end

          let(:ace_with_two) do
            Hand.new([
              Card.new(:spades, :ace),
              Card.new(:hearts, :ace),
              Card.new(:diamonds, :ace),
              Card.new(:clubs, :ace),
              Card.new(:spades, :two)
            ])
          end

          it 'compares based on high card value if same four of a kind value' do
            (ace_four <=> ace_with_two).should == 1
            (ace_with_two <=> ace_four).should == -1
          end

          let(:ace_with_two_hearts) do
            Hand.new([
              Card.new(:spades, :ace),
              Card.new(:hearts, :ace),
              Card.new(:diamonds, :ace),
              Card.new(:clubs, :ace),
              Card.new(:hearts, :two)
            ])
          end

          it 'compares based on high card suit if same high card value' do
            (ace_with_two <=> ace_with_two_hearts).should == 1
            (ace_with_two_hearts <=> ace_with_two).should == -1
          end
        end

        context 'when one pair' do
          let(:ace_pair) do
            Hand.new([
              Card.new(:spades, :ace),
              Card.new(:spades, :ace),
              Card.new(:hearts, :queen),
              Card.new(:diamonds, :jack),
              Card.new(:hearts, :ten)
            ])
          end

          let(:king_pair) do
            Hand.new([
              Card.new(:spades, :king),
              Card.new(:spades, :king),
              Card.new(:hearts, :queen),
              Card.new(:diamonds, :jack),
              Card.new(:hearts, :ten)
            ])
          end

          it 'should compare based on pair value' do
            (ace_pair <=> king_pair).should == 1
          end

          let(:ace_pair_king_high) do
            Hand.new([
              Card.new(:spades, :ace),
              Card.new(:spades, :ace),
              Card.new(:hearts, :king),
              Card.new(:diamonds, :jack),
              Card.new(:hearts, :ten)
            ])
          end

          it 'should compare based on high card if same pair value' do
            (ace_pair_king_high <=> ace_pair).should == 1
          end
        end

        context 'when high card' do
          let(:ten_high) do
            Hand.new([
              Card.new(:spades, :two),
              Card.new(:hearts, :four),
              Card.new(:diamonds, :six),
              Card.new(:spades, :nine),
              Card.new(:spades, :ten)
            ])
          end

          let(:king_high) do
            Hand.new([
              Card.new(:spades, :two),
              Card.new(:hearts, :four),
              Card.new(:diamonds, :six),
              Card.new(:spades, :nine),
              Card.new(:spades, :king)
            ])
          end

          it 'should compare based on high card' do
            (king_high <=> ten_high).should == 1
            (ten_high <=> king_high).should == -1
          end
        end
      end
    end

    describe '::winner' do
      it 'returns the winning hand' do
        Hand.winner([flush, straight_flush, one_pair])
          .should == straight_flush
        Hand.winner([one_pair, two_pair, three_of_a_kind])
          .should == three_of_a_kind
      end
    end
  end
end