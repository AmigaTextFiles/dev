/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* READSTR1.PL */
/* First attempt at a "read string" predicate */

/*
 * readstring(Result)
 *   Lets the user type any number of characters, ending
 *   with Return or New Line (Line Feed). Result is a list
 *   of the ASCII codes of these characters.
 *
 *   In this version the backspace key does not delete the
 *   previous character. Instead it lets the user retype
 *   the entire line.
 */

readstring(Result) :- put(62),            /* display '>' to prompt user */
                      get0(FirstChar),
                      readstring_aux(FirstChar,Result).

/* readstring_aux(Char,Result)
 *   Char is the previous character, and
 *   Result is a list (obtained recursively)
 *   of it plus all subsequent characters.
 */

readstring_aux(13,[]).  /* Return key */
readstring_aux(10,[]).  /* New Line key */

readstring_aux(8,Result) :-      /* Backspace key */
                    put(7),  /* beep */
                    write(' <Start over>'),
                    nl,
                    readstring(Result).

readstring_aux(Char,[Char|Result]) :-
                    Char \== 13,
                    Char \== 10,
                    Char \== 8,
                    get0(NewChar),
                    readstring_aux(NewChar,Result).

