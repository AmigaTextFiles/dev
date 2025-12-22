Program Test3;

{Test AVL Trees}

{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/memory.i"}
{$I "Include:Utils/GE_Hooks.i"}
{$I "Include:Libraries/GEngine.i"}
{$I "Include:Libraries/GE_AVL.i"}
{$I "Include:Libraries/GE_MemPools.i"}
{$I "Include:Intuition/IntuitionBase.i"}
{$I "Include:Libraries/GE_classes.i"}

var
 B1,B2,b3: Address;
 Trees,TT:AVLNodePtr;
 a:Integer;
 AVLH: Hook;
 {MemPool Hook structures}
 MPool:GE_MemPoolPtr;
 S1,S2,M1,M2:Integer;
 TClass: GEClassPtr;

{--------MAIN---------}

Begin
 GEngineBase:= GEBasePtr(OpenLibrary("gengine.library",0));
 if GEngineBase<>Nil then begin
  With AVLH do begin
	h_MinNode.mln_Succ:=Nil;
	h_MinNode.mln_Pred:=Nil;
	h_Entry:= Adr(HookEntry);
	h_SubEntry:= Adr(GE_AVLTest);
	h_Data:= Nil;
  end;
  CurrentTime(S1,M1);
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
  CurrentTime(S2,M2);
  Writeln("Time: ",S2-S1," Seconds, ",M2-M1," microsec.");
  Writeln("\nAhora probando Memory Pools...\n");
  MPool:= GE_NewMemPool(4096,MEMF_CLEAR+MEMF_PUBLIC,2);
  if MPool<>Nil then begin
	B1:= GE_PoolAlloc(MPool,4095);
	Write(MPool^.mp_MemFree," ");
	B1:= GE_PoolAlloc(MPool,4095);
	Write(MPool^.mp_MemFree," ");
      Write(Integer(B1)," ");
	B2:= GE_PoolAlloc(MPool,4095);
      Write(Integer(B2)," ");
	Write(MPool^.mp_MemFree," ");
	B3:= GE_PoolAlloc(MPool,4095);
      Writeln(Integer(B3));
	Write(MPool^.mp_MemFree," ");
	Write(MPool^.mp_MemTotal," ");
	GE_PoolDeAlloc(MPool,B2,4095);
	Write(MPool^.mp_MemTotal," ");
	GE_PoolDeAlloc(MPool,B1,4095);
	Write(MPool^.mp_MemTotal," ");
	GE_PoolDeAlloc(MPool,B3,4095);
	Writeln(MPool^.mp_MemTotal);
      Writeln("end");
	GE_FreeMemPool(MPool);
  end;
{Now Test Classes!!!}
    {With AVLSH1 do begin
	h_MinNode.mln_Succ:=Nil;
	h_MinNode.mln_Pred:=Nil;
	h_Entry:= Adr(HookEntry);
	h_SubEntry:= Adr(SComp1);
	h_Data:= Nil;
  end;
  With AVLSH2 do begin
	h_MinNode.mln_Succ:=Nil;
	h_MinNode.mln_Pred:=Nil;
	h_Entry:= Adr(HookEntry);
	h_SubEntry:= Adr(SComp2);
	h_Data:= Nil;
  end;}
  GEngineBase^.eb_ClassTree:= Nil;
  Writeln("\nAdding Root Class...");
  RClass:= GE_MakeClass("gerootClass",Nil,Nil,0,0);
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
   Writeln("Root added as public");
   RClass^.gc_Subclasscount:=0;
   TClass:= GE_MakeClass("TestClass","gerootclass",Nil,4,0);
   if TClass<>Nil then begin
    Writeln(TClass^.gc_SubclassCount);
    TClass^.gc_Subclasscount:=0;
    GE_AddClass(TClass);
    if not GE_FreeClass(RClass) then
     Writeln("Root has subclasses!");
    GE_RemoveClass(TClass);
    if GE_FreeClass(TClass) then
     Writeln("Test removed");
   end;
   GE_RemoveClass(RClass);
   if GE_FreeClass(RClass) then
    Writeln("Root Removed");
  end;
  CloseLibrary(LibraryPtr(GEngineBase));
 end;
end.