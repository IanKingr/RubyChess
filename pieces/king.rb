class King < Pieces

  def motions
    {forward: 1, horizontal: 1, backward: 1, diagonal: 1}
  end

  def left_castle
    retr = []
    y_ind = 1
    x, y = self.pos
    unless moved
      can_castle = true
      until y - y_ind == 0
        can_castle = false unless board[x,y-y_ind].is_a?(EmptySpace)
        y_ind += 1
      end
      can_castle = false if board[x,0].moved

      retr << [x,y-2] if can_castle
    end
    retr
  end

  def right_castle
    retr = []
    y_ind = 1
    x, y = self.pos
    unless moved
      can_castle = true
      until y + y_ind == 7
        can_castle = false unless board[x,y + y_ind].is_a?(EmptySpace)
        y_ind += 1
      end
      can_castle = false if board[x,7].moved

      retr << [x,y+2] if can_castle
    end
    retr
  end

  def possible_moves
    moves = super
    moves += left_castle
    moves += right_castle
    moves
  end

  def to_s
    self.color == :white ? " ♔ " : " ♚ "
  end

end
