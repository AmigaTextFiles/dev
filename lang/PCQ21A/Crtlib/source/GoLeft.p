external;

{$I "Crt.i"}

function WhereX : Integer;
external;

procedure GoLeft(n : integer);
begin
   if (n > 0) and (n < WhereX) then Write(CSI, n, "D");
end;
          
