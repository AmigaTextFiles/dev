{ ==
  == A (incomplete) set of chess sorts/operations
  ==  (a pure functional approach)
  ==}


SPEC Chess = 

  FOLD +
  LISTOPS +
  READWRITE +


SORTS

{ == a move can be up, down, left, right and combinations of those }

     move ::= up | down | left | right | combine move move.

{ == a position on the board (coordinates) }

     pos ::= p integer integer.

{ == a colour (we use empty for the colour of no_figure }

     colour ::= black | white | empty.

{ == a figure is a functional which calculates all boards the figure
     is capable to move to parametrized with the the position and the board }

     figure  ::= (pos -> board -> boards).
     figures ::= [figure].

{ == A stone is a coloured figure - to prevent a cyclic sort construction with
     stone figure and board we need the constructor }

     stone ::= stone(colour :: colour,
                     figure :: figure).

{ == a board is a functional giving the stone at a specific position }

     board  ::= (pos -> stone).
     boards ::= [board].


{ == check if a position is valid }

OPNS ok_pos :: pos -> boolean.
EQNS ok_pos (p X Y) = (1 <= X) && (X <= 8) && (1 <= Y) && (Y <= 8).



{ == opposite colour }

OPNS other_colour :: colour -> colour.
EQNS other_colour black = white.
     other_colour white = black.
     other_colour empty = empty.


{ == perform a move from a given position resulting in the new position but
     do not check if the position is valid }

OPNS pos_after_move :: pos -> move -> pos.
EQNS pos_after_move (p X Y) up   = p X (Y+1).
     pos_after_move (p X Y) down  = p X (Y-1).
     pos_after_move (p X Y) left  = p (X-1) Y.
     pos_after_move (p X Y) right = p (X+1) Y.
     pos_after_move P (combine Z1 Z2) = pos_after_move (pos_after_move P Z1) Z2.


{ == the (tricky) cover-functional which covers the former board-functional
     by 'filtering' the new situation. }

OPNS do_move :: pos -> pos -> board -> board.
EQNS do_move From To Board AskPos =
          if AskPos == From then empty
       elsif AskPos == To   then Board From
                            else Board AskPos.


{ == this is a kind of basic chess figure capable only to move one step
     in a specific direction }

OPNS one_step :: move -> figure. 
EQNS one_step Move Pos Board =
       let Colour = colour (Board Pos).
           Pos_ = pos_after_move Pos Move.
           Colour_ = colour (Board Pos_).
       in if ok_pos Pos_ &&
             ((Colour_ == empty) || (Colour_ == other_colour Colour))
          then [do_move Pos Pos_ Board]
          else [].


{ == another kind if basic chess figure capable to move as long into one
     direction as possible }

OPNS in_direction :: move -> figure.
EQNS in_direction Move Pos Board =
       let Colour = colour (Board Pos).
           Pos_ = pos_after_move Pos Move.
           Colour_ = colour (Board Pos_).
           Board_ = do_move Pos Pos_ Board.
       in if ok_pos Pos_ && (Colour_ == empty)
       then [Board_|in_direction Move Pos_ Board_]
       elsif ok_pos Pos_ && (Colour_ == other_colour Colour)
       then [Board_]  
       else [].


{ == this functions combines basic chess figures to actual figures }

OPNS combine :: figures -> figure.
EQNS combine FF Pos Board = foldr (combine_ Pos Board) [] FF.


     OPNS combine_ :: pos -> board -> figure -> boards -> boards.
     EQNS combine_ Pos Board Figure BB = Figure Pos Board ++ BB.


{ == i.e. the king is combined of eight figures ... }

OPNS king :: figure.
EQNS king = combine [one_step up,
                     one_step down,
                     one_step right,
                     one_step left,
                     one_step (combine up   right),
                     one_step (combine up   left ),
                     one_step (combine down right),
                     one_step (combine down left )].


{ == ... whereas the rock has only four components ... }

OPNS rock :: figure.    
EQNS rock = combine [in_direction up,
                     in_direction down,
                     in_direction right,
                     in_direction left].


{ == ... and the no_figure cannot move at all }

OPNS no_figure :: figure.
EQNS no_figure _ _ = [].


{ == the empty stone }

OPNS empty :: stone.
EQNS empty = stone(empty::colour,no_figure).


{ == and some initial situation for testing }

OPNS initial_board :: board.
EQNS initial_board (p 1 1) = stone(black,king).
     initial_board (p 1 2) = stone(black,rock).
     initial_board (p 8 8) = stone(white,king).
    $initial_board _       = empty.


{ == which moves are possible for a specific figure }

OPNS moves :: pos -> board -> boards.
EQNS moves Pos Board = figure(Board Pos) Pos Board.


{ == lets see what the black king is able to in the initial situation }

OPNS goal:: system -> system.
EQNS goal S = system(write(moves (p 1 1) initial_board,S)).


{ == feel free to continue this module on your own ... }

END.
