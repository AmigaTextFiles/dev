external;

{$I "Crt.i"}

function WhereY : integer;
external;

procedure GoUp(n : integer);
begin
   if (n > 1) and (n < WhereY) then Write(CSI, n, "A");
end;
             
