/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* READNUM.PL */
/* Input procedure for integers and floating-point numbers */

/* Requires procedure READSTRING defined in file READSTR.PL */
:- ( clause(readstring(_),_) ; consult('readstr.pl') ).

/* This is Arity and Quintus Prolog. Minor changes will probably be
 * required in other Prologs because of differences in arithmetic. */

/**********************************************************************
 * readnumber(Result)                                                 *
 *   Accepts a string from the user and interprets it as a number     *
 *   (integer or floating point). Negative numbers are accepted;      *
 *   E format is not.                                                 *
 **********************************************************************/

readnumber(Result) :- readstring(S),
                      nl,
                      readnumber_start(S,Result).

/* readnumber_start(String,Result)
 *    checks for initial blanks or minus sign, then passes
 *    control to readnumber_aux with state variables initialized.
 */

readnumber_start([32|Tail],Result) :-    /* discard leading blanks */
                    !,
                    readnumber_start(Tail,Result).

readnumber_start([45|Tail],Result) :-    /* begins with minus sign */
                    !,
                    readnumber_aux(Tail,no,-1,0,Result).

readnumber_start(String,Result) :-       /* does not begin with minus */
                    readnumber_aux(String,no,1,0,Result).

/* readnumber_aux(String,Point,Divisor,SoFar,Result)
 *    works through String one character at a time.
 *    Point is 'yes' if the point has been found, 'no' if not.
 *    Divisor is 1 until the point is encountered, after
 *    which it becomes 10, 100, etc., in succession.
 *    If number is negative, divisor is -1, -10, etc.
 *    SoFar represents the part of the number already read.
 */

readnumber_aux([Digit|Tail],no,Divisor,SoFar,Result) :-
          readnumber_value(Digit,Value),
          !,                       /* a digit to the left of the point */
          NewSoFar is SoFar*10 + Value,
          readnumber_aux(Tail,no,Divisor,NewSoFar,Result).

readnumber_aux([46|Tail],no,Divisor,SoFar,Result) :-
          !,                       /* the decimal point itself */
          readnumber_aux(Tail,yes,Divisor,SoFar,Result).

readnumber_aux([Digit|Tail],yes,Divisor,SoFar,Result) :-
          readnumber_value(Digit,Value),
          !,                       /* a digit to the right of the point */
          NewSoFar is SoFar*10 + Value,
          NewDivisor is Divisor*10,
          readnumber_aux(Tail,yes,NewDivisor,NewSoFar,Result).

readnumber_aux([],_,1,Result,Result) :- !. /* all done, positive integer */

readnumber_aux([],_,-1,SoFar,Result) :- !, /* all done, negative integer */
                                        Result is -(SoFar).

readnumber_aux([],yes,Divisor,SoFar,Result) :-
          !,                            /* all done, it's floating point */
          Result is SoFar/Divisor.

readnumber_aux(_,_,_,_,Result) :-      /* unrecognized character */
          write('Number expected. Try again:'),
          readnumber(Result).

/* readnumber_value(ASCII,Number)
 *   converts ASCII codes of digits to numeric values.
 */

readnumber_value(48,0).
readnumber_value(49,1).
readnumber_value(50,2).
readnumber_value(51,3).
readnumber_value(52,4).
readnumber_value(53,5).
readnumber_value(54,6).
readnumber_value(55,7).
readnumber_value(56,8).
readnumber_value(57,9).
