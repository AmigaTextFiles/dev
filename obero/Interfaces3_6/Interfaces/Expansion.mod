(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Expansion.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Expansion;

IMPORT
  e * := Exec,
  d * := Dos,
  c * := Config;

CONST
  expansionName * = "expansion.library";

(* flags for the AddDosNode() call *)
  startProc * = 0;

TYPE

(* BootNodes are scanned by dos.library at startup.  Items found on the
   list are started by dos. BootNodes are added with the AddDosNode() or
   the V36 AddBootNode() calls. *)

  BootNodePtr * = UNTRACED POINTER TO BootNode;
  BootNode * = STRUCT (node* : e.Node)
    flags * : SET;
    deviceNode* : e.NodePtr;
  END;


(* expansion.library has functions to manipulate most of the information in
   ExpansionBase.  Direct access is not permitted.  Use FindConfigDev()
   to scan the board list. *)

  ExpansionBasePtr * = UNTRACED POINTER TO ExpansionBase;
  ExpansionBase * = STRUCT (libNode * : e.Library)
    flags     - : SHORTSET;         (* read only (see below) *)
    private01   : e.BYTE;           (* private *)
    private02   : LONGINT;          (* private *)
    private03   : LONGINT;          (* private *)
    private04   : c.CurrentBinding; (* private *)
    private05   : e.List;           (* private *)
    mountList * : e.List;           (* contains struct BootNode entries *)
    (* private *)
  END;

CONST

(* error codes *)
  ok          * = 0;
  lastBoard   * = 40;  (* could not shut him up *)
  noExpansion * = 41;  (* not enough expansion mem; board shut up *)
  noMemory    * = 42;  (* not enough normal memory *)
  noBoard     * = 43;  (* no board at that address *)
  badMem      * = 44;  (* tried to add bad memory card *)

(* Flags *)
  ebClogged    * = 0;       (* someone could not be shutup *)
  ebShortMem   * = 1;       (* ran out of expansion mem *)
  ebBadMem     * = 2;       (* tried to add bad memory card *)
  ebDosFlag    * = 3;       (* reserved for use by AmigaDOS *)
  ebKickBack33 * = 4;       (* reserved for use by AmigaDOS *)
  ebKickBack36 * = 5;       (* reserved for use by AmigaDOS *)
(* If the following flag is set by a floppy's bootblock code, the initial
   open of the initial shell window will be delayed until the first output
   to that shell.  Otherwise the 1.3 compatible behavior applies. *)
  ebSilentStart* = 6;


VAR
  base * : ExpansionBasePtr;

(*--- functions in V33 or higher (Release 1.2) ---*)
PROCEDURE AddConfigDev        *{base,- 30}(configDev{8}      : c.ConfigDevPtr);
(* ---   functions in V36 or higher  (Release 2.0)   --- *)
(* --- REMEMBER: You are to check the version BEFORE you use this ! --- *)
PROCEDURE AddBootNode         *{base,- 36}(bootPri{0}        : LONGINT;
                                           flags{1}          : LONGSET;
                                           deviceNode{8}     : d.DeviceNodePtr;
                                           configDev{9}      : c.ConfigDevPtr): BOOLEAN;
(*--- functions in V33 or higher (Release 1.2) ---*)
PROCEDURE AllocBoardMem       *{base,- 42}(slotSpec{0}       : LONGINT);
PROCEDURE AllocConfigDev      *{base,- 48}(): c.ConfigDevPtr;
PROCEDURE AllocExpansionMem   *{base,- 54}(numSlots{0}       : LONGINT;
                                           slotAlign{1}      : LONGINT): e.APTR;
PROCEDURE ConfigBoard         *{base,- 60}(board{8}          : e.APTR;
                                           configDev{9}      : c.ConfigDevPtr);
PROCEDURE ConfigChain         *{base,- 66}(baseAddr{8}       : e.APTR);
PROCEDURE FindConfigDev       *{base,- 72}(oldConfigDev{8}   : c.ConfigDevPtr;
                                           manufacturer{0}   : LONGINT;
                                           product{1}        : LONGINT): c.ConfigDevPtr;
PROCEDURE FreeBoardMem        *{base,- 78}(startSlot{0}      : LONGINT;
                                           slotSepc{1}       : LONGINT);
PROCEDURE FreeConfigDev       *{base,- 84}(configDev{8}      : c.ConfigDevPtr);
PROCEDURE FreeExpansionMem    *{base,- 90}(startSlot{0}      : LONGINT;
                                           numSlots{1}       : LONGINT);
PROCEDURE ReadExpansionByte   *{base,- 96}(board{8}          : e.APTR;
                                           offset{0}         : LONGINT): e.BYTE;
PROCEDURE ReadExpansionRom    *{base,-102}(board{8}          : e.APTR;
                                           configDev{9}      : c.ConfigDevPtr);
PROCEDURE RemConfigDev        *{base,-108}(configDev{8}      : c.ConfigDevPtr);
PROCEDURE WriteExpansionByte  *{base,-114}(board{8}          : e.APTR;
                                           offset{0}         : LONGINT;
                                           byte{1}           : e.BYTE);
PROCEDURE ObtainConfigBinding *{base,-120}();
PROCEDURE ReleaseConfigBinding*{base,-126}();
PROCEDURE SetCurrentBinding   *{base,-132}(currentBinding{8} : c.CurrentBindingPtr;
                                           size{0}           : LONGINT);
PROCEDURE GetCurrentBinding   *{base,-138}(currentBinding{8} : c.CurrentBindingPtr;
                                           bindingSize{0}    : LONGINT): LONGINT;
PROCEDURE MakeDosNode         *{base,-144}(parmPacket{8}     : e.APTR): d.DeviceNodePtr;
PROCEDURE AddDosNode          *{base,-150}(bootPri{0}        : LONGINT;
                                           flags{1}          : LONGSET;
                                           deviceNode{8}     : d.DeviceNodePtr): BOOLEAN;
(* ---   functions in V36 or higher  (Release 2.0)   --- *)
(* --- REMEMBER: You are to check the version BEFORE you use this ! --- *)
PROCEDURE ExpansionResrved26  *{base,-156}();
PROCEDURE WriteExpansionWord  *{base,-162}(board{8}          : e.APTR;
                                           offset{0}         : LONGINT;
                                           word{1}           : INTEGER);

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base :=   e.OpenLibrary(expansionName,33);
  IF base = NIL THEN HALT(d.fail) END;

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END Expansion.

