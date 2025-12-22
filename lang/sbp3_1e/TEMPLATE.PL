/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* TEMPLATE.PL */

/* Simple natural language understander using templates. */

/* Uses READSTR.PL and TOKENIZE.PL */
:- (clause(readstring(_),_) ; consult('readstr.pl')).
:- (clause(tokenize(_,_),_) ; consult('tokenize.pl')).

:- unknown(_,fail),nl,nl. /* unknown procedures just fail without warning */

/*
 * process(Wordlist)
 *  translates Wordlist into Prolog and asserts it if it
 *  is a statement or queries it if it is a question.
 */

/* Note that this procedure assumes that whenever a word ends in S,
   the S is an affix (either noun plural or verb singular). */

process([X,is,a,Y]) :-        /* [fido,is,a,dog] => dog(fido). */
     !,
     Fact =.. [Y,X],
     note(Fact).

process([X,is,an,Y]) :-       /* same, with "an" */
     !,
     process([X,is,a,Y]).

process([is,X,a,Y]) :-        /* [is,fido,a,dog] => ?-dog(fido). */
     !,
     Query =.. [Y,X],
     check(Query).

process([is,X,an,Y]) :-       /* same, but with "an" */
     !,
     process([is,X,a,Y]).

process([X,are,Y]) :-         /* [dogs,are,animals] =>           */
     !,                       /*      animal(X) :- dog(X).       */
     remove_s(X,X1),
     remove_s(Y,Y1),
     Head =.. [Y1,Z],
     Tail =.. [X1,Z],
     note((Head :- Tail)).

process([does,X,Y]) :-        /* [does,fido,sleep] => ?-sleep(fido). */
     !,
     Query =.. [Y,X],
     check(Query).

process([X,Y]) :-             /* [fido,sleeps] => sleep(fido). */
     \+ remove_s(X,_),
     remove_s(Y,Y1),
     !,
     Fact =.. [Y1,X],
     note(Fact).

process([X,Y]) :-             /* [dogs,sleep] => sleep(X) :- dog(X). */
     remove_s(X,X1),
     \+ remove_s(Y,_),
     !,
     Head =.. [Y,Z],
     Tail =.. [X1,Z],
     note((Head :- Tail)).

process(_) :-
     write('I do not understand.'),
     nl.

/*
 * remove_s(X,X1)
 *  removes final S from X giving X1,
 *  or fails if X does not end in S.
 */

remove_s(X,X1) :-
     name(X,XList),
     remove_s_list(XList,X1List),
     name(X1,X1List).

remove_s_list("s",[]).

remove_s_list([Head|Tail],[Head|NewTail]) :-
     remove_s_list(Tail,NewTail).

/*
 * check(Query)
 *   Try Query. Report whether it succeeded.
 */

check(Query) :- /* write('Trying query: ?- '), */
                /* write(Query),  */     /* Un-comment these lines */
                /* nl,            */     /* to see the translations */
                call(Query),
                !,
                write('Yes.'),
                nl.

check(_) :-     write('Not as far as I know.'),
                nl.

/*
 * note(Fact)
 *  Asserts Fact and prints acknowledgement.
 */

note(Fact) :-  /* write('Adding to knowledge base: '), */
               /* write(Fact),     */   /* Un-comment these lines */
               /* nl,              */   /* to see the translations */
               asserta(Fact),
               write('OK'),
               nl.

/*
 * go
 *  Accept and process one sentence.
 */

go :- readstring(S),
      nl,
      tokenize(S,T),
      process(T).

/*
 * Starting query
 */

start :- write('TEMPLATE.PL at your service.'),nl,
         write('Terminate by pressing Ctrl-C.'),nl,
         repeat,
           go,
         fail.

:-start.
