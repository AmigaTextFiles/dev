SPEC MinMax =


FORMAL


 SORTS situation.
       move.
       moves ::= [move].
 
 OPNS all_moves:: situation -> moves.
      make_move:: situation -> move -> situation.
      value:: situation -> integer.
      no_move:: move.


GLOBAL


 SORTS lookahead ::= (integer).
       
 OPNS best_move:: situation -> lookahead -> move.



LOCAL

 Integer + ListFold + ListOps +

 
 SORTS minmax ::= minim | maxim.


 OPNS not:: minmax -> minmax.
 
 EQNS not minim = maxim.
      not maxim = minim.



 EQNS best_move Situation =
        find_best_move (all_moves Situation) (make_move Situation).
 
 
 OPNS find_best_move:: moves -> (move -> situation) -> lookahead -> move.
 
 EQNS find_best_move []     _ _ = no_move.
      find_best_move [Move] _ _ = Move.
     $find_best_move [Move|Moves] DoMove LookAhead =
        let MoveValue = move_value minim (DoMove Move) LookAhead.
        in move (foldl (decide DoMove LookAhead) (Move,MoveValue) Moves).

 
 OPNS decide:: (move -> situation) -> lookahead -> 
               (move,integer) -> move -> (move,integer).
 
 EQNS decide DoMove LookAhead (CurrMove,CurrMoveValue) Move =
        let MoveValue = move_value minim (DoMove Move) LookAhead.
        in if MoveValue > CurrMoveValue
           then (    Move,    MoveValue)
           else (CurrMove,CurrMoveValue).



 OPNS move_value:: minmax -> situation -> lookahead -> integer.

 EQNS move_value MinMax Situation LookAhead = 
        let AllMoves = all_moves Situation.
        in if LookAhead <= 0
           then value Situation
           elsif AllMoves == []
           then value Situation
           else let NewValue = move_value(not MinMax)
                                         (make_move Situation (hd AllMoves))
                                         (LookAhead-1).
                in foldl (decide MinMax Situation LookAhead)
                         NewValue 
                         (tl AllMoves).


 OPNS decide:: minmax -> situation -> lookahead ->
               integer -> move -> integer.
 
 EQNS decide MinMax Situation LookAhead Value Move =
         let NewValue = move_value(not MinMax)
                                  (make_move Situation Move)
                                  (LookAhead-1).
         in if (if MinMax == minim
                then NewValue < Value
                else NewValue > Value)
            then NewValue
            else Value.
END.
