go:-queens(96).

queens(N):-
    cputime(Start),
    make_list(N,List),
    List in 1..N,
    constrain_queens(List),
    labeling_fcf(List),
    write(List),
    cputime(End),
    T is End-Start,
    write('execution time is :'),write(T).

constrain_queens([]).
constrain_queens([X|Y]):-
    safe(X,Y,1),
    constrain_queens(Y).

safe(_,[],_).
safe(X,[Y|T],K):-
    noattack(X,Y,K),
    K1 is K+1,
    safe(X,T,K1).

noattack(X,Y,K):-
    c(X \= Y),
    c(X+K \= Y),
    c(X-K \= Y).

make_list(0,[]):-!.
make_list(N,[_|Rest]):-
    N1 is N-1,
    make_list(N1,Rest).

