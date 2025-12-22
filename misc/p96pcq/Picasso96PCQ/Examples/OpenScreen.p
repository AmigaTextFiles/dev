
PROGRAM OpenScreen;

{
    PCQ-Version des Picasso96-Demoprogrammes

    in Pascal übersetzt von Andreas Neumann
}

{$I "Include:exec/memory.i" }
{$I "Include:exec/interrupts.i" }
{$I "Include:exec/libraries.i" }
{$I "Include:dos/RDArgs.i" }
{$I "Include:libraries/dos.i" }
{$I "Include:graphics/graphics.i" }
{$I "Include:graphics/pens.i" }
{$I "Include:intuition/intuition.i" }
{$I "Include:utils/random.i" }
{$I "Include:p96/Picasso96.i" }

Const
    gfxname     :   String  =   "graphics.library";
    ScreenTitle :   String  =   "Picasso96 API Test";
    W1Title     :   String  =   "WritePixel";
    W2Title     :   String  =   "FillRect";
    Pens        :   Array [0..0] Of Short = (NOT(0));
    template    :   String  =   "Width=W/N,Height=H/N,Depth=D/N";
    vecarray    :   Array[0..2] of Address = (Nil, Nil, Nil);


Var
    i       :   Integer;
    sc      :   ScreenPtr;
    windowtags,
    ptags   :   Array [0..32] Of TagItem;
    wdf,
    wdp     :   WindowPtr;
    rpf,
    rpp     :   RastPortPtr;
    terminate   :   Boolean;
    signals     :   Integer;
    format      :   RGBFTYPE;
    x1, y1,
    x2, y2,
    x3, y3      :   Short;
    imsg        :   IntuiMessagePtr;
    msg         :   MessagePtr;
    Dimensions  :   Array [0..3] Of Short;
    Width,
    Height,
    Depth       :   Integer;
    rda         :   RDArgsPtr;

