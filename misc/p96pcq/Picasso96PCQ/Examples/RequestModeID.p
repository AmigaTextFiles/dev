Program RequestID;

{
    PCQ-Version des Picasso96-Demoprogrammes

    in Pascal übersetzt von Andreas Neumann
}

{ ***********************************************************************
  * This is example shows how to use p96RequestModeIDTagList()
  *
  * tabt (Sat Dec 28 03:44:35 1996)
  *********************************************************************** }

{$I "Include:exec/memory.i" }
{$I "Include:exec/libraries.i" }
{$I "Include:dos/RDArgs.i" }
{$I "Include:libraries/dosextens.i" }
{$I "Include:graphics/graphics.i" }
{$I "Include:graphics/displayinfo.i" }
{$I "Include:intuition/intuition.i" }
{$I "Include:utils/stringlib.i" }
{$I "Include:p96/Picasso96.i" }

Const
    gfxname     :   String = "graphics.library";
    WindowTitle :   String = "RequestModeID Test";
    template    :   String = "Width=W/N,Height=H/N,Depth=D/N";

    vecarray    :   Array[0..2] of Address = (Nil, Nil, Nil);

Var
    ptags       :   Array [0..32] Of TagItem;
    width,
    height,
    depth,
    DisplayID   :   Integer;
    dim         :   DimensionInfo;
    rda         :   RDArgsPtr;


Begin
 width:=640;
 height:=480;
 depth:=15;

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
   ptags[0].ti_Tag:=P96MA_MinWidth;
   ptags[0].ti_Data:=width;
   ptags[1].ti_Tag:=P96MA_MinHeight;
   ptags[1].ti_Data:=height;
   ptags[2].ti_Tag:=P96MA_MinDepth;
   ptags[2].ti_Data:=depth;
   ptags[3].ti_Tag:=P96MA_WindowTitle;
   ptags[3].ti_Data:=Integer(WindowTitle);
   ptags[4].ti_Tag:=P96MA_FormatsAllowed;
   ptags[4].ti_Data:=(RGBFF_CLUT or RGBFF_R5G6B5 or RGBFF_R8G8B8 or RGBFF_A8R8G8B8);
   ptags[5].ti_Tag:=TAG_DONE;
   DisplayID:=p96RequestModeIDTagList (Adr(ptags[0]));

   Writeln ("DisplayID:", DisplayID);
   If DisplayID<>INVALID_ID Then
   Begin
    If GetDisplayInfoData(Nil, Adr(dim),SizeOf(DimensionInfo),DTAG_DIMS,DisplayID)<>0 Then
     Writeln ("Dimensions: ",dim.Nominal.MaxX-dim.Nominal.MinX+1,"x",dim.Nominal.MaxY-dim.Nominal.MinY+1,"x",dim.MaxDepth)
    Else
     Writeln ("No Dimensioninfo.");
   End
   Else
    Writeln ("DisplayID invalid.");
   CloseLibrary(P96Base);
  End
  Else
   Writeln ("Unable to open Picasso96 library.");
  CloseLibrary (GfxBase);
 End;
End.
