/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* Modified for Quintus Prolog by Andreas Siebert */

/* CAR.PL */
/* Simple expert system */

/*
 * User interface and control routines
 */

start :-
   nl,
   write('This program diagnoses why a car won''t start.'),nl,
   write('Answer all questions with ''yes.'' or ''no.'''),nl,
   write('(lower case, with period, without quotes).'),nl,
   try_all_possibilities.

try_all_possibilities :-
   /* The 'fail' at the end causes this predicate to */
   /* backtrack through all possibilities.           */
   defect_may_be(D),
   explain(D),
   fail.

try_all_possibilities.
   /* If all paths through the previous definition */
   /* have been exhausted, succeed and quit.       */

/*
 * Diagnostic knowledge base: a set of diagnoses and
 *  the conditions under which each one is to be given
 */

defect_may_be(drained_battery) :-
   starter_was_ok(yes),
   starter_is_ok(no).

defect_may_be(wrong_gear) :-
   starter_was_ok(no).

defect_may_be(starting_system) :-
   starter_was_ok(no).

defect_may_be(fuel_system) :-
   starter_was_ok(yes),
   fuel_is_ok(no).

defect_may_be(ignition_system) :-
   starter_was_ok(yes),
   fuel_is_ok(yes).

/*
 * Working database
 *   Several items of information are collected from the user
 *   if and when they are needed, and added to the knowledge base.
 *   All start out with the value 'unknown'.
 */

starter_was_ok(unknown).

starter_was_ok(X) :-
   retract(starter_was_ok(unknown)),
   nl,
   write('When you first started trying to start the car,'),nl,
   write('did the starter crank the engine normally? '),
   read(Reply),
   asserta(starter_was_ok(Reply)),
   X = Reply.

starter_is_ok(unknown).

starter_is_ok(no) :-
   starter_was_ok(no).

starter_is_ok(X) :-
   retract(starter_is_ok(unknown)),
   nl,
   write('Does the starter crank the engine normally now? '),
   read(Reply),
   asserta(starter_is_ok(Reply)),
   X = Reply.

fuel_is_ok(unknown).

fuel_is_ok(X) :-
   retract(fuel_is_ok(unknown)),
   nl,
   write('Is fuel being delivered to the carburetor? '),
   read(Reply),
   asserta(fuel_is_ok(Reply)),
   X = Reply.

/*
 *  Explanations for the various diagnoses
 */

explain(wrong_gear) :-
   nl,
   write('Check that the gearshift is set to Park or Neutral.'),nl,
   write('Try jiggling the gearshift lever.'),nl.

explain(starting_system) :-
   nl,
   write('Check for a defective battery, voltage'),nl,
   write('regulator, or alternator; if any of these is'),nl,
   write('the problem, charging the battery or jump-'),nl,
   write('starting may get the car going temporarily.'),nl,
   write('Alternatively, the starter itself may be'),nl,
   write('defective.'),nl.

explain(drained_battery) :-
   nl,
   write('The battery has apparently become drained during'),nl,
   write('your attempts to start the car. Recharging or'),nl,
   write('jump-starting will be necessary. However, there'),nl,
   write('is probably nothing wrong with the battery itself.'),nl.

explain(fuel_system) :-
   nl,
   write('Check whether there is fuel in the tank.'),nl,
   write('If so, check for a clogged fuel line or filter'),nl,
   write('or a defective fuel pump.'),nl.

explain(ignition_system) :-
   nl,
   write('Check the spark plugs, cables, distributor,'),nl,
   write('coil, and other parts of the ignition system.'),nl,
   write('If any of these are visibly defective or long'),nl,
   write('overdue for replacement, replace them; if this'),nl,
   write('does not solve the problem, consult a mechanic.'),nl.

/*
 * Starting query
 */
