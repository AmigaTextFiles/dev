/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* READINT.PL */
/* First attempt at a general-purpose numeric input routine. */

/* Requires procedure READSTRING defined in file READSTR.PL */
:- ( clause(readstring(_),_) ; consult('readstr.pl') ).

/**********************************************************************
 * readinteger(Result)                                                *
 *   Accepts a string from the user and interprets it as an integer.  *
 *   Leading, trailing, and embedded blanks are permitted.            *
 **********************************************************************/

readinteger(Result) :- readstring(S),
                       readinteger_aux(S,0,Result).

readinteger_aux([32|T],SoFar,Result) :-   /* ignore blanks */
                         !,
                         readinteger_aux(T,SoFar,Result).

readinteger_aux([H|T],SoFar,Result) :-    /* process a digit */
                         readinteger_value(H,V),
                         !,
                         NewSoFar is SoFar*10 + V,
                         readinteger_aux(T,NewSoFar,Result).

readinteger_aux([],Result,Result) :- !.   /* string empty, */
                                          /* return result */

readinteger_aux(_,_,Result) :-            /* unrecognized character */
                         write('Number expected. Try again:'),
                         readinteger(Result).

readinteger_value(48,0).    /* Table converting ASCII codes */
readinteger_value(49,1).    /* of digits to numeric values  */
readinteger_value(50,2).
readinteger_value(51,3).
readinteger_value(52,4).
readinteger_value(53,5).
readinteger_value(54,6).
readinteger_value(55,7).
readinteger_value(56,8).
readinteger_value(57,9).
