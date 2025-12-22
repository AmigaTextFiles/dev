/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* FORALL.PL */

/*****************************************
 * for_all(GoalA,GoalB)                  *
 *  Succeeds if all instantiations that  *
 *  satisfy GoalA also satisfy GoalB.    *
 *  (There must be at least one such     *
 *  instantiation.)                      *
 *****************************************/

for_all(GoalA,GoalB) :-
     \+ (call(GoalA), \+ call(GoalB)),
     call(GoalA),
     !.


/* Test knowledge base */

dog(fido).
dog(rover).
dog(X) :- bulldog(X).

bulldog(bucephalus).

animal(X) :- dog(X).
animal(felix).
