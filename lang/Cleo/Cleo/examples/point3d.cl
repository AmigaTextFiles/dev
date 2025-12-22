program Essai_tableau_de_structures;

var
    tab3d : array[1..10] of point3d;
    tab2d : array[1..10] of point2d;
    color : array[1..10] of rgb;
    i : integer;
begin

    writeln;
    writeln('           Tableau de Points 2d ');
    writeln;
    i :=1;
    while i<10 do
        begin
            tab2d[i].x := i;
            tab2d[i].y := i;
            i := i+1;
        end;

    i :=1;
   repeat
            writeln('   i=', i, '   x=',tab2d[i].x, ' y=',tab2d[i].y);
            i := i+1;
   until i>9;

    writeln;
    writeln('           Tableau de Points 3d ');
    writeln;
    i :=1;
    while i<10 do
        begin
            tab3d[i].x := i;
            tab3d[i].y := i;
            tab3d[i].z := i;
            i := i+1;
        end;

    i :=1;
   repeat
            writeln('   i=', i, '   x=',tab3d[i].x, ' y=',tab3d[i].y, ' z=',tab3d[i].z);
            i := i+1;
   until i>9;

    writeln;
    writeln('           Tableau de Couleurs ');
    writeln;
    i :=1;
    while i<10 do
        begin
            color[i].r := i;
            color[i].g := i;
            color[i].b := i;
            i := i+1;
        end;

    i :=1;
   repeat
            writeln('   i=', i, '   red=',color[i].r, ' green=',color[i].g, ' blue=',color[i].b);
            i := i+1;
   until i>9;

    writeln;

end.