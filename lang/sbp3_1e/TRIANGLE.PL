/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* TRIANGLE.PL */

/*
 * Some parts of this program are repetitious because
 * table lookup is faster than computation, and CPU time
 * is at a premium. Slower but more concise routines
 * could of course be substituted.
 */

/*
 * Main routines
 */

triangle(N) :-   /* N is which peg to leave out */
     set_peg(0,N,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],FirstBoard),
     triangle_solver(14,[FirstBoard],Solution),
     nl,nl,
     fast_reverse(Solution,ReversedSolution),
     show_triangle(ReversedSolution).

triangle_solver(1,Solution,Solution).

triangle_solver(N,[OldBoard|PastBoards],Solution) :-
     write(N), put(32),
     legal_jump(OldBoard,NewBoard),
     M is N - 1,

triangle_solver(M,[NewBoard,OldBoard|PastBoards],Solution).

legal_jump(OldBoard,NewBoard) :- jump(X,Y,Z),
                                 \+ peg(Z,OldBoard),
                                 peg(X,OldBoard),
                                 peg(Y,OldBoard),
                                 set_peg(0,X,OldBoard,W1),
                                 set_peg(0,Y,W1,W2),
                                 set_peg(1,Z,W2,NewBoard).

/*
 * List reversal routine
 */

fast_reverse(X,Y) :- fast_reverse_aux(X,Y,[]).

fast_reverse_aux([],X,X).

fast_reverse_aux([H|T],Result,Temp) :-
fast_reverse_aux(T,Result,[H|Temp]).

/*
 * Legal jumps -- listed as a table for fast lookup
 */

jump(1,2,4).        jump(1,3,6).        jump(2,4,7).
jump(2,5,9).        jump(3,5,8).        jump(3,6,10).
jump(4,2,1).        jump(4,5,6).        jump(4,8,13).
jump(4,7,11).       jump(5,8,12).       jump(5,9,14).
jump(6,3,1).        jump(6,5,4).        jump(6,9,13).
jump(6,10,15).      jump(7,4,2).        jump(7,8,9).
jump(8,5,3).        jump(8,9,10).       jump(9,5,2).
jump(9,8,7).        jump(10,6,3).       jump(10,9,8).
jump(11,7,4).       jump(11,12,13).     jump(12,8,5).
jump(12,13,14).     jump(13,8,4).       jump(13,9,6).
jump(13,12,11).     jump(13,14,15).     jump(14,9,5).
jump(14,13,12).     jump(15,10,6).      jump(15,14,13).

/*
 * A separate rule for each hole to check
 * whether it has a peg in it
 */

peg(1,[1,_,_,_,_,_,_,_,_,_,_,_,_,_,_]).
peg(2,[_,1,_,_,_,_,_,_,_,_,_,_,_,_,_]).
peg(3,[_,_,1,_,_,_,_,_,_,_,_,_,_,_,_]).
peg(4,[_,_,_,1,_,_,_,_,_,_,_,_,_,_,_]).
peg(5,[_,_,_,_,1,_,_,_,_,_,_,_,_,_,_]).
peg(6,[_,_,_,_,_,1,_,_,_,_,_,_,_,_,_]).
peg(7,[_,_,_,_,_,_,1,_,_,_,_,_,_,_,_]).
peg(8,[_,_,_,_,_,_,_,1,_,_,_,_,_,_,_]).
peg(9,[_,_,_,_,_,_,_,_,1,_,_,_,_,_,_]).
peg(10,[_,_,_,_,_,_,_,_,_,1,_,_,_,_,_]).
peg(11,[_,_,_,_,_,_,_,_,_,_,1,_,_,_,_]).
peg(12,[_,_,_,_,_,_,_,_,_,_,_,1,_,_,_]).
peg(13,[_,_,_,_,_,_,_,_,_,_,_,_,1,_,_]).
peg(14,[_,_,_,_,_,_,_,_,_,_,_,_,_,1,_]).
peg(15,[_,_,_,_,_,_,_,_,_,_,_,_,_,_,1]).

