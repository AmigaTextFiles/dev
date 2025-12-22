/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* BIRDS.PL */
/* For use with DREASON.PL */

/*
 * N.B.: This file will not reconsult properly in Arity Prolog
 * and in some other Prologs because the interpreter will
 * take the two defeasible rules to be facts for the
 * predicate := instead of rules for the predicate flies.
 * Since these rules are not contiguous in the file, the
 * first rule will be retracted when the second rule is
 * added to the database.
 */

:- no_style_check(discontiguous).
:- dynamic (neg)/1, bird/1, penguin/1.
:- multifile (neg)/1.

flies(X) :=
     bird(X).

neg flies(X) :-
     penguin(X).

neg flies(X) :^
     sick(X).

flies(buzz) :=
     true.

bird(woody).

bird(X) :-
     penguin(X).

penguin(chilly).
