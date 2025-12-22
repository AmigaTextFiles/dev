(*
(*
**  Amiga Oberon Interface Module:
**  $VER: ClipBoard.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE ClipBoard;   (* $Implementation- *)

IMPORT e * := Exec;

CONST

  clipboardName * = "clipboard.device";

  post           * = e.nonstd+0;
  currentReadId  * = e.nonstd+1;
  currentWriteId * = e.nonstd+2;
  changeHook     * = e.nonstd+3;

  obsoleteId * = 1;

TYPE

  ClipboardUnitPartialPtr * = UNTRACED POINTER TO ClipboardUnitPartial;
  ClipboardUnitPartial * = STRUCT (node * : e.Node) (* list of units *)
    unitNum * : LONGINT;    (* unit number for this unit *)
    (* the remaining unit data is private to the device *)
  END;


  IOClipReqPtr * = UNTRACED POINTER TO IOClipReq;
  IOClipReq * = STRUCT (message * : e.Message)
    device * : e.DevicePtr;     (* device node pointer  *)
    unit * : ClipboardUnitPartialPtr; (* unit node pointer *)
    command * : INTEGER;        (* device command *)
    flags * : SHORTSET;         (* including QUICK and SATISFY *)
    error * : SHORTINT;         (* error or warning num *)
    actual * : LONGINT;         (* number of bytes transferred *)
    length * : LONGINT;         (* number of bytes requested *)
    data * : e.APTR;            (* either clip stream or post port *)
    offset * : LONGINT;         (* offset in clip stream *)
    clipID * : LONGINT;         (* ordinal clip identifier *)
  END;

CONST

  primaryClip * = 0;       (* primary clip unit *)

TYPE

  SatisfyMsgPtr * = UNTRACED POINTER TO SatisfyMsg;
  SatisfyMsg * = STRUCT (msg * : e.Message) (* the length will be 6 *)
    unit * : INTEGER;       (* which clip unit this is *)
    clipID * : LONGINT;     (* the clip identifier of the post *)
  END;

  ClipHookMsgPtr * = UNTRACED POINTER TO ClipHookMsg;
  ClipHookMsg * = STRUCT
    type * : LONGINT;           (* zero for this structure format *)
    changeCmd * : LONGINT;      (* command that caused this hook invocation: *)
                                (*   either Exec.update or ClipBoard.post *)
    clipID * : LONGINT;         (* the clip identifier of the new data *)
  END;

END ClipBoard.


