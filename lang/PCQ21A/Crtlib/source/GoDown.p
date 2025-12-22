external;

{$I "Crt.i"}

function MaxY:Integer;
External;

function WhereY:Integer;
external;

procedure GoDown(n : integer);
begin
   if (n > 0) and (n <= (MaxY - WhereY)) then Write(CSI, n, "B");
end;
               
