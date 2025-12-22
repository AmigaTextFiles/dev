program au_carre;   { triangle rectangle?  3 4 5    6 8 10}

var
    cote1, cote2,cote3    : integer;

begin
    writeln('Pour arreter, taper 0');
    write ('Entrer 3 entiers: ');
    readln(cote1, cote2,cote3);
    writeln ('************* ',cote1,' ', cote2,' ',cote3);
    while cote1 <> 0 do
    begin
        if sqr(cote3) = sqr(cote1)+sqr(cote2) then
                writeln(' C''est un triangle rectangle')
            else
                writeln(' Ce n''est pas un triangle rectangle');
        write(': ');
    readln(cote1, cote2,cote3);
    writeln ('************* ',cote1,' ', cote2,' ',cote3);
    end;

end.