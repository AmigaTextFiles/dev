Program OpenPIP;

{
    PCQ-Version des Picasso96-Demoprogrammes

    in Pascal übersetzt von Andreas Neumann
}

{ ***********************************************************************
  * This is an example that shows how to open a p96 PIP Window
  * to get input events and how to paint in that window.
  *
  *********************************************************************** }

{$I "Include:exec/memory.i" }
{$I "Include:exec/libraries.i" }
{$I "Include:dos/RDArgs.i" }
{$I "Include:libraries/dosextens.i" }
{$I "Include:graphics/graphics.i" }
{$I "Include:graphics/pens.i" }
{$I "Include:intuition/intuition.i" }
{$I "Include:utils/stringlib.i" }
{$I "Include:p96/Picasso96.i" }


Const
        WB          :   String = "Workbench";
        gfxname     :   String = "graphics.library";
        WDTitle     :   String = "Picasso96 API PIP Test";
        template    :   String = "Width=W/N,Height=H/N,Pubscreen=PS/K";
        vecarray    :   Array[0..2] of Address = (Nil, Nil, Nil);

Var
        PubScreenName   :   Array [0..80] Of Char;
        i,
        height,
        width           :   Integer;
        wd              :   WindowPtr;
        imsg            :   IntuiMessagePtr;
        goahead         :   Boolean;
        rp              :   RastPortPtr;
        ptags           :   Array [0..32] Of TagItem;
        x,
        y               :   Short;
        rda             :   RDArgsPtr;


Begin
 width:=256;
 height:=256;
 StrCpy (Adr(PubScreenName),WB);

 rda:=ReadArgs (template,Adr(vecarray),Nil);
 If rda<>Nil Then
 Begin
  If vecarray[0]<>NIL then CopyMem(vecarray[0],adr(width),4);
  If vecarray[1]<>NIL then CopyMem(vecarray[1],adr(height),4);
  If vecarray[2]<>NIL then StrCpy(adr(PubScreenName),vecarray[2]);
  FreeArgs(rda);
 End;

 GfxBase:=OpenLibrary (gfxname,0);
 If GfxBase<>Nil Then
 Begin
  P96Base:=OpenLibrary (P96Name,2);
  If P96Base<>Nil Then
  Begin
   ptags[0].ti_Tag:=P96PIP_SourceFormat;
   ptags[0].ti_Data:=RGBFB_R5G5B5;
   ptags[1].ti_Tag:=P96PIP_SourceWidth;
   ptags[1].ti_Data:=256;
   ptags[2].ti_Tag:=P96PIP_SourceHeight;
   ptags[2].ti_Data:=256;
   ptags[3].ti_Tag:=WA_Title;
   ptags[3].ti_Data:=Integer(WDTitle);
   ptags[4].ti_Tag:=WA_Activate;
   ptags[4].ti_Data:=Integer(TRUE);
   ptags[5].ti_Tag:=WA_RMBTrap;
   ptags[5].ti_Data:=Integer(TRUE);
   ptags[6].ti_Tag:=WA_Width;
   ptags[6].ti_Data:=Width;
   ptags[7].ti_Tag:=WA_Height;
   ptags[7].ti_Data:=Height;
   ptags[8].ti_Tag:=WA_DragBar;
   ptags[8].ti_Data:=Integer(TRUE);
   ptags[9].ti_Tag:=WA_DepthGadget;
   ptags[9].ti_Data:=Integer(TRUE);
   ptags[10].ti_Tag:=WA_SimpleRefresh;
   ptags[10].ti_Data:=Integer(TRUE);
   ptags[11].ti_Tag:=WA_SizeGadget;
   ptags[11].ti_Data:=Integer(TRUE);
   ptags[12].ti_Tag:=WA_CloseGadget;
   ptags[12].ti_Data:=Integer(TRUE);
   ptags[13].ti_Tag:=WA_IDCMP;
   ptags[13].ti_Data:=IDCMP_CLOSEWINDOW;
   ptags[14].ti_Tag:=WA_PubScreenName;
   ptags[14].ti_Data:=Integer(Adr(PubScreenName));
   ptags[15].ti_Tag:=TAG_DONE;
   wd:=p96PIP_OpenTagList (Adr(ptags));
   If wd<>Nil Then
   Begin
    goahead:=True;
    rp:=Nil;
    ptags[0].ti_Tag:=P96PIP_SourceRPort;
    ptags[0].ti_Data:=Integer(Adr(rp));
    ptags[1].ti_Tag:=TAG_END;
    p96PIP_GetTagList (wd,Adr(ptags));
    If rp<>Nil Then
    Begin
     For y:=0 To (Height-1) Do
      For x:=0 To (Width-1) Do
       p96WritePixel (rp,x,y,(x*256+y)*256);
    End
    Else
     Writeln ("No PIP rastport.");
    While goahead Do
    Begin
     WaitPort (wd^.UserPort);
     imsg:=p96PIP_GetIMsg (wd^.UserPort);
     While imsg<>Nil Do
     Begin
      If imsg^.Class=IDCMP_CLOSEWINDOW Then
       goahead:=False;
      p96PIP_ReplyIMsg (imsg);
      imsg:=p96PIP_GetIMsg (wd^.UserPort);
     End;
    End;
    p96PIP_Close(wd);
   End
   Else
    Writeln ("Unable to open PIP.");
   CloseLibrary (P96Base);
  End
  Else
   Writeln ("Unable to open Picasso96 library.");
  CloseLibrary (GfxBase);
 End;
End.
