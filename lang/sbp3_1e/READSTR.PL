/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* READSTR.PL */
/* Contains utility procedures READSTRING, WRITESTRING, and READATOM */
/* See text for further documentation. */

/*************************************************************************
 * readstring(Result)                                                    *
 *   Displays a one-character-prompt, then accepts a line of input from  *
 *   the keyboard and returns it as a string (list of ASCII codes).      *
 *   The user can use Backspace (Ctrl-H) to make corrections, and is     *
 *   prevented from backspacing past the beginning of the line.          *
 *************************************************************************/

readstring(Result) :- put(62),       /* Prompt character is '>' */
                      readstring_start(0,Result).

readstring_start(Count,X) :- get0(Char),
                             readstring_aux(Count,Char,X).

readstring_aux(_,13,[]) :- !.        /* Return */
readstring_aux(_,10,[]) :- !.        /* New line */

readstring_aux(0,8,Result) :-  !,    /* Backspace past beginning */
                               readstring(Result).     /* start over */

readstring_aux(Count,8,Result) :- !, /* Backspace */
                            put(32), /* Print a blank, then */
                            put(8),  /* backspace again */
                            NewCount is Count-1,
                            readstring_start(NewCount,Tail),
                            readstring_cons(8,Tail,Result).

readstring_aux(Count,Char,Result) :-    /* Normal character */
                            NewCount is Count+1,
                            readstring_start(NewCount,Tail),
                            readstring_cons(Char,Tail,Result).

readstring_cons(Char,[8|Tail],Tail) :- Char \== 8, !.
readstring_cons(Char,Tail,[Char|Tail]).

/*************************************************************************
 * writestring(String)                                                   *
 *  Displays a string (a list of ASCII codes).                           *
 *************************************************************************/

writestring([]).
writestring([Head|Tail]) :- put(Head), writestring(Tail).

/*************************************************************************
 * readatom(Atom)                                                        *
 *   Reads a string and then converts it to an atom.                     *
 *************************************************************************/

readatom(Atom) :- readstring(String), name(Atom,String).
