(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Icon.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V40 by hartmut Goebel
*)
*)

MODULE Icon;

IMPORT
  e  * := Exec,
  wb * := Workbench;

CONST
  iconName * = "icon.library";

VAR
  base * : e.LibraryPtr;

(*  next two are OBSOLETE and have been removed *)
PROCEDURE GetIcon          {base,- 42}(name{8}        : ARRAY OF CHAR;
                                       icon{9}        : wb.DiskObjectPtr;
                                       freelist{10}   : wb.FreeListPtr): LONGINT;
PROCEDURE PutIcon          {base,- 48}(name{8}        : ARRAY OF CHAR;
                                       icon{9}        : wb.DiskObjectPtr): BOOLEAN;

PROCEDURE FreeFreeList    *{base,- 54}(freelist{8}    : wb.FreeListPtr);
PROCEDURE AddFreeList     *{base,- 72}(freelist{8}    : wb.FreeListPtr;
                                       mem{9}         : e.APTR;
                                       size{10}       : LONGINT): BOOLEAN;
PROCEDURE GetDiskObject   *{base,- 78}(name{8}        : ARRAY OF CHAR): wb.DiskObjectPtr;
PROCEDURE PutDiskObject   *{base,- 84}(name{8}        : ARRAY OF CHAR;
                                       diskobj{9}     : wb.DiskObjectPtr): BOOLEAN;
PROCEDURE FreeDiskObject  *{base,- 90}(diskobj{8}     : wb.DiskObjectPtr);
PROCEDURE FindToolType    *{base,- 96}(toolTypes{8}   : e.APTR;
                                       typeName{9}    : ARRAY OF CHAR): e.LSTRPTR;
PROCEDURE MatchToolValue  *{base,-102}(typeString{8}  : ARRAY OF CHAR;
                                       val{9}         : ARRAY OF CHAR): BOOLEAN;
PROCEDURE BumpRevision    *{base,-108}(VAR newname{8} : ARRAY OF CHAR;
                                       oldname{9}     : ARRAY OF CHAR);

(* ---   functions in V36 or higher  (Release 2.0)   --- *)
(* --- REMEMBER: You are to check the version BEFORE you use this ! --- *)
(*      Use DiskObjects instead of obsolete WBObjects            *)
PROCEDURE GetDefDiskObject*{base,-120}(type{0}        : LONGINT): wb.DiskObjectPtr;
PROCEDURE PutDefDiskObject*{base,-126}(diskObject{8}  : wb.DiskObjectPtr): BOOLEAN;
PROCEDURE GetDiskObjectNew*{base,-132}(name{8}        : ARRAY OF CHAR): wb.DiskObjectPtr;
(* ---   functions in V37 or higher   --- *)
PROCEDURE DeleteDiskObject*{base,-138}(name{8}        : ARRAY OF CHAR): BOOLEAN;

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base :=   e.OpenLibrary(iconName,33);
  IF base=NIL THEN HALT(20) END;

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END Icon.

