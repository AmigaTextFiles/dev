/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* PRECEDES.PL */

/* Predicates that can be used in place of < to
   compare and sort objects other than numbers  */


/*
 * string_precedes(X,Y)
 *   True if X precedes Y in alphabetical order,
 *   where X and Y are strings (lists of ASCII codes).
 */

string_precedes([],_).

string_precedes([X|_],[Y|_]) :- X<Y.

string_precedes([X|Y],[X|Z]) :- string_precedes(Y,Z).


/*
 * atom_precedes(X,Y)
 *   Like string_precedes, but uses atoms.
 */

atom_precedes(X,Y) :- name(X,X1),
                      name(Y,Y1),
                      string_precedes(X1,Y1).

