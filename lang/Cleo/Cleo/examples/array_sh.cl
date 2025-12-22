program Essai_Procedure;

var
    n           : integer;
    tab1: array ['A'..'Z'] of char;
begin

    writeln('                 Exemple de PROCEDURE');
    n :='A';
    while n<='A'+10 do
      begin
        tab1[n]:=n;
        n := n+1;
      end;

    n :='A';
    repeat
        begin
            writeln(tab1[n]);
            n := n+1;
        end;
    until n>10+'A';
    writeln;
end.