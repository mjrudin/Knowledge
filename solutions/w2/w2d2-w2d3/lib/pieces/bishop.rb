# -*- coding: utf-8 -*-

require_relative 'piece'

class Bishop < SlidingPiece
  def symbols
    { :white => '♗', :black => '♝' }
  end

  protected
  def move_dirs
    SlidingPiece::DIAGONAL_DIRS
  end
end
