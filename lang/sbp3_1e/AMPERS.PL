/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* AMPERS.PL */

/* Defines the ampersand (&) as a compound goal constructor,
   to avoid the ambiguity created by using commas */

:- op(950,xfy,&).                       /* syntax of & */

GoalA & GoalB  :-  call(GoalA),
                   call(GoalB).         /* semantics of & */


/* Knowledge base to demonstrate the ampersand */

parent(michael,cathy).
parent(melody,cathy).
parent(charles_gordon,michael).
parent(hazel,michael).
parent(jim,melody).
parent(eleanor,melody).

grandparent(X,Y) :- parent(Z,Y) & parent(X,Z).

only_child(X) :- parent(P,X) & \+ (parent(P,Z) & Z\==X).
