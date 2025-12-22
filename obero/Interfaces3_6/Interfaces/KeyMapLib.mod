(*
(*
**  Amiga Oberon Interface Module:
**  $VER: KeyMapLib.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE KeyMapLib;

IMPORT
  e  * := Exec,
  ie * := InputEvent,
  km * := KeyMap;

CONST
  keyMapName * = "keymap.library";

VAR

  base * : e.LibraryPtr;  (* check base#NIL before you use any function! *)

(* ---   functions in V36 or higher  (Release 2.0)   --- *)
(* --- REMEMBER: You are to check the version BEFORE you use this ! --- *)

PROCEDURE SetKeyMapDefault*{base,-30}(keyMap{8}     : km.KeyMapPtr);
PROCEDURE AskKeyMapDefault*{base,-36}(): km.KeyMapPtr;
PROCEDURE MapRawKey       *{base,-42}(event{8}      : ie.InputEventDummyPtr;
                                      VAR buffer{9} : ARRAY OF CHAR;
                                      length{1}     : LONGINT;
                                      keyMap{10}    : km.KeyMapPtr): INTEGER;
PROCEDURE MapANSI         *{base,-48}(string{8}     : ARRAY OF CHAR;
                                      count{0}      : LONGINT;
                                      VAR buffer{9} : ARRAY OF CHAR;
                                      length{1}     : LONGINT;
                                      keyMap{10}    : km.KeyMapPtr): LONGINT;


BEGIN
  base :=  e.OpenLibrary(keyMapName,37);
CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;
END KeyMapLib.

