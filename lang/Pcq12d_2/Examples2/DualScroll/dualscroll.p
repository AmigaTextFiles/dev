{
  *  DualScroll, converted from Modula2 to PCQ-Pascal 03/1993 by Diesel  *
  *  Grundlage war ursprünglich ein C-Proggy von Gregg Williams.         *
  *									 *
  *  Playfield 1 ist ein ganz normaler Intuition-Screen, Playfield 2	 *
  *  dagegen eine übergroße Bitmap (640*512 Punkte ohne Interlace), die  *
  *  lustig durch die Gegend scrollt.					 *
}

Program DPFDemo;

{$I "Include:intuition/intuition.i" }
{$I "Include:graphics/areas.i" }
{$I "Include:graphics/pens.i" }
{$I "Include:exec/libraries.i" }
{$I "Include:exec/memory.i" }
{$I "Include:libraries/dos.i" }

CONST
  Farben : Array[1..32] OF Short = (
    $000, $E3F, $000, $CE7, $000, $000, $000, $000,
    $000, $FB0, $CCC, $F19, $270, $0C5, $777, $338,
    $000, $000, $000, $000, $000, $000, $000, $000,  
    $000, $000, $000, $000, $000, $000, $000, $000);  


VAR BMap	: BitMapPtr;			{  2. Bitmap  }
    RInfo	: ARRAY[0..1] OF RasInfo;	{  1. + 2. RasInfo  }
    RP		: ARRAY[0..1] OF RastPortPtr;	{  1. + 2. RastPort  }
    i,x,y	: INTEGER;
    ScreenDaten	: NewScreen;
    MeinScreen	: ScreenPtr;
    GfxBase	: Address;                    


{ -------------------------------------------------------------------- }

Function LeftMouseButton: Boolean;
Type
	bt = ^Byte;
Var
	bfe : bt;
Begin
	bfe := Address($bfe001);

	If (bfe^ MOD 128) > 64			{ bit 6 gesetzt ? }
	then  LeftMouseButton := False		{ ja -> nicht gedrückt }
	else  LeftMouseButton := True;		{ nein -> lmb gedrückt }
end;


PROCEDURE MakeBox(x1,y1,col1,col2: INTEGER);
BEGIN
    SetAPen(  RP[1] ,0);		{  Schatten zeichnen  }
    RectFill( RP[1] ,x1+4,y1+4,x1+40,y1+40);

    SetAPen(  RP[1] ,0);		{  Umrandung zeichnen  }
    RectFill( RP[1] ,x1,y1,x1+36,y1+36);

    SetAPen(  RP[1] ,col1);		{  großen Kasten zeichnen  }
    RectFill( RP[1] ,x1+2,y1+2,x1+34,y1+34);

    SetAPen(  RP[1] ,col2);		{  kleinen Kasten zeichnen  }
    RectFill( RP[1] ,x1+12,y1+12,x1+24,y1+24);
END;	{ MakeBox }

  
PROCEDURE ZeichneFields;
VAR x1,y1,temp,col1,col2: INTEGER;
BEGIN
				{  Fenster auf 1. Playfield malen  }
    SetRast(  RP[0], 1);	{  alles erstmal in Blau  }

    SetAPen(  RP[0], 0);
    RectFill( RP[0], 20,20,60,60);
    RectFill( RP[0], 262,195,302,235);

    SetAPen(  RP[0], 2);		{ Rahmen }
    RectFill( RP[0], 95,45,225,183);

    SetAPen(  RP[0], 0);		{ Fenster }
    RectFill( RP[0], 100,50,220,178);
    
    SetRast(  RP[1], 15);
    SetAPen(  RP[1], 14);
    
    temp:=1;
    FOR x1:=0 TO 640 DO {  Übergroßes Playfield 2 mit Gitter füllen  }
    BEGIN
      x1 := x1 + 19;				{ Step 20 }
      Move( RP[1], x1, 0);
      Draw( RP[1], x1, 512);
    END;
    FOR y1:=0 TO 512 DO
    BEGIN
      y1 := y1 + 19;				{ Step 20 }
      Move( RP[1],   0, y1 );
      Draw( RP[1], 640, y1 );
    END;
    
    FOR x1:=25 TO 590 DO {  Übergroßes Playfield 2 mit Kästen füllen  }
    BEGIN
      x1 := x1+49;				{ Step 50 }
      FOR y1:=0 TO 462 DO
      BEGIN
	y1 := y1+49;				{ Step 50 }
        col1:=temp+8;
        INC(temp);
        IF temp>7 THEN temp:=1;

        col2:=temp+8;
        INC(temp);
        IF temp>7 THEN temp:=1;

        MakeBox(x1,y1,col1,col2);
      END;
    END;
