(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Parallel.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Parallel;   (* $Implementation- *)

IMPORT e * := Exec;

TYPE

  IOPArrayPtr * = UNTRACED POINTER TO IOPArray;
  IOPArray * = ARRAY 8 OF CHAR;

(******************************************************************)
(* CAUTION !!  IF YOU ACCESS the parallel.device, you MUST (!!!!) use
   an IOExtPar-sized structure or you may overlay innocent memory !! *)
(******************************************************************)

  IOExtParPtr * = UNTRACED POINTER TO IOExtPar;
  IOExtPar * = STRUCT (ioPar * : e.IOStdReq)

(*     STRUCT   MsgNode
*   0   APTR     Succ
*   4   APTR     Pred
*   8   UBYTE    Type
*   9   UBYTE    Pri
*   A   APTR     Name
*   E   APTR     ReplyPort
*  12   UWORD    MNLength
*     STRUCT   IOExt
*  14   APTR     io_Device
*  18   APTR     io_Unit
*  1C   UWORD    io_Command
*  1E   UBYTE    io_Flags
*  1F   UBYTE    io_Error
*     STRUCT   IOStdExt
*  20   ULONG    io_Actual
*  24   ULONG    io_Length
*  28   APTR     io_Data
*  2C   ULONG    io_Offset
*  30 *)

    pExtFlags * : LONGSET;     (* (not used) flag extension area *)
    status * : SHORTSET;       (* status of parallel port and registers *)
    parFlags * : SHORTSET;     (* see PARFLAGS bit definitions below *)
    pTermArray * : IOPArray;   (* termination character array *)
  END;

CONST

  shared     * = 5;          (* parFlags non-exclusive access bit *)
  slowMode   * = 4;          (*    "     slow printer bit *)
  fastMode   * = 3;          (*    "     fast I/O mode selected bit *)
  radBoogie  * = 3;          (*    "     for backward compatibility *)

  ackMode    * = 2;          (*    "     ACK interrupt handshake bit *)

  eofMode    * = 1;          (*    "     EOF mode enabled bit *)

  queued     * = 6;          (* flags rqst-queued bit *)
  abort      * = 5;          (*   "   rqst-aborted bit *)
  active     * = 4;          (*   "   rqst-qued-or-current bit *)

  rwDir      * = 3;          (* status read=0,write=1 bit *)
  parSel     * = 2;          (*   "    printer selected on the A1000 *)
  paperOut   * = 1;          (*   "    paper out bit *)
  parBusy    * = 0;          (*   "    printer in busy toggle bit *)
(* Note: previous versions of this include files had bits 0 and 2 swapped *)

  parallelName * = "parallel.device";

  query         * = e.nonstd;
  setparams     * = e.nonstd + 1;

(* ParErrs: *)
  devBusy      * = 1;
  bufTooBig    * = 2;
  invParam     * = 3;
  lineErr      * = 4;
  notOpen      * = 5;
  portReset    * = 6;
  initErr      * = 7;

END Parallel.

