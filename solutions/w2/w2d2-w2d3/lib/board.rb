require_relative 'pieces'

class Board
  def initialize(fill_board = true)
    @pieces = []
    make_starting_grid(fill_board)
  end

  def [](pos)
    raise "invalid pos" unless valid_pos?(pos)

    i, j = pos
    @rows[i][j]
  end

  def add_piece(piece, pos)
    raise "position not empty" unless empty?(pos)

    self[pos] = piece
    @pieces << piece
  end

  def move_piece(turn_color, from_pos, to_pos)
    if move_into_check?(turn_color, from_pos, to_pos)
      raise "can't move into check"
    else
      perform_move(turn_color, from_pos, to_pos)
    end
  end

  def valid_pos?(pos)
    pos.all? do |coord|
      (0...8).include?(coord)
    end
  end

  def empty?(pos)
    self[pos].nil?
  end

  def in_check?(color)
    king = find_king(color)

    @pieces.any? do |piece|
      piece.color != color && piece.moves.include?(king.pos)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)

    @pieces.all? do |piece|
      next true if piece.color != color

      piece.moves.all? do |move|
        move_into_check?(color, piece.pos, move)
      end
    end
  end

  def render
    @rows.map do |row|
      row.map do |piece|
        piece.nil? ? "." : piece.render
      end.join
    end.join("\n")
  end

  def dup
    new_board = Board.new(false)

    @pieces.each do |piece|
      piece.dup(new_board)
    end

    new_board
  end

  protected
  def []=(pos, piece)
    raise "invalid pos" unless valid_pos?(pos)

    i, j = pos
    @rows[i][j] = piece
  end

  def make_starting_grid(fill_board)
    @rows = Array.new(8) { Array.new(8) }

    if fill_board
      [:white, :black].each do |color|
        fill_back_row(color)
        fill_pawns_row(color)
      end
    end
  end

  def fill_back_row(color)
    back_pieces = [
      Rook,
      Knight,
      Bishop,
      Queen,
      King,
      Bishop,
      Knight,
      Rook
    ]

    i = (color == :white) ? 7 : 0
    back_pieces.each_with_index do |piece_class, j|
      piece_class.new(color, self, [i, j])
    end
  end

  def fill_pawns_row(color)
    i = (color == :white) ? 6 : 1
    8.times do |j|
      Pawn.new(color, self, [i, j])
    end
  end

  def find_king(color)
    @pieces.each do |piece|
      return piece if piece.is_a?(King) && piece.color == color
    end

    raise "king not found?"
  end

  def move_into_check?(turn_color, from_pos, to_pos)
    test_board = self.dup
    test_board.perform_move(turn_color, from_pos, to_pos)
    test_board.in_check?(turn_color)
  end

  def perform_move(turn_color, from_pos, to_pos)
    raise "from position is empty" if empty?(from_pos)

    piece = self[from_pos]

    raise "move your own piece" unless piece.color == turn_color
    raise "piece cannot move to pos" unless piece.moves.include?(to_pos)

    captured_piece = self[to_pos]
    self[to_pos] = piece
    self[from_pos] = nil

    # TODO: might be a good idea to mark a captured piece as such...
    @pieces.delete(captured_piece) unless captured_piece.nil?

    piece.pos = to_pos

    # return moved piece
    piece
  end
end
