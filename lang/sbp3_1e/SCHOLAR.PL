/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* SCHOLAR.PL */

/*
 * An XSHELL knowledge base.
 * Requires all procedures in XSHELL.PL.
 */

:- ( clause(xshell,_) ; consult('xshell.pl') ).

/* Any clauses for the predicates XKB_INTRO,
 * XKB_REPORT, XKB_UNIQUE, XKB_EXPLAIN, XKB_IDENTIFY, and
 * XKB_QUESTION should be removed from the knowledge base.
 */

:- abolish(xkb_intro,1).
:- abolish(xkb_report,1). 
:- abolish(xkb_unique,1).
:- abolish(xkb_explain,1). 
:- abolish(xkb_identify,1).
:- abolish(xkb_question,2).

xkb_intro(
  ['',
   'SCHOLAR: An Expert System for Scholarship Eligibility',
   '',
   'This program will help a student identify scholarships',
   'for which he or she may be eligible.',
   '']).

xkb_report('You are eligible for this scholarship: ').
xkb_unique(no).
xkb_explain(no).

/*
 * xkb_identify(Scholarship)
 *   Each clause for this predicate provides a rule to be
 *   used with the utility predicates in the XSHELL.PRO file
 *   to determine whether the user meets minimal eligibility
 *   requirements for the Scholarship.
 */

xkb_identify(['',
 '  ADAPSO Program',
 '',
 'Amount of award: up to $1000',
 '',
 'For further information contact:',
 '  ADAPSO Fellowship and Grant Program',
 '  Selection Committee',
 '  1300 N. 17th St.',
 '  Arlington, VA  22209.']):-
  parmrange(need,500,10000),
  parmrange(gpa,3.0,4.0),
  prop(career_in_computer_services).

xkb_identify(['',
 '  Aid Association for Lutherans',
 '',
 'Amount of award: $500 - $1,750',
 '',
 'For further information contact:',
 '  Aid Association for Lutherans',
 '  Appleton, WI  54919.']):-
  parm(class,n,1),
  prop(aal_certificate),
  prop(insurance).

xkb_identify(['',
 '  American Institute of Certified Public Accountants',
 '',
 'Amount of award: $250-$1000',
 '',
 'For further information contact:',
 '  Manager, Minority Recruitment',
 '  AICPA',
 '  1211 Ave. of the Americas',
 '  New York, NY  10036.']):-
  parmset(class,n,[1,2,3,4]),
  prop(minority),
  prop(us_citizen),
  major(accounting).

xkb_identify(['',
 '  Reid Blackburn Scholarship',
 '',
 'Amount of award: $1000-$2000',
 '',
 'For further information contact:',
 '  Reid Blackburn Scholarship Chairman',
 '  Bergenfield, NJ  07621.']):-
  parmset(class,n,[1,2,3,4]),
  major(photojournalism).

xkb_identify(['',
 '  Business and Professional Women''s Foundation Scholarship',
 '',
 'Amount of award: $100 - $1000',
 '',
 'For further information contact:',
 '  BPW Foundation',
 '  2012 Massachusetts Avenue, NW',
 '  Washington, DC  20036.']):-
  parmset(class,n,[3,4]),
  parmrange(need,100,10000),
  prop(us_citizen),
  parm(gender,c,f),
  parmrange(age,25,50).

xkb_identify(['',
 '  Michelle Clark Scholarship',
 '',
 'Amount of award: $1000',
 '',
 'For further information contact:',
 '  Ernie Schultz',
 '  Radio-TV News Directors Foundation',
 '  1735 S. Desales Street',
 '  Washington, DC  20036.']):-
  prop(minority),
  major(broadcast_journalism),
  prop(electronic_journalism_experience).

xkb_identify(['',
 '  DAR - Enid Hall Griswold Memorial Scholarship',
 '',
 'Amount of award: $1000',
 '',
 'For further information contact:',
 '  Office of Committees',
 '  NSDAR',
 '  1776 D. Street, NW',
 '  Washington, DC  20006.']):-
  parmset(class,n,[3,4]),
  ( major(political_science)
  ; major(history)
  ; major(government)
  ; major(economics) ).

