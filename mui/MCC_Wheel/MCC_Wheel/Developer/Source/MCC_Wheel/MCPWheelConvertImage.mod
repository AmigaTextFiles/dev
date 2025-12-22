|##########|
|#MAGIC   #|GMGLIMBP
|#PROJECT #|"MCPWheelConvertImage"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx-x-x--xxx-x-x-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|xx---xxxxx-xx---
|##########|

(*
** converts raw picture type 1 (PersonalPaint) to MODULE
** first 3×8 bit colors, then bitplanes
*)

MODULE MCPWheelConvertImage;

FROM DosSupport IMPORT FName;
FROM InOut      IMPORT WriteGrp, RedirectionGrp;
FROM Streams    IMPORT ReadGrp;

PROCEDURE Separator (last : BOOLEAN) : LONGINT;
BEGIN
  IF last THEN
    RETURN INTEGER(" ");
  ELSE
    RETURN INTEGER(",");
  END;
END Separator;

CONST
  InPath  = "MUI:Developer/Cluster/pic";
  InName  = "Wheel3.raw";
  OutPath = "MUI:Developer/Cluster/txt";
  OutName = "MCPWheelImage";

  width   = 23;
  height  = 14;
  planes  =  4;

  widthBytes = ((width+15) SHR 4) SHL 1;

VAR
  c, maxC    : CARDINAL;
  cr, cg, cb : SHORTCARD;
  lr, lg, lb : LONGCARD;

  x, y, p    : LONGCARD;
  byte       : SHORTCARD;

BEGIN
  OpenInput  (FName (InPath,  InName,  ""));
  OpenOutput (FName (OutPath, OutName, "def"));

  WriteFormat ("DEFINITION MODULE %s;"+&10+&10, data := OutName.data'ADR);

  WriteFormat ("FROM MuiO     IMPORT RGB32Arr;"+&10);
  WriteFormat ("FROM Graphics IMPORT BitMap;"+&10+&10);

  WriteFormat ("CONST"+&10);
  WriteFormat ("  width  = %ld;"+&10, data := width);
  WriteFormat ("  height = %ld;"+&10, data := height);
  WriteFormat ("  planes = %ld;"+&10, data := planes);
  WriteLn;

  WriteFormat ("CONST"+&10);
  WriteFormat ("  palette = RGB32Arr : ("+&10);

  maxC := (1 SHL planes)-1;
  FOR c := 0 TO maxC DO
    ReadBlock (cr); lr := LONGCARD(cr) * $1010101;
    ReadBlock (cg); lg := LONGCARD(cg) * $1010101;
    ReadBlock (cb); lb := LONGCARD(cb) * $1010101;
    WriteFormat ("              ($%08.lx, $%08.lx, $%08.lx)%lc"+&10, data := CAST(LONGINT,lr), CAST(LONGINT,lg), CAST(LONGINT,lb), Separator(c=maxC));
  END;
  WriteFormat ("            );"+&10+&10);

  WriteFormat ("TYPE"+&10);
  WriteFormat ("  BitLine   = ARRAY [%ld] OF SHORTCARD;"+&10,    data := widthBytes);
  WriteFormat ("  BitPlane  = ARRAY [%ld] OF BitLine;"+&10,      data := height);
  WriteFormat ("  Raster    = ARRAY [%ld] OF BitPlane;"+&10+&10, data := planes);

  WriteFormat ("CONST"+&10);
  WriteFormat ("  raster = Raster : ("+&10);

  FOR p := 0 TO planes-1 DO
    WriteFormat ("              ("+&10);
    FOR y := 0 TO height-1 DO
      WriteFormat ("                (");
      FOR x := 0 TO widthBytes-1 DO
        ReadBlock (byte);
        WriteFormat ("$%02.lx%lc ", data := byte, Separator(x=widthBytes-1));
      END;
      WriteFormat (")%lc"+&10, data := Separator(y=height-1));
    END;
    WriteFormat ("              )%lc"+&10, data := Separator(p=planes-1));
  END;
  WriteFormat ("            );"+&10+&10);

  WriteFormat ("  bitmap = BitMap : ("+&10);
  WriteFormat ("    %ld, %ld, {}, %ld, 0,"+&10+
               "      (", data := widthBytes, height, planes);
  FOR p := 0 TO 7 DO
    IF p<planes THEN
      WriteFormat ("raster[%ld]'PTR", data := p);
    ELSE
      WriteFormat ("NIL");
    END;
    WriteFormat ("%lc ", data := Separator (p=7));
  END;
  WriteFormat (")"+&10+"  );"+&10+&10);

  WriteFormat ("END %s."+&10, data := OutName.data'ADR);
  CloseOutput;
  CloseInput;

  OpenOutput (FName (OutPath, OutName, "mod"));
  WriteFormat ("$$LibraryAlso := TRUE"+&10);
  WriteFormat ("$$StackChk    := FALSE"+&10);
  WriteFormat ("$$ChipMem     := TRUE"+&10+&10);
  WriteFormat ("IMPLEMENTATION MODULE %s;"+&10, data := OutName.data'ADR);
  WriteFormat ("END %s."+&10, data := OutName.data'ADR);
  CloseOutput;

END MCPWheelConvertImage.
