external;

{$I "Crt.i"}

procedure CursorOff;
begin
   Write(CSI,"0 p");
end;
                        
