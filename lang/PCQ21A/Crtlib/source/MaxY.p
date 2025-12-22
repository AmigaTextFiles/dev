external;

{$I "Crt.i"}

function ConData(modus : byte) : integer;
external;

function MaxY : integer;
begin
   MaxY := ConData(CD_MAXY);
end;
                                  
