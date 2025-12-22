(*
(*  Amiga Oberon Interface Module:
**  $VER: NonVolatile.mod 40.15 (28.12.93) Oberon 3.0
**
**      (C) Copyright 1993 Commodore-Amiga, Inc.
**          All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993 by hartmut Goebel
*)          All Rights Reserved
*)

MODULE NonVolatile;

IMPORT
  e * := Exec,
  u * := Utility,
  SYSTEM;

CONST
  nonvolatileName * = "nonvolatile.library";


TYPE
  NVEntryPtr * = UNTRACED POINTER TO NVEntry;
  NVInfoPtr  * = UNTRACED POINTER TO NVInfo;

(*****************************************************************************)


  NVInfo * = STRUCT
    maxStorage  * :  LONGINT;
    freeStorage * :  LONGINT;
  END;


(*****************************************************************************)


  NVEntry * = STRUCT (node *:  e.MinNode);
    name       * :  e.LSTRPTR;
    size       * :  LONGINT;
    protection * :  LONGINT;
  END;

CONST
(* bit definitions for mask in SetNVProtection().  Also used for
 * NVEntry.nve_Protection.
 *)
  delete  * = 0;
  appName * = 31;

(*****************************************************************************)


(* errors from StoreNV() *)
  errBadName   * = 1;
  errWriteProt * = 2;
  errFail      * = 3;
  errFatal     * = 4;

TYPE
  DataPtr * = UNTRACED POINTER TO Data;
  Data * = STRUCT END;

(* $StackChk- $RangeChk- $NilChk- $OvflChk- $ReturnChk- $CaseChk- *)

VAR
  base *: e.LibraryPtr;

(*--- functions in V40 or higher (Release 3.1) ---*)
PROCEDURE GetCopyNV       *{base,-001EH}(appName{8}   : ARRAY OF CHAR;
                                         itemName{9}  : ARRAY OF CHAR;
                                         killReqs{1}  : e.LONGBOOL): DataPtr;
PROCEDURE FreeNVData      *{base,-0024H}(data{8}      : DataPtr);
PROCEDURE StoreNV         *{base,-002AH}(appName{8}   : ARRAY OF CHAR;
                                         itemName{9}  : ARRAY OF CHAR;
                                         data{10}     : DataPtr;
                                         length{0}    : LONGINT;
                                         killReqs{1}  : e.LONGBOOL): INTEGER;
PROCEDURE DeleteNV        *{base,-0030H}(appName{8}   : ARRAY OF CHAR;
                                         itemName{9}  : ARRAY OF CHAR;
                                         killReqs{1}  : e.LONGBOOL): BOOLEAN;
PROCEDURE GetNVInfo       *{base,-0036H}(killReqs{1}  : e.LONGBOOL): NVInfoPtr;
PROCEDURE GetNVList       *{base,-003CH}(appName{8}   : ARRAY OF CHAR;
                                         killReqs{1}  : e.LONGBOOL): e.MinListPtr;
PROCEDURE SetNVProtection *{base,-0042H}(appName{8}   : ARRAY OF CHAR;
                                         itemName{9}  : ARRAY OF CHAR;
                                         mask{2}      : LONGSET;
                                         killReqs{1}  : e.LONGBOOL): BOOLEAN;

(* determine the size of data returned by this library *)
PROCEDURE SizeNVData * (data{8}: DataPtr): LONGINT;
TYPE Size = UNTRACED POINTER TO LONGINT;
BEGIN
  RETURN SYSTEM.VAL(Size,SYSTEM.VAL(LONGINT,data)-SIZE(LONGINT))^-4;
END SizeNVData;

BEGIN
  base := e.OpenLibrary(nonvolatileName,40);

CLOSE
  IF base # NIL THEN e.CloseLibrary(base); END;

END NonVolatile.

