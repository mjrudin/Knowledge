# -*- coding: utf-8 -*-

require 'colored'

class InvalidMoveError < RuntimeError
end

class Piece
  attr_reader :color, :board, :pos

  def initialize(color, board, pos, king = false)
    @color, @board, @pos, @king = color, board, pos, king

    board[pos] = self
  end

  def king?
    @king
  end

  def render
    char = (king?) ? "♔" : "♙"
    (color == :red) ? char.red : char.black
  end

  def perform_moves(move_positions)
    if valid_move_seq?(move_positions)
      perform_moves!(move_positions)
    else
      raise InvalidMoveError
    end
  end

  def valid_move_seq?(move_positions)
    duped_board = board.dup
    begin
      duped_board[pos].perform_moves!(move_positions)
    rescue InvalidMoveError
      false
    else
      true
    end
  end

  def dup(new_board)
    Piece.new(color, new_board, pos, king?)
  end

  protected
  attr_writer :pos

  # this one isn't reversible if it fails!
  def perform_moves!(move_positions)
    if move_positions.count == 1
      perform_single_move(move_positions.first)
    else
      move_positions.each { |move_pos| perform_jump (move_pos) }
    end

    self
  end

  def perform_single_move(move_pos)
    if slide_moves.include?(move_pos)
      perform_slide(move_pos)
    elsif jump_moves.include?(move_pos)
      perform_jump(move_pos)
    else
      raise InvalidMoveError
    end
  end

  def perform_slide(move_pos)
    if slide_moves.include?(move_pos)
      board[pos] = nil
      self.pos = move_pos
      board[move_pos] = self
    else
      raise InvalidMoveError
    end

    maybe_promote

    self
  end

  def perform_jump(jump_pos)
    if jump_moves.include?(jump_pos)
      jump_diff = [
        (jump_pos[0] - pos[0]) / 2,
        (jump_pos[1] - pos[1]) / 2
      ]
      jumped_pos = [
        pos[0] + jump_diff[0],
        pos[1] + jump_diff[1]
      ]

      board[pos] = nil
      board[jumped_pos] = nil

      self.pos = jump_pos
      board[jump_pos] = self
    else
      raise InvalidMoveError
    end

    maybe_promote

    self
  end

  def maybe_promote
    if (((color ==   :red) && (pos[0] == 7)) ||
         (color == :black) && (pos[0] == 0))
      @king = true
    end

    nil
  end

  def slide_moves
    move_dirs.map do |(dx, dy)|
      [pos[0] + dx, pos[1] + dy]
    end.select do |move_pos|
      Board.valid_pos?(move_pos) && board.empty?(move_pos)
    end
  end

  def jump_moves
    jump_positions = []
    move_dirs.each do |(dx, dy)|
      jump_pos = [pos[0] + (2 * dx), pos[1] + (2 * dy)]

      next unless Board.valid_pos?(jump_pos)
      next unless board.empty?(jump_pos)

      jumped_pos = [pos[0] + dx, pos[1] + dy]
      jumped_piece = board[jumped_pos]
      next if (jumped_piece.nil? || jumped_piece.color == color)

      jump_positions << jump_pos
    end

    jump_positions
  end

  def move_dirs
    red_moves = [
      [ 1, -1],
      [ 1,  1]
    ]

    black_moves = [
      [-1, -1],
      [-1,  1]
    ]

    if king?
      red_moves + black_moves
    else
      (color == :red) ? red_moves : black_moves
    end
  end
end
