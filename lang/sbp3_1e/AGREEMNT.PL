/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* AGREEMNT.PL */

/* Parser for sentences with
   verb-subject number agreement. */

/* Queries will use the built-in predicate phrase/2 */

/* The argument N is the number of
   the subject and main verb.
   It is instantiated to 'singular'
   or 'plural' as the parse progresses. */

sentence --> noun_phrase(N), verb_phrase(N).

noun_phrase(N) --> determiner(N), noun(N).

verb_phrase(N) --> verb(N), noun_phrase(_).
verb_phrase(N) --> verb(N), sentence.

determiner(singular) --> [a].
determiner(_)        --> [the].
determiner(plural)   --> [].

noun(singular) --> [dog];[cat];[boy];[girl].
noun(plural)   --> [dogs];[cats];[boys];[girls].

verb(singular) --> [chases];[sees];[says];[believes].
verb(plural)   --> [chase];[see];[say];[believe].
