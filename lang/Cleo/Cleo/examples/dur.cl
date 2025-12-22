program Essai;     { verifié par Boss }

var
    b,e       :   boolean;
    n: integer;
    i,r       : real;

begin
    e := 1;
    i:=1;

    repeat
        writeln( 'i=',i);
        i := i+0.9998e-3-sin(2*i);
    until i>12 ;

    while i<12 do
        begin
            e :=  b*5-sin(9*cos(n));
            writeln;
        end;
    if b=13.2 then
       begin
            writeln;
            n:=n+1;
            b:=2*3-sin(r);
       end;
end.