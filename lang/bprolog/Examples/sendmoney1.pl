
go:-
    cputime(Start),
    vars_constraints(Vars),
    labeling(Vars),
    write(Vars),
    cputime(End),
    T is End-Start,
    write('execution time is '),write(T), write(milliseconds).

vars_constraints(Vars):-
    Vars=[R1,R2,R3,R4,S,E,N,D,M,O,R,Y],
    Vars in 0..9,
    alldifferent([S,E,N,D,M,O,R,Y]),
    c(S\=0),
    c(M\=0),
    c(R1=M),
    c(R2+S+M=O+10*R1),
    c(R3+E+O=N+10*R2),
    c(R4+N+R=E+10*R3),
    c(D+E=Y+10*R4).
