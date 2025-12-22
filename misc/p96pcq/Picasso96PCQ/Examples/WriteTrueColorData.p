Program WriteTrueColorData;

{
    PCQ-Version des Picasso96-Demoprogrammes

    in Pascal übersetzt von Andreas Neumann
}

{ ***********************************************************************
  * This is an example that shows how to use p96WriteTrueColorData
  * Program terminates when space bar or any mouse button is pressed!
  *
  * alx (Mon Dec 30 12:09:35 1996)
  *********************************************************************** }

{$I "Include:exec/libraries.i" }
{$I "Include:exec/memory.i" }
{$I "Include:dos/dos.i" }
{$I "Include:dos/RDArgs.i" }
{$I "Include:graphics/graphics.i" }
{$I "Include:intuition/intuition.i" }
{$I "Include:intuition/screens.i" }
{$I "Include:utils/stringlib.i" }
{$I "Include:utils/parameters.i" }
{$I "Include:p96/Picasso96.i" }

Const
    DataWidth   =   160;
    DataHeight  =   160;

    gfxname     :   String = "graphics.library";
    ScreenTitle :   String = "WriteTrueColorData Test";
    template    :   String = "Width=W/N,Height=H/N,Depth=D/N";

    vecarray    :   Array[0..2] of Address = (Nil, Nil, Nil);

Var
    rda         :   RDArgsPtr;

{ p96WriteTrueColorData only works on True- and HiColorModes }

Const
    HiColorFormats      =   (RGBFF_R5G6B5 or RGBFF_R5G5B5 or RGBFF_R5G6B5PC or RGBFF_R5G5B5PC or RGBFF_B5G6R5PC or RGBFF_B5G5R5PC);
    TrueColorFormats    =   (RGBFF_R8G8B8 or RGBFF_B8G8R8);
    TrueAlphaFormats    =   (RGBFF_R8G8B8A8 or RGBFF_B8G8R8A8 or RGBFF_A8R8G8B8 or RGBFF_A8B8G8R8);
    UsefulFormats       =   (HiColorFormats or TrueColorFormats or TrueAlphaFormats);

    Pens    :   Array [0..0] Of Short = (NOT(0));

Var
    sc          :   ScreenPtr;
    win         :   WindowPtr;
    i,
    DisplayID   :   Integer;
    width,
    height,
    depth       :   Integer;
    ptags       :   Array [0..32] Of TagItem;
    quit        :   Boolean;
    reddata,
    greendata,
    bluedata    :   Address;
    tci         :   TrueColorInfo;
    fh          :   FileHandle;
    imsg        :   IntuiMessagePtr;
    WB          :   WBStartupPtr;


