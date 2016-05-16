require_relative 'board.rb'

class Game
  attr_accessor :board
  attr_reader :display, :current, :player1, :player2

  def initialize(board = Board.new,player1,player2)
    @board = board
    @display = Display.new(board)
    @player1 = player1
    @player2 = player2
    @current = player1
  end

  def get_start_pos
    begin
    input_pos = display.get_input
    display.render
    while input_pos.nil?
      input_pos = display.get_input
      display.render
    end
    raise "Empty position selected." if board[*input_pos].is_a?(EmptySpace)
    raise "Wrong piece color selected." if board[*input_pos].color != current.color
    return input_pos
    rescue RuntimeError => e
      puts "#{e.message} Please select your piece."
      retry
    end
  end

  def switch_player
    current == player1 ? (@current = player2) : (@current = player1)
  end

  def move_to(start_pos)
    begin
    input_pos = display.get_input
    display.render
    while input_pos.nil?
      input_pos = display.get_input
      display.render
    end
    raise ArgumentError.new("Select new starting position.") if start_pos == input_pos
    unless board[*start_pos].possible_moves.include?(input_pos) &&
       not(input_pos.nil?) && board.valid_move?(start_pos,input_pos)
      raise "Move not possible."
    end

    if input_pos.nil?
      puts "Would you like to switch pieces? (y/n)"
      reply = gets.chomp
      raise ArgumentError.new("Select another piece.") if reply == "y"
    end

    return input_pos
    rescue RuntimeError => e
      puts "#{e.message} Please select a valid move."
      retry
    end
  end

  def play
    until board.checkmate?(current.color)
      begin
        display.render
        puts "You are in check" if board.in_check?(current.color)
        start_pos = get_start_pos
        puts "Select square to move to, or deselect current square."
        end_pos = move_to(start_pos)
      rescue ArgumentError => e
        puts "#{e.message}"
        retry
      end
      if board[*start_pos].is_a?(King)
        if (end_pos[1] - start_pos[1]).abs == 2
          board.castle(end_pos)
        end
      end
      board.move(start_pos, end_pos)
      exchange_piece(end_pos) if pawn_switch?(end_pos)
      display.render
      switch_player
    end
  end

  def pawn_switch?(pos)
    x,y = pos
    return false unless [0,7].include?(x) && board[*pos].is_a?(Pawn)
    true
  end

  def exchange_piece(end_pos)
    exchange_arr = ["queen","bishop","knight","rook"]
    begin
      puts "What piece type would you like to exchange for?"
      switch_type = gets.chomp.downcase
      case switch_type
      when "queen"
        piece_to_add = Queen.new(board,end_pos,board[*end_pos].color)
      when "bishop"
        piece_to_add = Bishop.new(board,end_pos,board[*end_pos].color)
      when "knight"
        piece_to_add = Knight.new(board,end_pos,board[*end_pos].color)
      when "rook"
        piece_to_add = Rook.new(board,end_pos,board[*end_pos].color)
      else
        raise "Choose one of the following: #{exchange_arr.join(", ")}"
      end
    rescue RuntimeError => e
      puts "Improper input. #{e.message}."
      retry
    end
    board[*end_pos] = piece_to_add
  end

  # def can_castle?(piece)
  #   not(piece.left_castle.empty?) || not(piece.right_castle.empty?)
  # end
end

class Player
  attr_reader :color

  def initialize(name = "Frédéric",color)
    @name = name
    @color = color
  end
end

new_game = Game.new(Player.new("Henrietta",:white),Player.new(:black))
new_game.play
