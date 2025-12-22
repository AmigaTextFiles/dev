edges(X):-X>67 : true.
edges(X):-findall((Y,W),edge(X,Y,W),Ys),
    write(neighbors(X,Ys)),write('.'),nl,
    X1 is X+1,
    edges(X1).

