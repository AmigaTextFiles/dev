program exemple_sqrt;   { determinant }

var
    a,b,c,d : real;
    root1, root2    : real;

begin
    writeln('Pour arreter, taper 0');
    write ('Entrer les 3 coefs: ');
    readln(a,b,c);
    while a<>0 do
        begin
             d:= sqr(b)-4*a*c;
             if d>0 then
                begin
                    root1 := ((((-b)+sqrt(d))))/2*a;   { prb: SI (2*a) }
                    root2 := ((-b)-sqrt(d))/2*a;
                    writeln('Les Racines de ',a,'x^2+',b,'x+',c,' sont :',root1,' ',root2);
                end
             else
             if d=0 then
                writeln(' Racine unique:', -b/2*a)
             else
                writeln('Pas de solution simple');
             write('Prochains coefs:');
             readln(a,b,c);
        end;
end.