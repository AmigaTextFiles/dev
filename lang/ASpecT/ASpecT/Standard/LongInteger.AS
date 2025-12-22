{
 ==
 == Long-Integer operations
 ==  (long integers are integers 'without' maximal size
 == Version 2.0 (23.11.1992, JvH)
 ==
}

SPEC LongInteger =

  Boolean +
  Integer +
  String +
  Comparison +


  SORTS linteger.


{ == conversions from integer and string to linteger ...                   }

  OPNS long :: integer -> linteger.

  OPNS long :: string -> (boolean,linteger).


{ == and vice versa                                                        }

  OPNS string :: linteger -> string.
  
  OPNS integer :: linteger -> (boolean,integer).


{ == addition                                                              }

  OPNS linteger + linteger :: linteger.

  OPNS linteger + integer :: linteger.


{ == increment                                                             }

  OPNS (++),
       succ :: linteger -> linteger.


{ == subtraction                                                           }

  OPNS linteger - linteger :: linteger.

  OPNS linteger - integer :: linteger.


{ == decrement                                                             }

  OPNS (--),
       pred :: linteger -> linteger.


{ == another subtraction (reversed)                                        }

  OPNS subtract :: linteger -> linteger -> linteger.
  FORALL X, Y :: linteger.
  EQNS subtract X Y = Y - X.


{ == negation(s)                                                           }

  OPNS (-),
       negate :: linteger -> linteger.


{ == absolute value                                                        }

  OPNS abs :: linteger -> linteger.


{ == multiplication(s)                                                     }

  OPNS linteger * linteger :: linteger.

  OPNS linteger * integer :: linteger.


{ == division                                                              }

  OPNS linteger _div linteger,
       linteger /    linteger :: linteger.

  OPNS linteger _div integer,
       linteger /    integer :: linteger.


{ == modulo                                                                }

  OPNS linteger _mod linteger,
       linteger %    linteger :: linteger.

  OPNS linteger _mod integer,
       linteger %    integer :: integer.


{ == division and modulo in as function                                    }

  OPNS divmod :: linteger -> linteger -> (linteger,linteger).

  OPNS divmod :: linteger -> integer -> (linteger,integer).


{ == square                                                                }

  OPNS sqr :: linteger -> linteger.


{ == signum                                                                }

  OPNS sgn :: linteger -> integer.


{ == the comparisons between lintegers                                     }

  OPNS linteger <  linteger,
       linteger <= linteger,
       linteger >  linteger,
       linteger >= linteger :: boolean.
  FORALL L1, L2 :: linteger.
  EQNS (L1 <  L2) = compare L1 L2 == less.
       (L1 <= L2) = (compare L1 L2 == less) || (compare L1 L2 == eq).
       (L1 >  L2) = compare L1 L2 == greater.
       (L1 >= L2) = (compare L1 L2 == greater) || (compare L1 L2 == eq).


{ == ... the operation all these comparisons are based on                 }

  OPNS compare :: linteger -> linteger -> comparison.


{ ======================================================================== }

 LOCAL

  ListOps +
  ListFold +
  ListMap +
  ListZip +
  Char +
  String +
  Combinator +


  SORTS linteger ::= [integer].
        lintegers ::= [linteger].


  OPNS base :: integer.
  EQNS base = 32768.  { base*base+base < 2^32 }


  OPNS strep :: linteger -> linteger.
  EQNS strep L = let L = dropwhile ((==) 0) L. in
                 if L == [] then [0] else L.


  OPNS align :: linteger -> linteger -> (linteger,linteger).
  EQNS align L1 L2 = let N = length L2 - length L1. in
                     if N > 0 then (rep N 0 ++ L1,L2)
                              else (L1,rep (abs N) 0 ++ L2).


  OPNS carry :: integer -> linteger -> linteger.
  EQNS carry X (B:Y) = [(X + B) / base, (X + B) % base | Y].
      $carry _ _ = [].


  OPNS norm :: linteger -> linteger.
  EQNS norm = strep * foldr carry [0].


{ OPNS long :: integer -> linteger. }
  EQNS long I = if I < base then [I] else postfix (I % base) (long (I / base)).


{ OPNS long :: string -> linteger. }
  EQNS long (_ :: string) = (false,[]).


{ OPNS string :: linteger -> string. }
  EQNS string L = if L < [-1] then "-" ++ string1 (abs L) ""
                              else string1 L "".
               
               
  OPNS string1 :: linteger -> string -> string.
  EQNS string1 L S = let (D,R) = divmod L 10. in
                     if D == [0]
                     then integer_char (R + char_integer '0') : S
                     else string1 D (integer_char (R + char_integer '0') : S).
                


{ OPNS integer :: linteger -> (boolean,integer). }
  EQNS integer _ = (false,0).


{ OPNS linteger + linteger :: linteger. }
  EQNS X + Y = norm (uncurry (zip (+)) (align X Y)).


{ OPNS linteger + integer :: linteger. }
  EQNS X + Y = norm (uncurry (zip (+)) (align X [Y])).


{ OPNS (++) :: integer -> integer. }
  EQNS (++) = (+) [1].


{ OPNS succ :: linteger -> linteger. }
  EQNS succ = (+) [1].


{ OPNS linteger - linteger :: linteger. }
  EQNS X - Y = norm (uncurry (zip (-)) (align X Y)).


{ OPNS linteger - linteger :: linteger. }
  EQNS X - Y = norm (uncurry (zip (-)) (align X [Y])).


{ OPNS (--) :: integer -> integer. }
  EQNS (--) X = X - [1].


{ OPNS pred :: integer -> integer. }
  EQNS pred X = X - [1].


{ OPNS (-) :: linteger -> linteger. }
  EQNS (-) = norm * (map negate).


{ OPNS negate :: linteger -> linteger. }
  EQNS negate = norm * (map negate).


{ OPNS abs :: linteger -> linteger. }
  EQNS abs = norm * (map abs).


{ OPNS linteger * linteger :: linteger. }
  EQNS X * Y = foldl1 add (map ((*) X) Y :: lintegers).

  
  OPNS add :: linteger -> linteger -> linteger.
  EQNS add X Y = (X++[0]) + Y.

  
{ OPNS linteger * integer :: linteger. }
  EQNS X * Y = norm (map ((*) Y) X).


{ OPNS linteger _div linteger :: linteger. }
  FORALL X, Y :: linteger.
  EQNS X _div Y = let (R,_) = divmod X Y. in R.


{ OPNS linteger / linteger :: linteger. }
  FORALL X, Y :: linteger.
  EQNS X / Y = let (R,_) = divmod X Y. in R.


{ OPNS linteger _mod linteger :: linteger. }
  FORALL X, Y :: linteger.
  EQNS X _mod Y = let (_,R) = divmod X Y. in R.


{ OPNS linteger % linteger :: linteger. }
  FORALL X, Y :: linteger.
  EQNS X % Y = let (_,R) = divmod X Y. in R.


  SORTS qrs ::= [qr].
        qr  ::= qr  q :: integer
                    r :: linteger.


{ OPNS divmod :: linteger -> linteger -> (linteger,linteger). }
  FORALL X, Y :: linteger.
  EQNS divmod X (B:(C:Y)) =
                    let D  = base / (B + 1).
                        DS = divalg (X * D) (B:(C:Y) * D).
                        RS = r (last DS) / D.
                        QS = map q DS.
                    in (strep QS,strep RS).
       divmod X [B] = let (Q,R) = divmod X B. in (Q,[R]).
      $divmod _ _ = ([],[]).


  OPNS divalg :: linteger -> linteger -> qrs.
  EQNS divalg X Y = let M = length Y - 1.
                        (X1,X2) = split M X.
                    in scan (dstep Y) (qr 0 X1) X2.


  OPNS dstep :: linteger -> qr -> integer -> qr.
  EQNS dstep Y (qr _ R) X =
           let Ly = length Y.
               X  = R ++ [X].
               Lx = length X.
           in if Lx <  Ly then qr 0 Y
           elsif Lx == Ly then let Z = X - Y. in
                               if hd Z < 0 then qr 0 X
                                           else qr 1 Z
                          else let Q  = if hd X >= hd Y
                                        then base - 1
                                        else (hd X * base + hd (tl X)) / hd Y.
                                   Q  = Q - 2.
                                   R0 = X - (Y * Q).
                                   R1 = R0 - Y.
                                   R2 = R1 - Y.
                               in if R0 < Y then qr Q R0
                               elsif R1 < Y then qr (Q+1) R1
                                            else qr (Q+2) R2.


{ OPNS linteger _div linteger :: linteger. }
  FORALL X :: linteger. Y :: integer.
  EQNS X _div Y = let (R,_) = divmod X Y. in R.


{ OPNS linteger / linteger :: linteger. }
  FORALL X :: linteger. Y :: integer.
  EQNS X / Y = let (R,_) = divmod X Y. in R.


{ OPNS linteger _mod linteger :: linteger. }
  FORALL X :: linteger. Y :: integer.
  EQNS X _mod Y = let (_,R) = divmod X Y. in R.


{ OPNS linteger % linteger :: linteger. }
  FORALL X :: linteger. Y :: integer.
  EQNS X % Y = let (_,R) = divmod X Y. in R.


{ OPNS divmod :: linteger -> integer -> (linteger,integer). }
  FORALL X :: linteger. Y :: integer.
  EQNS divmod (A:(B:X)) Y = let RS = scan (divmod1 Y) A (B:X).
                        QS = map (c div Y) (RS::linteger).
                    in (strep QS,last RS % Y).
       divmod [A] Y = ([A / Y], A % Y).
      $divmod _ _ = ([],0).


  OPNS divmod1 :: integer -> integer -> integer -> integer.
  EQNS divmod1 D R X = base * (R % D) + X.


{ OPNS sqr :: linteger -> linteger. }
  FORALL X, Y :: linteger.
  EQNS sqr X = X * X.


{ OPNS sgn :: integer -> integer. }
  EQNS sgn []    = 0.
       sgn (A:X) = if A<0 then -1 elsif A > 0 then 1 else sgn X.


{ OPNS compare :: linteger -> linteger -> comparison. }
  EQNS compare = compare compare.

END.
