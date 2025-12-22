
PROGRAM BestModeID;

{
    PCQ-Version des Picasso96-Demoprogrammes

    in Pascal übersetzt von Andreas Neumann
}


{ ***********************************************************************
  * This is example shows how to use p96BestModeIDTagList()
  *
  * tabt (Mon Aug 28 14:07:40 1995)
  ***********************************************************************   }

{$I "Include:exec/memory.i" }
{$I "Include:exec/libraries.i" }
{$I "Include:dos/RDArgs.i" }
{$I "Include:graphics/modeid.i" }
{$I "Include:graphics/graphics.i" }
{$I "Include:utils/stringlib.i" }
{$I "Include:p96/Picasso96.i" }

Const
    gfxname     :   String  =   "graphics.library";
    template    :   String  =    "Width=W/N,Height=H/N,Depth=D/N";
    vecarray    :   Array[0..2] of Address = (Nil, Nil, Nil);

    fmtstrings  :   Array [1..(Ord(RGBFB_MaxFormats)-2)] OF String = (
                                                                  "RGBFB_NONE",
                                                                  "RGBFB_CLUT",
                                                                  "RGBFB_R8G8B8",
                                                                  "RGBFB_B8G8R8",
                                                                  "RGBFB_R5G6B5PC",
                                                                  "RGBFB_R5G5B5PC",
                                                                  "RGBFB_A8R8G8B8",
                                                                  "RGBFB_A8B8G8R8",
                                                                  "RGBFB_R8G8B8A8",
                                                                  "RGBFB_B8G8R8A8",
                                                                  "RGBFB_R5G6B5",
                                                                  "RGBFB_R5G5B5",
                                                                  "RGBFB_B5G6R5PC",
                                                                  "RGBFB_B5G5R5PC"
                                                                 );
Var
        DisplayID,
        width,
        height,
        depth       :   Integer;
        args        :   Array [1..3] Of Array [0..80] Of Char;
        ptags       :   Array [0..32] Of TagItem;
        rda         :   RDArgsPtr;

Begin
 GfxBase:=OpenLibrary (gfxname,0);
 If GfxBase<>Nil Then
 Begin
  P96Base:=OpenLibrary (P96Name,2);
  If P96Base<>Nil Then
  Begin
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

   ptags[0].ti_Tag:=P96BIDTAG_NominalWidth;
   ptags[0].ti_Data:=width;
   ptags[1].ti_Tag:=P96BIDTAG_NominalHeight;
   ptags[1].ti_Data:=height;
   ptags[2].ti_Tag:=P96BIDTAG_Depth;
   ptags[2].ti_Data:=depth;
   ptags[3].ti_Tag:=P96BIDTAG_FormatsForbidden;
   ptags[3].ti_Data:=(RGBFF_R5G5B5 or RGBFF_R5G5B5PC or RGBFF_B5G5R5PC);
   ptags[4].ti_Tag:=TAG_DONE;

   DisplayID:=p96BestModeIDTagList(Adr(ptags));
   If DisplayID>0 Then
   Begin
    Writeln ("DisplayID: ", DisplayID);
    If DisplayID<>INVALID_ID Then
    Begin
     Writeln ("Width: ", p96GetModeIDAttr(DisplayID, P96IDA_WIDTH));
     Writeln ("Height: ", p96GetModeIDAttr(DisplayID, P96IDA_HEIGHT));
     Writeln ("Depth: ", p96GetModeIDAttr(DisplayID, P96IDA_DEPTH));
     Writeln ("BytesPerPixel: ", p96GetModeIDAttr(DisplayID, P96IDA_BYTESPERPIXEL));
     Writeln ("BitsPerPixel: ", p96GetModeIDAttr(DisplayID, P96IDA_BITSPERPIXEL));
     Writeln ("RGBFormat: ", fmtstrings[p96GetModeIDAttr(DisplayID,P96IDA_RGBFORMAT)+1]);
     If p96GetModeIDAttr(DisplayID, P96IDA_ISP96)<>0 Then
      Writeln ("Is P96: yes")
     Else
      Writeln ("Is P96: no");
    End;
   End
   Else
    Writeln ("DisplayID is 0.");
   CloseLibrary (P96Base);
  End
  Else
   Writeln ("Unable to open Picasso96 library.");
  CloseLibrary (GfxBase);
 End;

End.

