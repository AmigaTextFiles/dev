Program Carres;

vAr
    tab1: array [0..100] of char;
    tab2: array [0..100] of integer;
    tab3: array [0..100] of real;
    n :integer;
bEgin

    n :=0;
    while n<=100 do
      begin
        tab1[n]:=n;
        tab2[n]:=sqr(n);
        tab3[n]:=sqrt(n);
        n := n+1;
      end;

    n :=0;
    repeat
        begin
            writeln(tab1[n], '        ',tab2[n], '        ',tab3[n]);
            n := n+1;
        end;
    until n>100;
    writeln;

end.