Begin

 WB:=GetStartupMsg;
 If WB<>Nil Then
  If CurrentDir (WB^.sm_ArgList^[1].wa_Lock)=NIL Then ;

 width:=640;
 height:=480;
 depth:=24;

 rda:=ReadArgs (template,Adr(vecarray),Nil);
 If rda<>Nil Then
 Begin
  If vecarray[0]<>NIL then CopyMem(vecarray[0],adr(width),4);
  If vecarray[1]<>NIL then CopyMem(vecarray[1],adr(height),4);
  If vecarray[2]<>NIL then CopyMem(vecarray[2],adr(depth),4);
  FreeArgs(rda);
 End;

 GfxBase:=OpenLibrary (gfxname,0);
 If GfxBase<>Nil Then
 Begin
  P96Base:=OpenLibrary (P96Name,2);
  If P96Base<>Nil Then
  Begin
   ptags[0].ti_Tag:=P96BIDTAG_NominalWidth;
   ptags[0].ti_Data:=width;
   ptags[1].ti_Tag:=P96BIDTAG_NominalHeight;
   ptags[1].ti_Data:=height;
   ptags[2].ti_Tag:=P96BIDTAG_Depth;
   ptags[2].ti_Data:=depth;
   ptags[3].ti_Tag:=P96BIDTAG_FormatsAllowed;
   ptags[3].ti_Data:=UsefulFormats;
   ptags[4].ti_Tag:=TAG_DONE;
   DisplayID:=p96BestModeIDTagList (Adr(ptags));
   ptags[0].ti_Tag:=P96SA_DisplayID;
   ptags[0].ti_Data:=DisplayID;
   ptags[1].ti_Tag:=P96SA_Width;
   ptags[1].ti_Data:=width;
   ptags[2].ti_Tag:=P96SA_Height;
   ptags[2].ti_Data:=height;
   ptags[3].ti_Tag:=P96SA_Depth;
   ptags[3].ti_Data:=depth;
   ptags[4].ti_Tag:=P96SA_AutoScroll;
   ptags[4].ti_Data:=TRUE;
   ptags[5].ti_Tag:=P96SA_Pens;
   ptags[5].ti_Data:=Integer(Adr(Pens));
   ptags[6].ti_Tag:=P96SA_Title;
   ptags[6].ti_Data:=Integer(ScreenTitle);
   ptags[7].ti_Tag:=TAG_DONE;
   sc:=p96OpenScreenTagList (Adr(ptags));
   If sc<>Nil Then
   Begin
    ptags[0].ti_Tag:=WA_CustomScreen;
    ptags[0].ti_Data:=Integer(sc);
    ptags[1].ti_Tag:=WA_Backdrop;
    ptags[1].ti_Data:=Integer(True);
    ptags[2].ti_Tag:=WA_Borderless;
    ptags[2].ti_Data:=Integer(True);
    ptags[3].ti_Tag:=WA_SimpleRefresh;
    ptags[3].ti_Data:=Integer(True);
    ptags[4].ti_Tag:=WA_RMBTrap;
    ptags[4].ti_Data:=Integer(True);
    ptags[5].ti_Tag:=WA_Activate;
    ptags[5].ti_Data:=Integer(True);
    ptags[6].ti_Tag:=WA_IDCMP;
    ptags[6].ti_Data:=IDCMP_RAWKEY or IDCMP_MOUSEBUTTONS;
    ptags[7].ti_Tag:=TAG_END;

    win:=OpenWindowTagList (Nil,Adr(ptags));
    If win<>Nil Then
    Begin

     quit:=False;
     reddata:=AllocVec(DataWidth*DataHeight, MEMF_ANY);
     greendata:=AllocVec(DataWidth*DataHeight, MEMF_ANY);
     bluedata:=AllocVec(DataWidth*DataHeight, MEMF_ANY);
     If (reddata<>Nil) And (greendata<>Nil) And (bluedata<>Nil) Then
     Begin
      tci.PixelDistance:=1;
      tci.BytesPerRow:=DataWidth;
      tci.RedData:=reddata;
      tci.GreenData:=greendata;
      tci.BlueData:=bluedata;

      fh:=DOSOpen ("Symbol.red",MODE_OLDFILE);
      If fh<>Nil Then
      Begin
       i:=DOSRead(fh, reddata, DataWidth*DataHeight);
       DOSClose(fh);
      End;

      fh:=DOSOpen ("Symbol.green",MODE_OLDFILE);
      If fh<>Nil Then
      Begin
       i:=DOSRead(fh, greendata, DataWidth*DataHeight);
       DOSClose(fh);
      End;

      fh:=DOSOpen ("Symbol.blue",MODE_OLDFILE);
      If fh<>Nil Then
      Begin
       i:=DOSRead(fh, bluedata, DataWidth*DataHeight);
       DOSClose(fh);
      End;

      { paint something on the screen }

      p96WriteTrueColorData(Adr(tci),0,0,win^.RPort,50,50,DataWidth,DataHeight);

     End;

     FreeVec(reddata);
     FreeVec(greendata);
     FreeVec(bluedata);

     { wait for input }

     While Not(quit) Do
     Begin

      WaitPort(win^.UserPort);
      imsg:=Address(GetMsg (win^.UserPort));

      While(imsg<>Nil) Do
      Begin
       If ((imsg^.Class=IDCMP_MOUSEBUTTONS) or ((imsg^.Class=IDCMP_RAWKEY) And (imsg^.Code=$40))) Then
       Begin
        { press MOUSEBUTTONS or SPACE bar to end program }
        quit:=True;
       End;
       ReplyMsg(Address(imsg));
       imsg:=Address(GetMsg (win^.UserPort));
      End;
     End;

     CloseWindow(win);
    End
    Else
     Writeln ("Unable to open window.");
    p96CloseScreen(sc);
   End
   Else
    Writeln ("Unable to open screen.");
   CloseLibrary(P96Base);
  End
  Else
   Writeln ("Unable to open Picasso96 library.");
  CloseLibrary (GfxBase);
 End;
End.
