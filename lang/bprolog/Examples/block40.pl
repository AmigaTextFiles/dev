%   File   : block40.pl
%   Author : Neng-Fa ZHOU
%   Date   : 1992
%   Purpose: Solving the blocks world problem using Boolean tables

go :- true :
    cputime(Start),
    Bs=(1..40),
    bt(holding(Bs),false),
    bt(clear(Bs),false),
    bt(ontable(Bs),false),
    bt(on(Bs,Bs),false),
    bt(handempty([robot]),true),
    bt(on_goal(Bs,Bs),false),
    bt(ontable_goal(Bs),false),
    bt(above_goal(Bs,Bs),false),
    bt(stable(Bs),false),
    initialize,
    goal(G),
    goal_state(G),
    compute_above(1,40),
    InitLen is 40*4,
    assert(plan_len(InitLen)),
    plan(G),
    cputime(End),
    T is End-Start,
    nl,write(T),write(' milliseconds'),nl.
    
plan(G):-
    true ?
    solve(0,G,[]).
plan(G):-
    true : true.

goal_state((G,Gs)):-
    true :
    goal_state1(G),
    goal_state(Gs).
goal_state(G):-
    true :
    goal_state1(G).

goal_state1(ontable(X)):-
    true :
    bt_set_true(ontable_goal(X)).
goal_state1(on(X,Y)):-
    true :
    bt_set_true(on_goal(X,Y)).

compute_above(N0,N):-
    N0>N : true.
compute_above(N0,N):-
    true :
    compute_above1(N0),
    N1 is N0+1,
    compute_above(N1,N).

compute_above1(X):-
    true ?
    bt_select(on_goal(X,Y)),!,
    bt_set_true(above_goal(X,Y)),
    compute_above2(X,Y).
compute_above1(X):-true : true.

compute_above2(X,Y):-
    true ?
    bt_select(on_goal(Y,Z)),!,
    bt_set_true(above_goal(X,Z)),
    compute_above2(X,Z).
compute_above2(X,Y):-true : true.
    

% bottom-up search
solve(N0,G,P0):-true ?
    all_hold(G),
    write(P0),nl,
    write('length='),write(N0),nl,
    retract(plan_len(_)),
    assert(plan_len(N0)),
    fail.
solve(N0,G,P0):-
    true :
    plan_len(N),
    N0<N,
    choose(P0,R),
    N1 is N0+1,
    solve(N1,G,[R|P0]).

/* choose an operator */
choose([],R):-
    true ?
    R=pickup(_),
    try(R),!.
choose([],R):-
    true :
    R=unstack(_,_),
    try(R).
choose([pickup(X)|P0],R):-
    true :
    R=stack(X,_),
    try(R).
choose([putdown(X)|P0],R):-
    true ?
    R=pickup(_),
    try(R),!.
choose([putdown(X)|P0],R):-
    true :
    R=unstack(_,_),
    try(R).
choose([stack(X,Y)|P0],R):-
    true ?
    R=pickup(_),
    try(R),!.
choose([stack(X,Y)|P0],R):-
    true :
    R=unstack(_,_),
    try(R).
choose([unstack(X,Y)|P0],R):-
    true ?
    R=stack(X,_),
    try(R),!.
choose([unstack(X,Y)|P0],R):-
    true :
    R=putdown(X),
    try(R).

all_hold((G,Gs)):-
    true :
    all_hold(G),
    all_hold(Gs).
all_hold(on(X,Y)):-
    true :
    bt_true(on(X,Y)).
all_hold(ontable(X)):-
    true :
    bt_true(ontable(X)).

try(pickup(X)):-
    true :
    bt_select(clear(X)),
    bt_true(ontable(X)),
    bt_false(stable(X)),
    bt_select(clear(Y)),
    bt_true(stable(Y)),
    bt_true(on_goal(X,Y)),
    bt_set_false(ontable(X)).
try(putdown(X)):-
    true ?
    bt_true(ontable_goal(X)),
    bt_set_true(ontable(X)),
    bt_set_true(stable(X)).
try(putdown(X)):-
    true :
    bt_set_true(ontable(X)).
try(stack(X,Y)):-
    true :
    bt_select(clear(Y)),
    bt_true(stable(Y)),
    bt_true(on_goal(X,Y)),
    bt_set_true(on(X,Y)),
    bt_set_true(stable(X)),
    bt_set_false(clear(Y)).
try(unstack(X,Y)):-    % ontable(X) holds in G
    true :
    try_unstack(X,Y).

