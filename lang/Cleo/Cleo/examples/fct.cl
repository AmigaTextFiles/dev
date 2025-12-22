program Essai;

PROCEDURE Pair(debut : INTEGER; float1, float2: REAL)

var
    a,b      : real;

begin
    b := 1;

    while b<10 do
        begin
            write(b);

            if b/2=trunc(b/2) then
                begin
                    write(' ----->');
                    writeln(' Nbre pair');
                end
            else
                writeln(' Nbre impair');
            b:=b+1;
        end;
    write('OK!');
end;

var
    n : integer;

begin

    writeln('                 Exemple de PROCEDURE');
    n :=0;
    writeln;
end.