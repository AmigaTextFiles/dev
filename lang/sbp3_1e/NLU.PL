/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* NLU.PL */

/***********************************************
 * Demonstration natural language understander *
 * Michael A. Covington         Copyright 1987 *
 * Advanced Computational Methods Center       *
 * University of Georgia                       *
 * Athens, Georgia 30602                       *
 ***********************************************/


/*****************
 * Preliminaries *
 *****************/

:- write('Loading program. Please wait...'),nl,nl.

:- ( clause(tokenize(_,_),_) ; consult('tokenize.pl') ).
:- ( clause(readstring(_),_) ; consult('readstr.pl') ).

/* Queries will use built-in predicate phrase/2 */

:- dynamic dummy_count/1.

/* Define the ampersand (&) as a compound goal constructor
   with narrower scope (lower precedence) than the comma. */

:- op(950,xfy,&).      /* syntax of & */

GoalA & GoalB  :-
    call(GoalA),
    call(GoalB).       /* semantics of & */


/**********
 * Parser *
 **********/

/*
 *   The following code parses each sentence and converts it into
 *   a structure of the form
 *        SentenceType(EntityList,Predicate).
 *   For convenience, each rule is preceded by a comment
 *   summarizing the syntactic structure that it accounts for.
 */


/*
 *   sentence --> noun_phrase, verb_phrase.
 */

sentence(statement([Subj|Tail],Pred)) -->
     noun_phrase(Subj),
     verb_phrase(verb_phrase([Subj|Tail],Pred)).


/*
 *   sentence --> noun_phrase, copula, noun_phrase.
 *   sentence --> noun_phrase, copula, adj_phrase.
 */

sentence(statement([NewSubj],Pred)) -->
     noun_phrase(Subj),
     copula(_),
     (noun_phrase(Comp) ; adj_phrase(Comp)),
     { change_a_to_null(Subj,NewSubj) },
     { NewSubj = entity(S,_,_) },
     { Comp = entity(S,_,Pred) }.


/*
 *   sentence --> aux_verb, noun_phrase, verb_phrase.
 */

sentence(question([Subj|Tail],Pred)) -->
     aux_verb(_),
     noun_phrase(Subj),
     verb_phrase(verb_phrase([Subj|Tail],Pred)).


/*
 *   sentence --> copula, noun_phrase, noun_phrase.
 *   sentence --> copula, noun_phrase, adj_phrase.
 */

sentence(question([NewSubj],Pred)) -->
     copula(_),
     noun_phrase(Subj),
     (noun_phrase(Comp) ; adj_phrase(Comp)),
     { change_a_to_null(Subj,NewSubj) },
     { NewSubj = entity(S,_,_) },
     { Comp = entity(S,_,Pred) }.


/*
 * change_a_to_null(Entity,NewEntity)
 *
 *   Special rule to change determiner 'a' to 'null'.
 *   Invoked when parsing sentences with copulas so that
 *   "A dog is an animal" will mean "Dogs are animals."
 */

change_a_to_null(entity(V,a,C),entity(V,null,C)) :- !.

change_a_to_null(X,X). /* if it didn't match the above */


/*
 *   verb_phrase --> verb, noun_phrase.
 */

verb_phrase(verb_phrase([Subj,Obj],Pred)) -->
     verb(V),
     noun_phrase(Obj),
     { Subj = entity(Su,_,_) },
     { Obj  = entity(Ob,_,_) },
     { Pred =.. [V,Su,Ob] }.


/*
 *   adj_phrase --> adjective.
 */

adj_phrase(entity(X,_,Cond)) -->
     adjective(A),
     { Cond =.. [A,X] }.


/*
 *   noun_phrase --> determiner, noun_group.
 */

noun_phrase(entity(X,D,Conds)) -->
     determiner(D),
     noun_group(entity(X,_,Conds)).


/*
 *   noun_group --> adjective, noun_group.
 */

noun_group(entity(X,_,(Cond & Rest))) -->
     adjective(A),
     { Cond =.. [A,X] },
     noun_group(entity(X,_,Rest)).


/*
 *   noun_group --> common_noun.
 */

noun_group(entity(X,_,Cond)) -->
     common_noun(N),
     { Cond =.. [N,X] }.


/*
 *   noun_group --> proper_noun.
 */

noun_group(entity(N,_,true)) -->
     proper_noun(N).


/**************
 * Vocabulary *
 **************/

copula(be)          --> [is];[are].
aux_verb(do)        --> [do];[does].
determiner(a)       --> [a];[an].
determiner(null)    --> [].

verb(chase)         --> [chase];[chases].
verb(see)           --> [see];[sees].
verb(like)          --> [like];[likes].

adjective(green)    --> [green].
adjective(brown)    --> [brown].
adjective(big)      --> [big].
adjective(little)   --> [little].

common_noun(dog)    --> [dog];[dogs].
common_noun(cat)    --> [cat];[cats].
common_noun(frog)   --> [frog];[frogs].
common_noun(boy)    --> [boy];[boys].
common_noun(girl)   --> [girl];[girls].
common_noun(person) --> [person];[people].
common_noun(child)  --> [child];[children].
common_noun(animal) --> [animal];[animals].

proper_noun(cathy)  --> [cathy].
proper_noun(fido)   --> [fido].
proper_noun(felix)  --> [felix].
proper_noun(kermit) --> [kermit].


/*********************************
 * Procedure to drive the parser *
 *********************************/

/*
 * parse(List,Structure)
 *   parses List as a sentence, creating Structure.
 */

parse(List,Structure) :-
     phrase(sentence(Structure),List),
     !.
     /* Commit to this structure, even if there  */
     /* are untried alternatives, because we are */
     /* going to modify the knowledge base.      */

