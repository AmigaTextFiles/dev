Program Scroll;

{ Scroller V1.0 © 1994 by Andreas Tetzl

  Dieses Programm ist Freeware.
  Sie können es verwenden, solange mein Name erwähnt wird.

  Andreas Tetzl
  Liebethaler Str.18
  01796 Pirna
  Tel. 03501/523854
}

{$I "Include:Intuition/Intuition.i"}
{$I "Include:Graphics/Graphics.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Graphics/Text.i"}
{$I "Include:Graphics/Blitter.i"}
{$I "Include:Graphics/View.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Libraries/DOS.i"}

CONST
  BMWIDTH = 640;          { Der zu scrollende Bereich sollte so klein wie möglich sein,
                          { daß geht noch schneller. }
  BMHEIGHT = 490+200;     { Zeilen*10+Höhe des Screens }

  Topaz : TextAttr = ("topaz.font",8,FS_NORMAL,FPB_ROMFONT);

  ns : NewScreen = (0,0,640,200,1,0,1,HIRES,CUSTOMSCREEN_f,NIL,NIL,NIL,NIL);
  nw : NewWindow = (0,0,640,200,0,1,0,BORDERLESS+ACTIVATE+RMBTRAP,
                    NIL,NIL,NIL,NIL,NIL,0,0,0,0,CUSTOMSCREEN_F);

  MyText : Array[1..49] of String =(
   "","","","","","","","","","","","","","","","","","","","","","","",
   "Scroller V1.0 © 1994 by Andreas Tetzl","","","","",
   "Dieser Scroller benutzt die Blitterbefehle der",
   "Graphics.Library.",
   "Der Text wird in eine große Bitmap geschrieben,",
   "und dann in die Bitmap des Screen geblittet.",
   "Es ist auch möglich Grafik zu scrollen, aber",
   "bei mehr Farben fängt's an zu ruckeln.",
   "","","","","",
   "Grüße gehen an","","",
   "Diesel",
   "und",
   "Andreas Neumann",
   "","","","");


  Colors : Array[1..2] of Short = ($0,$FFF);       { Schwarz, Weiß }


VAR Scr : ScreenPtr;
    Win : WindowPtr;
    RP, RP2 : RastPortPtr;
    BM, BM2 : BitMapPtr;
    VP : ViewPortPtr;
    i, BitPlanes: Integer;
    TopazFont : TextFontPtr;

PROCEDURE CleanExit(Why : String; RC : Integer);
BEGIN
 IF BM2^.Planes[0]<>NIL THEN FreeRaster(BM2^.Planes[0],BMWIDTH,BMHEIGHT);
 IF Win<>NIL THEN CloseWindow(Win);
 IF Scr<>NIL THEN CloseScreen(Scr);
 IF TopazFont<>NIL THEN CloseFont(TopazFont);
 IF GfxBase<>NIL THEN CloseLibrary(GfxBase);
 IF Why<>NIL THEN Writeln(Why);
 Exit(RC);
END;

Function LeftMouseButton: Boolean;
Type
        bt = ^Byte;
Var
        bfe : bt;
Begin
        bfe := Address($bfe001);

        If (bfe^ MOD 128) > 64                  { bit 6 gesetzt ? }
        then  LeftMouseButton := False          { ja -> nicht gedrückt }
        else  LeftMouseButton := True;          { nein -> lmb gedrückt }
end;

BEGIN
 GfxBase:=OpenLibrary("graphics.library",0);
 IF GfxBase=NIL THEN CleanExit("Kann Gfx.lib nicht öffnen",10);
 Scr:=OpenScreen(adr(ns));
 IF Scr=NIL THEN CleanExit("Kann Screen nicht öffnen",10);
 VP:=adr(Scr^.SViewPort);
 LoadRGB4(VP,adr(Colors),2);
 nw.Screen:=Scr;
 Win:=OpenWindow(adr(nw));
 IF WIn=NIL THEN CleanExit("Kann Window nicht öffnen",10);
 BM:=adr(Scr^.SBitMap);
 RP:=adr(Scr^.SRastPort);

 TopazFont:=OpenFont(adr(Topaz));
 IF TopazFont=NIL THEN CleanExit("Kann Topaz.Font nicht öffnen",10);

 New(BM2);
 InitBitMap(BM2,1,BMWIDTH,BMHEIGHT);
 BM2^.Planes[0]:=AllocRaster(BMWIDTH,BMHEIGHT);
 IF BM2^.Planes[0]=NIL THEN CleanExit("Nicht genug Speicher für Bitmap",10);

 New(RP2);
 InitRastPort(RP2);
 RP2^.BitMap := BM2;

 SetFont(RP2,TopazFont);
 SetRast(RP2,0);

 { Text in Bitmap schreiben }
 For i:=1 to 49 do
  BEGIN
   Move(RP2,(BMWidth/2)-(TextLength(RP2,MyText[i],StrLen(MyText[i]))/2),i*10);
   GText(RP2,MyText[i],StrLen(MyText[i]));
  END;

 { Scrollen }
 REPEAT
  For i:=1 to BMHEIGHT-200 do
   BEGIN
    BitPlanes:=BltBitMap(BM2,0,i,BM,0,0,BMWIDTH,Scr^.Height,$C0,%00000001,NIL);
    { Versuchen Sie mal einen sehr kleinen Bereich zu scrollen (z.B. 100*100) }

    IF LeftmouseButton THEN CleanExit(NIL,0);
    { Wenn das Scrolling zu schnell ist, dann müssen Sie hier
      warten. Delay(1) dauert zu lange, benutzen Sie WaitTimer() aus
      Include:Utils/TimerUtils (Demo in Examples/TimerTest.p) }
   END;
 UNTIL FALSE;
END.






 
