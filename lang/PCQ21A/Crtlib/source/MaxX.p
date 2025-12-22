external;

{$I "Crt.i"}

function ConData(modus : byte) : integer;
external;

function MaxX : integer;
begin
   MaxX := ConData(CD_MAXX);
end;
                                    
