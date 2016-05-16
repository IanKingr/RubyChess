class Knight < Pieces

  def motions
    {ell: true}
  end

  def to_s
    self.color == :white ? " ♘ " : " ♞ "
  end

end
