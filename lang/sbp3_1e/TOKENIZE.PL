/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* TOKENIZE.PL */

/**************************************************
 * tokenize(String,Result)                        *
 *  Converts String (a list of ASCII codes) into  *
 *  into a list of atoms, discarding punctuation  *
 *  and converting all letters to lower case.     *
 **************************************************/

tokenize([],[]) :- !.

tokenize(String,[Word|Rest]) :-
  grab_word(String,Chars,NewString),
  name(Word,Chars),
  tokenize(NewString,Rest).


/*
 * grab_word(String,Chars,Rest)
 *  Splits String into the characters constituting
 *  the first token (Chars) and the remainder (Rest).
 */

grab_word([32|Tail],[],Tail) :- !.
  /* Stop upon hitting a blank */

grab_word([],[],[]).
  /* Stop upon hitting the end of the list */

grab_word([Char|Tail],Chars,Rest) :-
  punctuation_mark(Char), !,
  grab_word(Tail,Chars,Rest).
  /* Skip punctuation marks */

grab_word([Char|Tail1],[NewChar|Tail2],Rest) :-
  grab_word(Tail1,Tail2,Rest),
  lower_case(Char,NewChar),
  !.
  /* If within a word, keep going. */
  /* Cut rules out spurious alternatives. */


/*
 * punctuation_mark(Char)
 *   succeeds if Char is a punctuation mark.
 */

punctuation_mark(Char) :- Char =< 47.
punctuation_mark(Char) :- Char >= 58, Char =< 64.
punctuation_mark(Char) :- Char >= 91, Char =< 96.
punctuation_mark(Char) :- Char >= 123.


/*
 * lower_case(Char,NewChar)
 *  NewChar is the lower case character
 *  corresponding to Char.
 */

lower_case(Char,NewChar) :-
   Char >= 65,
   Char =< 90,
   NewChar is Char+32.

lower_case(Char,Char) :-
   Char < 65.

lower_case(Char,Char) :-
   Char > 90.