try_unstack(X,Y):-
    true ?
    bt_select(clear(X)),
    bt_select(on(X,Y)),
    bt_false(stable(X)),
    bt_true(ontable_goal(X)),!,
    bt_set_true(clear(Y)),
    bt_set_false(on(X,Y)).
try_unstack(X,Y):-    % stack(X,Z) is applicable for some Z
    true ?
    bt_select(clear(X)),
    bt_select(on(X,Y)),
    bt_false(stable(X)),
    bt_select(clear(Z)),
    bt_true(stable(Z)),
    bt_true(on_goal(X,Z)),!,
    bt_set_true(clear(Y)),
    bt_set_false(on(X,Y)).
try_unstack(X,Y):-    % X is above Z in I and X is also above Z in G
    true ?
    bt_select(clear(X)),
    bt_select(on(X,Y)),
    bt_false(stable(X)),
    above_current(X,Z),
    bt_true(above_goal(X,Z)),!,
    bt_set_true(clear(Y)),
    bt_set_false(on(X,Y)).
/*try(unstack(X,Y)):-    % for any applicable unstack(U,V), above(U,X).
    true ?
    bt_select(clear(X)),
    bt_select(on(X,Y)),
    bt_false(stable(X)),
    lowest_block(X),!,
    write('the new heuristics is used'),nl,
    bt_set_true(clear(Y)),
    bt_set_false(on(X,Y)).
*/
try_unstack(X,Y):-    % nondeterminate choice
    true :
    bt_select(clear(X)),
    bt_select(on(X,Y)),
    bt_false(stable(X)),
    bt_set_true(clear(Y)),
    bt_set_false(on(X,Y)).

above_current(X,Z):-
    true :
    bt_select(on(X,Y)),
    above_current1(Y,Z).

above_current1(Y,Z):-
    true ?
    Z:=Y.
above_current1(Y,Z):-
    true :
    above_current(Y,Z).

lowest_block(X):-
    true ?
    bt_select(clear(U)),
    X\==U,
    bt_select(on(U,V)),
    bt_false(stable(U)),
    bt_false(above_goal(U,X)),!,fail.
lowest_block(X):-
    true : true.

initialize :-
    true :
    bt_set_true(clear(27)),
    bt_set_true(clear(25)),
    bt_set_true(clear(24)),
    bt_set_true(clear(17)),
    bt_set_true(clear(18)),
    bt_set_true(ontable(16)),
    bt_set_true(ontable(9)),
    bt_set_true(ontable(14)),
    bt_set_true(ontable(17)),
    bt_set_true(ontable(37)),
    bt_set_true(on(27,29)),
    bt_set_true(on(29,8)),
    bt_set_true(on(8,7)),
    bt_set_true(on(7,26)),
    bt_set_true(on(26,33)),
    bt_set_true(on(33,20)),
    bt_set_true(on(20,35)),
    bt_set_true(on(35,22)),
    bt_set_true(on(22,5)),
    bt_set_true(on(5,16)),
    bt_set_true(on(25,6)),
    bt_set_true(on(6,21)),
    bt_set_true(on(21,23)),
    bt_set_true(on(23,39)),
    bt_set_true(on(39,36)),
    bt_set_true(on(36,3)),
    bt_set_true(on(3,30)),
    bt_set_true(on(30,13)),
    bt_set_true(on(13,40)),
    bt_set_true(on(40,2)),
    bt_set_true(on(2,9)),
    bt_set_true(on(24,28)),
    bt_set_true(on(28,38)),
    bt_set_true(on(38,15)),
    bt_set_true(on(15,12)),
    bt_set_true(on(12,14)),
    bt_set_true(on(18,31)),
    bt_set_true(on(31,34)),
    bt_set_true(on(34,1)),
    bt_set_true(on(1,32)),
    bt_set_true(on(32,19)),
    bt_set_true(on(19,10)),
    bt_set_true(on(10,11)),
    bt_set_true(on(11,4)),
    bt_set_true(on(4,37)),
    bt_set_true(stable(17)).

goal(G):-
    true :
    G:=(ontable(12),ontable(11),ontable(17),ontable(28),on(1,28),on(18,1),on(7,18),on(40,7),on(37,40),on(14,37),on(19,14),on(4,19),on(9,4),on(26,9),on(23,26),on(8,23),on(21,8),on(22,21),on(25,12),on(39,25),on(16,39),on(6,16),on(3,6),on(33,3),on(10,33),on(31,10),on(29,31),on(38,29),on(27,38),on(20,27),on(2,20),on(13,2),on(36,13),on(5,36),on(30,5),on(24,30),on(15,11),on(35,15),on(34,35),on(32,34)).

