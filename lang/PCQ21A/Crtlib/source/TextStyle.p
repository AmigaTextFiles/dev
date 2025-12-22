external;

{$I "Crt.i"}

procedure TextStyle(style : byte);
begin
   Write(CSI, style, "m");
end;
                  
