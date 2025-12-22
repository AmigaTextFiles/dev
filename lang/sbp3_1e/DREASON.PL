/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* DREASON.PL */
/* Defeasible Reasoner */

/*****************************************************
 * This file will define the special operators and   *
 * predicates used by a defeasible inference engine. *
 * This file must be loaded before any other files   *
 * containing defeasible rules, presumptions, or     *
 * defeaters are loaded. Otherwise, Prolog will be   *
 * unable to read these special representations.     *
 *****************************************************/

:- unknown(_,fail).

init :- op(1100,fx,@),
        op(900,fx,neg),
        op(1100,xfx,:=),
        op(1100,xfx,:^),
	op(700,xfx,\=).

:- init.

/*
 * To invoke the defeasible inference engine, put the
 * operator @ in front of your goal. For example, the
 * defeasible inference engine will be used to try to
 * satisfy the goal ?- @ flies(X).
 */

@(Condition) :- Condition =.. [',',First,Rest],
                !,
                @(First),
                @(Rest).

@(X\=Y) :- X=Y, !, fail.
@(_\=_) :- !.

@(Goal) :- Goal =.. [P|_],
	   system(P),
	   !,
	   Goal.

@(Goal) :- Goal.

@(Goal) :- strict_rule(Goal,Condition),
           @(Condition),
           opposite(Goal,Contrary),
           \+ Contrary.

@(Goal) :- (Goal:=Condition),
           @(Condition),
           opposite(Goal,Contrary),
           \+ Contrary,
           \+ defeat((Goal:=Condition)).

system('=').
system('<').
system('>').
system('-').
system('+').
system('/').
system('*').

strict_rule(true,_) :- !, fail.
strict_rule(Goal,Condition) :- clause(Goal,Condition).

opposite(neg Clause,Clause) :- !.
opposite(Clause,neg Clause).

/*
 * defeat(DefeasibleRule)
 *   succeeds if the opposite of the head of DefeasibleRule
 *   succeeds, or if there is a competing absolute rule,
 *   defeasible rule, or defeater whose body is defeasibly
 *   derivable. For competing defeasible rules or defeaters,
 *   the body of the competing rule must not be properly
 *   included in the information required to satisfy the body
 *   of DefeasibleRule.
 */

defeat((Head:=_)) :-
     opposite(Head,ContraryOfHead),
     strict_rule(ContraryOfHead,Condition),
     @(Condition).

defeat((Head:=Body)) :-
     opposite(Head,ContraryOfHead),
     (ContraryOfHead:=Condition),
     not_more_informative(Body,Condition),
     @(Condition).

defeat((Head:=Body)) :-
     opposite(Head,ContraryOfHead),
     (ContraryOfHead:^Condition),
     not_more_informative(Body,Condition),
     @(Condition).

not_more_informative(Clauses1,Clauses2) :-
     \+ absolute_consequence(Clauses2,Clauses1).

not_more_informative(Clauses1,Clauses2) :-
     absolute_consequence(Clauses1,Clauses2).

/*
 * absolute_consequence(Goals,Premises)
 *   succeeds if every member of Goals can be derived
 *   from a knowledge base containing only the facts in
 *   Premises plus the absolute rules in the actual
 *   knowledge base.
 */

absolute_consequence(Goals,Premises) :-
     Goals =.. [',',First,Rest],
     !,
     absolute_consequence(First,Premises),
     absolute_consequence(Rest,Premises).

absolute_consequence(true,_).

absolute_consequence(Goal,Premises) :-
     belongs(Goal,Premises).

absolute_consequence(Goal,Premises) :-
     strict_rule(Goal,Body),
     \+ (Body = true),  /* there is no \= in Quintus Prolog */
     absolute_consequence(Body,Premises).

belongs(Clause,Clause).

belongs(Clause,Conjunction) :-
    Conjunction =.. [',',Clause,_].

belongs(_,Conjunction) :-
     Conjunction =.. [',',_,RestOfConjunction],
     belongs(_,RestOfConjunction).
