program bigoudi;



var
  i,j,nbx,nby:integer;
  minx,maxx,miny,maxy,zx,zy,cx,cy,sv:real;
  pasx,pasy:real;
  k : integer;
  ok : integer;

begin

     minx:=-2;   miny:=-1;
     maxx:=1;    maxy:=1;

     nbx:=70;     { resolution en x }
     nby:=20;     { resolution en y }

     pasx:=(maxx-minx)/nbx;
     pasy:=(maxy-miny)/nby;

      j:=0;

      writeln('      Ensemble de Mandelbrot ( recursion 20 ), etonnant non ? ...');

     while j<nby do
        begin
            i:=0;
            while i<nbx do
                begin
                    k := 0; ok := 0;
                    zx:=0; zy:=0;
                    cx:= i*pasx+minx;
                    cy:= j*pasy+miny;
                    while  ok=0 do
                        begin
                            sv:= zx*zx-zy*zy+cx;
                            zy:=2*zx*zy+cy;
                            zx:=sv;
                            k := k+1;
                            if k>20 then ok := 2;

                            if sqr( zx*zx + zy*zy) > 2 then ok :=1;
                        end;
                    if  ok=1
                    then begin
                                    if k<5  then  write(' ')
                               else if k<10 then  write('.')
                               else if k<15 then  write('°')
                               else               write('o');
                         end

                    else write('0');

                    i:=i+1;
                end;
            writeln;
            j:=j+1;
        end;

end.

