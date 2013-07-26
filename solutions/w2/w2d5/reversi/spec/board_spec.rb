# -*- coding: utf-8 -*-

require 'rspec'

require 'board'
require 'position'

describe Board do
  subject(:board) { Board.new }

  it "stores and retrieves a piece" do
    piece = double("piece")
    board[pos(2, 2)] = piece

    board[pos(2, 2)].should == piece
  end

  it "sets itself up correctly initially" do
    board[pos(3, 3)].color.should == :white
    board[pos(3, 4)].color.should == :black
    board[pos(4, 3)].color.should == :black
    board[pos(4, 4)].color.should == :white

    board[pos(3, 3)].board.should == board
  end
  
  describe "#has_move?" do
    it "has initial move" do
      board.has_move?(:white).should be_true
      board.has_move?(:black).should be_true
    end
    
    it "doesn't have move at end" do
      board[pos(3, 3)].flip!
      board[pos(4, 4)].flip!
      
      board.has_move?(:white).should be_false
    end
  end
  
  describe "#result" do
    it "doesn't prematurely declare winner" do
      board.result.should be_nil
    end
    
    it "declares winner with more squares" do
      board[pos(3, 3)].flip!
      board[pos(4, 4)].flip!
      board.result.should == :black
    end
    
    it "declares a draw if no valid move" do
      Piece.stub(:valid_move?).and_return(false)
      board.result.should == :draw
    end
  end

  it "renders properly" do
    board.render.should == (<<-EOF).chomp
 01234567
0        
1        
2        
3   ◌◉   
4   ◉◌   
5        
6        
7        
EOF
  end
end
