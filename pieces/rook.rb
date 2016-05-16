require_relative '../pieces'
class Rook < Pieces
  def motions
    {forward: 8, horizontal: 8, backward: 8}
  end

  def castle
    castle_move = []
    unless self.moved
      x,y = self.pos
      poss_king = board[x,4]
      if poss_king.is_a?(King) && not(poss_king.left_castle.empty?)
        if y == 0
          castle_move << [x,3]
        elsif y == 7
          castle_move << [x,5]
        end
      end
    end
    castle_move
  end

  def possible_moves
    moves = super
    moves += castle
    moves
  end

  def to_s
    self.color == :white ? " ♖ " : " ♜ "
  end

end
