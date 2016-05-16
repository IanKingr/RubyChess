require_relative 'pieces'
require_relative 'requirements'
require_relative 'display'
require 'byebug'

class Board
  attr_reader :grid
  def initialize(setup = true)
    @grid = Array.new(8) { Array.new(8) }
    populate if setup
  end

  def get_pieces
    pieces = []
    rows.each do |row|
      row.each do |el|
        pieces << el unless el.is_a?(EmptySpace)
      end
    end
    pieces
  end

  def populate
    row_ind = 0
    2.times do
      @grid[row_ind] = special_row(row_ind)
      row_ind = 7
    end

    row_ind = 1
    2.times do
      @grid[row_ind] = pawn_row(row_ind)
      row_ind = 6
    end

    (2..5).each do |i|
      @grid[i] = Array.new(8) { EmptySpace.new(self) }
    end
  end

  def dup
    duped = Board.new(false)
    rows.each_with_index do |row,i|
      row.each_with_index do |el,j|
        duped[i,j] = el.class.new(duped,el.pos,el.color,el.moved)
      end
    end
    duped
  end

  def move(pos1,pos2)
    self[*pos1].move(pos2)
    self[*pos2] = self[*pos1]
    self[*pos1] = EmptySpace.new(self)
    self
  end

  def in_check?(color)
    opp_pieces = get_pieces.select { |piece| piece.color != color}
    opp_pieces.each do |piece|
      piece.possible_moves.each do |move|
        if self[*move].is_a?(King)
          return true
        end
      end
    end
    false
  end

  def castle(end_pos)
    x,y = end_pos
    if y == 6
      move([x,7],[x,5])
    else
      move([x,0],[x,3])
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)
    our_pieces = get_pieces.select { |piece| piece.color == color}
    our_pieces.each do |piece|
      piece.possible_moves.each do |move|
        duped = self.dup
        duped.move(piece.pos,move)
        return false unless duped.in_check?(color)
      end
    end
    color == :black ? winning_color = "White" : winning_color = "Black"
    puts "#{winning_color} won! ¡Felicidades!"
    true
  end

  def pawn_row(start_ind)
    row = []
    start_ind == 1 ? color = :black : color = :white
    (0..7).to_a.each do |y|
      row << Pawn.new(self, [start_ind, y], color)
    end

    row
  end

  def rows
    @grid
  end

  def special_row(start_row)
    start_row == 0 ? color = :black : color = :white
    ind_arr = (0..7).to_a
    [
      Rook.new(self, [start_row, ind_arr[0] ], color),
      Knight.new(self, [start_row, ind_arr[1] ],color),
      Bishop.new(self, [start_row, ind_arr[2] ], color),
      Queen.new(self, [start_row, ind_arr[3] ],color),
      King.new(self, [start_row, ind_arr[4] ],color),
      Bishop.new(self, [start_row, ind_arr[5] ], color),
      Knight.new(self, [start_row, ind_arr[6] ],color),
      Rook.new(self, [start_row, ind_arr[7] ], color)
    ]
  end

  def valid_move?(pos1,pos2)
    x,y = pos1
    duped = self.dup
    return false if duped.move(pos1,pos2).in_check?(self[*pos1].color)
    true
  end

  def [](*pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(*pos,value)
    x, y = pos
    @grid[x][y] = value
  end

  def in_bounds?(pos)
    possible_dim = (0...@grid.size).to_a
    x,y = pos
    possible_dim.include?(x) && possible_dim.include?(y)
  end

  def inspect
    "Board!"
  end
end
