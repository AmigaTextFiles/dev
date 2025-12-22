go:-
    true :
    cputime(S),
    vars_constraints(Vars),
    labeling(Vars),
    write(Vars),
    cputime(E),
    T is E-S,
    write('execution time is '),write(T), write(milliseconds),nl.

vars_constraints(Vars):-
    true :
    Vars:=[N1,N2,N3,N4,N5,
	   C1,C2,C3,C4,C5,
	   P1,P2,P3,P4,P5,
	   A1,A2,A3,A4,A5,
	   D1,D2,D3,D4,D5],
    in(Vars,1..5),
    alldifferent([C1,C2,C3,C4,C5]),
    alldifferent([P1,P2,P3,P4,P5]),
    alldifferent([N1,N2,N3,N4,N5]),
    alldifferent([A1,A2,A3,A4,A5]),
    alldifferent([D1,D2,D3,D4,D5]),
    c(N1=C2),
    c(N2=A1),
    c(N3=P1),
    c(N4=D3),
    c(N5=1),
    c(D5=3),
    c(P3=D1),
    c(C1=D4),
    c(P5=A4),
    c(P2=C3),
    plusc(C1,C5,1),
    plusorminus(A3,P4,1),
    plusorminus(A5,P2,1),
    plusorminus(N5,C4,1).

plusc(X,Y,C):-
    true :
    c(X=Y+C).

plusorminus(X,Y,C):-
    true ?
    c(X=Y-C).
plusorminus(X,Y,C):-
    true :
    c(X=Y+C).
