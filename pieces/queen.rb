class Queen < Pieces

  def motions
    {forward: 8, horizontal: 8, backward: 8, diagonal: 8}
  end

  def to_s
    self.color == :white ? " ♕ " : " ♛ "
  end

end
