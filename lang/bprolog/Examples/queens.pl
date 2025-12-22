%   File   : queens.pl
%   Author : Neng-Fa ZHOU
%   Date   : 1992
%   Purpose: Forward chekcing algorithm for N-queens

:-determinate([bt/2,set_false/1,select_all/2]).

go:-queens(96).

queens(N) :- 
    cputime(Start),
    range(1,N,Qs),
    functor(Solution,solution,N),
    bt(domain(Qs,Qs),true),
    solve(Qs,Solution),
    cputime(End),
    T is End-Start,
    write(Solution),nl,
    write('execution time is :'),write(T).

range(N0,N,L):-
    N0=:=N :
    L:=[N].
range(N0,N,L):-
    true :
    L:=[N0|L1],
    N1 is N0+1,
    range(N1,N,L1).

solve([],Solution):-
    true : true.
solve(Qs,Solution):-
    true :
    queen_choose(Qs,X,Rest),
    bt_select(domain(X,Y)),
    arg(X,Solution,Y),
    queen_exclude(Rest,X,Y),
    solve(Rest,Solution).


queen_choose([Q|Qs],Q1,Rest):-
    true :
    bt_count(domain(Q,_),Count),
    queen_choose(Qs,Count,Q,Q1,Rest).

queen_choose([],Count,Q,Q1,Rest):-
    true :
    Q=Q1,
    Rest=[].
queen_choose([Q|Qs],Count1,Q1,Q2,Rest):-
    bt_count(domain(Q,_),Count),
    Count<Count1 :
    Rest:=[Q1|Rest1],
    queen_choose(Qs,Count,Q,Q2,Rest1).
queen_choose([Q|Qs],Count1,Q1,Q2,Rest):-
    true :
    Rest:=[Q|Rest1],
    queen_choose(Qs,Count1,Q1,Q2,Rest1).

queen_exclude([],_,_):-true : true.
queen_exclude([X|Qs],X1,Y1):-
    true :
    N1 is X1+Y1-X,
    N2 is -X1+Y1+X,
    bt_set_false(domain(X,Y1)),
    bt_set_false(domain(X,N1)),
    bt_set_false(domain(X,N2)),
    bt_count(domain(X,_),Count),
    Count>0,
    queen_exclude(Qs,X1,Y1).




