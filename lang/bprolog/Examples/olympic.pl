go:-
    cputime(S),
    vars_cs(Vars),
    labeling_fc(Vars),
    write(Vars),
    cputime(E),
    T is E-S,
    write(T), write(' milliseconds').

vars_cs(Vars):-
    Vars:=[X1,X2,X3,X4,X5,X6,X7,X8,X9,X10],
    in(Vars,1..10),
    alldifferent(Vars),
    c(X1=3),
    minus(X2,X3,X1),
    minus(X4,X5,X2),
    minus(X5,X6,X3),
    minus(X7,X8,X4),
    minus(X8,X9,X5),
    minus(X9,X10,X6).

minus(X,Y,Z):-
    c(X-Y=Z).
minus(X,Y,Z):-
    c(Y-X=Z).



