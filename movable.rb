# Movable module determines movement logic available for each piece depending on the hash keys
# they can pass to this module.

module Movable
  DIAGONAL = [
    [1,1],
    [1,-1],
    [-1,1],
    [-1,-1]
  ]

  ELL = [
    [1,2],
    [2,1],
    [-1,-2],
    [-2,-1],
    [-1,2],
    [1,-2],
    [-2,1],
    [2,-1]
  ]


  # Returns an array with all possible moves that a piece can make
  def possible_moves
    retr = []
    retr += forward(pos,motions[:forward]) if motions[:forward]
    retr += backward(pos,motions[:backward]) if motions[:backward]
    retr += diagonal(pos, motions[:diagonal]) if motions[:diagonal]
    retr += horizontal(pos, motions[:horizontal]) if motions[:horizontal]
    retr += ell(pos) if motions[:ell]

    retr
  end

  # Logic for if a piece can move linearly forward (e.g. Pawn)
  def forward(pos,move_num)
    frwrd_arr = []
    x,y = pos
    (1..move_num).each do |i|
      if color == :white
        delta_x = i * -1
      else
        delta_x = i
      end
      check_pos = [x + delta_x,y]
      break if !on_board?(check_pos) || board[*check_pos].color == self.color
      frwrd_arr << check_pos if on_board?(check_pos)
      break if board[*check_pos].color != :blank
    end
    frwrd_arr
  end

  # Logic for if a piece can move linearly backward (e.g. Rook)
  def backward(pos,move_num)
    bkwrd_arr = []
    x,y = pos
    (1..move_num).each do |i|
      if color == :white
        delta_x = i
      else
        delta_x = i * -1
      end
      check_pos = [x + delta_x,y]
      break if !on_board?(check_pos) || board[*check_pos].color == self.color
      bkwrd_arr << check_pos if on_board?(check_pos)
      break if board[*check_pos].color != :blank

    end
    bkwrd_arr
  end

  # Logic for if a piece can move horizontally (e.g. Rook)
  def horizontal(pos,move_num)
    hrzn_arr = []
    x,y = pos
    (1..move_num).each do |i|
      check_pos = [x,y + i]
      break if !(on_board?(check_pos)) || board[*check_pos].color == self.color
      hrzn_arr << check_pos
      break if board[*check_pos].color != :blank
    end

    (1..move_num).each do |i|
      check_pos = [x,y - i]
      break if !(on_board?(check_pos)) || board[*check_pos].color == self.color
      hrzn_arr << check_pos if on_board?(check_pos)
      break if board[*check_pos].color != :blank
    end
    hrzn_arr
  end

  # Logic for if a piece can move diagonally (e.g. Bishop)
  def diagonal(pos,move_num)
    dgnl_arr = []
    x,y = pos
    DIAGONAL.each do |dx,dy|
      (1..move_num).each do |i|
        check_pos = [x + i * dx, y + i * dy]
        break if !(on_board?(check_pos)) || board[*check_pos].color == self.color
        dgnl_arr << check_pos
        break if board[*check_pos].color != :blank
      end
    end
    dgnl_arr
  end

  # Logic for Knight piece moving in an L ("ell")
  def ell(pos)
    ell_arr = []
    x,y = pos
    ELL.each do |dx,dy|
      check_pos = [x + dx, y + dy]
      next if !(on_board?(check_pos)) || board[*check_pos].color == self.color
      ell_arr << check_pos
    end
    ell_arr
  end

  # Checks if piece is on the board
  def on_board?(pos)
    possible_dim = (0...board.grid.size).to_a
    x,y = pos
    possible_dim.include?(x) && possible_dim.include?(y)
  end

end