parse(_,'PARSE FAILED').
     /* if the above rule failed */


/*********************************
 * Translation into Prolog rules *
 *********************************/

/*
 * make_rule(EntityList,Pred,Rule)
 *   rearranges EntityList and Pred to make a Prolog-like rule,
 *   which may be ill-formed (with a compound left side).
 */

make_rule(EntityList,Pred,(Pred :- Conds)) :-
   combine_conditions(EntityList,Conds).


/*
 * combine_conditions(EntityList,Result)
 *   combines the conditions of all the entities
 *   in EntityList to make a single compound goal.
 */

combine_conditions([entity(_,_,Cond),Rest1|Rest], Cond & RestConds) :-
   combine_conditions([Rest1|Rest],RestConds).

combine_conditions([entity(_,_,Cond)],Cond).


/****************************
 * Processing of statements *
 ****************************/

/*
 * dummy_item(X)
 *   Creates a unique dummy individual (a structure of
 *   the form dummy(N) where N is a unique number).
 */

dummy_item(dummy(N)) :-
     retract(dummy_count(N)),
     NewN is N+1,
     asserta(dummy_count(NewN)).

dummy_count(0).


/*
 * substitute_dummies(Det,Elist,NewElist)
 *   Substitutes dummies for all the entities in Elist
 *   whose determiners match Det and whose identifying
 *   variables are not already instantiated.
 *   If Det is uninstantiated, it is taken as matching
 *   all determiners, not just the first one found.
 */

substitute_dummies(Det,[Head|Tail],[NewHead|NewTail]) :-
  !,
  substitute_one(Det,Head,NewHead),
  substitute_dummies(Det,Tail,NewTail).

substitute_dummies(_,[],[]).

substitute_one(Det,entity(V,D,Conds),entity(V,D,true)) :-
  var(V),
  (var(Det) ; Det == D),
  !,
  dummy_item(V),
  assert_rule((Conds :- true)).

substitute_one(_,E,E).
  /* for those that didn't match the above */


/*
 * assert_rule(Rule)
 *   Adds Rule to the knowledge base.
 *   If the left side is compound, multiple rules
 *   with simple left sides are created.
 */

assert_rule(((C1 & C2) :- Premises)) :-
     !,
     Rule = (C1 :- Premises),
     message('Adding to knowledge base:'),
     message(Rule),
     assert(Rule),
     assert_rule((C2 :- Premises)).

assert_rule(Rule) :-
     /* Did not match the above */
     message('Adding to knowledge base:'),
     message(Rule),
     assert(Rule).


/***************************
 * Processing of questions *
 ***************************/

/*
 * move_conditions_into_predicate(Det,E,P,NewE,NewP)
 *   E and P are original entity-list and predicate, respectively.
 *   The procedure searches E for entities whose determiner
 *   matches Det, and transfers their conditions into P.
 *   Results are NewE and NewP.
 */

move_conditions_into_predicate(Det,[E1|E2],P,[E1|NewE2],NewP) :-
     \+ (E1 = entity(_,Det,_)),
     !,
     /* No change needed in this one */
     move_conditions_into_predicate(Det,E2,P,NewE2,NewP).

move_conditions_into_predicate(Det,[E1|E2],P,
                                  [NewE1|NewE2],Conds & NewP) :-
     E1 = entity(V,Det,Conds),
     !,
     NewE1 = entity(V,Det,true),
     move_conditions_into_predicate(Det,E2,P,NewE2,NewP).

move_conditions_into_predicate(_,[],P,[],P).


/*
 * query_rule(Rule)
 *   Tests whether Rule expresses a valid generalization.
 *   This procedure always succeeds.
 */

query_rule((Conclusion :- Premises)) :-
     message('Testing generalization:'),
     message(for_all(Premises,Conclusion)),
     for_all(Premises,Conclusion),
     !,
     write('Yes.'),nl.

query_rule(_) :-
     /* Above clause did not succeed */
     write('No.'),nl.


/*
 * for_all(GoalA,GoalB)
 *   Succeeds if:
 *   (1) All instantiations that satisfy GoalA also satisfy GoalB,
 *   (2) There is at least one such instantiation.
 */

for_all(GoalA,GoalB) :-
     \+ (call(GoalA), \+ call(GoalB)),
     call(GoalA),
     !.


/******************
 * User interface *
 ******************/

/*
 * message(Msg)
 *   Prints Msg only if message_flag(true).
 */

message(X) :-
     message_flag(true),
     !,
     write(X),nl.

message(_).

message_flag(true).
    /* Change to false to suppress messages */


/*
 * process(Structure)
 *   Interprets and acts upon a sentence.
 *   Structure is the output of the parser.
 */

process('PARSE FAILED') :-
             write('I do not understand.'),
             nl.

process(statement(E,P)) :-
             substitute_dummies(a,E,NewE),
             make_rule(NewE,P,Rule),
             assert_rule(Rule),
             substitute_dummies(_,NewE,_).

process(question(E,P)) :-
             move_conditions_into_predicate(a,E,P,NewE,NewP),
             make_rule(NewE,NewP,Rule),
             query_rule(Rule).


/*
 * go
 *   Top-level loop to interact with user.
 */

go :-  message(' '),
       message('Enter a sentence:'),
       readstring(String),nl,
       tokenize(String,Words),
       message('Parsing:'),
       parse(Words,Structure),
       message(Structure),
       process(Structure),
       go.


/* Starting query */

start :-
    write('NATURAL LANGUAGE UNDERSTANDER'),nl,
    write('Copyright 1987 Michael A. Covington'),nl,
    nl,
    write('Type sentences. Terminate by pressing Ctrl-C.'),nl,
    go.

:-start. 
