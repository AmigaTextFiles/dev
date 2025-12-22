external;

{$I "Crt.i"}

procedure TextBackground(bgpen : byte);
begin
   Write(CSI, '4', bgpen, 'm');
end;
                          
