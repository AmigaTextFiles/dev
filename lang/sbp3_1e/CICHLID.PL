/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* CICHLID.PL */

/*
 * Contains an XSHELL knowledge base.
 * Requires all procedures in XSHELL.PL.
 */

:- ( clause(xshell,_) ; consult('xshell.pl') ).

/* Any clauses for the predicates XKB_INTRO,
   xkb_report, XKB_UNIQUE, XKB_EXPLAIN, XKB_IDENTIFY, and
   XKB_QUESTION should be removed from the knowledge base. */

:- abolish(xkb_intro,1).
:- abolish(xkb_report,1).   
:- abolish(xkb_unique,1). 
:- abolish(xkb_explain,1). 
:- abolish(xkb_identify,1).
:- abolish(xkb_question,2).

xkb_intro(
 ['',
  'CICHLID: An Expert System for Identifying Dwarf Cichlids',
  '',
  'The cichlids are a family of tropical fish.  Many of',
  'these fish are large and can only be kept in large',
  'aquariums. Others, called ''dwarf cichlids'', rarely',
  'exceed 3 inches and can be kept in smaller aquariums.',
  '',
  'This program will help you identify many of the more',
  'familiar species of dwarf cichlid.  Identification of',
  'these fish is not always easy, and the program may offer',
  'more than one possible identification.  Even then, you',
  'should consult photographs in an authoritative source',
  'such as Staek, AMERIKANISCHE CICHLIDEN I: KLEINE',
  'BUNTBARSCHE (Melle: Tetra Verlag, 1984), or Goldstein,',
  'CICHLIDS OF THE WORLD (Neptune City, New Jersey:',
  't.f.h. Publications, 1973) for positive identification.',
  '',
  'To use the program, simply describe the fish by',
  'answering the following questions.']).

xkb_report('Possible identification: ').
xkb_unique(no).
xkb_explain(no).

/*
 * xkb_identify(Species)
 *   Each clause for this predicate provides a rule to be
 *   used with the utility predicates in the XSHELL.PRO file
 *   to determine whether the fish to be identified is likely
 *   to belong to the Species.
 */

xkb_identify('Apistogramma agassizii'):-
     parm(caudal,c,s),
     parm(body_shape,c,l),
     parm(lateral_stripe,c,d),
     prop(dorsal_streamer),
     prop(lateral_stripe_extends_into_tail).

xkb_identify('Apistogramma borelli'):-
     parm(caudal,c,n),
     parm(body_shape,c,d),
     parm(lateral_stripe,c,i),
     prop(dorsal_streamer),
     prop(ventral_streamer),
     prop(lateral_stripe_extends_into_tail),
     parm(color,c,y).

xkb_identify('Apistogramma cacatuoides'):-
     parm(caudal,c,l),
     parm(body_shape,c,d),
     parm(lateral_stripe,c,d),
     prop(dorsal_crest),
     prop(dorsal_streamer),
     prop(anal_streamer),
     prop(stripes_in_lower_body),
     prop(lateral_stripe_extends_into_tail).

xkb_identify('Apistogramma trifasciata'):-
     parm(caudal,c,n),
     parm(body_shape,c,n),
     parm(lateral_stripe,c,d),
     prop(dorsal_crest),
     prop(dorsal_streamer),
     prop(anal_streamer),
     prop(ventral_streamer),
     prop(lateral_stripe_extends_into_tail),
     prop(angular_line_above_ventral).

xkb_identify('Lamprologus brichardi'):-
     parm(caudal,c,l),
     parm(body_shape,c,n),
     parm(lateral_stripe,c,n),
     parm(color,c,g),
     prop(gill_spot),
     prop(fins_trimmed_white).

xkb_identify('Pelvicachromis pulcher'):-
     parm(caudal,c,s),
     parm(body_shape,c,l),
     prop(dorsal_streamer),
     prop(anal_streamer),
     prop(orange_spots_in_tail).

xkb_identify('Microgeophagus ramirezi'):-
     parm(caudal,c,n),
     parm(body_shape,c,d),
     parm(lateral_stripe,c,n),
     prop(dorsal_crest),
     parm(color,c,v).

xkb_identify('Nannacara anomala'):-
     parm(caudal,c,n),
     parm(body_shape,c,d),
     parm(lateral_stripe,c,n),
     parm(color,c,m).

xkb_identify('Nanochromis nudiceps'):-
     parm(caudal,c,n),
     parm(body_shape,c,l),
     parm(lateral_stripe,c,n),
     parm(color,c,b).

/*
 * xkb_question(Property_or_Parameter,Question)
 *   Each of these clauses provides a question or a simple
 *   menu to be used by the utility predicates in the
 *   XSHELL.PRO file to ask the user whether the fish to be
 *   identified has the property or what value the parameter
 *   takes for the fish.
*/

xkb_question(caudal,
     ['What is the shape of the tail-fin?',
      '  (l)  Lyre-shaped',
      '  (s)  Spear-shaped',
      '  (n)  Normal, i.e, round or fan-shaped.']).

xkb_question(body_shape,
     ['What is the shape of the body?',
      '  (l)  Long and narrow.',
      '  (d)  Deep, heavy and short.',
      '  (n)  Normal fish shape.']).

xkb_question(dorsal_crest,
     ['Are any fin rays at the front of the dorsal fin',
      'clearly extended above the rest of the fin?']).

xkb_question(dorsal_streamer,
     ['Are any fin rays at the back of the dorsal fin',
      'clearly extended into a long streamer?']).

xkb_question(anal_streamer,
     ['Are any fin rays at the back of the anal fin',
      'clearly extended into a long streamer?']).

xkb_question(ventral_streamer,
     ['Are any fin rays at the bottom of the ventral',
      'fins clearly extended into streamers?']).

xkb_question(lateral_stripe,
     ['Describe the line running the length of the body.',
      '  (d)  Sharp and distinct from eye to base of tail.',
      '  (i)  Irregular, indistinct or incomplete.',
      '  (n)  None visible or barely visible.']).

xkb_question(color,
     ['What is the basic color of the body?',
      '  (b)  pale blue,',
      '  (g)  pale gray,',
      '  (m)  metallic bronze or green,',
      '  (v)  violet, yellow and claret highlights,',
      '  (y)  yellow,',
      '  (n)  none of the above.']).

xkb_question(lateral_stripe_extends_into_tail,
     ['Does the stripe down the side extend into the base',
      'of the tail?']).

xkb_question(stripes_in_lower_body,
      ['Are there horizontal stripes in the lower part',
       'of the body?']).

xkb_question(angular_line_above_ventral,
     ['Is there an angular line above the ventral fin',
      'slanting from the pectoral downward toward the',
      'stomach region?']).

xkb_question(orange_spots_in_tail,
      ['Are there black spots trimmed in orange in',
       'the tail fin?']).

xkb_question(gill_spot,'Is there a dark spot on the gill?').

xkb_question(fins_trimmed_white,
      'Are the unpaired fins trimmed with a white edge?').

:- xshell.
