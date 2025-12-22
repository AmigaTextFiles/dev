external;

procedure GotoXY(x,y:integer);
external;

function WhereX:integer;
external;

function WhereY:integer;
external;

function MaxX:integer;
external;

function MaxY:integer;
external;

procedure TextRectFill(x, y, w, h : Integer; c : Char);
var
   ox, oy, mx, my, i, j :  Integer;
begin
   ox := WhereX;
   oy := WhereY;
   
   GotoXY(x, y);
   
   x  := WhereX;
   y  := WhereY;
   
   if w < 0 then w := -w;
   if h < 0 then h := -h;
   
   mx := MaxX;
   my := MaxY;
   
   if (x+w) > mx then w := mx-x;
   if (y+h) > my then h := my-y;
   
   for i := 1 to h do begin
      for j := 1 to w do Write(c);
      GotoXY(x, WhereY+1);
   end;
   
   GotoXY(ox, oy);
end;                    
