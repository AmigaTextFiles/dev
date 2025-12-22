/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* BICOND.PL */
/* Extension of Prolog to handle
   certain biconditionals */

/* The -:- operator joins the two
   sides of a biconditional rule. */

:- op(950,xfx,'-:-').


/* Inference engine for biconditionals */

prove(Goal)  :-  call(Goal).

prove(GoalA) :-  (GoalA -:- GoalB),
                 call(GoalB).

prove(GoalB) :-  (GoalA -:- GoalB),
                 call(GoalA).


/* Sample knowledge base */

dog(fido).
canine(rolf).
dog(X) -:- canine(X).
