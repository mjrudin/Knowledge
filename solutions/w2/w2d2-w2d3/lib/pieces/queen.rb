# -*- coding: utf-8 -*-

require_relative 'piece'

class Queen < SlidingPiece
  def symbols
    { :white => '♕', :black => '♛' }
  end

  protected
  def move_dirs
    SlidingPiece::HORIZONTAL_DIRS + SlidingPiece::DIAGONAL_DIRS
  end
end
