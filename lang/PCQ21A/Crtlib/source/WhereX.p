external;

{$I "Crt.i"}

function ConData(modus : byte) : integer;
external;

function WhereX : integer;
begin
   WhereX := ConData(CD_CURRX);
end;
                                      
