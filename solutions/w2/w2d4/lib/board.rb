require_relative 'piece'

class Board
  def initialize(do_fill_grid = true)
    @grid = Array.new(8) { Array.new(8, nil) }
    
    fill_grid if do_fill_grid
  end
  
  def [](pos)
    x, y = pos
    @grid[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def empty?(pos)
    self[pos].nil?
  end
  
  def dup
    duped_board = Board.new(false)

    @grid.each do |row|
      row.each do |maybe_piece|
        next if maybe_piece.nil?
        maybe_piece.dup(duped_board)
      end
    end
    
    duped_board
  end

  def render
    @grid.map do |row|
      row.map do |maybe_piece|
        maybe_piece.nil? ? "." : maybe_piece.render
      end.join("")
    end.join("\n")
  end
  
  def print
    puts self.render
  end
  
  def self.valid_pos?(pos)
    pos.all? { |coord| (0...8).include?(coord) }
  end

  private
  def fill_grid
    (0...3).each { |row| fill_row(row, :red) }
    (5...8).each { |row| fill_row(row, :black) }
  end
  
  def fill_row(row, color)
    8.times do |col|
      Piece.new(color, self, [row, col]) if ((row % 2) == (col % 2))
    end
  end
end
