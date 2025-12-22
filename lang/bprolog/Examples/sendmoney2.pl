go([S,E,N,D,M,O,R,Y]):-
    [S,E,N,D,M,O,R,Y] in 0..9,
    alldifferent([S,E,N,D,M,O,R,Y]),
    c(S\=0),
    c(M\=0),
    c(1000*S+100*E+10*N+D+1000*M+100*O+10*R+E=10000*M+1000*O+100*N+10*E+Y),
    labeling([S,E,N,D,M,O,R,Y]).

