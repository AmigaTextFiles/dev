(*
(*
**  Amiga Oberon Interface Module:
**  $VER: KeyMap.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE KeyMap;  (* $Implementation- *)

IMPORT e  * := Exec,
       ie * := InputEvent;

TYPE

  KeyMapPtr * = UNTRACED POINTER TO KeyMap;
  KeyMap * = STRUCT
    loKeyMapTypes * : UNTRACED POINTER TO ARRAY 64 OF SHORTSET;
    loKeyMap      * : UNTRACED POINTER TO ARRAY 64 OF LONGINT;   (* or: ... OF ARRAY 4 OF CHAR; *)
    loCapsable    * : UNTRACED POINTER TO ARRAY  8 OF SHORTSET;
    loRepeatable  * : UNTRACED POINTER TO ARRAY  8 OF SHORTSET;
    hiKeyMapTypes * : UNTRACED POINTER TO ARRAY 64 OF SHORTSET;
    hiKeyMap      * : UNTRACED POINTER TO ARRAY 64 OF LONGINT;   (* or: ... OF ARRAY 4 OF CHAR; *)
    hiCapsable    * : UNTRACED POINTER TO ARRAY  8 OF SHORTSET;
    hiRepeatable  * : UNTRACED POINTER TO ARRAY  8 OF SHORTSET;
  END;

  KeyMapNodePtr * = UNTRACED POINTER TO KeyMapNode;
  KeyMapNode * = STRUCT (node * : e.Node) (* including name of keymap *)
    keyMap * : KeyMap;
  END;


(* the structure of keymap.resource *)
  KeyMapResourcePtr * = UNTRACED POINTER TO KeyMapResource;
  KeyMapResource * = STRUCT (node * : e.Node)
    list * : e.List;        (* a list of KeyMapNodes *)
  END;

CONST

(* Key Map Types *)
  shift   * = 0;
  alt     * = 1;
  control * = 2;
  downup  * = 3;

  dead    * = 5;          (* may be dead or modified by dead key: *)
                          (*   use dead prefix bytes              *)
  string  * = 6;

  nop     * = 7;

  noQual  * = SHORTSET{};
  vanilla * = -SHORTSET{shift,alt,control};   (* note that SHIFT+ALT+CTRL is VANILLA *)

(* Dead Prefix Bytes *)
  dpbMod          * = 0;
  dpbDead         * = 3;

  dp2dIndexMask   * = 00FH;   (* mask for index for 1st of two dead keys *)
  dp2dFacShift    * = 4;      (* shift for factor for 1st of two dead keys *)


END KeyMap.

