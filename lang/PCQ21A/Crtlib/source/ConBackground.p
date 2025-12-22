external;

{$I "Crt.i"}

function GetTextBackground: byte;
external;

procedure ConBackground(bgpen : byte);
begin
   if bgpen = TEXT_BACKGROUND then bgpen := GetTextBackground;
   
   Write(CSI, '4', bgpen, ';>', bgpen, 'm');
end;
                      
