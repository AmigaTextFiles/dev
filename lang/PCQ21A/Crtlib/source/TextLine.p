external;

procedure GotoXY(x,y:integer);
external;

procedure GotoY(x:integer);
external;

function WhereY:integer;
external;

function WhereX:integer;
external;

procedure TextLine(x1, y1, x2, y2 : Integer; c : Char);
var
   i, j, m, n, d, x, y, dy :  integer;
   s, f  :  real;
   
   procedure Tausch(var a, b : integer);
   begin
      i := a;
      a := b;
      b := i;
   end;
   
   procedure d_ermitteln;
   begin
      s  := s + f;
      n  := trunc(s+0.5);
      d  := n - m;
      m  := n;
   end;
begin
   
   {  Grundsätzlich von links nach rechs zeichnen;
      always draw from left to right }
   if x2 < x1 then begin
      Tausch(x1, x2);
      Tausch(y1, y2);
   end;
   
   GotoXY(x1, y1);
   
   {  Die vertikale Zeichenrichtung und die Abmessung in der Höhe ermitteln;
      determine the vertical drawing direction and height }
   if y1 < y2 then begin
      y  := (y2-y1)+1;
      dy := 1;
   end else begin
      y  := (y1-y2)+1;
      dy := -1;
   end;
   
   {  Die Breite in Zeichen ermitteln;
      determine the count of chars in width }
   x  := (x2-x1)+1;
   
   m  := 0;
   s  := 0;
   
   if x >= y then begin
      {  Die Diagonale bedeckt eine Fläche, die breiter ist, als sie hoch ist;
         The diagonal is smaller in height than in width }
      f  := x/y;
      
      for i := 1 to y do begin
         d_ermitteln;
         
         for j := 1 to d do Write(c);
         
         if i < y then GotoY(WhereY+dy);
      end;
   end else begin
      {  Die Diagonale bedeckt eine Fläche, die schmaler ist, als sie hoch ist;
         The diagonal is smaller in width than in height }
      f  := y/x;
      
      for i := 1 to x do begin
         d_ermitteln;
         
         for j := 1 to d-1 do begin
            Write(c);
            GotoXY(WhereX-1, WhereY+dy);
         end;
         
         Write(c);
         
         if i < x then GotoY(WhereY+dy);
      end;
   end;
end;
                                                       
