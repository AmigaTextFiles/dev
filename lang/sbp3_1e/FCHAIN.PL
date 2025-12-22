/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* FCHAIN.PL */

/* This file contains a simple forward chaining      */
/* inference engine that accepts Prolog translations */
/* of production rules, plus a supervisory program   */
/* for use with the inference engine.                */

  cls :- nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl.


/*
 * Supervisory program
 */

:- dynamic goal/1, fact/1.
:- multifile goal/1, fact/1.

fc :-
    /*
     * First, the supervisor prints an introductory
     * message to the user.
     */
     cls,
     write('FCHAIN - A Forward Chaining Inference Engine'),
     nl, nl,
     write('This is an interpreter for files containing production'),
     nl,
     write('rules written in the FCHAIN format.'),
     nl, nl,
     write('The > prompt accepts four commands:'), nl, nl,
     write('load. - prompts for names of rules files'), nl,
     write('        (enclose names in single quotes)'), nl,
     write('list. - lists facts and goals in working'), nl,
     write('        memory'),  nl,
     write('go.   - starts the forward chainer'), nl, nl,
     write('stop. - exits FCHAIN'), nl, nl,
     /*
      * Then the supervisor enters a simple read-evaluate
      * loop that reads the user's commands and processes them.
      */
     repeat,
     write('>'),
     read(X),
     /*
      * If the command is to stop the supervisor,
      * then the temporary database is erased and the
      * supervisor succeeds. Otherwise, the user's
      * command is passed on to the processing procedure.
      * After the command is processed, the supervisor fails
      * and execution backtracks to the 'repeat' goal above.
      */
     ( X = stop,abolish(fact,1),abolish(goal,1)
       ;
       process(X), nl, fail
     ).

/*
 * process(Command)
 *   provides procedures for processing each of the
 *   four kinds of commands the user may give to the
 *   supervisor.
 */

process(go) :- nl, forward_chainer.

process(go) :- !.  /* if forward_chainer failed */

process(load) :- nl, write('File name? '),
                 read(Filename),
                 reconsult(Filename), !.

process(list) :- nl, write('Facts:'),
                 nl, fact(X),
                 write('     '),
                 write(X), nl, fail.

process(list) :- nl, write('Goals:'),
                 nl, goal(X),
                 write('     '),
                 write(X), nl, fail.

process(list) :- !.

process(list(X)) :- nl, fact(X),
                    write('     '),
                    write(X), nl, fail.

process(list(_)) :- !.

/*
 * forward-chainer
 *   finds a production rule that can be fired,
 *   fires it, and informs the user, then calls
 *   itself to repeat the process.
 */

forward_chainer :- rule(ID),
                   write('Fired rule: '),
                   write(ID),
                   write('.'),
                   nl, !,
                   forward_chainer.

/*
 * The remaining predicates are provided to make
 * writing and reading production rules easier.
 */

af(X) :- asserta(fact(X)).

rf(X) :- retract(fact(X)).

ag(X) :- assert(goal(X)).

rg(X) :- retract(goal(X)).

then.

/* Starting query */

start :- fc.
:- start.
