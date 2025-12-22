/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* CARTONS.PL */

/*
 * This is a set of production rules for a robot that
 * stacks cartons in a warehouse. The rules have been
 * translated into Prolog rules that can be used with
 * the forward chaining inference engine in FCHAIN.PL.
 */

rule(1) :- goal(stack([X,Y|Rest])),
           fact(supports(X,Y)),
                then,
           rg(stack([X,Y|Rest])),
           ag(stack([Y|Rest])).

rule(2) :- goal(stack([X,Y|Rest])),
           \+ fact(supports(X,_)),
           \+ fact(supports(Y,_)),
           fact(supports(Z,Y)),
                then,
           rf(supports(Z,Y)),
           af(supports(X,Y)),
           rg(stack([X,Y|Rest])),
           ag(stack([Y|Rest])).

rule(3) :- goal(stack([X,Y|_])),
           fact(supports(X,Z)),
           \+ (Y = Z),
           \+ goal(remove(Z)),
                then,
           ag(remove(Z)).

rule(4) :- goal(stack([_,X|_])),
           fact(supports(X,Y)),
           \+ goal(remove(Y)),
                then,
           ag(remove(Y)).

rule(5) :- goal(remove(X)),
           fact(supports(X,Y)),
           \+ goal(remove(Y)),
                then,
           ag(remove(Y)).

rule(6) :- goal(remove(X)),
           \+ fact(supports(X,_)),
           fact(supports(Y,X)),
                then,
           rf(supports(Y,X)),
           af(supports(floor,X)),
           rg(remove(X)).

rule(7) :- goal(stack([X])),
                then,
           rg(stack([X])).

/*
 * Initial facts and goals for the carton stacking robot
 */

fact(supports(floor,a)).
fact(supports(floor,b)).
fact(supports(b,c)).
fact(supports(c,d)).

goal(stack([a,b,c,d])).
