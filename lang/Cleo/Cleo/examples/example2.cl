program Test;

var
    a,b       : real;
    n,i       :integer;

begin
    b := 3.141592; writeln(b);

    while b<20 do
        begin
            b  := b+1;
            writeln( b);
        end;
    writeln('OK! ca tourne...');
end.