BEGIN
 Width:=640;
 Height:=480;
 Depth:=8;

 rda:=ReadArgs (template,Adr(vecarray),Nil);
 If rda<>Nil Then
 Begin
  If vecarray[0]<>NIL then CopyMem(vecarray[0],adr(width),4);
  If vecarray[1]<>NIL then CopyMem(vecarray[1],adr(height),4);
  If vecarray[2]<>NIL then CopyMem(vecarray[2],adr(depth),4);
  FreeArgs(rda);
 End;

 windowtags[0].ti_Tag:=WA_Width;
 windowtags[0].ti_Data:=200;
 windowtags[1].ti_Tag:=WA_Height;
 windowtags[1].ti_Data:=300;
 windowtags[2].ti_Tag:=WA_MinWidth;
 windowtags[2].ti_Data:=100;
 windowtags[3].ti_Tag:=WA_MinHeight;
 windowtags[3].ti_Data:=100;
 windowtags[4].ti_Tag:=WA_MaxWidth;
 windowtags[4].ti_Data:=-1;
 windowtags[5].ti_Tag:=WA_MaxHeight;
 windowtags[5].ti_Data:=-1;
 windowtags[6].ti_Tag:=WA_SimpleRefresh;
 windowtags[6].ti_Data:=Integer(TRUE);
 windowtags[7].ti_Tag:=WA_RMBTrap;
 windowtags[7].ti_Data:=Integer(TRUE);
 windowtags[8].ti_Tag:=WA_Activate;
 windowtags[8].ti_Data:=Integer(TRUE);
 windowtags[9].ti_Tag:=WA_CloseGadget;
 windowtags[9].ti_Data:=Integer(TRUE);
 windowtags[10].ti_Tag:=WA_DepthGadget;
 windowtags[10].ti_Data:=Integer(TRUE);
 windowtags[11].ti_Tag:=WA_DragBar;
 windowtags[11].ti_Data:=Integer(TRUE);
 windowtags[12].ti_Tag:=WA_SizeGadget;
 windowtags[12].ti_Data:=Integer(TRUE);
 windowtags[13].ti_Tag:=WA_SizeBBottom;
 windowtags[13].ti_Data:=Integer(TRUE);
 windowtags[14].ti_Tag:=WA_GimmeZeroZero;
 windowtags[14].ti_Data:=Integer(TRUE);
 windowtags[15].ti_Tag:=WA_ScreenTitle;
 windowtags[15].ti_Data:=Integer(ScreenTitle);
 windowtags[16].ti_Tag:=WA_IDCMP;
 windowtags[16].ti_Data:=IDCMP_RAWKEY+IDCMP_CLOSEWINDOW;
 windowtags[17].ti_Tag:=TAG_END;

 GFXBase:=OpenLibrary (gfxname,0);
 IF GFXBase<>Nil Then
 Begin
  P96Base:=OpenLibrary (P96NAME,0);
  If P96Base<>Nil Then
  Begin
   ptags[0].ti_Tag:=P96SA_Width;
   ptags[0].ti_Data:=Width;
   ptags[1].ti_Tag:=P96SA_Height;
   ptags[1].ti_Data:=Height;
   ptags[2].ti_Tag:=P96SA_Depth;
   ptags[2].ti_Data:=Depth;
   ptags[3].ti_Tag:=P96SA_AutoScroll;
   ptags[3].ti_Data:=Integer(TRUE);
   ptags[4].ti_Tag:=P96SA_Pens;
   ptags[4].ti_Data:=Integer(Adr(Pens));
   ptags[5].ti_Tag:=P96SA_Title;
   ptags[5].ti_Data:=Integer(ScreenTitle);
   ptags[6].ti_Tag:=TAG_DONE;

   sc:=p96OpenScreenTagList (Adr(ptags));
   If sc=Nil Then
    Writeln ("Unable to open screen.")
   Else
   Begin
    Dimensions[0]:=0;
    Dimensions[1]:=sc^.BarHeight+1;
    Dimensions[2]:=sc^.Width;
    Dimensions[3]:=sc^.Height-sc^.BarHeight-1;

    ptags[0].ti_Tag:=WA_CustomScreen;
    ptags[0].ti_Data:=Integer (sc);
    ptags[1].ti_Tag:=WA_Title;
    ptags[1].ti_Data:=Integer(W1Title);
    ptags[2].ti_Tag:=WA_Left;
    ptags[2].ti_Data:=(sc^.Width DIV 2-200) DIV 2+sc^.Width DIV 2;
    ptags[3].ti_Tag:=WA_Top;
    ptags[3].ti_Data:=(sc^.Height-sc^.BarHeight-300) DIV 2;
    ptags[4].ti_Tag:=WA_Zoom;
    ptags[4].ti_Data:=Integer(Adr(Dimensions));
    ptags[5].ti_Tag:=TAG_MORE;
    ptags[5].ti_Data:=Integer(Adr(WindowTags));

    wdp:=OpenWindowTagList (NIL,Adr(ptags));

    If wdp<>Nil Then
    Begin
     ptags[0].ti_Tag:=WA_CustomScreen;
     ptags[0].ti_Data:=Integer (sc);
     ptags[1].ti_Tag:=WA_Title;
     ptags[1].ti_Data:=Integer(W2Title);
     ptags[2].ti_Tag:=WA_Left;
     ptags[2].ti_Data:=(sc^.Width DIV 2-200) DIV 2;
     ptags[3].ti_Tag:=WA_Top;
     ptags[3].ti_Data:=(sc^.Height-sc^.BarHeight-300) DIV 2;
     ptags[4].ti_Tag:=WA_Zoom;
     ptags[4].ti_Data:=Integer(Adr(Dimensions));
     ptags[5].ti_Tag:=TAG_MORE;
     ptags[5].ti_Data:=Integer(Adr(WindowTags));

     wdf:=OpenWindowTagList (NIL,Adr(ptags));
     If wdf<>Nil Then
     Begin
      rpf:=wdf^.RPort;
      rpp:=wdp^.RPort;
      terminate:=False;
      signals:=((1 shl wdf^.UserPort^.mp_SigBit) or (1 shl wdp^.UserPort^.mp_SigBit));
      format:=RGBFTYPE (p96GetBitMapAttr (sc^.SRastPort.BitMap, P96BMA_RGBFORMAT));

      SelfSeed;

      Repeat
       x1:=RangeRandom (wdf^.Width);
       y1:=RangeRandom (wdf^.Height);
       x2:=RangeRandom (wdf^.Width);
       y2:=RangeRandom (wdf^.Height);
       If x2<x1 Then
       Begin
        x3:=x2;
        x2:=x1;
        x1:=x3;
       End;
       If y2<y1 Then
       Begin
        y3:=y2;
        y2:=y1;
        y1:=y3;
       End;

       x3:=RangeRandom (wdp^.Width);
       y3:=RangeRandom (wdp^.Height);

       If format=RGBFB_CLUT Then
       Begin
        SetAPen (rpf, RangeRandom (255));
        RectFill (rpf,x1,y1,x2,y2);

        SetAPen (rpp, RangeRandom (255));
        WritePixel (rpp,x3,y3);
       End
       Else
       Begin
        p96RectFill (rpf, x1, y1, x2, y2,(RangeRandom(255) shl 16)+(RangeRandom(255) shl 8)+(RangeRandom (255)));


        p96WritePixel (rpp, x3, y3, ((RangeRandom(255)) shl 16)+((RangeRandom(255)) shl 8)+(RangeRandom(255)));
       End;

       Repeat
        imsg:=Address(GetMsg (wdf^.UserPort));
        If imsg<>Nil Then
        Begin
         If ((imsg^.Class=IDCMP_CLOSEWINDOW) Or ((imsg^.Class=IDCMP_RAWKEY) And ((imsg^.Code=$40) or (imsg^.Code=$45)))) Then
          terminate:=True;
         ReplyMsg (Address(imsg));
        End;
       Until imsg=Nil;
       Repeat
        imsg:=Address(GetMsg (wdp^.UserPort));
        If imsg<>Nil Then
        Begin
         If ((imsg^.Class=IDCMP_CLOSEWINDOW) Or ((imsg^.Class=IDCMP_RAWKEY) And ((imsg^.Code=$40) or (imsg^.Code=$45)))) Then
          terminate:=True;
         ReplyMsg (Address(imsg));
        End;
       Until imsg=Nil;

      Until terminate;

      Forbid;
      Repeat
       msg:=GetMsg (wdf^.UserPort);
       If msg<>Nil Then
        ReplyMsg (msg);
      Until msg=Nil;
      Repeat
       msg:=GetMsg (wdp^.UserPort);
       If msg<>Nil Then
        ReplyMsg (msg);
      Until msg=Nil;
      Permit;

      CloseWindow (wdf);
     End
     Else
      Writeln ("Unable to open window 2.");
     CloseWindow (wdp);
    End
    Else
     Writeln ("Unable to open window 1.");

    p96CloseScreen (sc);
   End;

   CloseLibrary (GfxBase);
   CloseLibrary (P96Base);
  End
  Else
  Begin
   CloseLibrary (GfxBase);
   Writeln ("Unable to open Picasso96 library.");
  End;
 End
 Else
  Writeln ("Unable to open Gfx library.");
END.

