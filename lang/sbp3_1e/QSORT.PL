/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* QSORT.PL */
/* Several versions of Quicksort */

/*
 * partition(List,Pivot,Before,After)
 *   Divides List into two lists, one
 *   containing elements that should
 *   come before Pivot, the other containing
 *   elements that should come after it.
 *   Used in all versions of Quicksort.
 */

partition([X|Tail],Pivot,[X|Before],After) :-
    X =< Pivot,
    !,
    partition(Tail,Pivot,Before,After).

partition([X|Tail],Pivot,Before,[X|After]) :-
    X > Pivot,
    !,
    partition(Tail,Pivot,Before,After).

partition([],_,[],[]).


/* Original Quicksort algorithm */
/* (Sterling and Shapiro, 1986:56;
   Clocksin and Mellish 1984:157) */

quicksort([X|Tail],Result) :-
    !,
    partition(Tail,X,Before,After),
    quicksort(Before,SortedBefore),
    quicksort(After,SortedAfter),
    append(SortedBefore,[X|SortedAfter],Result).

quicksort([],[]).

append([],X,X).
append([X|Tail],Y,[X|Z]) :- append(Tail,Y,Z).


/* Quicksort with difference-lists */
/* (Sterling and Shapiro 1986:244) */

dlqsort(List,Result) :- quicksort_dl(List,Result/[]).

quicksort_dl([X|Tail],Result/ResultTail) :-
     !,
     partition(Tail,X,Before,After),
     quicksort_dl(Before,Result/[X|Z]),
     quicksort_dl(After,Z/ResultTail).

quicksort_dl([],X/X).


/* Improved Quicksort using stacks */
/* (Kluzniak and Szpakowicz 1985;
   Clocksin and Mellish 1984:157) */

iqsort(List,Result) :- iqsort_aux(List,[],Result).

iqsort_aux([X|Tail],Stack,Result) :-
     !,
     partition(Tail,X,Before,After),
     iqsort_aux(After,Stack,NewStack),
     iqsort_aux(Before,[X|NewStack],Result).

iqsort_aux([],Stack,Stack).
