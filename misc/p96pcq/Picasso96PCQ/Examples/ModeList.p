Program ModeList;

{
    PCQ-Version des Picasso96-Demoprogrammes

    in Pascal übersetzt von Andreas Neumann
}


{ ***********************************************************************
  * This is example shows how to use p96AllocModeListTagList()
  *
  * tabt (Sat Dec 28 03:44:35 1996)
  *********************************************************************** }

{$I "Include:exec/memory.i" }
{$I "Include:exec/libraries.i" }
{$I "Include:dos/RDArgs.i" }
{$I "Include:libraries/dosextens.i" }
{$I "Include:utils/stringlib.i" }
{$I "Include:p96/Picasso96.i" }

Const
    template    :   String  =   "Width=W/N,Height=H/N,Depth=D/N";
    vecarray    :   Array[0..2] of Address = (Nil, Nil, Nil);

Var
        ml          :   ListPtr;
        width,
        height,
        depth       :   Integer;
        rda         :   RDArgsPtr;
        ptags       :   Array [0..32] Of TagItem;
        mn          :   ^P96Mode;

Begin
 P96Base:=OpenLibrary (P96Name,2);
 IF P96Base<>NIL Then
 Begin
  width:=640;
  height:=480;
  depth:=8;

  rda:=ReadArgs (template,Adr(vecarray),Nil);
  If rda<>Nil Then
  Begin
   If vecarray[0]<>NIL then CopyMem(vecarray[0],adr(width),4);
   If vecarray[1]<>NIL then CopyMem(vecarray[1],adr(height),4);
   If vecarray[2]<>NIL then CopyMem(vecarray[2],adr(depth),4);
   FreeArgs(rda);
  End;

  ptags[0].ti_Tag:=P96MA_MinWidth;
  ptags[0].ti_Data:=width;
  ptags[1].ti_Tag:=P96MA_MinHeight;
  ptags[1].ti_Data:=height;
  ptags[2].ti_Tag:=P96MA_MinDepth;
  ptags[2].ti_Data:=depth;
  ptags[3].ti_Tag:=TAG_DONE;
  ml:=p96AllocModeListTagList (Adr(ptags));
  If ml<>Nil Then
  Begin
   mn:=Address(ml^.lh_Head);
   If mn<>Nil Then
   Begin
    While mn^.Node.ln_Succ<>Nil Do
    Begin
     Writeln (mn^.Description);
     mn:=Address(mn^.Node.ln_Succ);
    End;
   End;
   p96FreeModeList(ml);
  End
  Else
   Writeln ("Unable to allocate list.");
  CloseLibrary(P96Base);
 End
 Else
  Writeln ("Unable to open Picasso96 library.");
End.
