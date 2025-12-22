/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* MORPH.PL */

/* Queries will use built-in predicate phrase/2 */

/* Parser for sentences with
   verb-subject number agreement.
   Like AGREEMNT.PL but includes
   a few morphological rules. */

sentence --> noun_phrase(N), verb_phrase(N).

noun_phrase(N) --> determiner(N), noun(N).

verb_phrase(N) --> verb(N), noun_phrase(_).
verb_phrase(N) --> verb(N), sentence.

determiner(singular) --> [a].
determiner(_)        --> [the].
determiner(plural)   --> [].

noun(N) --> [X], { morph(noun(N),X) }.
verb(N) --> [X], { morph(verb(N),X) }.

/*
 * morph(Type,Word)
 *  succeeds if Word is a word-form
 *  of the specified type.
 */

/* Singular (unmarked) nouns */

morph(noun(singular),dog).
morph(noun(singular),cat).
morph(noun(singular),boy).
morph(noun(singular),girl).
morph(noun(singular),child).

/* Irregular plural nouns */

morph(noun(plural),children).

/* Rule for regular plural nouns */

morph(noun(plural),X) :-
     remove_s(X,Y),
     morph(noun(singular),Y).

/* Plural (unmarked) verbs */

morph(verb(plural),chase).
morph(verb(plural),see).
morph(verb(plural),say).
morph(verb(plural),believe).

/* Rule for singular verbs */

morph(verb(singular),X) :-
     remove_s(X,Y),
     morph(verb(plural),Y).

/*
 * remove_s(X,X1) [lifted from TEMPLATE.PRO]
 *  removes final S from X giving X1,
 *  or fails if X does not end in S.
 */

remove_s(X,X1) :-
     name(X,XList),
     remove_s_list(XList,X1List),
     name(X1,X1List).

remove_s_list("s",[]).

remove_s_list([Head|Tail],[Head|NewTail]) :-
     remove_s_list(Tail,NewTail).
