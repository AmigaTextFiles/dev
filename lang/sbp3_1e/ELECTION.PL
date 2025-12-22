/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* ELECTION.PRO */
/* For use with DREASON.PRO */

/*
 * N.B.: this file will not reconsult properly
 * in Arity or certain other Prologs.
 */

:- no_style_check(discontiguous).
:- dynamic (neg)/1, supports/2, runs/1.
:- multifile (neg)/1.

nominate(free_traders,hunter) := true.

nominate(free_traders,farmer) :=
     neg nominate(free_traders,hunter).

nominate(free_traders,baker) :=
     neg nominate(free_traders,hunter),
     neg nominate(free_traders,farmer).

neg nominate(free_traders,hunter) :=
     neg supports(gardener,hunter).

nominate(isolationists,fox) :=
     neg runs(bull),
     neg nominate(free_traders,hunter).

nominate(isolationists,bull) :=
     runs(bull),
     supports(crow,fox).

nominate(isolationists,hart) :=
     neg nominate(isolationists,bull),
     neg nominate(isolationists,fox).

elected(Candidate1) :=
     nominate(free_traders,Candidate1),
     nominate(isolationists,Candidate2),
     supports(crow,Candidate2).

elected(bull) :=
     nominate(isolationists,bull),
     nominate(free_traders,Candidate),
     neg supports(gardener,Candidate).

supports(gardener,baker).

supports(crow,fox).

neg supports(Politician,Candidate2) :-
     supports(Politician,Candidate1),
     Candidate2 \= Candidate1.  /* \= is defined in dreason.pl */

runs(hunter).

runs(farmer).

runs(baker).

runs(fox).

runs(hart).

neg runs(bull) := true.
