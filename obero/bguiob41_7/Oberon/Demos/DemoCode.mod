(*------------------------------------------
  :
  :Module.      DemoCode.mod
  :Author.      Larry Kuhns [lak]
  :Address.     Cortland, Ohio
  :Revision.    $VER 0.0
  :Date.        02-Dec-1996
  :Copyright.   NONE
  :Language.    Oberon-2
  :Translator.  Amiga Oberon V3.11d (Converted to English)
  :Contents.
  :Imports.     AmigaOberon Amiga interface modules
  :Remarks.     BGUI user notification for demos
  :Bugs.        None Known
  :Usage.
  :History.     0.0    [lak] 02-Dec-1996 : Initial Release for BGUI
  :                                        Library V41.7
  :
--------------------------------------------*)

MODULE DemoCode;
(*
 * DEMOCODE.H
 *
 * (C) Copyright 1995 Jaba Development.
 * (C) Copyright 1995 Jan van den Baard.
 *     All Rights Reserved.
 *
 *     Oberon Conversion - Larry Kuhns   12/01/96
 *       - Replaced console notification with a requester
 *)

IMPORT
  b   := Bgui,
  e   := Exec,
  i   := Intuition,
  u   := Utility,
  y   := SYSTEM;


CONST
  defaultFlags = LONGSET{ b.reqfCenterWindow, b.reqfLockWindow, b.reqfAutoAspect, b.reqfFastKeys };

  defaultReq *= b.request( defaultFlags,      (* Flags *)
                           NIL,               (* Title *)
                           y.ADR( "*_OK" ),   (* Response Gadgets   *)
                           NIL,               (* Text format string *)
                           b.posCenterMouse,  (* Requester position on screen *)
                           NIL,               (* Requester font *)
                           '_',               (* Underscore character *)
                           0,0,0,             (* Reserved0 *)
                           NIL,               (* Default Public Screen *)
                           0,0,0,0 );         (* Reserved1 *)

(*
 * Output text to a requester
 *)


PROCEDURE Request * ( win      : i.WindowPtr;
                      str,
                      title,
                      gads     : e.LSTRPTR;
                      flags    : LONGSET ) : LONGINT;
  VAR
    req : b.request;
  BEGIN
    req:= defaultReq;
    IF flags # LONGSET{} THEN req.flags:=        flags END;
    IF gads  # NIL       THEN req.gadgetFormat:= gads  END;
    IF title # NIL       THEN req.title:=        title END;
    req.textFormat:= str;
    RETURN b.Request( win, y.ADR( req ), NIL );
  END Request;


  PROCEDURE Tell * ( win : i.WindowPtr; str : ARRAY OF CHAR );
  VAR
    rc : LONGINT;
    (* $CopyArrays- *)
  BEGIN
    rc:= Request( win, y.ADR( str ), NIL, NIL, LONGSET{} );
  END Tell;


BEGIN
END DemoCode.
