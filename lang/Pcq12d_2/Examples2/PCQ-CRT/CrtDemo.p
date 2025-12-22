Program CrtDemo;

{$I "Include:Utils/Crt.i"}

PROCEDURE DrawShellGfx;
VAR i, z, s : Integer;
Begin
 GetConSize(z,s);

 ClrScr;
 CursorOff;

 SetTextStyle(TS_PLAIN,1,2);
 TxtLine(1,1,s,z,' ');
 TxtLine(s,1,1,z,' ');

 SetTextStyle(TS_BOLD,1,0);
 Locate(z/2,s-13);
 Write("Zeilen: ",z);
 Locate(z/2+1,s-13);
 Write("Spalten: ",s);
 SetTextStyle(TS_PLAIN,1,0);

 For i:=1 to z do
  Begin
   Locate(i,1);
   Write(i);
  end;

 SetTextStyle(TS_PLAIN,1,3);
 HorizTxtLine(s/2-8,2,16,' ');
 TxtLine(s/2-8,2,s/2,10,' ');
 TxtLine(s/2,10,s/2+8,2,' ');

 SetTextStyle(TS_PLAIN,1,1);
 TxtRectFill(4,z/2-4,10,8,' ');

 SetTextStyle(TS_BOLD,2,3);
 Locate(z-3,s/2-8);
 Write("Press <RETURN>");
 SetTextStyle(TS_PLAIN,0,0);
end;


Begin
 DrawShellGfx;

 Readln;

 ResetConsole;
end.