/*
 * A separate rule for each hole to
 * insert or remove a peg
 */

set_peg(X,1,[_,B,C,D,E,F,G,H,I,J,K,L,M,N,O],
            [X,B,C,D,E,F,G,H,I,J,K,L,M,N,O]).
set_peg(X,2,[A,_,C,D,E,F,G,H,I,J,K,L,M,N,O],
            [A,X,C,D,E,F,G,H,I,J,K,L,M,N,O]).
set_peg(X,3,[A,B,_,D,E,F,G,H,I,J,K,L,M,N,O],
            [A,B,X,D,E,F,G,H,I,J,K,L,M,N,O]).
set_peg(X,4,[A,B,C,_,E,F,G,H,I,J,K,L,M,N,O],
            [A,B,C,X,E,F,G,H,I,J,K,L,M,N,O]).
set_peg(X,5,[A,B,C,D,_,F,G,H,I,J,K,L,M,N,O],
            [A,B,C,D,X,F,G,H,I,J,K,L,M,N,O]).
set_peg(X,6,[A,B,C,D,E,_,G,H,I,J,K,L,M,N,O],
            [A,B,C,D,E,X,G,H,I,J,K,L,M,N,O]).
set_peg(X,7,[A,B,C,D,E,F,_,H,I,J,K,L,M,N,O],
            [A,B,C,D,E,F,X,H,I,J,K,L,M,N,O]).
set_peg(X,8,[A,B,C,D,E,F,G,_,I,J,K,L,M,N,O],
            [A,B,C,D,E,F,G,X,I,J,K,L,M,N,O]).
set_peg(X,9,[A,B,C,D,E,F,G,H,_,J,K,L,M,N,O],
            [A,B,C,D,E,F,G,H,X,J,K,L,M,N,O]).
set_peg(X,10,[A,B,C,D,E,F,G,H,I,_,K,L,M,N,O],
             [A,B,C,D,E,F,G,H,I,X,K,L,M,N,O]).
set_peg(X,11,[A,B,C,D,E,F,G,H,I,J,_,L,M,N,O],
             [A,B,C,D,E,F,G,H,I,J,X,L,M,N,O]).
set_peg(X,12,[A,B,C,D,E,F,G,H,I,J,K,_,M,N,O],
             [A,B,C,D,E,F,G,H,I,J,K,X,M,N,O]).
set_peg(X,13,[A,B,C,D,E,F,G,H,I,J,K,L,_,N,O],
             [A,B,C,D,E,F,G,H,I,J,K,L,X,N,O]).
set_peg(X,14,[A,B,C,D,E,F,G,H,I,J,K,L,M,_,O],
             [A,B,C,D,E,F,G,H,I,J,K,L,M,X,O]).
set_peg(X,15,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,_],
             [A,B,C,D,E,F,G,H,I,J,K,L,M,N,X]).

/*
 * Routines to display the solution
 */

show_triangle([]).

show_triangle([X|Y]) :-
     show_board(X),
     show_triangle(Y).

show_board([P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15]):-
     write('    '), show_peg(P1), nl,
     write('   '), show_peg(P2), show_peg(P3), nl,
     write('  '), show_peg(P4), show_peg(P5),
          show_peg(P6), nl,
     write(' '), show_peg(P7), show_peg(P8),
          show_peg(P9), show_peg(P10), nl,
     show_peg(P11), show_peg(P12), show_peg(P13),
          show_peg(P14), show_peg(P15), nl,
     write('Press Return. '),
     get0(_),
     nl, nl.

show_peg(X) :- write(X), write(' ').

%% Starting query


start :-
  write('Which peg do you wish to leave out?'),nl,
  write('Type the number (1-15) followed by a period.'),nl,
  read(N),
  triangle(N).

