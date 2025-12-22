PROGRAM GfxModeTest;

Uses Graph, Crt;

VAR
  Driver, Mode : INTEGER;
  c : CHAR;

BEGIN
  driver:=DETECT;
  InitGraph(Driver,Mode,'');
  SetGraphMode(VGAHi);
  OutText(GetModeName(Mode));
  OutText(GetDriverName);
  OutTextXY(10,10,'Better known as VGAHi');
  c:=readkey;
END.
    