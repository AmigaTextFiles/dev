external;

{$I "Crt.i"}

procedure TextReset;
begin
   Write(CSI, "0;39;49m");
end;
                              
