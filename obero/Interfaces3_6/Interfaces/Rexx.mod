(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Rexx.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V40.15 by hartmut Goebel
*)
*)

MODULE Rexx;

IMPORT
  e * := Exec,
  d * := Dos,
  y *:= SYSTEM;

TYPE

(* The NexxStr structure is used to maintain the internal strings in REXX.
 * It includes the buffer area for the string and associated attributes.
 * This is actually a variable-length structure; it is allocated for a
 * specific length string, and the length is never modified thereafter
 * (since it's used for recycling).
 *)

  NexxStrPtr * = UNTRACED POINTER TO NexxStr;
  NexxStr * = STRUCT
    ivalue * : LONGINT;              (* integer value                 *)
    length * : INTEGER;              (* length in bytes (excl null)   *)
    flags * : SHORTSET;              (* attribute flags               *)
    hash * : SHORTINT;               (* hash code                     *)
    buff * : ARRAY 8 OF CHAR;        (* buffer area for strings       *)
  END;                               (* size: 16 bytes (minimum)      *)

CONST

  nxAddLen * = 9;                     (* offset plus null byte *)

(* String attribute flag bit definitions                                *)
  keep     * = 0;                 (* permanent string?             *)
  string   * = 1;                 (* string form valid?            *)
  notNum   * = 2;                 (* non-numeric?                  *)
  number   * = 3;                 (* a valid number?               *)
  binary   * = 4;                 (* integer value saved?          *)
  float    * = 5;                 (* floating point format?        *)
  ext      * = 6;                 (* an external string?           *)
  source   * = 7;                 (* part of the program source?   *)

(* Combinations of flags                                                *)
  intNum   * = {number, binary, string};
  dpNum    * = {number, float};
  alpha    * = {notNum, string};
  owned    * = {source, ext,    keep};
  keepStr  * = {string, source, notNum};
  keepNum  * = {string, source, number, binary};

TYPE

(* The RexxArg structure is identical to the NexxStr structure, but
 * is allocated from system memory rather than from internal storage.
 * This structure is used for passing arguments to external programs.
 * It is usually passed as an "argstring", a pointer to the string buffer.
 *)

  RexxArgPtr * = UNTRACED POINTER TO RexxArg;
  RexxArg * = STRUCT
    size * : LONGINT;                (* total allocated length        *)
    length * : INTEGER;              (* length of string              *)
    flags * : SHORTSET;              (* attribute flags               *)
    hash * : SHORTINT;               (* hash code                     *)
    buff * : ARRAY 8 OF CHAR;        (* buffer area                   *)
  END;                               (* size: 16 bytes (minimum)      *)

(* The RexxMsg structure is used for all communications with REXX
 * programs.  It is an EXEC message with a parameter block appended.
 *)

  RexxMsgPtr * = UNTRACED POINTER TO RexxMsg;
  RexxMsg * = STRUCT (node * : e.Message) (* EXEC message structure  *)
    taskBlock : e.APTR;            (* global structure (private)    *)
    libBase   : e.LibraryPtr;      (* library base (private)        *)
    action   *: LONGINT;           (* command (action) code *)
    result1  *: e.APTR;            (* primary result (return code)  *)
    result2  *: e.APTR;            (* secondary result              *)
    args  *: ARRAY 16 OF e.LSTRPTR;(* argument block (ARG0-ARG15)   *)

    passPort *: e.MsgPortPtr;      (* forwarding port               *)
    commAddr *: e.LSTRPTR;         (* host address (port name)      *)
    fileExt  *: e.LSTRPTR;         (* file extension                *)
    stdin    *: d.FileHandlePtr;   (* input stream (filehandle)     *)
    stdout   *: d.FileHandlePtr;   (* output stream (filehandle)    *)
    avail    *: LONGINT;           (* future expansion              *)
  END;                             (* size: 128 bytes               *)

CONST

  maxRMArg * = 15;                  (* maximum arguments             *)

(* Command (action) codes for message packets                        *)
  rxComm     * = 001000000H;        (* a command-level invocation    *)
  rxFunc     * = 002000000H;        (* a function call               *)
  rxClose    * = 003000000H;        (* close the REXX server         *)
  rxQuery    * = 004000000H;        (* query for information         *)
  rxAddFH    * = 007000000H;        (* add a function host           *)
  rxAddLib   * = 008000000H;        (* add a function library        *)
  rxRemLib   * = 009000000H;        (* remove a function library     *)
  rxAddCon   * = 00A000000H;        (* add/update a ClipList string  *)
  rxRemCon   * = 00B000000H;        (* remove a ClipList string      *)
  rxTCOpn    * = 00C000000H;        (* open the trace console        *)
  rxTCCls    * = 00D000000H;        (* close the trace console       *)

(* Command modifier flag bits                                        *)
  rxNoIO     * = 000010000H;        (* suppress I/O inheritance?     *)
  rxResult   * = 000020000H;        (* result string expected?       *)
  rxString   * = 000040000H;        (* program is a "string file"?   *)
  rxToken    * = 000080000H;        (* tokenize the command line?    *)
  rxNonRet   * = 000100000H;        (* a "no-return" message?        *)

  rxfNoIO    * = 16;                (* suppress I/O inheritance?     *)
  rxfResult  * = 17;                (* result string expected?       *)
  rxfString  * = 18;                (* program is a "string file"?   *)
  rxfToken   * = 19;                (* tokenize the command line?    *)
  rxfNonRet  * = 20;                (* a "no-return" message?        *)

  rxCodeMask * = 0FF000000H;
  rxArgMask  * = 00000000FH;

PROCEDURE ActionCode * (action{0}: LONGINT): LONGINT;
(*
 * Filter Command code out of RexxMsg.action. Result will be one of rxComm,
 * rxFunc,...
 *)
BEGIN
  RETURN y.VAL(LONGINT,y.VAL(LONGSET,action) * y.VAL(LONGSET,rxCodeMask));
END ActionCode;


PROCEDURE ActionFlags * (action{0}: LONGINT): LONGSET;
(*
 * Filter Command modifier flag bit out of RexxMsg.action. Result will be a set of
 * rxfNoIO, rxfResult, ...
 *)
BEGIN RETURN y.VAL(LONGSET,action) * LONGSET{16..23}; END ActionFlags;


PROCEDURE ActionArg * (action{0}: LONGINT): LONGINT;
(*
 * Filter Arg out of RexxMsg.action.
 *)
BEGIN RETURN action MOD 16; END ActionArg;


TYPE
(* The RexxRsrc structure is used to manage global resources.  Each node
 * has a name string created as a RexxArg structure, and the total size
 * of the node is saved in the "rr_Size" field.  The REXX systems library
 * provides functions to allocate and release resource nodes.  If special
 * deletion operations are required, an offset and base can be provided in
 * "rr_Func" and "rr_Base", respectively.  This "autodelete" function will
 * be called with the base in register A6 and the node in A0.
 *)

  RexxRsrcPtr * = UNTRACED POINTER TO RexxRsrc;
  RexxRsrc * = STRUCT (node * : e.Node)
    func * : INTEGER;                   (* "auto-delete" offset          *)
    base * : e.APTR;                    (* "auto-delete" base            *)
    size * : LONGINT;                   (* total size of node            *)
    arg1 * : e.APTR;                    (* available ...         *)
    arg2 * : e.APTR;                    (* available ...         *)
  END;                                  (* size: 32 bytes                *)

CONST

(* Resource node types                                                  *)
  any      * = 0;                 (* any node type ...             *)
  lib      * = 1;                 (* a function library            *)
  port     * = 2;                 (* a public port         *)
  file     * = 3;                 (* a file IoBuff         *)
  host     * = 4;                 (* a function host               *)
  clip     * = 5;                 (* a Clip List node              *)

(* The RexxTask structure holds the fields used by REXX to communicate with
 * external processes, including the client task.  It includes the global
 * data structure (and the base environment).  The structure is passed to
 * the newly-created task in its "wake-up" message.
 *)

  globalSz * = 200;               (* total size of GlobalData      *)

TYPE

  RexxTaskPtr * = UNTRACED POINTER TO RexxTask;
  RexxTask * = STRUCT
    global * : ARRAY globalSz OF e.BYTE;(* global data structure *)
    msgPort * : e.MsgPort;              (* global message port           *)
    flags * : SHORTSET;                 (* task flag bits                *)
    sigBit * : SHORTINT;                (* signal bit                    *)

    clientID * : e.APTR;                (* the client's task ID          *)
    msgPkt * : e.APTR;                  (* the packet being processed    *)
    taskID * : e.APTR;                  (* our task ID                   *)
    rexxPort * : e.APTR;                (* the REXX public port          *)

    errTrap * : e.APTR;                 (* Error trap address            *)
    stackPtr * : e.APTR;                (* stack pointer for traps       *)

    header1 * : e.List;                 (* Environment list              *)
    header2 * : e.List;                 (* Memory freelist               *)
    header3 * : e.List;                 (* Memory allocation list        *)
    header4 * : e.List;                 (* Files list                    *)
    header5 * : e.List;                 (* Message Ports List            *)
  END;

CONST

(* Definitions for RexxTask flag bits                                   *)
  trace   * = 0;                 (* external trace flag           *)
  halt    * = 1;                 (* external halt flag            *)
  susp    * = 2;                 (* suspend task?         *)
  tCUse   * = 3;                 (* trace console in use? *)
  wait    * = 6;                 (* waiting for reply?            *)
  close   * = 7;                 (* task completed?               *)

(* Definitions for memory allocation constants                          *)
  memQuant * = 16;                  (* quantum of memory space       *)
  memMask  * = 0FFFFFFF0H;          (* mask for rounding the size    *)

  memQuick * = LONGSET{0};          (* EXEC flags: MEMF_PUBLIC       *)
  memClear * = LONGSET{16};         (* EXEC flags: MEMF_CLEAR        *)

TYPE

(* The SrcNode is a temporary structure used to hold values destined for
 * a segment array.  It is also used to maintain the memory freelist.
 *)

  SrcNodePtr * = UNTRACED POINTER TO SrcNode;
  SrcNode * = STRUCT
    succ * : SrcNodePtr;            (* next node                     *)
    pred * : SrcNodePtr;            (* previous node                 *)
    ptr * : e.APTR;                 (* pointer value                 *)
    size * : LONGINT;               (* size of object                *)
  END;                              (* size: 16 bytes                *)

CONST
  rxBuffSz * = 204;                 (* buffer length         *)

TYPE

(*
 * The IoBuff is a resource node used to maintain the File List.  Nodes
 * are allocated and linked into the list whenever a file is opened.
 *)

  IoBuffPtr * = UNTRACED POINTER TO IoBuff;
  IoBuff * = STRUCT (node * : RexxRsrc) (* structure for files/strings   *)
    rpt * : e.APTR;                     (* read/write pointer            *)
    rct * : LONGINT;                    (* character count               *)
    dFH * : d.FileHandlePtr;            (* DOS filehandle                *)
    lock * : d.FileLockPtr;             (* DOS lock                      *)
    bct * : LONGINT;                    (* buffer length         *)
    area * : ARRAY rxBuffSz OF e.BYTE;  (* buffer area                   *)
  END;                                  (* size: 256 bytes               *)

CONST

(* Access mode definitions                                              *)
  ioExists  * = -1;                (* an external filehandle        *)
  ioStrF    * = 0;                 (* a "string file"               *)
  ioRead    * = 1;                 (* read-only access              *)
  ioWrite   * = 2;                 (* write mode                    *)
  ioAppend  * = 3;                 (* append mode (existing file)   *)

(*
 * Offset anchors for SeekF()
 *)
  ioBegin * = -1;     (* relative to start             *)
  ioCurr  * = 0;      (* relative to current position  *)
  ioEnd   * = 1;      (* relative to end               *)

TYPE

(*
 * A message port structure, maintained as a resource node.  The ReplyList
 * holds packets that have been received but haven't been replied.
 *)

  RexxMsgPortPtr * = UNTRACED POINTER TO RexxMsgPort;
  RexxMsgPort * = STRUCT (node * : RexxRsrc) (* linkage node   *)
    port * : e.MsgPort;       (* the message port              *)
    replyList * : e.List;     (* messages awaiting reply       *)
  END;

CONST

(*
 * DOS Device types
 *)
  dtDev * = 0;                (* a device                      *)
  dtDir * = 1;                (* an ASSIGNed directory         *)
  dtVol * = 2;                (* a volume                      *)

(*
 * Private DOS packet types
 *)
  actionStack = 2002;         (* stack a line                  *)
  actionQueue = 2003;         (* queue a line                  *)

(* Errors: *)

  errcMsg  * = 0;             (*  error code offset           *)
  err10001 * = errcMsg+1;     (*  program not found           *)
  err10002 * = errcMsg+2;     (*  execution halted            *)
  err10003 * = errcMsg+3;     (*  no memory available         *)
  err10004 * = errcMsg+4;     (*  invalid character in program*)
  err10005 * = errcMsg+5;     (*  unmatched quote             *)
  err10006 * = errcMsg+6;     (*  unterminated comment        *)
  err10007 * = errcMsg+7;     (*  clause too long             *)
  err10008 * = errcMsg+8;     (*  unrecognized token          *)
  err10009 * = errcMsg+9;     (*  symbol or string too long   *)

  err10010 * = errcMsg+10;    (*  invalid message packet      *)
  err10011 * = errcMsg+11;    (*  command string error        *)
  err10012 * = errcMsg+12;    (*  error return from function  *)
  err10013 * = errcMsg+13;    (*  host environment not found  *)
  err10014 * = errcMsg+14;    (*  required library not found  *)
  err10015 * = errcMsg+15;    (*  function not found          *)
  err10016 * = errcMsg+16;    (*  no return value             *)
  err10017 * = errcMsg+17;    (*  wrong number of arguments   *)
  err10018 * = errcMsg+18;    (*  invalid argument to function*)
  err10019 * = errcMsg+19;    (*  invalid PROCEDURE           *)

  err10020 * = errcMsg+20;    (*  unexpected THEN/ELSE        *)
  err10021 * = errcMsg+21;    (*  unexpected WHEN/OTHERWISE   *)
  err10022 * = errcMsg+22;    (*  unexpected LEAVE or ITERATE *)
  err10023 * = errcMsg+23;    (*  invalid statement in SELECT *)
  err10024 * = errcMsg+24;    (*  missing THEN clauses        *)
  err10025 * = errcMsg+25;    (*  missing OTHERWISE           *)
  err10026 * = errcMsg+26;    (*  missing or unexpected END   *)
  err10027 * = errcMsg+27;    (*  symbol mismatch on END      *)
  err10028 * = errcMsg+28;    (*  invalid DO syntax           *)
  err10029 * = errcMsg+29;    (*  incomplete DO/IF/SELECT     *)

  err10030 * = errcMsg+30;    (*  label not found             *)
  err10031 * = errcMsg+31;    (*  symbol expected             *)
  err10032 * = errcMsg+32;    (*  string or symbol expected   *)
  err10033 * = errcMsg+33;    (*  invalid sub-keyword         *)
  err10034 * = errcMsg+34;    (*  required keyword missing    *)
  err10035 * = errcMsg+35;    (*  extraneous characters       *)
  err10036 * = errcMsg+36;    (*  sub-keyword conflict        *)
  err10037 * = errcMsg+37;    (*  invalid template            *)
  err10038 * = errcMsg+38;    (*  invalid TRACE request       *)
  err10039 * = errcMsg+39;    (*  uninitialized variable      *)

  err10040 * = errcMsg+40;    (*  invalid variable name       *)
  err10041 * = errcMsg+41;    (*  invalid expression          *)
  err10042 * = errcMsg+42;    (*  unbalanced parentheses      *)
  err10043 * = errcMsg+43;    (*  nesting level exceeded      *)
  err10044 * = errcMsg+44;    (*  invalid expression result   *)
  err10045 * = errcMsg+45;    (*  expression required         *)
  err10046 * = errcMsg+46;    (*  boolean value not 0 or 1    *)
  err10047 * = errcMsg+47;    (*  arithmetic conversion error *)
  err10048 * = errcMsg+48;    (*  invalid operand             *)

(*
 * Return Codes for general use
 *)
  ok    * = 0;                (*  success                     *)
  warn  * = 5;                (*  warning only                *)
  error * = 10;               (*  something's wrong           *)
  fatal * = 20;               (*  complete or severe failure  *)


  rxsName * = "rexxsyslib.library";
  rxsDir * = "REXX";
  rxsTName * = "ARexx";

TYPE

(* The REXX systems library structure.  This should be considered as    *)
(* semi-private and read-only, except for documented exceptions.        *)

  RxsLibPtr * = UNTRACED POINTER TO RxsLib;
  RxsLib * = STRUCT (node * : e.Library) (* EXEC library node             *)
    flags * : SHORTSET;                  (* global flags                  *)
    shadow * : SHORTSET;                 (* shadow flags                  *)
    sysBase * : e.LibraryPtr;            (* EXEC library base             *)
    dosBase * : d.DosLibraryPtr;         (* DOS library base              *)
    ieeeDPBase * : e.LibraryPtr;         (* IEEE DP math library base     *)
    segList * : e.BPTR;                  (* library seglist               *)
    nil * : d.FileHandlePtr;             (* global NIL: filehandle        *)
    chunk * : LONGINT;                   (* allocation quantum            *)
    maxNest * : LONGINT;                 (* maximum expression nesting    *)
    null * : NexxStrPtr;                 (* static string: NULL           *)
    false * : NexxStrPtr;                (* static string: FALSE          *)
    true * : NexxStrPtr;                 (* static string: TRUE           *)
    rexx * : NexxStrPtr;                 (* static string: REXX           *)
    command * : NexxStrPtr;              (* static string: COMMAND        *)
    stdin * : NexxStrPtr;                (* static string: STDIN          *)
    stdout * : NexxStrPtr;               (* static string: STDOUT *)
    stderr * : NexxStrPtr;               (* static string: STDERR *)
    version * : e.LSTRPTR;               (* version string                *)

    taskName * : e.LSTRPTR;              (* name string for tasks *)
    taskPri * : LONGINT;                 (* starting priority             *)
    taskSeg * : e.BPTR;                  (* startup seglist               *)
    stackSize * : LONGINT;               (* stack size                    *)
    rexxDir * : e.LSTRPTR;               (* REXX directory                *)
    cTABLE * : e.LSTRPTR;                (* character attribute table     *)
    notice * : e.LSTRPTR;                (* copyright notice              *)

    rexxPort * : e.MsgPort;              (* REXX public port              *)
    readLock* : INTEGER;                 (* lock count                    *)
    traceFH * : d.FileHandlePtr;         (* global trace console          *)
    taskList * : e.List;                 (* REXX task list                *)
    numTask * : INTEGER;                 (* task count                    *)
    libList * : e.List;                  (* Library List header           *)
    numLib * : INTEGER;                  (* library count         *)
    clipList * : e.List;                 (* ClipList header               *)
    numClip * : INTEGER;                 (* clip node count               *)
    msgList * : e.List;                  (* pending messages              *)
    numMsg * : INTEGER;                  (* pending count         *)
    pgmList * : e.List;                  (* cached programs               *)
    numPgm * : INTEGER;                  (* program count         *)

    traceCnt * : INTEGER;                (* usage count for trace console *)
    avail * : INTEGER;
  END;

CONST

(* Global flag bit definitions for RexxMaster                           *)
(*trace * = trace; *)              (* interactive tracing?          *)
(*halt  * = halt;  *)              (* halt execution?               *)
(*susp  * = susp;  *)              (* suspend execution?            *)
  stop  * = 6;                     (* deny further invocations      *)
(*close * = 7;     *)              (* close the master              *)

  rlfMask * = SHORTSET{trace,halt,susp};

(* Initialization constants                                             *)
  rxsChunk  * = 1024;        (* allocation quantum            *)
  rxsNest   * = 32;          (* expression nesting limit      *)
  rxsTPri   * = 0;           (* task priority         *)
  rxsStack  * = 4096;        (* stack size                    *)

(* Character attribute flag bits used in REXX.                          *)
  ctSpace   * = 0;                  (* white space characters        *)
  ctDigig   * = 1;                  (* decimal digits 0-9            *)
  ctAlpha   * = 2;                  (* alphabetic characters *)
  ctRrxxSym * = 3;                  (* REXX symbol characters        *)
  ctRexxOpr * = 4;                  (* REXX operator characters      *)
  ctRexxSpc * = 5;                  (* REXX special symbols          *)
  ctUpper   * = 6;                  (* UPPERCASE alphabetic          *)
  ctLower   * = 7;                  (* lowercase alphabetic          *)


PROCEDURE IVALUE * (nsPtr{8} : NexxStrPtr): LONGINT;
BEGIN RETURN nsPtr.ivalue END IVALUE;

(* Field definitions                                                    *)

PROCEDURE ARG0 * (rmp{8}: RexxMsgPtr): e.APTR; (* start of argblock             *)
BEGIN RETURN rmp.args[0] END ARG0;

PROCEDURE ARG1 * (rmp{8}: RexxMsgPtr): e.APTR; (* first argument                *)
BEGIN RETURN rmp.args[1] END ARG1;

PROCEDURE ARG2 * (rmp{8}: RexxMsgPtr): e.APTR; (* second argument               *)
BEGIN RETURN rmp.args[2] END ARG2;



(* The Library List contains just plain resource nodes.         *)

PROCEDURE LLOFFSET * (rrp{8}: RexxRsrcPtr): LONGINT;  (* "Query" offset     *)
BEGIN RETURN y.VAL(LONGINT,rrp.arg1) END LLOFFSET;

PROCEDURE LLVERS * (rrp{8}: RexxRsrcPtr): LONGINT;    (* library version    *)
BEGIN RETURN y.VAL(LONGINT,rrp.arg2) END LLVERS;

(*
 * The RexxClipNode structure is used to maintain the Clip List.  The value
 * string is stored as an argstring in the rr_Arg1 field.
 *)
PROCEDURE CLVALUE * (rrp{8}: RexxRsrcPtr): e.LSTRPTR;
BEGIN RETURN rrp.arg1 END CLVALUE;


END Rexx.


