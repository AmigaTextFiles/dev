program readkey;

{$I "include:Other/crt.i" }

var
   key            :  char;
   i, j, tc, tb   :  byte;
   spalte         :  integer;
   
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
   tb := GetTextBackground;
   
   TextMode(TS_BOLD, 6, 2);
   Write('ReadKey: [');
   TextColor(3);
   Write('q=quit');
   TextColor(6);
   Write('] > ');
   TextMode(TS_PLAIN, 2, 3);
   
   spalte   := WhereX;
   
   repeat
      Bell;
      GotoX(spalte);
      key := ReadKey;
      WriteHexChar(key);
   until key = 'q';
   
   TextColor(tc);
   TextBackground(tb);
   
   Writeln;
   CursorOn;
end.
