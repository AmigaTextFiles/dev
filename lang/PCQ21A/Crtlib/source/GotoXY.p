external;

{$I "Crt.i"}

function MaxX : integer;
external;

function MaxY : integer;
external;

function WhereX : integer;
external;

function WhereY : integer;
external;

procedure GotoXY(x, y : integer);
var
   mx, my : integer;
begin
   mx := MaxX;
   my := MaxY;
   
   if x < 1 then x := WhereX
   else if x > mx then x := mx;
   
   if y < 1 then y := WhereY
   else if y > my then y := my;
   
   Write(CSI, y, ";", x, "H");
end;
                                    
