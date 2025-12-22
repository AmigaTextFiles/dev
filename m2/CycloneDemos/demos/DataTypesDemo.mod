// Shows a picture on a new screen using datatypes
// V0.7, 12.12.96, Stefan Tiemann

MODULE DataTypesDemo;


IMPORT DL: DosL;
IMPORT DTD: DataTypesD;
IMPORT DTL: DataTypesL;
IMPORT ED: ExecD;
IMPORT GL: GraphicsL;
IMPORT GD: GraphicsD;
IMPORT ID: IntuitionD;
IMPORT IL: IntuitionL;
FROM UtilityD IMPORT tagEnd;
FROM ModulaLib IMPORT Assert;




PROCEDURE ShowPicture(FileName: ARRAY OF CHAR):BOOLEAN;
VAR
   DataTypeO: ID.ObjectPtr;
   ScreenP: ID.ScreenPtr;
   NumColors: LONGINT;
   PaletteTable: POINTER TO ARRAY [0..255] OF RECORD red,green,blue:LONGCARD; END;
   gpLayout: ID.GpLayout;
   BMP: GD.BitMapPtr;
   BMHP: DTD.BitMapHeaderPtr;
   LZ: LONGINT;
   RetVal:BOOLEAN;
BEGIN
   RetVal:= FALSE;

   //Open picture
   DataTypeO:= DTL.NewDTObjectA(@FileName,
                                [DTD.dtaGroupID, DTD.gIdPicture,
                                 DTD.pdtaRemap, FALSE,
                                 tagEnd]);
   IF DataTypeO # NIL THEN

      //layout picture, now datatype will write in bitmap
      gpLayout.methodID:= DTD.dtmProcLayout;
      gpLayout.gInfo:= NIL;
      gpLayout.initial:= 1;
      IF DTL.DoDTMethodA(DataTypeO, NIL, NIL, @gpLayout) # 0 THEN

         //get info about picture depth, dimension etc.
         IF 4 = DTL.GetDTAttrsA(DataTypeO,
                                [DTD.pdtaBitMapHeader, @BMHP,
                                 DTD.pdtaBitMap, @BMP,
                                 DTD.pdtaNumColors, @NumColors,
                                 DTD.pdtaCRegs, @PaletteTable,
                                 tagEnd]) THEN

             //open screen to show picture
             ScreenP:= IL.OpenScreenTagList(NIL, [ID.saHeight, BMHP^.height,
                                                  ID.saWidth, BMHP^.width,
                                                  ID.saDepth, BMHP^.depth,
                                                  ID.saQuiet, ED.LTRUE,
                                                  tagEnd]);
             IF ScreenP # NIL THEN
                //copy datatype bitmap into screen
                GL.BltBitMapRastPort(BMP, 0, 0, @ScreenP^.rastPort, 0, 0, BMHP^.width, BMHP^.height, 0C0H);
                //set colors
                IF NumColors > 256 THEN   NumColors:= 256;   END;
                FOR LZ:= 0 TO (NumColors-1) DO
                   GL.SetRGB32(@ScreenP^.viewPort, LZ, PaletteTable^[LZ].red, PaletteTable^[LZ].green, PaletteTable^[LZ].blue);
                END;

                //wait and clean up
                RetVal:= TRUE;
                DL.Delay(250);  // Wait 5 secs;
                IL.CloseScreen(ScreenP);

             END;
         END;
      END;
      DTL.DisposeDTObject(DataTypeO);
   END;
   RETURN RetVal;
END ShowPicture;


BEGIN
   Assert(ShowPicture("DataTypesExamplePic.ilbm"), @"DataTypesDemo failed");
END DataTypesDemo.
