/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* YES.PL */

% get1(C)
%  accepts a line of input and returns only the first character.
%  A good way to obtain a 1-character response from the user
%  in a Prolog with buffered input, such as Quintus or ALS.

get1(C) :-
  get(C),
  repeat,
    get0(N),
    (N=10 ; N=13),
  !.


/*****************************************************
 * yes(Question)                                     *
 *  Displays Question, insists that the user type    *
 *  Y or N (upper or lower case), and then succeeds  *
 *  if user typed Y, or fails if user typed N.       *
 *****************************************************/

yes(Question) :-  write(Question),
                  get1(Char),
                  yes_aux(Char).

yes_aux(89)   :- !.         /* Y */

yes_aux(121)  :- !.         /* y */

yes_aux(78)   :- !,fail.    /* N */

yes_aux(110)  :- !,fail.    /* n */

yes_aux(_)    :- put(7),   /* beep */
                 write(' [Type Y or N]:'),
                 get1(Char),
                 yes_aux(Char).
