(*
(*
**  Amiga Oberon Interface Module:
**  $VER: RexxSysLib.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V40.15 by hartmut Goebel
*)
*)

MODULE RexxSysLib;

IMPORT e * := Exec,
       rx* := Rexx;

CONST
  rexxsysName * = "rexxsyslib.library";

VAR
  base * : rx.RxsLibPtr;

(*--- functions in V33 or higher (Release 1.2) ---*)
(*----------- Check 'base#NIL' BEFORE you use these ! -----------*)
PROCEDURE CreateArgstring * {base,-126}(string{8}: ARRAY OF CHAR;
                                        length{0}: LONGINT): e.LSTRPTR;
PROCEDURE DeleteArgstring * {base,-132}(argstring{8}: e.LSTRPTR);
PROCEDURE LengthArgstring * {base,-138}(argstring{8}: e.LSTRPTR): LONGINT;
PROCEDURE CreateRexxMsg   * {base,-144}(port{8}: e.MsgPortPtr;
                                        extension{9}: ARRAY OF CHAR;
                                        host{0}: ARRAY OF CHAR): rx.RexxMsgPtr;
PROCEDURE DeleteRexxMsg   * {base,-150}(packet{8}: rx.RexxMsgPtr);
PROCEDURE ClearRexxMsg    * {base,-156}(msgptr{8}: rx.RexxMsgPtr;
                                        count{0}: LONGINT);
PROCEDURE FillRexxMsg     * {base,-162}(msgptr{8}: rx.RexxMsgPtr;
                                        count{0}: LONGINT;
                                        mask{1}: SET): BOOLEAN;
PROCEDURE IsRexxMsg       * {base,-168}(msgptr{8}: rx.RexxMsgPtr): BOOLEAN;
PROCEDURE LockRexxBase    * {base,-450}(resource{0}: LONGINT);
PROCEDURE UnlockRexxBase  * {base,-456}(resource{0}: LONGINT);

BEGIN
  base := e.OpenLibrary(rexxsysName,33);

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END RexxSysLib.

