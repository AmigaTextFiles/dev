program Newton;

{   Calcul par la methode de newton de la racine carree d'un nombre }
{
    Nombre A,   EPS erreur relative

    X0 = A
    Xn+1 = 1/2(Xn+ A/Xn)

    Arret :     | Xn+1 -Xn |
                | -------- | < EPS
                |    Xn    |
}

var
    a, x0, x1, eps, err : real;
begin

    write ('Enter epsilon:'); readln(eps);
    write ('Enter A:'); readln(a);

    x0 := a;
    err := eps+1;

    while  err > eps do
        begin
            x1 := (x0 +a/x0) / 2;
            err := abs( (x1-x0)/x0);
            x0 := x1;
        end;
    writeln(' Racine de ', a, ' a ', eps,' pres = ', x0);
    writeln;

end.

