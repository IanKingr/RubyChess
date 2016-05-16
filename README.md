# RubyChess
Classic chess game for the terminal, written in Ruby!

## Features & Implementation

![board screenshot](/docs/chess.png)

Features the following features and technical implementations

* Supports two players

* Automically checks and enforces rules for moving in and out of check

* Automatically checks and returns checkmate if conditions are met after each move

* Highlights all possible moves for selected piece

* Enforces standard movement rules including castling, knight, and pawn specific movements

* Console UI that can be controlled via directional buttons and space bar for confirming selections

### Checking Checkmate

Verifying “check” and “checkmate” conditions had a couple important steps. In order to see if a move would result in checkmate, the game (or more specifically the Board class) has to iterate over every piece to see if a counter play is possible that would remove the check condition. 

Additionally to accomplish this, we first deeply duplicates our pieces and the board into a test board, and then had every opposing piece try every possible move to see if they could remove the check condition. If so, the player is simply in check. If not, they are in checkmate and the game is over!


Deeply duplicates every piece on the board and places them on a new board for checking check conditions 
```ruby
  def dup
    duped = Board.new(false)
    rows.each_with_index do |row,i|
      row.each_with_index do |el,j|
        duped[i,j] = el.class.new(duped,el.pos,el.color,el.moved)
      end
    end
    duped
  end
```

Makes all possible moves with every piece to determine if the player is in check
```ruby
def in_check?(color)
    opp_pieces = get_pieces.select { |piece| piece.color != color}
    opp_pieces.each do |piece|
      piece.possible_moves.each do |move|
        if self[*move].is_a?(King)
          return true
        end
      end
    end
    false
  end
```

### Inheritance

Chess pieces could share a lot of the same methods, so in order to DRY up code, a parent class "Pieces" was created along with a "Movable" module.
These helped initialize each piece with a board, position, color, and moved/unmoved state. The module defined the types of moves that could be made as well as the distance of those moves such that the individual chess piece classes were relatively short and concise.

Concise Queen class which inherits from Pieces 

```ruby
class Queen < Pieces
  def motions
    {forward: 8, horizontal: 8, backward: 8, diagonal: 8}
  end

  def to_s
    self.color == :white ? " ♕ " : " ♛ "
  end
end
```

Pieces class initialization and inclusion of movable module that defines movement patterns

```ruby
class Pieces
  attr_reader :board,:pos, :color, :moved
  include Movable

  def initialize(board, pos, color, moved = false)
    @moved = moved
    @board = board
    @pos = pos
    @color = color
  end
```

Array of possible moves that are returned for each piece depending on the keys they possess for movement

```ruby
  def possible_moves
    retr = []
    retr += forward(pos,motions[:forward]) if motions[:forward]
    retr += backward(pos,motions[:backward]) if motions[:backward]
    retr += diagonal(pos, motions[:diagonal]) if motions[:diagonal]
    retr += horizontal(pos, motions[:horizontal]) if motions[:horizontal]
    retr += ell(pos) if motions[:ell]

    retr
  end
```
