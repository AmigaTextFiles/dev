program Horner;
    { Calcul du polynome de degre n en 1 point x }
    {
        Shema de Horner:
            P(X) = a0.X**n + a1.X**(n-1) + ... + an

        calcul:
            P(X) = ( ((a0.X +a1)X + a2)X +a3)X + ... ) X +an
        Or P(X) est le reste de la div euclidienne du poly P(x)
        par (x-X);
            P(x) = (x-X) Q(x) + P(X);
        Soit b0, b1, b2, ..., bn-1 les coefs du poly Q et notons
        bn le reste de P(X) on a la suite:
            b0 = a0
            b1 = b0.X + a1
                ...
            bi = bi-1.X + ai
                ...
            bn = bn-1.X + an
    }

var
    n, i : integer;
    x   : real;
    a : array[1..30] of real;       { Poly de degre < 30 }
    b : array[1..30] of real;

begin
    a[1] := 1;
    a[2] := 3;
    a[3] := 2;
   { Degre du polynome: }
    n := 2;

    write('Valeur au point X='); readln(x);

    b[1] := a[1];
    i:=2;                       { 2eme coef }
    while  i <=n+1 do           { +1 car le tab commence en 1 }
        begin
            b[i] := b[i-1]*x+a[i];
            i := i+1;
        end;
    writeln('     Valeur du polynome au point ',x,' = ',b[n+1]);
    writeln;
end.