xkb_identify(['',
 '  Kenneth E. Grant Research Scholarship',
 '',
 'Amount of award: $1000',
 '',
 'For further information contact:',
 '  Soil Conservation Society of America',
 '  7515 Northeast Arkeny Road',
 '  Arkeny, IA  50021.']):-
  parmset(class,n,[5,6]),
  prop(scsa_member).

xkb_identify(['',
 '  National Federation of the Blind Merit Scholarships',
 '',
 'Amount of award: $2500',
 '',
 'For further information contact:',
 '  National Federation of the Blind Scholarship Committee',
 '  1005 Nebraska Street',
 '  Sioux City, IA  51105.']):-
  parmrange(need,2500,10000),
  parmrange(gpa,3.0,4.0),
  prop(legally_blind).

xkb_identify(['',
 '  National Hispanic Scholarship Fund',
 '',
 'Amount of award: $250 - $800',
 '',
 'For further information contact:',
 '  National Hispanic Scholarship Fund',
 '  P.O. Box 748',
 '  San Francisco, CA  94101.']):-
  parmrange(need,250,10000),
  parmrange(gpa,3.0,4.0),
  prop(us_citizen),
  prop(hispanic).

xkb_identify(['',
 '  Melva T. Owen Memorial Scholarship',
 '',
 'Amount of award: $1200',
 '',
 'For further information contact:',
 '  National Federation of the Blind Scholarship Committee',
 '  1005 Nebraska Street',
 '  Sioux City, IA  51105.']):-
  parmrange(need,1200,10000),
  parmrange(gpa,3.0,4.0),
  prop(legally_blind).

xkb_identify(['',
 '  Soil Conservation Society of America Scholarships',
 '',
 'Amount of award: $750',
 '',
 'For further information contact:',
 '  Soil Conservation Society of America',
 '  7515 Northeast Arkeny Road',
 '  Arkeny, IA  50021.']):-
  parmset(class,n,[3,4]),
  parmrange(gpa,2.5,4.0),
  major(agriculture).

/*
 * xkb_question(Property_or_Parameter,Question)
 *   Each of these clauses provides a question or a simple
 *   menu to be used by the utility predicates in the
 *   XSHELL.PRO file to ask the user whether he or she has
 *   the property or what value the parameter takes for him
 *   or her.
 */

xkb_question(class,
     ['What is (will be) your class standing?',
      '  (1)  freshman',
      '  (2)  sophomore',
      '  (3)  junior',
      '  (4)  senior',
      '  (5)  graduate (MA, MS, MEd, MBA, etc.)',
      '  (6)  graduate (PhD, EdD, etc.)']).

xkb_question(need,
     ['What is the minimum amount of support you will need',
      'to continue school?']).

xkb_question(gpa,
     ['What is your grade point average converted to a',
      '4-point system?']).

xkb_question(career_in_computer_services,
     'Do you plan a career in computer services?').

xkb_question(aal_certificate,
     ['Do you own an Aid Association for Lutherans',
      'membership certificate?']).

xkb_question(insurance,
     ['Do you own Aid Association for Lutherans insurance',
      'in your own name?']).

xkb_question(us_citizen,'Are you a U.S. citizen?').

xkb_question(gender,'Are you male or female (m/f)?').

xkb_question(age,'How old are you?').

xkb_question(minority,
     'Are you a member of a recognized minority?').

xkb_question(electronic_journalism_experience,
     ['Have you had at least one year of experience in',
      'electronic journalism?']).

xkb_question(scsa_member,
     ['Are you a member of the Soil Conservation Society',
      'of America?']).

xkb_question(legally_blind,'Are you legally blind?').

xkb_question(hispanic,'Are you American Hispanic?').

xkb_question(multi_major,'Do you have more than one major?').

/*
 * major(Area)
 *   Succeeds if Area is one of the areas in which the user
 *   is majoring in college. This is a special predicate not
 *   usually found in an XSHELL knowledge base.
 */

major(Area) :-  known([major,Area],y), !.

major(Area) :- known([major,Area],n), !, fail.

major(_) :- known([major,_],y),
            \+ prop(multi_major),
            !, fail.

major(Area) :- write('Are you majoring in '),
               write(Area),
               writeln('?'),
               yes(>), nl, nl,
               assert(known([major,Area],y)),
               !.

major(Area) :- assert(known([major,Area],n)),
               nl, nl,
               !, fail.

:- xshell.
