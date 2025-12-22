/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* PARSER2.PL */
/* Like PARSER1.PL, but uses grammar rule notation. */

/* Queries will use the built-in predicate phrase/2 */

sentence --> noun_phrase, verb_phrase.

noun_phrase --> determiner, noun.

verb_phrase --> verb, noun_phrase.
verb_phrase --> verb, sentence.

determiner --> [the].
determiner --> [a].

noun --> [dog].
noun --> [cat].
noun --> [boy].
noun --> [girl].

verb --> [chased].
verb --> [saw].
verb --> [said].
verb --> [believed].
