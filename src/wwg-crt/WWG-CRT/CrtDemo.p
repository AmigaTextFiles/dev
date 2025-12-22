program CrtDemo;

{$I "INCLUDE:Utils/Crt.i"}

var
   x, y     :  integer;
   tc, tb   :  byte;
   
procedure DrawShellGfx;
var
   i, mx, my   :  integer;
   key         :  char;
begin
   mx := x/2+1;
   my := y/2;
   
   { Die Diagonalen: }
   TextBackground(2);
   TextLine(2, 2, x-1, y-1, ' ');
   TextBackground(4);
   TextLine(x-1, 2, 2, y-1, ' ');
   
   { Die Informationen: }
   TextMode(TS_BOLD, 5, 7);
   GotoXY(x-12, my);    Write("Spalten: ", x:2);
   GotoXY(x-12, my+1);  Write("Zeilen : ", y:2);
   
   { Die Nummerierungsspalte: }
   TextMode(TS_ITALIC, 0, 3);
   GotoXY(1, 1);  Write(1:2);
   for i := 3 to y-2 do begin
      GotoXY(1, i);  Write(i:2);
   end;
   GotoXY(1, y);  Write(y:2);
   
   { Der Untergrund für das Dreieck: }
   TextMode(TS_PLAIN, 1, 0);
   TextRectFill(mx-9, my/8, 19, my/4, ' ');
   
   { Das Dreieck: }
   TextMode(TS_PLAIN, 4, 3);
   TextLine(mx-8, 2, mx+8, 2, '·');
   TextLine(mx-8, 2, mx, my-1, '·');
   TextLine(mx+8, 2, mx, my-1, '·');
   
   { Warten auf die Benutzereingabe: }
   TextMode(TS_BOLD, 2, 3);
   GotoY(my+my*2/3+1);
   CenterText("Press <RETURN>");
   key := ReadKey;
end;

begin
   x  := MaxX;
   y  := MaxY;
   
   if (x >= 32) and (y >= 8) then begin
      ClrScr;
      CursorOff;
      
      tc := GetTextColor;
      tb := GetTextBackground;
      
      DrawShellGfx;
      
      TextColor(tc);
      TextBackground(tb);
      
      ClrScr;
      CursorOn;
   end else WriteLn('Bitte das Fenster vergrößern!');
end.  
