program readkey;

{$I "include:Other/crt.i" }
{$I "Include:dos/dos.i" }

var
   key   :  char;
   i, j, tc, tb   :  byte;
   x     :  integer;
   ex    :  boolean;
   
procedure WriteHexChar(c : char);
var
   i     :  integer;
   a, b  :  byte;
begin
   a := (ord(c) shr 4) and $0F;
   b := ord(c) and $0F;
   
   for i := 0 to 1 do begin
      if a < 10 then Write(char(ord('0') + a))
      else Write(char(ord('A') + (a-10)));
      
      a := b;
   end;
end;

begin
   ClrScr;
   CursorOff;
   
   tc := GetTextColor;
   TextColor(3);
   Write("Break:");
   TextColor(0);
   tb := GetTextBackground;
   TextBackground(3);
   Write(" [ctrl c = Abbruch] > ");
   
   TextColor(tc);
   TextBackground(tb);
   
   x := WhereX;
   j := 0;

   repeat
      Inc(j);
      Write('·'); Delay(10);

      ex := Break;

      if ex = true then begin
         GotoX(x);   WriteLn("** Abbruch!     ");
      end;
   until (j = 15) or (ex = true);

   if ex = false then begin
      GotoX(x);   WriteLn("ok.            ");
   end;
   
   CursorOn;
end.
