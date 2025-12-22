Program TestTag;

{$I "Include:Intuition/IntuitionBase.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Graphics/Graphics.i"}
{$I "Include:Libraries/GEngine.i"}
{$I "Include:Libraries/GE_TagItem.i"}
{$I "Include:Libraries/GE_classes.i"}
{$I "Include:Libraries/GE_imageclass.i"}

Const
 TAGSS: Array[0..3] of TagItem = ((TAG_USER+13,10),(TAG_USER+14,20),(TAG_USER+15,30),(TAG_DONE,0));

Var
 Tepun1,Tepun2: TagItemPtr;
 AVLH: Hook;
 Trees,TT:AVLNodePtr;
 a : short;

Begin
 GEngineBase:= GEBasePtr(OpenLibrary("gengine.library",0));
 if GEngineBase<>Nil then begin
  Tepun1 := @TAGSS;
  Tepun2 := Tepun1;
  Tepun2 := GE_NextTagItem(Tepun1);
  While Tepun2<>Nil do begin
   Writeln(Tepun2^.ti_Tag," ",Tepun2^.ti_Data);
   Tepun2 := GE_NextTagItem(Tepun1);
  end;
  Tepun1 := @TAGSS;
  Writeln(15,"->",GE_GetTagData(TAG_USER+15,15,Tepun1));
  Writeln(16,"->",GE_GetTagData(TAG_USER+16,-1,Tepun1));
  Writeln(14,"->",GE_GetTagData(TAG_USER+14,10,Tepun1));
  Writeln(13,"->",GE_GetTagData(TAG_USER+13,115,Tepun1));
  With AVLH do begin
	h_MinNode.mln_Succ:=Nil;
	h_MinNode.mln_Pred:=Nil;
	h_Entry:= Adr(HookEntry);
	h_SubEntry:= Adr(GE_AVLTest);
	h_Data:= Nil;
  end;
  Writeln("Tags OK..."); Readln(a);
  Trees:= GE_AVLInsert(Nil,35,@AVLH);
  if Trees<>Nil then begin
	Writeln("Tree created...");
	TT:=GE_AVLInsert(@Trees,25,@AVLH);
	TT:=GE_AVLInsert(@Trees,40,@AVLH);
	TT:= GE_AVLInsert(@Trees,0,@AVLH);
	TT:= GE_AVLInsert(@Trees,100,@AVLH);
	TT:= GE_AVLInsert(@Trees,50,@AVLH);
	Writeln("Max: ",GE_AVLMax(@Trees)^.an_Key);
	Writeln("Min: ",GE_AVLMin(@Trees)^.an_Key);
      Readln(a);
	Writeln("Remove Max...");
	if GE_AVLRemove(@Trees,100,@AVLH) then;
	Writeln("Max: ",GE_AVLMax(@Trees)^.an_Key);
	{Delete tree}
	if GE_AVLRemove(@Trees,40,@AVLH)then
	      Writeln("removed: ",40);
	if GE_AVLRemove(@Trees,25,@AVLH)then
	      Writeln("removed: ",25);
	if GE_AVLRemove(@Trees,0,@AVLH)then
	      Writeln("removed: ",0);
	if GE_AVLRemove(@Trees,35,@AVLH)then
	      Writeln("removed: ",35);
	if GE_AVLRemove(@Trees,50,@AVLH)then
	      Writeln("removed: ",50);
  end;
  Writeln(Trees=Nil);
  GEngineBase^.eb_ClassTree:= Nil;
  Writeln("\nAdding Root Class...");
  RClass:= GE_MakeClass("gerootClass",Nil,Nil,SizeOf(_GObject),0);
  if RClass<>Nil then begin
   Writeln("Done!!!    :-D");
   With RClass^.gc_dispatcher do begin {Init GERootClass dispatcher hook}
      h_MinNode.mln_Succ:=Nil;
      h_MinNode.mln_Pred:=Nil;
	h_Entry:= Adr(HookEntry);
	h_SubEntry:= Adr(_GERootHook);
	h_Data:= Nil;
   end;
   GE_AddClass(RClass);
   ReadLN(A);
   Writeln("Root added as public");
   RClass^.gc_Subclasscount:=0;
   IClass:= GE_MakeClass("gimageclass",NIL,RClass,SizeOf(Image),0);
   if IClass<>Nil then begin
    With IClass^.gc_dispatcher do begin {Init dispatcher hook}
     h_MinNode.mln_Succ:=Nil;
     h_MinNode.mln_Pred:=Nil;
     h_Entry:= Adr(HookEntry);
     h_SubEntry:= Adr(_GEImageHook);
     h_Data:= Nil;
    end;
    IClass^.gc_Subclasscount:=0;
    GE_AddClass(IClass);
    GE_RemoveClass(IClass);
    if GE_FreeClass(IClass) then;
    Writeln("Deleted IClass");
   end;
   Readln(A);
   GE_RemoveClass(RClass);
   Writeln("Removed RClass");
   if GE_FreeClass(RClass) then;
   Writeln("Deleted RClass");
  end;
  CloseLibrary(LibraryPtr(GEngineBase));
 end;
end.