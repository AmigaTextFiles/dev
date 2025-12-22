program factorielle;

var
    n, i, fact : integer;

begin

    write('Entrer le nombre:'); readln(n);

    i:=2;  fact:=1;
    while  i <=n do
        begin
            fact := fact * i;
            i := i+1;
        end;
    writeln('           ',n,'! =',fact);
    writeln;
end.