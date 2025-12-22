(* This module interfaces to the boopsi class "GetFile"  *)
(* which is © by Jaba Development                        *)

(* you must join or link with "boopsi.o" and "bases.o"   *)
MODULE GetFile;

IMPORT
  Intuition, Graphics, Utility, GadTools, Exec;

PROCEDURE InitGet {"initGet"} (): Intuition.IClassPtr;

VAR
  IntuitionBase ["_IntuitionBase"], GfxBase ["_GfxBase"],
  UtilityBase ["_UtilityBase"], GadToolsBase ["_GadToolsBase"]: Exec.LibraryPtr;

  GetFileClass*: Intuition.IClassPtr;

BEGIN
  IntuitionBase := Intuition.int;
  GfxBase       := Graphics.gfx;
  UtilityBase   := Utility.base;
  GadToolsBase  := GadTools.base;

  GetFileClass := InitGet ();
CLOSE
  IF GetFileClass # NIL THEN
    IF Intuition.FreeClass (GetFileClass) THEN END;
    GetFileClass := NIL;
  END;
END GetFile.
