external;

{$I "Crt.i"}

procedure CursorOn;
begin
   Write(CSI,"1 p");
end;
                      
