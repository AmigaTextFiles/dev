/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* MDC.PL  */

/*
 * Contains a CONMAN knowledge base.
 * Requires all utility procedures defined in file CONMAN.PL.
 */

:- ( clause(conman,_) ; consult('conman.pl') ).

/*
 * Any previously defined clauses for the predicates KB_INTRO,
 * KB_THRESHOLD, KB_HYPOTHESIS, C_RULE, and KB_CAN_ASK should
 * be removed from the knowledge base before loading the
 * clauses below.
 */

:- abolish(kb_intro,1).
:- abolish(kb_threshold,1).
:- abolish(kb_hypothesis,1). 
:- abolish(c_rule,4).     
:- abolish(kb_can_ask,1).   

kb_intro(
     ['',
      'MDC: A Demonstration Medical Diagnostic System',
      '           Using Confidence Rules',
      '']).

kb_threshold(65).

kb_hypothesis('The patient has allergic rhinitis.').
kb_hypothesis('The patient has strep throat.').
kb_hypothesis('The patient has pneumonia.').
kb_hypothesis('Give the patient an antihistamine.').
kb_hypothesis('Give the patient a decongestant.').
kb_hypothesis('Give the patient penicillin.').
kb_hypothesis('Give the patient tetracycline.').
kb_hypothesis('Give the patient erythromycin.').

c_rule('The patient has nasal congestion.',
     95,
     [],
     ['The patient is breathing through the mouth.',yes]).

c_rule('The patient has a sore throat.',
     95,
     [],
     [and,['The patient is coughing.',yes],
          ['The inside of the patient''s throat is red.',
               yes]]).

c_rule('The patient has a sore throat.',
     90,
     [],
     ['The inside of the patient''s throat is red.',yes]).

c_rule('The patient has a sore throat.',
     75,
     [],
     ['The patient is coughing.',yes]).

c_rule('The patient has chest congestion.',
     100,
     [],
     ['There are rumbling sounds in the chest.',yes]).

c_rule('The patient has allergic rhinitis.',
     85,
     [],
     [and,['The patient has nasal congestion.',yes],
          [and,['The patient has a sore throat.',no],
               ['The patient has chest congestion.',no]]]).

c_rule('The patient has strep throat.',
     80,
     [],
     [and,['The patient has nasal congestion.',yes],
          ['The patient has a sore throat.',yes]]).

c_rule('The patient has pneumonia.',
     90,
     [],
     [and,['The patient has chest congestion.',yes],
          [and,['The patient has nasal congestion.',yes],
               ['The patient has a sore throat.',no]]]).

c_rule('The patient has pneumonia.',
     75,
     [],
     [and,['The patient has chest congestion.',yes],
          ['The patient has nasal congestion.',yes]]).

c_rule('Give the patient an antihistamine.',
     100,
     ['The patient has allergic rhinitis.'],
     []).

c_rule('Give the patient a decongestant.',
     100,
     ['The patient has nasal congestion.'],
     ['The patient has high blood pressure.',no]).

c_rule('Give the patient penicillin.',
     100,
     ['The patient has pneumonia.'],
     ['The patient is allergic to penicillin.',no]).

c_rule('Give the patient penicillin.',
     100,
     ['The patient has pneumonia.',
      'The patient is allergic to penicillin.'],
     [and,['The patient is in critical condition.',yes],
          ['The patient is allergic to tetracycline.',yes]]).

c_rule('Give the patient tetracycline.',
     100,
     ['The patient has pneumonia.',
      -,'Give the patient penicillin.'],
     ['The patient is allergic to tetracycline.',no]).

c_rule('Give the patient erythromycin.',
     100,
     ['The patient has strep throat.'],
     ['The patient is allergic to erythromycin.',no]).

kb_can_ask('The patient has nasal congestion.').
kb_can_ask('The patient has chest congestion.').
kb_can_ask('The patient has a sore throat.').
kb_can_ask('The patient has high blood pressure.').
kb_can_ask('The patient is allergic to penicillin.').
kb_can_ask('The patient is allergic to erythromycin.').
kb_can_ask('The patient is allergic to tetracycline.').
kb_can_ask('The patient is breathing through the mouth.').
kb_can_ask('The patient is coughing.').
kb_can_ask('The inside of the patient''s throat is red.').
kb_can_ask('There are rumbling sounds in the chest.').
kb_can_ask('The patient is in critical condition.').

:- conman.
