/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* REALSQRT.PL */

/*
 * Succeeds if second parameter is (approximately)
 * a real square root of the first parameter.
 *
 * Preserves nondeterminism and interchangeability
 * of unknowns -- see text.
 */

/* load math library */
:- ensure_loaded(library(math)).

close_enough(X,X) :- !.

close_enough(X,Y) :- X < Y,
                     Diff is Y-X,
                     Diff < 0.0001.

close_enough(X,Y) :- Y < X,
                     close_enough(Y,X).


real_square_root(X,nonexistent) :- X < 0.

real_square_root(X,Y) :- number(X),
                         var(Y),
                         X >= 0.0,
                         sqrt(X,R), /* sqrt(Argument,Result) */
                         close_enough(R,Y).

real_square_root(X,Y) :- number(X),
                         var(Y),
                         X >= 0.0,
                         sqrt(X,R1),
			 R is -R1, /* negative root */
                         close_enough(R,Y).

real_square_root(X,Y) :- number(Y),
                         Ysquared is Y*Y,
                         close_enough(Ysquared,X).
