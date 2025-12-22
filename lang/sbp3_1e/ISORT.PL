/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* ISORT.PL */
/* Insertion sort */


/* To sort a list, sort its tail, then
   insert its head in the right position. */

isort([Head|Tail],Result) :-
    !,
    isort(Tail,SortedTail),
    insert(Head,SortedTail,Result).

isort([],[]).


/* To insert an item into the correct position
   in a sorted list: Put it at the beginning
   if it should precede the first element;
   otherwise CDR down the list until a position
   is found where this is the case. */

insert(X,[Y|Tail],[X,Y|Tail]) :-
    X =< Y,
    !.

insert(X,[Y|Tail],[Y|Z]) :-
    X > Y,
    !,
    insert(X,Tail,Z).

insert(X,[],[X]).
