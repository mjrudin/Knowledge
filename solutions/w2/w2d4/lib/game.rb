require_relative 'board'
require_relative 'piece'

# I cheaped out on this one; it's pretty bare-bones.
class Game
  def initialize
    @board = Board.new
  end

  def print
    @board.print
  end

  def move(from_pos, to_positions)
    @board[from_pos].perform_moves(to_positions)
  end

  def play
    loop do
      print

      from_pos, *to_positions = get_move_sequence

      p from_pos
      p to_positions
      move(from_pos, to_positions)
    end
  end

  def get_move_sequence
    positions = []

    # get starting pos
    positions << get_pos

    # get next positions
    loop do
      next_pos = get_pos

      return positions if next_pos.empty?
      positions << next_pos
    end
  end

  def get_pos
    gets.chomp.split(",").map(&:to_i)
  end

  def self.test
    g = Game.new

    # Red advances
    g.print
    g.move([2, 0], [[3, 1]])
    g.print
    g.move([3, 1], [[4, 2]])
    # Black jumps
    g.print
    g.move([5, 1], [[3, 3]])

    g.print

    g
  end
end
