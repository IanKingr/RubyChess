
require_relative 'movable'

class Pieces
  attr_reader :board,:pos, :color, :moved
  include Movable

  def initialize(board, pos, color, moved = false)
    @moved = moved
    @board = board
    @pos = pos
    @color = color
  end

  def move(new_pos)
    @pos = new_pos
    @moved = true
  end

  def moves
    self.possible_moves
  end

  def inspect
    "#{self.class}"
  end
end