END;  { ZeichneFields }
  

 { ---- MAIN ---- }

BEGIN
  GfxBase := OpenLibrary( "graphics.library", 32 );
  If GfxBase=NIL THEN Exit(20);


  New( BMap );
  New( RP[0] );
  New( RP[1] );


  WITH ScreenDaten DO
  BEGIN
    leftEdge:=0;
    topEdge:=0;
    width:=322;
    height:=256;
    depth:=3;
    detailPen:=0;
    blockPen:=1;
    viewModes:= 0;
    Stype:=customScreen_f;
    defaultTitle:=NIL;
    gadgets:=NIL;
    font:=NIL;
    customBitMap:=NIL;
  END;
  
  MeinScreen:=OpenScreen( ADR(ScreenDaten));

  InitBitMap(BMap,3,640,512); {  Bitmap 2 initialisieren  }

  FOR i:=0 TO 2 DO
  BEGIN
    BMap^.planes[i]:=AllocRaster(640,512); {  Bitplanes reservieren  }
  END;

  InitRastPort( RP[1] );			{  RastPort 2 erstellen  }
  RP[1]^.bitMap := BMap;			{  Bitmap 2 einbinden  }

  WITH RInfo[1] DO				{  RasInfo 2 ausfüllen  }
  BEGIN
    bitMap:=BMap; rxOffset:=0; ryOffset:=0; next:=NIL;
  END;

					{  RastPort u. RasInfo deklarieren  }
  CopyMem( Adr(MeinScreen^.SrastPort), RP[0], SizeOf(RastPort) );
  RInfo[0].next := MeinScreen^.SViewPort.rasInfo^.next;
  MeinScreen^.SviewPort.rasInfo^.next:=ADR( RInfo[1] );	{  RasInfo 2 anpassen  }

  LoadRGB4(ADR(MeinScreen^.SviewPort),ADR(Farben),32);	{  Farben laden  }
    
  MeinScreen^.SviewPort.modes := DualPF;		{  DUALPF setzen  }

  MakeScreen(MeinScreen);				{  erneuern  }
  RethinkDisplay;

  ZeichneFields;	  {  Playfields füllen  }

  x:=1; y:=1;
  
  REPEAT
    RInfo[1].rxOffset:=RInfo[1].rxOffset+x;	{  Koordinaten f. PF2 erhöhen  }
    RInfo[1].ryOffset:=RInfo[1].ryOffset+y;
    
    IF (RInfo[1].rxOffset<=0) OR (RInfo[1].rxOffset>=319) THEN
    BEGIN
      x:=-x;
    END;

    IF (RInfo[1].ryOffset<=0) OR (RInfo[1].ryOffset>=255) THEN
    BEGIN
      y:=-y;
    END;
    RemakeDisplay;				{  Display erneuern  }
  UNTIL LeftMouseButton;

  MeinScreen^.SviewPort.rasInfo^.next := NIL;	{  Intuition-Screen setzen  }
  MeinScreen^.SviewPort.modes := 0;		{  DUALPF löschen  }
  
  MakeScreen(MeinScreen);			{  OK !  }
  RemakeDisplay;			     
  RethinkDisplay;

  CloseScreen(MeinScreen);
  FOR i:=0 TO 2 DO				{  2. Bitmap freigeben  }
  BEGIN
    FreeRaster(BMap^.planes[i],640,512);
  END;
  CloseLibrary( GfxBase );

END.
