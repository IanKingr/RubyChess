# Empty spaces on the board are filled with this object

class EmptySpace
  attr_reader :board,:pos,:moved,:color

  def initialize(board,pos = nil,color = :blank,moved = true)
    @board = board
    @pos = pos
    @moved = moved
    @color = color
  end

  def possible_moves
    []
  end

  def to_s
    "   "
  end

end
