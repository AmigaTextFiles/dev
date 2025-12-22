/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* FAMILY.PL */
/* Part of a family tree expressed in Prolog */

/* With "father," "mother," and "parent,"
   the first argument is the parent and
   the second is the son or daughter */

father(michael,cathy).
father(charles_gordon,michael).
father(charles_gordon,julie).
father(charles,charles_gordon).
father(jim,melody).
father(jim,crystal).
father(elmo,jim).
father(greg,stephanie).

mother(melody,cathy).
mother(hazel,michael).
mother(hazel,julie).
mother(eleanor,melody).
mother(eleanor,crystal).
mother(crystal,stephanie).

male(michael).
male(charles_gordon).
male(jim).
male(elmo).
male(greg).

female(cathy).
female(julie).
female(crystal).
female(stephanie).
female(hazel).
female(eleanor).
female(melody).


parent(X,Y) :- father(X,Y).
parent(X,Y) :- mother(X,Y).
sibling(X,Y) :- mother(M,X),mother(M,Y),X\==Y.
ancestor(X,Y) :- parent(X,Z),ancestor(Z,Y).
grandfather(GF,GC)   :- father(F,GC),father(GF,F).
grandfather(GF,GC)   :- mother(F,GC),father(GF,F).
grand_parent(X,Y)    :- parent(X,C),parent(C,Y).
great_grand_parent(X,Y) :- grand_parent(X,C),parent(C,Y).
aunt(A,N)   :- sibling(A,X),parent(X,N),female(A).
uncle(U,N)  :- sibling(U,X),parent(X,N),male(U).
cousin(X,Y) :- sibling(A,B),parent(A,X),parent(B,Y).

