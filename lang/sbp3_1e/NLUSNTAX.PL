/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* NLUSNTAX.PL */

/* Syntax for the language that will be parsed
   by NLU.PL  (See NLU.PL for vocabulary.)  */


/* Rule */                              /* Example */

sentence -->
  noun_phrase, verb_phrase.             /* Dogs chase cats. */

sentence -->
  noun_phrase, copula, noun_phrase.     /* Dogs are animals. */

sentence -->
  noun_phrase, copula, adj_phrase.      /* Dogs are big. */

sentence -->
  aux_verb, noun_phrase, verb_phrase.   /* Do dogs chase cats? */

sentence -->
  copula, noun_phrase, noun_phrase.     /* Are dogs animals? */

sentence -->
  copula, noun_phrase, adj_phrase.      /* Are dogs big? */

verb_phrase --> verb, noun_phrase.      /* chase cats */

adj_phrase --> adjective.               /* big */

noun_phrase -->
  determiner, noun_group.               /* a big brown dog */

noun_group --> adjective, noun_group.   /* big brown dog */

noun_group --> common_noun.             /* dog */

noun_group --> proper_noun.             /* Fido */
