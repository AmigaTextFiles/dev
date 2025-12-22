%   File   : block50.pl
%   Author : Neng-Fa ZHOU
%   Date   : 1992
%   Purpose: Solving the blocks world problem using Boolean tables

go :- true :
    cputime(Start),
    Bs=(1..50),
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
    compute_above(1,50),
    InitLen is 50*4,
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

initialize:-
    true :
    bt_set_true(clear(30)),
    bt_set_true(clear(19)),
    bt_set_true(clear(42)),
    bt_set_true(clear(38)),
    bt_set_true(ontable(18)),
    bt_set_true(ontable(45)),
    bt_set_true(ontable(16)),
    bt_set_true(ontable(26)),
    bt_set_true(on(35,26)),
    bt_set_true(on(32,35)),
    bt_set_true(on(25,32)),
    bt_set_true(on(50,25)),
    bt_set_true(on(3,50)),
    bt_set_true(on(36,3)),
    bt_set_true(on(37,36)),
    bt_set_true(on(48,37)),
    bt_set_true(on(9,48)),
    bt_set_true(on(22,9)),
    bt_set_true(on(17,22)),
    bt_set_true(on(2,17)),
    bt_set_true(on(39,2)),
    bt_set_true(on(20,39)),
    bt_set_true(on(30,20)),
    bt_set_true(on(23,16)),
    bt_set_true(on(49,23)),
    bt_set_true(on(15,49)),
    bt_set_true(on(7,15)),
    bt_set_true(on(41,7)),
    bt_set_true(on(5,41)),
    bt_set_true(on(10,5)),
    bt_set_true(on(14,10)),
    bt_set_true(on(43,14)),
    bt_set_true(on(13,43)),
    bt_set_true(on(8,13)),
    bt_set_true(on(47,8)),
    bt_set_true(on(28,47)),
    bt_set_true(on(29,28)),
    bt_set_true(on(34,29)),
    bt_set_true(on(31,34)),
    bt_set_true(on(46,31)),
    bt_set_true(on(6,46)),
    bt_set_true(on(4,6)),
    bt_set_true(on(27,4)),
    bt_set_true(on(12,27)),
    bt_set_true(on(19,12)),
    bt_set_true(on(44,45)),
    bt_set_true(on(40,44)),
    bt_set_true(on(33,40)),
    bt_set_true(on(42,33)),
    bt_set_true(on(1,18)),
    bt_set_true(on(11,1)),
    bt_set_true(on(21,11)),
    bt_set_true(on(24,21)),
    bt_set_true(on(38,24)),
    bt_set_true(stable(45)).

% goal state
goal(G):-
    true :
    G:=(ontable(48),ontable(2),ontable(45),on(21,48),on(8,21),on(37,8),on(30,37),on(27,30),on(4,27),on(9,4),on(44,9),on(19,44),on(26,19),on(43,26),on(28,43),on(11,28),on(42,11),on(39,42),on(12,39),on(5,12),on(49,5),on(36,49),on(23,36),on(1,23),on(16,1),on(7,16),on(40,7),on(3,2),on(13,3),on(10,13),on(6,10),on(33,6),on(50,33),on(41,50),on(35,41),on(24,35),on(15,24),on(34,15),on(17,34),on(20,17),on(14,20),on(46,14),on(32,46),on(47,32),on(22,47),on(18,22),on(38,18),on(31,38),on(25,31),on(29,45)). 
