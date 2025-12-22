program RepeatUntil;

var
    b      : real;

begin
    b := 1;

    repeat
        begin
            writeln(b);
            b := b+frac(b/2)*3;
        end;
    until b>10;

    writeln('OK!');
end.