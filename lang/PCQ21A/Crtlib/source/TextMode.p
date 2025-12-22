external;

{$I "Crt.i"}

procedure TextReset;
external;

procedure TextMode(style, fgpen, bgpen : byte);
begin
   TextReset;
   Write(CSI, style, ";3", fgpen, ";4", bgpen, "m");
end;
           
