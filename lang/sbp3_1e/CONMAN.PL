/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

% get1(C)
%  accepts a line of input and returns only the first character.
%  A good way to obtain a 1-character response from the user
%  in a Prolog with buffered input, such as Quintus or ALS.

:- multifile get1/1.

get1(C) :-
  get(C),
  repeat,
    get0(N),
    (N=10 ; N=13),
  !.


/* CONMAN.PL */

/*
 * Requires procedures defined in files
 * WRITELN.PL, YES.PL, and FINDALL.PL.
 */

:- ( clause(writeln(_),_) ; consult('writeln.pl') ).
:- ( clause(yes(_),_) ; consult('yes.pl') ).
:- ( clause(find_all(_),_) ; consult('findall.pl') ).

:- dynamic known/3.

/*
 * CONMAN user interface
 *   CONMAN modifies and extends the standard Prolog infer-
 *   ence engine, providing the ability to use confidence
 *   factors in reaching conclusions. As a result, we dis-
 *   tinguish the procedures in CONMAN that handle communi-
 *   cation with the user from the predicates that make up
 *   the CONMAN inference engine.
 */

conman :- kb_intro(Statement),
          writeln(Statement),nl,
          kb_threshold(T),
          kb_hypothesis(Hypothesis),
          confidence_in([Hypothesis,yes],CF),
          CF >= T,
          write('Conclusion: '),
          writeln(Hypothesis),
          write('Confidence in hypothesis: '),
          write(CF),
          writeln('%.'),
          explain_conclusion(Hypothesis), fail.

conman :- kb_hypothesis(Hypothesis),
          confirm([Hypothesis]),!,
          writeln('No further conclusions.'),
          nl, finish_conman.

conman :- writeln('Can draw no conclusions.'),
          nl, finish_conman.

finish_conman :-
     abolish(known,3),
     write('Do you want to conduct another consultation?'),
     yes('>'), nl, nl,
     asserta(known(xxx,yyy,zzz)), /* dummy predicate */
     !, conman.

finish_conman :- asserta(known(xxx,yyy,zzz)).  /* dummy predicate */

ask_confidence(Hypothesis,CF) :-
     kb_can_ask(Hypothesis),
     writeln('Is the following conjecture true? --'),
     write('  '), writeln(Hypothesis),
     writeln(['Possible responses: ',
              '  (y) yes            (n) no',
              '  (l) very likely    (v) very unlikely',
              '  (p) probably       (u) unlikely',
              '  (m) maybe          (d) don''t know.',
              '         (?) why?']),
     write('  Your response --> '),
     get0_only([y,l,p,m,n,v,u,d,?],Reply), nl, nl,
     convert_reply_to_confidence(Reply,CF),
     !, Reply \== d,
     ask_confidence_aux(Reply,Hypothesis,CF).

ask_confidence_aux(Char,_,_) :- Char \== ?, !.

ask_confidence_aux(_,Hypothesis,CF) :-
     explain_question,
     !, ask_confidence(Hypothesis,CF).

get0_only(List,Reply) :-
     get1(Char),   % Some Prologs can use get0 here
     name(Value,[Char]),
     member(Value,List),Reply = Value, !.

get0_only(List,Result) :-
     put(7), write(' [Invalid response.  Try again.] '),
     get0_only(List,Result).

convert_reply_to_confidence(?,_).
convert_reply_to_confidence(d,_).
convert_reply_to_confidence(n,0).
convert_reply_to_confidence(v,5).
convert_reply_to_confidence(u,25).
convert_reply_to_confidence(m,60).
convert_reply_to_confidence(p,80).
convert_reply_to_confidence(l,90).
convert_reply_to_confidence(y,100).

explain_question :-
     current_hypothesis(Hypothesis),
     writeln(
'I need this information to test the following hypothesis:'),
     writeln(Hypothesis), nl,
     writeln('Do you want further explanation?'),
     explain_question_aux,!.

explain_question :-
     writeln('This is a basic hypothesis.'),
     nl, wait.

explain_question_aux :- \+ yes('>'), nl, nl, !.

explain_question_aux :- nl, nl, fail.

explain_conclusion(Hypothesis) :-
     writeln('Do you want an explanation?'),
     yes('>'), nl, nl,
     explain_conclusion_aux(Hypothesis), wait, !.

explain_conclusion(_) :- nl, nl.

explain_conclusion_aux([]) :- !.

explain_conclusion_aux([Hypothesis,_]) :-
     !, explain_conclusion_aux(Hypothesis).

explain_conclusion_aux([and,[Hypothesis,_],Rest]) :-
     !, explain_conclusion_aux(Hypothesis),
     explain_conclusion_aux(Rest).

explain_conclusion_aux([or,[Hypothesis,_],Rest]) :-
     !, explain_conclusion_aux(Hypothesis),
     explain_conclusion_aux(Rest).

explain_conclusion_aux(Hypothesis) :-
     known(Hypothesis,CF,user),
     kb_threshold(T),CF >= T,
     !, write(Hypothesis),writeln(' -'),
     write('From what you told me, I accepted this with '),
     write(CF),writeln('% confidence.'), nl.

