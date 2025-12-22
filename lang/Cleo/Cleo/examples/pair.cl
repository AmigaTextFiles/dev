program Pair;

var
    a,b      : real;
    d           : integer;

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
end.