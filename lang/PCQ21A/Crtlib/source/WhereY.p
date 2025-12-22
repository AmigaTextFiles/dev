external;

{$I "Crt.i"}

function ConData(modus : byte) : integer;
external;

function WhereY : integer;
begin
   WhereY := ConData(CD_CURRY);
end;
                                          
