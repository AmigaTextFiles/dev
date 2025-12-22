(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Translator.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Translator;

IMPORT e * := Exec;

CONST
  translatorName * = "translator.library";

(* Translator error return codes *)

  notUsed   * = -1;  (* This is an oft used system rc  *)
  noMem     * = -2;  (* Can't allocate memory          *)
  makeBad   * = -4;  (* Error in MakeLibrary call      *)

VAR
  base * : e.LibraryPtr;

PROCEDURE Translate *{base,- 30}(inputString{8}      : ARRAY OF CHAR;
                                 inputLength{0}      : LONGINT;
                                 VAR outputBuffer{9} : ARRAY OF CHAR;
                                 bufferSize{1}       : LONGINT): LONGINT;

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
 base := e.OpenLibrary(translatorName,33);
 IF base=NIL THEN HALT(20) END;

CLOSE
 IF base#NIL THEN e.CloseLibrary(base) END;

END Translator.

