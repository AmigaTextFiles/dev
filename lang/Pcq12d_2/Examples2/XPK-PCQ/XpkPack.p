Program XpkPack;

{ XpkPack 1995 by Andreas Tetzl }

{$I "Include:Libraries/xpk.i"}
{$I "Include:Utils/TagUtils.i"}
{$I "Include:Utility/Utility.i"}
{$I "Include:Utility/Hooks.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Utils/Parameters.i"}

VAR TagList : Address;
    res : Integer;
    err : String;
    arg1, arg2, arg3 : String;
    ChunkHook : Hook;
    prog : XpkProgressPtr;

PROCEDURE CleanExit(Why : String; RC : Integer);
BEGIN
 If XpkMasterBase<>NIL then CloseLibrary(XpkMasterBase);
 If UtilityBase<>NIL then CloseLibrary(UtilityBase);
 If Why<>NIL then Writeln(Why);
 Exit(RC);
END;

FUNCTION ChunkFunc : Integer;
BEGIN
 {$A    move.l  a1,_prog    }
 Write("\r",prog^.packername,": ",prog^.done,"% done");
 ChunkFunc:=0;
END;

BEGIN
 arg1:=AllocString(50);
 arg2:=AllocString(50);
 arg3:=AllocString(50);
 err:=AllocString(XPKERRMSGSIZE);

 GetParam(1,arg1);
 GetParam(2,arg2);
 GetParam(3,arg3);

 If (StrEq(arg1,"")) or (StrEq(arg1,"?")) then CleanExit("XpkPack inname outname method",0);

 UtilityBase:=OpenLibrary("utility.library",0);
 If UtilityBase=NIL then CleanExit("Can't opne utility.library",20);

 XpkMasterBase:=OpenLibrary(XPKNAME,0);
 If XpkMasterBase=NIL then CleanExit("Can't open XpkMaster.library",10);

 ChunkHook.h_entry:=adr(ChunkFunc);
 TagList:=CreateTagList(xpk_InName,arg1,
                        xpk_OutName,arg2,
                        xpk_FindMethod,arg3,
                        xpk_GetError,err,
                        xpk_ChunkHook,adr(ChunkHook),
                        xpk_NoClobber,TRUE);
 res:=XpkPack(TagList);
 FreeTagItems(TagList);
 Writeln;
 If res<>XPKERR_OK then CleanExit(err,10);

 CleanExit(NIL,0);
END.
