require 'rspec'

require 'game'

describe Game do
  subject(:game) { Game.new(player1, player2, board) }
  let(:player1) { double("player1") }
  let(:player2) { double("player2") }
  let(:board) { double("board") }
  
  context "after initialization" do
    its(:current_color) { should == :white }
  end

  describe "#play" do
    before do
      # modify @game_result when you want game to end.
      @game_result = nil
      board.stub(:result) do
        @game_result
      end

      # don't bother printing.
      board.stub(:print)

      # don't actually try to place pieces.
      Piece.stub(:place)
    end

    context "in a single move game" do
      before do
        # play the one turn
        player1.stub(:get_move) do
          @game_result = :white
          pos(0, 0)
        end
      end

      it "asks player one for his move" do
        player1.should_receive(:get_move)
        game.play
      end

      it "plays the player's move" do
        Piece.should_receive(:place).with(board, pos(0, 0), :white)
        game.play
      end

      it "ends after one turn" do
        player2.should_not_receive(:get_move)
        game.play
      end
    end

    context "with two moves" do
      before do
        # play the one turn
        player1.stub(:get_move) do
          pos(0, 0)
        end

        player2.stub(:get_move) do
          @game_result = :black
          pos(1, 1)
        end
      end

      it "ends after two turns" do
        player1
          .should_receive(:get_move)
          .ordered
        Piece
          .should_receive(:place)
          .with(board, pos(0, 0), :white)
          .ordered
        player2.should_receive(:get_move)
          .ordered
        Piece
          .should_receive(:place)
          .with(board, pos(1, 1), :black)
          .ordered

        game.play
      end
    end
  end
end
