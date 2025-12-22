/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* LEARNER.PL */
/* Program that modifies its knowledge base */

/* This program stores its knowledge base on the file KB.PL.
   Initially, KB.PL should contain the clauses for capital_of
   as given in CAPITALS.PL and a DYNAMIC statement. */

/* This program uses recursion to implement a loop. It will
   run out of memory after a number of iterations. Techniques
   to prevent this will be given in Chapter 4. */

start :-  consult('kb.pl'),
	  nl,
	  write('Note! Type names entirely in'),nl,
	  write('lower case, followed by a period.'),nl,
	  write('Type "stop." to quit.'),nl,
	  nl,
	  process_a_query.

process_a_query :- write('State? '),
		   read(State),
		   answer(State).

   /* If user typed "stop." then save the knowledge base and quit. */

answer(stop) :-    write('Saving the knowledge base...'),nl,
		   tell('kb.pl'),
		   listing(capital_of/2),
		   told,
		   write('Done.'),nl.

   /* If the state is in the knowledge base, display it, then
      loop back to process_a_query */

answer(State) :-   capital_of(State,City),
		   write('The capital of '),
		   write(State),
		   write(' is '),
		   write(City),nl,
		   nl,
		   process_a_query.

   /* If the state is not in the knowledge base, ask the
      user for information, add it to the knowledge base, and
      loop back to process_a_query */

answer(State) :-   not capital_of(State,_),
		   write('I do not know the capital of that state.'),nl,
		   write('Please tell me.'),nl,
		   write('Capital? '),
		   read(City),
		   write('Thank you.'),nl,nl,
		   assertz(capital_of(State,City)),
		   process_a_query.


