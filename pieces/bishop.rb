class Bishop < Pieces

  def motions
    {diagonal: 8}
  end

  def to_s
    self.color == :white ? " ♗ " : " ♝ "
  end

end
