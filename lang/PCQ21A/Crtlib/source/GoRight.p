external;

{$I "Crt.i"}

function MaxX : Integer;
external;

function WhereX : integer;
external;

procedure GoRight(n : integer);
begin
   if (n > 0) and (n <= (MaxX - WhereX)) then Write(CSI, n, "C");
end;
                               
