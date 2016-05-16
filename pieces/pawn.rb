class Pawn < Pieces

  def motions
    if moved
      {forward: 1, diagonal: 1}
    else
      {forward: 2, diagonal: 1}
    end
  end


  def diagonal(pos,move_num)
    moves = super
    moves.reject! {|move| board[*move].is_a?(EmptySpace)}
    moves
  end

  def forward(pos,move_num)
    moves = super
    moves.select! {|move| board[*move].is_a?(EmptySpace)}
    moves
  end


  def possible_moves
    moves = super
    x,_ = self.pos
    moves.reject! do |m,_|
      if self.color == :black
        m < x
      else
        m > x
      end
    end
    moves
  end

  def to_s
    self.color == :white ? " ♙ " : " ♟ "
  end

end
