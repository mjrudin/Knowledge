require 'rspec'

require 'piece'
require 'position'

require 'spec_helper'

describe Piece do
  let(:board) { board_double }

  context "with basic piece" do
    subject(:piece) { Piece.new(board, pos(3, 2), :black) }

    its(:board) { should == board }
    its(:pos) { should == pos(3, 2) }
    its(:color) { should == :black }
  end

  describe "::positions_to_flip_in_dir" do
    it "flips a single position" do
      Piece.positions_to_flip_in_dir(
        board,
        pos(3, 2),
        :black,
        pos(0, 1)
      ).should == [pos(3, 3)]
    end

    it "flips a line of pieces" do
      board[pos(2, 2)] = Piece.new(board, pos(2, 2), :black)

      Piece.positions_to_flip_in_dir(
        board,
        pos(5, 5),
        :black,
        pos(-1, -1)
      ).should =~ [pos(3, 3), pos(4, 4)]
    end

    it "will return [] if no pieces to flip" do
      Piece.positions_to_flip_in_dir(
        board,
        pos(2, 2),
        :black,
        pos(1, 1)
      ).should be_empty
    end
  end

  describe "::valid_move?" do
    it "returns false if space is occupied" do
      board[pos(2, 2)] = Piece.new(board, pos(2, 2), :black)

      Piece.valid_move?(
        board,
        pos(4, 4),
        :black
      ).should be_false
    end

    it "returns false if no piece is flipped" do
      Piece.valid_move?(
        board,
        pos(2, 2),
        :black
      ).should be_false
    end

    it "returns true for valid move" do
      Piece.valid_move?(
        board,
        pos(2, 3),
        :black
      ).should be_true
    end
  end

  describe "#flip" do
    subject(:piece) { Piece.new(board, pos(0, 0), :black) }

    it "swaps color" do
      piece.flip!
      piece.color.should == :white
    end
  end

  describe "#flip_neighbors" do
    let(:piece) do
      piece = Piece.new(board, pos(3, 2), :black)
      board[pos(3, 2)] = piece

      piece
    end

    before do
      piece.flip_neighbors!
    end

    it "flips a neighbor" do
      board[pos(3, 3)].color.should == :black
    end

    it "doesn't flip non-neighbors" do
      board[pos(4, 4)].color.should == :white
    end
  end

  describe "::place" do
    it "doesn't place in an invalid pos" do
      expect do
        Piece.place(board, pos(2, 2), :white)
      end.to raise_error(InvalidMoveError)
    end

    context "with valid pos" do
      it "places the piece in the board" do
        piece = Piece.place(board, pos(3, 2), :black)

        board[pos(3, 2)].should == piece
      end

      it "flips pieces" do
        Piece.place(board, pos(3, 2), :black)
        board[pos(3, 3)].color.should == :black
      end
    end
  end
end
