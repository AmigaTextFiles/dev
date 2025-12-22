/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* PRINTABL.PL */

/*
 * print_table(Proc,Start,Finish,Step)
 *   Prints a table of the mathematical function
 *   computed by Proc, which is a lambda-expression
 *   (see text), for input values from Start to
 *   Finish at intervals of Step.
 */

print_table(_,Start,Finish,_) :-
  Start > Finish,
  !.

print_table(lambda(Input,Result,Goal),Start,Finish,Step) :-
  write(Start),
  write('  '),
  prove_and_discard_instantiations(
     ( Input = Start, call(Goal), write(Result), nl )
                                  ),
  NewStart is Start+Step,
  print_table(lambda(Input,Result,Goal),NewStart,Finish,Step).


/*
 * prove_and_discard_instantiations(Goal)
 *   Like call(Goal), except that any instantiations
 *   done during execution are undone upon exit.
 */

prove_and_discard_instantiations(Goal) :-
                                    \+ \+ call(Goal).

/*
 * Demonstration of the above
 */

demo :- print_table(lambda(X,Y,(Y is 3*X*X)), 0.0, 1.0, 0.1).
