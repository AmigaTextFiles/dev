external;

{$I "Crt.i"}

procedure TextColor(fgpen : byte);
begin
   Write(CSI, '3', fgpen, 'm');
end;
                
