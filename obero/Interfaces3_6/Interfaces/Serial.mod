(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Serial.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Serial;   (* $Implementation- *)

IMPORT e * := Exec;

TYPE

                   (* array of termination char's *)
                   (* to use,see serial.doc setparams *)

  IOTArrayPtr * = UNTRACED POINTER TO IOTArray;
  IOTArray * = ARRAY 8 OF CHAR;

CONST

  defaultCtlChar * = 011130000H;    (* default chars for xON,xOFF *)
(* You may change these via SETPARAMS.  At this time, parity is not
   calculated for xON/xOFF characters.  You must supply them with the
   desired parity. *)

TYPE

(******************************************************************)
(* CAUTION !!  IF YOU ACCESS the serial.device, you MUST (!!!!) use an
   IOExtSer-sized structure or you may overlay innocent memory !! *)
(******************************************************************)

  IOExtSerPtr * = UNTRACED POINTER TO IOExtSer;
  IOExtSer * = STRUCT (ioSer * : e.IOStdReq)

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
*
*  30 *)
    ctlChar * : LONGINT;    (* control char's (order = xON,xOFF,INQ,ACK) *)
    rBufLen * : LONGINT;    (* length in bytes of serial port's read buffer *)
    extFlags * : LONGSET;   (* additional serial flags (see bitdefs below) *)
    baud * : LONGINT;       (* baud rate requested (true baud) *)
    brkTime * : LONGINT;    (* duration of break signal in MICROseconds *)
    termArray * : IOTArray; (* termination character array *)
    readLen * : SHORTINT;   (* bits per read character (# of bits) *)
    writeLen * : SHORTINT;  (* bits per write character (# of bits) *)
    stopBits * : SHORTINT;  (* stopbits for read (# of bits) *)
    serFlags * : SHORTSET;  (* see SerFlags bit definitions below  *)
    status * : SET;
  END;
   (* status of serial port, as follows:
*                  BIT  ACTIVE  FUNCTION
*                   0    ---    reserved
*                   1    ---    reserved
*                   2    high   Connected to parallel "select" on the A1000.
*                               Connected to both the parallel "select" and
*                               serial "ring indicator" pins on the A500
*                               & A2000.  Take care when making cables.
*                   3    low    Data Set Ready
*                   4    low    Clear To Send
*                   5    low    Carrier Detect
*                   6    low    Ready To Send
*                   7    low    Data Terminal Ready
*                   8    high   read overrun
*                   9    high   break sent
*                  10    high   break received
*                  11    high   transmit x-OFFed
*                  12    high   receive x-OFFed
*               13-15           reserved
*)

CONST

  query       * = e.nonstd;       (* 09H *)
  break       * = e.nonstd+1;     (* 0AH *)
  setparams   * = e.nonstd+2;     (* 0BH *)


  xDisabled  * = 7;       (* serFlags xOn-xOff feature disabled bit *)
  eofMode    * = 6;       (*    "     EOF mode enabled bit *)
  shared     * = 5;       (*    "     non-exclusive access bit *)
  radBoogie  * = 4;       (*    "     high-speed mode active bit *)
  queuedBrk  * = 3;       (*    "     queue this Break ioRqst *)
  sevenWire  * = 2;       (*    "     RS232 7-wire protocol *)
  partyOdd   * = 1;       (*    "     parity feature enabled bit *)
  partyOn    * = 0;       (*    "     parity-enabled bit *)

(* These now refect the actual bit positions in the io_Status UWORD *)
  xOffRead   * = 12;      (* status receive currently xOFF'ed bit  *)
  xOffWrite  * = 11;      (*    "   transmit currently xOFF'ed bit *)
  readBreak  * = 10;      (*    "   break was latest input bit     *)
  wroteBreak * =  9;      (*    "   break was latest output bit    *)
  overRun    * =  8;      (*    "   status word RBF overrun bit    *)


  mSpOn     * = 1;        (* io_ExtFlags. Use mark-space parity, *)
                          (*          instead of odd-even. *)
  mark      * = 0;        (*    "     if mark-space, use mark *)


(* SerErrs: *)
  devBusy        * =  1;
  baudMismatch   * =  2;  (* baud rate not supported by hardware *)
  bufErr         * =  4;  (* Failed to allocate new read buffer *)
  invParam       * =  5;
  lineErr        * =  6;
  parityErr      * =  9;
  timerErr       * = 11;  (*(See the serial/OpenDevice autodoc)*)
  bufOverflow    * = 12;
  noDSR          * = 13;
  detectedBreak  * = 15;


  serialName * = "serial.device";

END Serial.


