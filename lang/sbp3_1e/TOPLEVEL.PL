/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* TOPLEVEL.PL */
/* A customized user interface for Prolog */

/********************************************
 * top_level                                *
 *   Endless repeat-fail loop.              *
 *   Get a query and display its solutions. *
 ********************************************/

top_level :-   repeat,
               nl,
               write('Type a query: '),
               read(Q),
               find_solutions(Q),
               fail.

/**************************************************
 * find_solutions(Q)                              *
 *   Call Q, then display Q with instantiations,  *
 *   then ask if more solutions are wanted.       *
 *   If so, backtrack; if not, cut.               *
 *   If we run out of solutions and the cut has   *
 *   not been executed, go to the second clause,  *
 *   which displays a message.                    *
 **************************************************/

find_solutions(Q) :-  call(Q),
                      write('Solution found:    '),
                      write(Q),
                      nl,
                      write('Look for another? (Y/N):'),
                      get(Char), nl,
                      (Char = 78 ; Char = 110),   /* N or n */
                      !.

find_solutions(_) :-  write('No (more) solutions'),
                      nl.


/* Sample knowledge base */

father(michael,cathy).
mother(melody,cathy).
parent(X,Y) :- father(X,Y).
parent(X,Y) :- mother(X,Y).


/* Starting query */

start :- top_level.
:-start.
