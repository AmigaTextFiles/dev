program Operateurs;

var
    n,b,c,d,e,f : integer;

begin

    n := 3 or 6;      { = 7 }
    b := 3 and 6;     { = 2 }
    c := 7 % 3;       { = 3 }
    e := 7 mod 3;     { la meme chose que % }
    d := 3 xor 6;     { = 5 }
    f := 7 div 3;     { = 2 }
    writeln('n= ', n, ' b=',b,' c=',c, ' d=',d,' e=',e,' f=',f);
end.