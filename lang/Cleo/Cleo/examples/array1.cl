program tableau1;

var
    tab: array [0..50] of integer;
    a :integer;
begin

    tab[1] := 10; tab[2] := 11;
    tab[3] := 12;
    a := tab[1];

    writeln('tab : ',a, ' ',tab[2],' ', tab[3] );
end.