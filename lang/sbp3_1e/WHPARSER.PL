/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* WHPARSER.PL */

/* Parser that handles WH-questions as well as statements.
   For simplicity, we neglect morphology. */

/* Each phrase that can contain a WH-word has 3 arguments:
     (1) List of WH-words found before starting to
          parse this constituent;
     (2) List of WH-words still available after
          parsing this constituent;
     (3) Structure built while parsing this
          constituent (as in STRUCTUR.PL). */

/* Queries will use built-in predicate phrase/2 */

sentence(X,Z,sentence(NP,VP)) -->  /* Sentence that does not */
     noun_phrase(X,Y,NP),          /* begin with a WH-word,  */
     verb_phrase(Y,Z,VP).          /* but may be embedded in */
                                   /* a sentence that does   */

sentence(X,Z,sentence(NP,VP)) -->
     wh_word(W),                /* Sentence begins with WH-word. */
     [did],                     /* Put the WH-word on the list,  */
     noun_phrase([W|X],Y,NP),   /* absorb "did," and continue.   */
     verb_phrase(Y,Z,VP).


noun_phrase(X,X,noun_phrase(D,N)) -->
     determiner(D),                /* Ordinary NP that does */
     noun(N).                      /* not use saved WH-word */

noun_phrase([X|Tail],Tail,noun_phrase(X)) --> [].
     /* Missing NP supplied by picking a */
     /* stored WH-word off the list      */


verb_phrase(X,Z,verb_phrase(V,NP)) -->
     verb(V),
     noun_phrase(X,Z,NP).

verb_phrase(X,Z,verb_phrase(V,S)) -->
     verb(V),
     sentence(X,Z,S).

determiner(determiner(a))   --> [a].
determiner(determiner(the)) --> [the].

noun(noun(dog))  --> [dog].
noun(noun(cat))  --> [cat].
noun(noun(boy))  --> [boy].
noun(noun(girl)) --> [girl].

/* Two forms of every verb:
   "The boy saw the cat" vs. "Did the boy see the cat?" */

verb(verb(chased))   --> [chased];[chase].
verb(verb(saw))      --> [saw];[see].
verb(verb(said))     --> [said];[say].
verb(verb(believed)) --> [believed];[believe].

wh_word(who)  --> [who].
wh_word(what) --> [what].


/* Sample queries */

demo1 :- phrase(sentence([],[],Structure),
           [who,did,the,boy,believe,the,girl,saw]),
         write(Structure),
         nl.

demo2 :- phrase(sentence([],[],Structure),
           [who,did,the,boy,believe,saw,the,girl]),
         write(Structure),
         nl.