explain_conclusion_aux(Hypothesis) :-
     known(Hypothesis,CF,user),
     !, DisCF is 100 - CF,
     write(Hypothesis),writeln(' -'),
     write('From what you told me, I rejected this with '),
     write(DisCF),writeln('% confidence.'), nl.

explain_conclusion_aux(Hypothesis) :-
     known(Hypothesis,50,no_evidence),
     !, write(Hypothesis),writeln(' -'),
     writeln(
          'Having no evidence, I assumed this was 50-50.'),
      nl.

explain_conclusion_aux(Hypothesis) :-
     !, known(Hypothesis,CF1,[CF,Prerequisites,Conditions]),
     writeln(Hypothesis),write('Accepted with '),
     write(CF1),
     writeln('% confidence on the basis of the following'),
     write('Rule: '),writeln(Hypothesis),
     write('  with confidence of '),
     write(CF),
     writeln('% if'),
     list_prerequisites(Prerequisites),
     list_conditions(Conditions), nl,
     explain_conclusion_aux(Conditions).

list_prerequisites([]) :- !.

list_prerequisites([-,Hypothesis|Rest]) :-
     !, write('  is disconfirmed: '),
     writeln(Hypothesis),
     list_prerequisites(Rest).

list_prerequisites([Hypothesis|Rest]) :-
     write('  is confirmed: '),
     writeln(Hypothesis),
     list_prerequisites(Rest).

list_conditions([]) :- !.

list_conditions([and,Hypothesis,Rest]) :-
     list_conditions(Hypothesis),
     list_conditions(Rest).

list_conditions([or,Hypothesis,Rest]) :-
     writeln(' ['),
     list_conditions(Hypothesis),
     writeln('     or'),
     list_conditions(Rest), writeln(' ]').

list_conditions([Hypothesis,yes]) :-
     write('    to confirm: '),
     writeln(Hypothesis).

list_conditions([Hypothesis,no]) :-
     write('    to disconfirm: '),
     writeln(Hypothesis).

wait :- write('Press Return when ready to continue. '),
        get0(_), nl, nl.  % Even ALS can use get0 here



/*
 * CONMAN inference engine
 *   The CONMAN inference engine computes the confidence in
 *   compound goals and decides which of several rules best
 *   support a conclusion. It remembers this information for
 *   later use by itself, the main conman procedure, and the
 *   explanatory facilities.
 */

confidence_in([],100) :- !.

confidence_in([Hypothesis,yes],CF) :-
     known(Hypothesis,CF,_), !.

confidence_in([Hypothesis,yes],CF) :-
     ask_confidence(Hypothesis,CF), !,
     assert(known(Hypothesis,CF,user)).

confidence_in([Hypothesis,yes],CF) :-
     asserta(current_hypothesis(Hypothesis)),
     find_all(X,evidence_that(Hypothesis,X),List),
     find_all(C,member([C,_],List),CFList),
     retract(current_hypothesis(_)),
     CFList \== [],
     !, maximum(CFList,CF),
     member([CF,Explanation],List),
     assert(known(Hypothesis,CF,Explanation)).

confidence_in([Hypothesis,yes],50) :-
     assert(known(Hypothesis,50,no_evidence)), !.

confidence_in([Hypothesis,no],CF) :-
     !, confidence_in([Hypothesis,yes],CF0),
     CF is 100 - CF0.

confidence_in([and,Conjunct1,Conjunct2],CF) :-
     !, confidence_in(Conjunct1,CF1),
     confidence_in(Conjunct2,CF2),
     minimum([CF1,CF2],CF).

confidence_in([or,Disjunct1,Disjunct2],CF) :-
     !, confidence_in(Disjunct1,CF1),
     confidence_in(Disjunct2,CF2),
     maximum([CF1,CF2],CF).

evidence_that(Hypothesis,[CF,[CF1,Prerequisite,Condition]]):-
     c_rule(Hypothesis,CF1,Prerequisite,Condition),
     confirm(Prerequisite),
     confidence_in(Condition,CF2),
     CF is (CF1 * CF2)//100.

confirm([]).

confirm([-,Hypothesis|Rest]) :-
     !, known(Hypothesis,CF,_),
     kb_threshold(T),
     M is 100 - CF, M >= T,
     confirm(Rest).

confirm([Hypothesis|Rest]) :-
     known(Hypothesis,CF,_),
     kb_threshold(T),CF >= T,
     !, confirm(Rest).

minimum([M,K],M) :- M < K, ! .
minimum([_,M],M).

maximum([],0) :- !.
maximum([M],M) :- !.
maximum([M,K],M) :- M >= K, !.
maximum([M|R],N) :- maximum(R,K), maximum([K,M],N).

append([],X,X).
append([X|Y],Z,[X|W]) :- append(Y,Z,W).

member(X,[X|_]).
member(X,[_|Z]) :- member(X,Z).
