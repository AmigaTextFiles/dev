go:-
    cputime(Start),
    vars_constraints(Vars),
    labeling(Vars),
    write(Vars),
    cputime(End),
    T is End-Start,
    write('execution time is :'),write(T).


vars_constraints(Vars):-
    Vars:=[X1,X2,X3,X4,X5,X6,X7,X8,X9],
    Vars in 1..9,
    alldifferent(Vars),
    c(X1+X2+X3=15),
    c(X4+X5+X6=15),
    c(X7+X8+X9=15),
    c(X1+X4+X7=15),
    c(X2+X5+X8=15),
    c(X3+X6+X9=15),
    c(X1+X5+X9=15),
    c(X3+X5+X7=15).


    
