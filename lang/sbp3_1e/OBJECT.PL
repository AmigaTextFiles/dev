/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* OBJECT.PL */
/* Sample of object-oriented programming */
/* Adapted from Stabler (1986) */

/* Variable names beginning with underscores,
   such as _c, are those that are not used further
   in the computation. Their names look like
   anonymous variables but have more mnemonic value. */

/* load the math library */
:- ensure_loaded(library(math)).

object(spaceship(X_Velocity,Y_Velocity,Mass),
           [
            (kinetic_energy(E) :- E is 0.5 * Mass *
                 (X_Velocity*X_Velocity + Y_Velocity*Y_Velocity)),
            (speed(S) :- sqrt(X_Velocity*X_Velocity + Y_Velocity*Y_Velocity),S),
            description('a space ship')
           ]).

object(enterprise(_,_,_),
    [description('a federation star ship')]).

object(klingon(_,_,_),
    [description('an enemy star ship')]).

isa(klingon(X_Velocity,Y_Velocity,Mass),
                        spaceship(X_Velocity,Y_Velocity,Mass)).
isa(enterprise(X_Velocity,Y_Velocity,Mass),
                        spaceship(X_Velocity,Y_Velocity,Mass)).

send(Object, Message) :-
    isa_hierarchy(Object, Object1),
    object(Object1,MethodList),
    get_method(Message,MethodList,Method),
    call(Method).

get_method(Message,[FirstMethod|_],Method) :-
    fact_or_rule(Message,FirstMethod,Method),
    !.
get_method(Message,[_|Rest],Method) :-
    get_method(Message,Rest,Method).

fact_or_rule(Message,Message,true).
fact_or_rule(Message,(Message:-Body),Body).

isa_hierarchy(Object,Object).
isa_hierarchy(Object,Object1) :-
    isa(Object,Object2),
    isa_hierarchy(Object2,Object1).

/* Starting query */


:-  nl,
    nl,
    write('Sending energy message to Enterprise...'),
    send(enterprise(20,30,40),kinetic_energy(E)),
    nl,
    write('Energy is '),
    write(E),
    nl,
    write('Sending description message to Klingon...'),
    send(klingon(_xv,_yv,_m),description(D)),
    nl,
    write('Klingon is '),
    write(D),
    nl,
    nl.
