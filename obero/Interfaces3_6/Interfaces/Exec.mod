(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Exec.mod 40.15 (12.1.95) Oberon 3.6
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Exec;

(* $IFNOT AO3r10 $Implementation- $END *)

IMPORT SYSTEM *;

(*********************************************************************
*
*  Format of the alert error number:
*
*    +-+-------------+----------------+--------------------------------+
*    |D|  SubSysId   |  General Error |    SubSystem Specific Error    |
*    +-+-------------+----------------+--------------------------------+
*     1    7 bits          8 bits                  16 bits
*
*                    D:  DeadEnd alert
*             SubSysId:  indicates ROM subsystem number.
*        General Error:  roughly indicates what the error was
*       Specific Error:  indicates more detail
**********************************************************************)

(**********************************************************************
*
*  Hardware/CPU specific alerts:  They may show without the 8 at the
*  front of the number.  These are CPU/68000 specific.        See 680x0
*  programmer's manuals for more details.
*
**********************************************************************)
CONST
  acpuBusErr     * = 80000002H;      (* Hardware bus fault/access error *)
  acpuAddressErr * = 80000003H;      (* Illegal address access (ie: odd) *)
  acpuInstErr    * = 80000004H;      (* Illegal instruction *)
  acpuDivZero    * = 80000005H;      (* Divide by zero *)
  acpuCHK        * = 80000006H;      (* Check instruction error *)
  acpuTRAPV      * = 80000007H;      (* TrapV instruction error *)
  acpuPrivErr    * = 80000008H;      (* Privilege violation error *)
  acpuTrace      * = 80000009H;      (* Trace error *)
  acpuLineA      * = 8000000AH;      (* Line 1010 Emulator error *)
  acpuLineF      * = 8000000BH;      (* Line 1111 Emulator error *)
  acpuFormat     * = 8000000EH;      (* Stack frame format error *)
  acpuSpurious   * = 80000018H;      (* Spurious interrupt error *)
  acpuAutoVec1   * = 80000019H;      (* AutoVector Level 1 interrupt error *)
  acpuAutoVec2   * = 8000001AH;      (* AutoVector Level 2 interrupt error *)
  acpuAutoVec3   * = 8000001BH;      (* AutoVector Level 3 interrupt error *)
  acpuAutoVec4   * = 8000001CH;      (* AutoVector Level 4 interrupt error *)
  acpuAutoVec5   * = 8000001DH;      (* AutoVector Level 5 interrupt error *)
  acpuAutoVec6   * = 8000001EH;      (* AutoVector Level 6 interrupt error *)
  acpuAutoVec7   * = 8000001FH;      (* AutoVector Level 7 interrupt error *)


(*********************************************************************
*
*  General Alerts
*
*  For example: timer.device cannot open math.library would be 0x05038015
*
*       Alert(AN_TimerDev|AG_OpenLib|AO_MathLib);
*
*********************************************************************)

CONST

(*------ alert types *)
  deadEnd      * = 080000000H;
  recovery     * = 000000000H;


(*------ general purpose alert codes *)
  noMemory     * = 000010000H;
  makeLib      * = 000020000H;
  openLib      * = 000030000H;
  openDev      * = 000040000H;
  openRes      * = 000050000H;
  ioError      * = 000060000H;
  noSignal     * = 000070000H;
  badParm      * = 000080000H;
  closeLib     * = 000090000H;       (* usually too many closes *)
  closeDev     * = 0000A0000H;       (* or a mismatched close *)
  procCreate   * = 0000B0000H;       (* Process creation failed *)


(*------ alert objects: *)
  execLib      * = 000008001H;
  graphicsLib  * = 000008002H;
  layersLib    * = 000008003H;
  intuition    * = 000008004H;
  mathLib      * = 000008005H;
  dosLib       * = 000008007H;
  ramLib       * = 000008008H;
  iconLib      * = 000008009H;
  expansionLib * = 00000800AH;
  diskfontLib  * = 00000800BH;
  utilityLib   * = 00000800CH;
  keyMapLib    * = 00000800DH;

  audioDev     * = 000008010H;
  consoleDev   * = 000008011H;
  gamePortDev  * = 000008012H;
  keyboardDev  * = 000008013H;
  trackDiskDev * = 000008014H;
  timerDev     * = 000008015H;

  ciaRsrc      * = 000008020H;
  diskRsrc     * = 000008021H;
  miscRsrc     * = 000008022H;

  bootStrap    * = 000008030H;
  workbench    * = 000008031H;
  diskCopy     * = 000008032H;
  gadTools     * = 000008033H;
  atUnknown    * = 000008035H;


(*********************************************************************
*
*   Specific Alerts:
*
*   For example:   exec.library -- corrupted memory list
*
*         ALERT  AN_MemCorrupt        ;8100 0005
*
*********************************************************************)

(*------ exec.library *)
  anExecLib    * = 001000000H;
  excptVect    * = 001000001H;  (* 68000 exception vector checksum (obs.) *)
  baseChkSum   * = 001000002H;  (* Execbase checksum (obs.) *)
  libChkSum    * = 001000003H;  (* Library checksum failure *)
  memCorrupt   * = 081000005H;  (* Corrupt memory list detected in FreeMem *)
  intrMem      * = 081000006H;  (* No memory for interrupt servers *)
  initAPtr     * = 001000007H;  (* InitStruct() of an APTR source (obs.) *)
  semCorrupt   * = 001000008H;  (* A semaphore is in an illegal state
                                      at ReleaseSempahore() *)
  freeTwice    * = 001000009H;  (* Freeing memory already freed *)
  bogusExcpt   * = 08100000AH;  (* illegal 68k exception taken (obs.) *)
  ioUsedTwice  * = 00100000BH;  (* Attempt to reuse active IORequest *)
  memoryInsane * = 00100000CH;  (* Sanity check on memory list failed
                                      during AvailMem(MEMF_LARGEST) *)
  ioAfterClose * = 00100000DH;  (* IO attempted on closed IORequest *)
  stackProbe   * = 00100000EH;  (* Stack appears to extend out of range *)
  badFreeAddr  * = 00100000FH;  (* Memory header not located. [ Usually an
                                      invalid address passed to FreeMem() ] *)
  badSemaphore * = 001000010H;  (* An attempt was made to use the old
                                      message semaphores. *)

(*------ graphics.library *)
  anGraphicsLib* = 002000000H;
  gfxNoMem     * = 082010000H;       (* graphics out of memory *)
  gfxNoMemMspc * = 082010001H;       (* MonitorSpec alloc, no memmory *)
  longFrame    * = 082010006H;       (* long frame, no memory *)
  shortFrame   * = 082010007H;       (* short frame, no memory *)
  textTmpRas   * = 002010009H;       (* text, no memory for TmpRas *)
  bltBitMap    * = 08201000AH;       (* BltBitMap, no memory *)
  regionMemory * = 08201000BH;       (* regions, memory not available *)
  makeVPort    * = 082010030H;       (* MakeVPort, no memory *)
  gfxNewError  * = 00200000CH;
  gfxFreeError * = 00200000DH;

  gfxNoLCM     * = 082011234H;       (* emergency memory not available *)

  obsoleteFont * = 002000401H;       (* unsupported font description used *)

(*------ layers.library *)
  anLayersLib  * = 003000000H;
  layersNoMem  * = 083010000H;       (* layers out of memory *)

(*------ intuition.library *)
  anIntuition  * = 004000000H;
  gadgetType   * = 084000001H;   (* unknown gadget type *)
  badGadget    * = 004000001H;   (* Recovery form of GadgetType *)
  createPort   * = 084010002H;   (* create port, no memory *)
  itemAlloc    * = 004010003H;   (* item plane alloc, no memory *)
  subAlloc     * = 004010004H;   (* sub alloc, no memory *)
  planeAlloc   * = 084010005H;   (* plane alloc, no memory *)
  itemBoxTop   * = 084000006H;   (* item box top < RelZero *)
  openScreen   * = 084010007H;   (* open screen, no memory *)
  openScrnRast * = 084010008H;   (* open screen, raster alloc, no memory *)
  sysScrnType  * = 084000009H;   (* open sys screen, unknown type *)
  addSWGadget  * = 08401000AH;   (* add SW gadgets, no memory *)
  openWindow   * = 08401000BH;   (* open window, no memory *)
  badState     * = 08400000CH;   (* Bad State Return entering Intuition *)
  badMessage   * = 08400000DH;   (* Bad Message received by IDCMP *)
  weirdEcho    * = 08400000EH;   (* Weird echo causing incomprehension *)
  noConsole    * = 08400000FH;   (* couldn't open the Console Device *)
  noISem       * = 004000010H;   (* Intuition skipped obtaining a sem *)
  iSemOrder    * = 004000011H;   (* Intuition obtained a sem in bad order *)

(*------ math.library *)
  anMathLib    * = 005000000H;

(*------ dos.library *)
  anDosLib     * = 007000000H;
  startMem     * = 007010001H;  (* no memory at startup *)
  endTask      * = 007000002H;  (* EndTask didn't *)
  qPktFail     * = 007000003H;  (* Qpkt failure *)
  asyncPkt     * = 007000004H;  (* Unexpected packet received *)
  freeVec      * = 007000005H;  (* Freevec failed *)
  diskBlkSeq   * = 007000006H;  (* Disk block sequence error *)
  bitMap       * = 007000007H;  (* Bitmap corrupt *)
  keyFree      * = 007000008H;  (* Key already free *)
  badChkSum    * = 007000009H;  (* Invalid checksum *)
  diskError    * = 00700000AH;  (* Disk Error *)
  keyRange     * = 00700000BH;  (* Key out of range *)
  badOverlay   * = 00700000CH;  (* Bad overlay *)
  badInitFunc  * = 00700000DH;  (* Invalid init packet for cli/shell *)
  fileReclosed * = 00700000EH;  (* A filehandle was closed more than once *)

(*------ ramlib.library *)
  anRAMLib     * = 008000000H;
  badSegList   * = 008000001H;       (* no overlays in library seglists *)

(*------ icon.library *)
  anIconLib    * = 009000000H;

(*------ expansion.library *)
  anExpansionLib    * = 00A000000H;
  badExpansionFree  * = 00A000001H;  (* freeed free region *)

(*------ diskfont.library *)
  anDiskfontLib* = 00B000000H;

(*------ audio.device *)
  anAudioDev   * = 010000000H;

(*------ console.device *)
  anConsoleDev * = 011000000H;
  noWindow     * = 011000001H;       (* Console can't open initial window *)

(*------ gameport.device *)
  anGamePortDev* = 012000000H;

(*------ keyboard.device *)
  anKeyboardDev* = 013000000H;

(*------ trackdisk.device *)
  anTrackDiskDev* = 014000000H;
  tdCalibSeek  * = 014000001H;       (* calibrate: seek error *)
  tdDelay      * = 014000002H;       (* delay: error on timer wait *)

(*------ timer.device *)
  anTimerDev   * = 015000000H;
  tmBadReq     * = 015000001H;  (* bad request *)
  tmBadSupply  * = 015000002H;  (* power supply -- no 50/60Hz ticks *)

(*------ cia.resource *)
  anCIARsrc    * = 020000000H;

(*------ disk.resource *)
  anDiskRsrc   * = 021000000H;
  drHasDisk    * = 021000001H;       (* get unit: already has disk *)
  drIntNoAct   * = 021000002H;       (* interrupt: no active unit *)

(*------ misc.resource *)
  anMiscRsrc   * = 022000000H;

(*------ bootstrap *)
  anBootStrap  * = 030000000H;
  bootError    * = 030000001H;       (* boot code returned an error *)

(*------ Workbench *)
  anWorkbench                  * = 031000000H;
  noFonts                      * = 0B1000001H;
  wbBadStartupMsg1             * = 031000001H;
  wbBadStartupMsg2             * = 031000002H;
  wbBadIOMsg                   * = 031000003H;  (* Hacker code? *)
  wbReLayoutToolMenu           * = 0B1010009H;  (* GadTools broke? *)

(* no longer used since V39 *)
  wbInitPotionAllocDrawer      * = 0B1010004H;
  wbCreateWBMenusCreateMenus1  * = 0B1010005H;
  wbCreateWBMenusCreateMenus2  * = 0B1010006H;
  wbLayoutWBMenusLayoutMenus   * = 0B1010007H;
  wbAddToolMenuItem            * = 0B1010008H;
  wbinitTimer                  * = 0B101000AH;
  wbInitLayerDemon             * = 0B101000BH;
  wbinitWbGels                 * = 0B101000CH;
  wbInitScreenAndWindows1      * = 0B101000DH;
  wbInitScreenAndWindows2      * = 0B101000EH;
  wbInitScreenAndWindows3      * = 0B101000FH;
  wbMAlloc                     * = 0B1010010H;

(*------ DiskCopy *)
  anDiskCopy   * = 032000000H;

(*------ toolkit for Intuition *)
  anGadTools   * = 033000000H;

(*------ System utility library *)
  anUtilityLib * = 034000000H;

(*------ For use by any application that needs it *)
  anUnknown    * = 035000000H;



CONST

  includeVersion * = 40; (* Version of the include files in use. (Do not
                              use this label for OpenLibrary() calls!) *)

TYPE
  ADDRESS  * = SYSTEM.ADDRESS;  (* 32-bit untyped pointer *)
  APTR     * = ADDRESS;
  BPTR     * = BPOINTER TO LONGINT;

  LONG     * = LONGINT;  (* signed 32-bit quantity *)
  ULONG    * = LONGINT;  (* unsigned 32-bit quantity, be careful with this! *)
  LONGBITS * = LONGSET;  (* 32 bits manipulated individually *)
  WORD     * = INTEGER;  (* signed 16-bit quantity *)
  UWORD    * = INTEGER;  (* unsigned 16-bit quantity, be careful with this! *)
  WORDBITS * = SET;      (* 16 bits manipulated individually *)
  BYTE     * = SYSTEM.BYTE; (* 8-bit quantity *)
  SBYTE    * = SHORTINT; (* signed 8-bit quantity *)
  UBYTE    * = BYTE;     (* unsigned 8-bit quantity *)
  BYTEBITS * = SHORTSET; (* 8 bits manipulated individually *)
  RPTR     * = INTEGER;  (* signed relative pointer *)
  STRING   * = ARRAY 256 OF CHAR; (* general String type *)
  STRPTR   * = UNTRACED POINTER TO STRING;
                         (* string pointer (NULL terminated) *)
  LSTRPTR  * = UNTRACED POINTER TO ARRAY MAX(LONGINT)-1 OF CHAR;
                         (* string pointer (NULL terminated) *)
  LONGBOOL * = LONGINT;

  PROC     * = PROCEDURE;

(* Types with specific semantics *)
  FLOAT    * = REAL;
  DOUBLE   * = LONGREAL;
  SINGLE   * = LONGSET;  (* single precision real number, set type avoids intermix *)
  BOOL     * = INTEGER;
  TEXT     * = CHAR;

CONST
  true     * = 1;
  false    * = 0;
  LTRUE    * = -1;
  LFALSE   * = 0;

  null     * = NIL;
  NILSTR   * = NIL;  (* pass this to formal parameters ARRAY OF CHAR
                        for passing _no_ string (lib-calls only)  *)
  EMPTYSTR * = "";   (* and this one for passing an emptry string *)

  byteMask * = 255;


(* LIBRARY_VERSION is now obsolete.  Please use LIBRARY_MINIMUM *)
(* or code the specific minimum library version you require.    *)
  libraryMinimum * = 33; (* Lowest version supported by Commodore-Amiga *)

TYPE

(* Pointers: *)
  NodePtr           * = UNTRACED POINTER TO Node;
  MinNodePtr        * = UNTRACED POINTER TO MinNode;
  ListPtr           * = UNTRACED POINTER TO List;
  MinListPtr        * = UNTRACED POINTER TO MinList;
  TaskPtr           * = UNTRACED POINTER TO Task;
  StackSwapStructPtr* = UNTRACED POINTER TO StackSwapStruct;
  MsgPortPtr        * = UNTRACED POINTER TO MsgPort;
  MsgPortSoftIntPtr * = UNTRACED POINTER TO MsgPortSoftInt;
  MessagePtr        * = UNTRACED POINTER TO Message;
  InterruptPtr      * = UNTRACED POINTER TO Interrupt;
  LibraryPtr        * = UNTRACED POINTER TO Library;
  DevicePtr         * = UNTRACED POINTER TO Device;
  UnitPtr           * = UNTRACED POINTER TO Unit;
  IntVectorPtr      * = UNTRACED POINTER TO IntVector;
  SoftIntListPtr    * = UNTRACED POINTER TO SoftIntList;
  ExecBasePtr       * = UNTRACED POINTER TO ExecBase;
  IORequestPtr      * = UNTRACED POINTER TO IORequest;
  IOStdReqPtr       * = UNTRACED POINTER TO IOStdReq;
  MemChunkPtr       * = UNTRACED POINTER TO MemChunk;
  MemHeaderPtr      * = UNTRACED POINTER TO MemHeader;
  MemEntryPtr       * = UNTRACED POINTER TO MemEntry;
  MemListPtr        * = UNTRACED POINTER TO MemList;
  MemPoolPtr        * = UNTRACED POINTER TO MemPool;
  ResidentPtr       * = UNTRACED POINTER TO Resident;
  SemaphoreRequestPtr * = UNTRACED POINTER TO SemaphoreRequest;
  SemaphoreMessagePtr * = UNTRACED POINTER TO SemaphoreMessagePtr;
  SignalSemaphorePtr* = UNTRACED POINTER TO SignalSemaphore;
  SemaphorePtr      * = UNTRACED POINTER TO Semaphore;

TYPE

(*
 * Type compatible to MinNode and Node:
 *)
  CommonNode * = STRUCT END;
  CommonNodePtr * = UNTRACED POINTER TO CommonNode;

(*
 *  List Node Structure.  Each member in a list starts with a Node
 *)


  Node * = STRUCT (dummy *: CommonNode)
    succ * : NodePtr;           (* Pointer to next (successor) *)
    pred * : NodePtr;           (* Pointer to previous (predecessor) *)
    type * : SHORTINT;
    pri  * : SHORTINT;          (* Priority, for sorting *)
    name * : LSTRPTR;           (* ID string, null terminated *)
  END;  (* Note: word aligned *)

(* minimal node -- no type checking possible *)
  MinNode * = STRUCT (dummy *: CommonNode)
    succ * : MinNodePtr;
    pred * : MinNodePtr;
  END;


(*
** Note: Newly initialized IORequests, and software interrupt structures
** used with Cause(), should have type NT_UNKNOWN.  The OS will assign a type
** when they are first used.
*)

CONST

(*----- Node Types for LN_TYPE -----*)
  unknown      * = 0;
  task         * = 1;       (* Exec task *)
  interrupt    * = 2;
  device       * = 3;
  msgPort      * = 4;
  message      * = 5;       (* Indicates message currently pending *)
  freeMsg      * = 6;
  replyMsg     * = 7;       (* Message has been replied *)
  resource     * = 8;
  library      * = 9;
  memory       * = 10;
  softInt      * = 11;      (* Internal flag used by SoftInits *)
  font         * = 12;
  process      * = 13;      (* AmigaDOS Process *)
  semaphore    * = 14;
  signalSem    * = 15;      (* signal semaphores *)
  bootNode     * = 16;
  kickMem      * = 17;
  graphics     * = 18;
  deathMessage * = 19;
  user         * = 254;     (* User node types work down from here *)
  extended     * = 255;

TYPE

(*
 * Type compatible to MinList and List:
 *)
  CommonList * = STRUCT END;
  CommonListPtr * = UNTRACED POINTER TO CommonList;

(*
 *  Full featured list header.
 *)

  List * = STRUCT (dummy *: CommonList)
    head * : NodePtr;
    tail * : NodePtr;
    tailPred * : NodePtr;
    type * : SHORTINT;
    pad  * : BYTE;
  END;     (* word aligned *)


(*
 * Minimal List Header - no type checking
 *)
  MinList * = STRUCT (dummy *: CommonList)
   head*, tail*, tailPred*: MinNodePtr;
  END;    (* longword aligned *)


(* Please use Exec functions to modify task structure fields, where available.
 *)
  Task * = STRUCT (node* : Node)
    flags * : SHORTSET;
    state * : SHORTSET;
    idNestCnt * : SHORTINT;         (* intr disabled nesting*)
    tdNestCnt * : SHORTINT;         (* task disabled nesting*)
    sigAlloc  * : LONGSET;          (* sigs allocated *)
    sigWait   * : LONGSET;          (* sigs we are waiting for *)
    sigRecvd  * : LONGSET;          (* sigs we have received *)
    sigExcept * : LONGSET;          (* sigs we will take excepts for *)
    trapAlloc * : SET;              (* traps allocated *)
    trapAble  * : SET;              (* traps enabled *)
    exceptData* : APTR;             (* points to except data *)
    exceptCode* : PROC;             (* points to except code *)
    trapData  * : APTR;             (* points to trap code *)
    trapCode  * : PROC;             (* points to trap data *)
    spReg     * : APTR;             (* stack pointer        *)
    spLower   * : APTR;             (* stack lower bound    *)
    spUpper   * : APTR;             (* stack upper bound + 2*)
    switch    * : PROC;             (* task losing CPU    *)
    launch    * : PROC;             (* task getting CPU  *)
    memEntry  * : List;             (* Allocated memory. Freed by RemTask() *)
    userData  * : APTR;             (* For use by the task; no restrictions! *)
  END;

(*
 * Stack swap structure as passed to StackSwap()
 *)
  StackSwapStruct * = STRUCT
    lower * : APTR;             (* Lowest byte of stack *)
    upper * : LONGINT;          (* Upper end of stack (size + Lowest) *)
    pointer * : APTR;           (* Stack pointer at switch point *)
  END;

CONST
(*----- Flag Bits ------------------------------------------*)
(* Task.flags: *)
  procTime     * = 0;
  eTask        * = 3;
  stackChk     * = 4;
  exception    * = 5;
  switch       * = 6;
  launch       * = 7;

(*----- Task States ----------------------------------------*)
(* Task.state *)
  inval        * = 0;
  added        * = 1;
  run          * = 2;
  ready        * = 3;
  wait         * = 4;
  except       * = 5;
  removed      * = 6;

(*----- Predefined Signals -------------------------------------*)
  sigAbort      * = 0;
  sigChild      * = 1;
  sigBlit       * = 4;       (* Note: same as SINGLE *)
  sigSingle     * = 4;       (* Note: same as BLIT *)
  sigIntuition  * = 5;
  sigNet        * = 7;
  sigDos        * = 8;


TYPE

(****** MsgPort *****************************************************)

  MsgPort * = STRUCT (node * : Node)
    flags * : SHORTINT;
    sigBit * : SHORTINT;        (* signal bit number    *)
    sigTask* : TaskPtr;         (* object to be signalled *)
    msgList* : List;            (* message linked list  *)
  END;

  MsgPortSoftInt * = STRUCT (node * : Node)
    flags * : SHORTINT;
    sigBit * : SHORTINT;        (* signal bit number    *)
    softInt* : InterruptPtr;    (* object to be signalled *)
    msgList* : List;            (* message linked list  *)
  END;

CONST

(* MsgPort.flags: Port arrival actions (PutMsg) *)
  signal     * = 0;       (* Signal task in mp_SigTask *)
  softint    * = 1;       (* Signal SoftInt in mp_SoftInt/mp_SigTask *)
  ignore     * = 2;       (* Ignore arrival *)

TYPE

(****** Message *****************************************************)

  Message * = STRUCT (node * : Node)
    replyPort * : MsgPortPtr;  (* message reply port *)
    length * : INTEGER;        (* total message length, in bytes *)
                               (* (include the size of the Message *)
                               (* structure in the length) *)
  END;

CONST

(*------ Special Constants ---------------------------------------*)
  vectSize    * = 6;      (* Each library entry takes 6 bytes *)
  reserved    * = 4;      (* Exec reserves the first 4 vectors *)
  base        * = -vectSize;
  userDef     * = base-reserved*vectSize;
  nonStd      * = userDef;

(*------ Standard Functions --------------------------------------*)
  open        * = - 6;
  close       * = -12;
  expunge     * = -18;
  extFunc     * = -24;   (* for future expansion *)

TYPE

(*------ Library Base Structure ----------------------------------*)
(* Also used for Devices and some Resources *)
  Library * = STRUCT (node * : Node)
    flags * : SHORTSET;
    pad   * : BYTE;
    negSize * : INTEGER;            (* number of bytes before library *)
    posSize * : INTEGER;            (* number of bytes after library *)
    version * : INTEGER;            (* major *)
    revision* : INTEGER;            (* minor *)
    idString* : LSTRPTR;            (* ASCII identification *)
    sum     * : LONGINT;            (* the checksum itself *)
    openCnt * : INTEGER;            (* number of current opens *)
  END;  (* Warning: size is not a longword multiple! *)

CONST

(* Library.flags bit definitions (all others are system reserved) *)
  summing * = 0;       (* we are currently checksumming *)
  changed * = 1;       (* we have just changed the lib *)
  sumUsed * = 2;       (* set if we should bother to sum *)
  delExp  * = 3;       (* delayed expunge *)

TYPE

(****** Device ******************************************************)

  Device * = STRUCT (library * : Library) END;


(****** Unit ********************************************************)

  Unit * = STRUCT (msgPort * : MsgPort) (* queue for unprocessed messages *)
                                        (* instance of msgport is recommended *)
    flags   * : SHORTSET;
    pad     * : BYTE;
    openCnt * : INTEGER;                (* number of active opens *)
  END;


CONST

(* Unit.flags *)
  active   * = 0;
  inTask   * = 1;


(* errors: *)
  openFail    * = -1; (* device/unit failed to open *)
  aborted     * = -2; (* request terminated early [after AbortIO()] *)
  noCmd       * = -3; (* command not supported by device *)
  badLength   * = -4; (* not a valid length (usually IO_LENGTH) *)
  badAddress  * = -5; (* invalid address (misaligned or bad range) *)
  unitBusy    * = -6; (* device opens ok, but requested unit is busy *)
  selfTest    * = -7; (* hardware failed self-test *)


TYPE

  Interrupt * = STRUCT (node * : Node)
    data * : APTR;               (* server data segment  *)
    code * : PROC;               (* server code entry    *)
  END;


  IntVector * = STRUCT           (* For EXEC use ONLY! *)
    data * : APTR;
    code * : PROC;
    node * : NodePtr;
  END;


  SoftIntList * = STRUCT (list * : List)   (* For EXEC use ONLY! *)
    pad  * : INTEGER;
  END;


CONST

(* this is a fake INT definition, used only for AddIntServer and the like *)
  nmi * = 15;


TYPE

(* Definition of the Exec library base structure (pointed to by location 4).
** Most fields are not to be viewed or modified by user programs.  Use
** extreme caution.
*)
  ExecBase * = STRUCT (libNode * : Library) (* Standard library node *)

(******** Static System Variables ********)

        softVer      * : INTEGER; (* obsolete! kickstart release number *)
        lowMemChkSum * : INTEGER; (* checksum of 68000 trap vectors *)
        chkBase      * : LONGINT; (* system base pointer complement *)
        coldCapture  * : APTR;    (* coldstart soft capture vector *)
        coolCapture  * : APTR;    (* coolstart soft capture vector *)
        warmCapture  * : APTR;    (* warmstart soft capture vector *)
        sysStkUpper  * : APTR;    (* system stack base   (upper bound) *)
        sysStkLower  * : APTR;    (* top of system stack (lower bound) *)
        maxLocMem    * : APTR;    (* top of chip memory *)
        debugEntry   * : APTR;    (* global debugger entry point *)
        debugData    * : APTR;    (* global debugger data segment *)
        alertData    * : APTR;    (* alert data segment *)
        maxExtMem    * : APTR;    (* top of extended mem, or null if none *)

        chkSum       * : INTEGER; (* for all of the above (minus 2) *)

(****** Interrupt Related ***************************************)

        intVects    * : ARRAY 16 OF IntVector;

(****** Dynamic System Variables *************************************)

        thisTask       * : TaskPtr;  (* pointer to current task (readable) *)

        idleCount      * : LONGINT;  (* idle counter *)
        dispCount      * : LONGINT;  (* dispatch counter *)
        quantum        * : INTEGER;  (* time slice quantum *)
        elapsed        * : INTEGER;  (* current quantum ticks *)
        sysFlags       * : SET;      (* misc internal system flags *)
        idNestCnt      * : SHORTINT; (* interrupt disable nesting count *)
        tdNestCnt      * : SHORTINT; (* task disable nesting count *)

        attnFlags      * : SET;      (* special attention flags (readable) *)

        attnResched    * : INTEGER;  (* rescheduling attention *)
        resModules     * : APTR;     (* resident module array pointer *)
        taskTrapCode   * : PROC;
        taskExceptCode * : PROC;
        taskExitCode   * : PROC;
        taskSigAlloc   * : LONGSET;
        taskTrapAlloc  * : SET;


(****** System Lists (private!) ********************************)

        memList      - : List;
        resourceList - : List;
        deviceList   - : List;
        intrList     - : List;
        libList      - : List;
        portList     - : List;
        taskReady    - : List;
        taskWait     - : List;

        softInts     - : ARRAY 5 OF SoftIntList;

(****** Other Globals *******************************************)

        lastAlert    - : ARRAY 4 OF LONGINT;

        (* these next two variables are provided to allow
        ** system developers to have a rough idea of the
        ** period of two externally controlled signals --
        ** the time between vertical blank interrupts and the
        ** external line rate (which is counted by CIA A's
        ** "time of day" clock).  In general these values
        ** will be 50 or 60, and may or may not track each
        ** other.  These values replace the obsolete AFB_PAL
        ** and AFB_50HZ flags.
        *)
        vblankFrequency      - : SHORTINT;   (* (readable) *)
        powerSupplyFrequency - : SHORTINT;   (* (readable) *)

        semaphoreList        - : List;

        (* these next two are to be able to kickstart into user ram.
        ** KickMemPtr holds a singly linked list of MemLists which
        ** will be removed from the memory list via AllocAbs.  If
        ** all the AllocAbs's succeeded, then the KickTagPtr will
        ** be added to the rom tag list.
        *)
        kickMemPtr   * : APTR;   (* ptr to queue of mem lists *)
        kickTagPtr   * : APTR;   (* ptr to rom tag queue *)
        kickCheckSum * : APTR;   (* checksum for mem and tags *)

(****** V36 Exec additions start here **************************************)

        pad0            : INTEGER; (* Private internal use *)
        launchPoint     : LONGINT; (* Private to Launch/Switch *)
        ramLibPrivate   : APTR;
        (* The next ULONG contains the system "E" clock frequency,
        ** expressed in Hertz.  The E clock is used as a timebase for
        ** the Amiga's 8520 I/O chips. (E is connected to "02").
        ** Typical values are 715909 for NTSC, or 709379 for PAL.
        *)
        eClockFrequency - : LONGINT;  (* (readable) *)
        cacheControl      : APTR;     (* Private to CacheControl calls *)
        taskID          * : LONGINT;  (* Next available task ID *)

        reserved1       * : ARRAY 5 OF LONGINT;

        mmuLock           : APTR;     (* private *)

        reserved2       * : ARRAY 3 OF LONGINT;

(****** V39 Exec additions start here **************************************)

        (* The following list and data element are used
         * for V39 exec's low memory handler...
         *)
        memHandlers    *: MinList;  (* The handler list *)
        memHandler      : APTR;     (* Private! handler pointer *)
      END;

CONST
(****** Bit defines for AttnFlags (see above) ******************************)

(*  Processors and Co-processors: *)
(* ExecBase.attnFlags *)
  m68010     * = 0;       (* also set for 68020 *)
  m68020     * = 1;       (* also set for 68030 *)
  m68030     * = 2;       (* also set for 68040 *)
  m68040     * = 3;
  m68881     * = 4;       (* also set for 68882 *)
  m68882     * = 5;


(****** Selected flag definitions for Cache manipulation calls **********)

  enableI       * = 0;  (* Enable instruction cache *)
  freezeI       * = 1;  (* Freeze instruction cache *)
  clearI        * = 3;  (* Clear instruction cache  *)
  ibe           * = 4;  (* Instruction burst enable *)
  enableD       * = 8;  (* 68030 Enable data cache  *)
  freezeD       * = 9;  (* 68030 Freeze data cache  *)
  clearD        * = 11; (* 68030 Clear data cache   *)
  dbe           * = 12; (* 68030 Data burst enable *)
  writeAllocate * = 13; (* 68030 Write-Allocate mode (must always be set!) *)
  enableE       * = 30; (* Master enable for external caches
                         * External caches should track the
                         * state of the internal caches
                         * such that they do not cache anything
                         * that the internal cache turned off for. *)
  copyBack      * = 31; (* Master enable for copyback caches *)

  dmaContinue    * = 1; (* Continuation flag for CachePreDMA *)
  dmaNoModify    * = 2; (* Set if DMA does not update memory *)
  dmaReadFromRAM * = 3; (* Set if DMA goes *FROM* RAM to device *)

TYPE

  IORequest * = STRUCT (message * : Message)
    device  * : DevicePtr;    (* device node pointer  *)
    unit    * : UnitPtr;      (* unit (driver private)*)
    command * : INTEGER;      (* device command *)
    flags   * : SHORTSET;
    error   * : SHORTINT;     (* error or warning num *)
  END;

  IOStdReq * = STRUCT (message * : Message)
    device  * : DevicePtr;    (* device node pointer  *)
    unit    * : UnitPtr;      (* unit (driver private)*)
    command * : INTEGER;      (* device command *)
    flags   * : SHORTSET;
    error   * : SHORTINT;     (* error or warning num *)
    actual  * : LONGINT;      (* actual number of bytes transferred *)
    length  * : LONGINT;      (* requested number bytes transferred*)
    data    * : APTR;         (* points to data area *)
    offset  * : LONGINT;      (* offset for block structured devices *)
  END;

CONST

(* library vector offsets for device reserved vectors *)
  beginIO  * = -30;
  abortIO  * = -36;

(* io_Flags defined bits *)
  quick    * =   0;

(* IORequest.command: *)
  invalid    * = 0;
  reset      * = 1;
  read       * = 2;
  write      * = 3;
  update     * = 4;
  clear      * = 5;
  stop       * = 6;
  start      * = 7;
  flush      * = 8;

  nonstd     * = 9;

TYPE

(****** MemChunk ****************************************************)

  MemChunk * = STRUCT
    next * : MemChunkPtr;  (* pointer to next chunk *)
    bytes* : LONGINT;      (* chunk byte size      *)
  END;


(****** MemHeader ***************************************************)

  MemHeader * = STRUCT (node * : Node)
    attributes * : SET;         (* characteristics of this region *)
    first * : MemChunkPtr;      (* first free region            *)
    lower * : APTR;             (* lower memory bound           *)
    upper * : APTR;             (* upper memory bound+1 *)
    free  * : LONGINT;          (* total number of free bytes   *)
  END;


(****** MemEntry ****************************************************)

  MemEntry * = STRUCT
    addr  * : APTR;      (* the address of this memory region      *)
                         (* or: LONGSET, the AllocMem requirements *)
    length* : LONGINT    (* the length of this memory region *)
  END;


(****** MemList *****************************************************)

(* Note: sizeof(struct MemList) includes the size of the first MemEntry! *)
  MemList * = STRUCT (node * : Node)
    numEntries * : INTEGER;            (* number of entries in this struct *)
(*  me: ARRAY numEntries OF MemEntry;  (* the entries                      *) *)
  END;

CONST

(*----- Memory Requirement Types ---------------------------*)
(*----- See the AllocMem() documentation for details--------*)

  any         * =  LONGSET{};    (* Any type of memory will do *)
  public      * =  0;
  chip        * =  1;
  fast        * =  2;
  local       * =  8;
  mem24BitDMA * =  9;   (* DMAable memory within 24 bits of address *)
  kick        * = 10;   (* Memory that can be used for KickTags *)

  memClear    * = 16;
  largest     * = 17;
  reverse     * = 18;
  total       * = 19;   (* AvailMem: return total size of memory *)

  noExpunge   * = 31;   (* AllocMem: Do not cause expunge on failure *)

  (*----- Current alignment rules for memory blocks (may increase) -----*)
  blockSize   * = 8;
  blockMask   * = blockSize-1;

TYPE
  MemPool * = STRUCT END; (* dummy for memory pools *)

(****** MemHandlerData **********************************************)
(* Note:  This structure is *READ ONLY* and only EXEC can create it!*)
TYPE
  MemHandlerData * = STRUCT
    requestSize  -: LONGINT;      (* Requested allocation size *)
    requestFlags -: LONGSET;      (* Requested allocation flags *)
    flags        -: LONGSET;      (* Flags (see below) *)
  END;

CONST
  recycle *= 0; (* 0==First time, 1==recycle *)

(****** Low Memory handler return values ***************************)
  didNothing * =  0;    (* Nothing we could do... *)
  allDone    * = -1;    (* We did all we could do *)
  tryAgain   * =  1;    (* We did some, try the allocation again *)

TYPE
  Resident * = STRUCT
    matchWord * : INTEGER;     (* word to match on (ILLEGAL)   *)
    matchTag  * : ResidentPtr; (* pointer to the above       *)
    endSkip   * : APTR;        (* address to continue scan     *)
    flags     * : SHORTSET;    (* various tag flags            *)
    version   * : SHORTINT;    (* release version number       *)
    type      * : SHORTINT;    (* type of module (NT_XXXXXX)   *)
    pri       * : SHORTINT;    (* initialization priority *)
    name      * : LSTRPTR;     (* pointer to node name *)
    idString  * : LSTRPTR;     (* pointer to identification string *)
    init      * : APTR;        (* pointer to init code *)
  END;


CONST

  matchWord  * = 4AFCH;  (* The 68000 "ILLEGAL" instruction *)

(* Resident.flags: *)
  autoinit   * = 7;  (* rt_Init points to data structure *)
  afterDos   * = 2;
  singleTask * = 1;
  coldStart  * = 0;

TYPE
(****** SignalSemaphore *********************************************)

(* Private structure used by ObtainSemaphore() *)
  SemaphoreRequest * = STRUCT (link - : MinNode)
    waiter - : TaskPtr;
  END;

(* Signal Semaphore data structure *)
  SignalSemaphore * = STRUCT (link * : Node)
    nestCount * : INTEGER;
    waitQueue * : MinList;
    multipleLink -: SemaphoreRequest;
    owner     * : TaskPtr;
    queueCount* : INTEGER;
  END;

(****** Semaphore procure message (for use in V39 Procure/Vacate ****)

  SemaphoreMessage * = STRUCT (message *: Message)
    semaphore * :SignalSemaphorePtr;
   END;

CONST
  shared    * = 1;
  exclusive * = 0;

TYPE
  MsgPortLockMsg * = STRUCT (node * : Node)
    flags * : SHORTINT;
    sigBit * : SHORTINT;     (* signal bit number    *)
    lockMsg* : MessagePtr;   (* object to be signalled *) (* may be other type [hG] *)
    msgList* : List;         (* message linked list  *)
  END;

(****** Semaphore (Old Procure/Vacate type, not reliable) ***********)

  Semaphore * = STRUCT (msgPort * : MsgPort)  (* Do not use these semaphores! *)
    bids    * : INTEGER;
  END;


VAR
  AbsExecBase * [4H] : ExecBasePtr; (* absolute exec base, avoid to use this *)
(* $IF Implementation *)
  SysBase     *      : ExecBasePtr; (* exec base, use this!                  *)
  exec        *      : ExecBasePtr; (* obsolety, included for compatibility  *)
(* $ELSE *)
  SysBase     * [4H] : ExecBasePtr; (* see above *)
  exec        * [4H] : ExecBasePtr;
(* $END *)

(* ------ misc ---------------------------------------------------------*)
PROCEDURE Supervisor   *{SysBase,- 30}(userFunction{13}: PROC): APTR;
PROCEDURE ExitIntr     *{SysBase,- 36};
PROCEDURE Schedule     *{SysBase,- 42};
PROCEDURE Reschedule   *{SysBase,- 48};
PROCEDURE Switch       *{SysBase,- 54};
PROCEDURE Dispatch     *{SysBase,- 60};
PROCEDURE Exception    *{SysBase,- 66};
(* ------ special patchable hooks to internal exec activity ------------*)
(* ------ module creation ----------------------------------------------*)
PROCEDURE InitCode     *{SysBase,- 72}(startClass{0}: SHORTSET;
                                       version{1}: LONGINT);
PROCEDURE InitStruct   *{SysBase,- 78}(initTable{9}: APTR;
                                       memory{10}: APTR;
                                       size{0}: LONGINT);
PROCEDURE MakeLibrary  *{SysBase,- 84}(funcInit{8}   : APTR;
                                       structInit{9} : APTR;
                                       libInit{10}   : PROC;
                                       dataSize{0}   : LONGINT;
                                       segList{1}    : BPTR): LibraryPtr;
PROCEDURE MakeFunctions*{SysBase,- 90}(target{8}     : APTR;
                                       funcArray{9}  : APTR;
                                       funcDisplBase{10}: APTR);
PROCEDURE FindResident *{SysBase,- 96}(name{9}       : ARRAY OF CHAR): ResidentPtr;
PROCEDURE InitResident *{SysBase,-102}(resident{9}   : ResidentPtr;
                                       segList{1}    : BPTR);
(* ------ diagnostics --------------------------------------------------*)
PROCEDURE Alert        *{SysBase,-108}(alertNum{7}   : LONGINT);
PROCEDURE Debug        *{SysBase,-114}(flags{0}      : LONGSET);
(* ------ interrupts ---------------------------------------------------*)
PROCEDURE Disable      *{SysBase,-120};
PROCEDURE Enable       *{SysBase,-126};
PROCEDURE Forbid       *{SysBase,-132};
PROCEDURE Permit       *{SysBase,-138};
PROCEDURE SetSR        *{SysBase,-144}(newSR{0}      : SET;
                                       mask{1}       : SET): SET;
PROCEDURE SuperState   *{SysBase,-150};
PROCEDURE UserState    *{SysBase,-156}(sysStack{0}   : APTR);
PROCEDURE SetIntVector *{SysBase,-162}(intNumber{0}  : LONGINT;
                                       interrupt{9}  : InterruptPtr): InterruptPtr;
PROCEDURE AddIntServer *{SysBase,-168}(intNumber{0}  : LONGINT;
                                       interrupt{9}  : InterruptPtr);
PROCEDURE RemIntServer *{SysBase,-174}(intNumber{0}  : LONGINT;
                                       interrupt{9}  : InterruptPtr);
PROCEDURE Cause        *{SysBase,-180}(interrupt{9}  : InterruptPtr);
(* ------ memory allocation --------------------------------------------*)
PROCEDURE Allocate     *{SysBase,-186}(freeList{8}   : MemHeaderPtr;
                                       byteSize{0}   : LONGINT): APTR;
PROCEDURE Deallocate   *{SysBase,-192}(freeList{8}   : MemHeaderPtr;
                                       memoryBlock{9}: APTR;
                                       byteSize{0}   : LONGINT);
PROCEDURE AllocMem     *{SysBase,-198}(byteSize{0}   : LONGINT;
                                       requirements{1}: LONGSET): APTR;
PROCEDURE AllocAbs     *{SysBase,-204}(byteSize{0}   : LONGINT;
                                       location{9}   : APTR): APTR;
PROCEDURE FreeMem      *{SysBase,-210}(memoryBlock{9}: APTR;
                                       byteSize{0}   : LONGINT);
PROCEDURE AvailMem     *{SysBase,-216}(requirements{1}: LONGSET): LONGINT;
PROCEDURE AllocEntry   *{SysBase,-222}(memList{8}    : APTR): APTR;
PROCEDURE FreeEntry    *{SysBase,-228}(entry{8}      : APTR);
(* ------ lists --------------------------------------------------------*)
PROCEDURE Insert       *{SysBase,-234}(VAR list{8}   : CommonList;
                                       node{9}       : CommonNodePtr;
                                       pred{10}      : CommonNodePtr);
PROCEDURE AddHead      *{SysBase,-240}(VAR list{8}   : CommonList;
                                       node{9}       : CommonNodePtr);
PROCEDURE AddTail      *{SysBase,-246}(VAR list{8}   : CommonList;
                                       node{9}       : CommonNodePtr);
PROCEDURE Remove       *{SysBase,-252}(node{9}       : CommonNodePtr);
PROCEDURE RemHead      *{SysBase,-258}(VAR list{8}   : CommonList): CommonNodePtr;
PROCEDURE RemTail      *{SysBase,-264}(VAR list{8}   : CommonList): CommonNodePtr;
PROCEDURE Enqueue      *{SysBase,-270}(VAR list{8}   : CommonList;
                                       node{9}       : CommonNodePtr);
PROCEDURE FindName     *{SysBase,-276}(VAR list{8}   : CommonList;
                                       name{9}       : ARRAY OF CHAR): CommonNodePtr;
(* ------ tasks --------------------------------------------------------*)
PROCEDURE AddTask      *{SysBase,-282}(task{9}       : TaskPtr;
                                       initPC{10}    : PROC;
                                       finalPC{11}   : APTR);
PROCEDURE RemTask      *{SysBase,-288}(task{9}       : TaskPtr);
PROCEDURE FindTask     *{SysBase,-294}(name{9}       : ARRAY OF CHAR): TaskPtr;
PROCEDURE SetTaskPri   *{SysBase,-300}(task{9}       : TaskPtr;
                                       priority{0}   : LONGINT): SHORTINT;
PROCEDURE SetSignal    *{SysBase,-306}(newSignals{0} : LONGSET;
                                       signalSet{1}  : LONGSET): LONGSET;
PROCEDURE SetExcept    *{SysBase,-312}(newSignals{0} : LONGSET;
                                       signalSet{1}  : LONGSET): LONGSET;
PROCEDURE Wait         *{SysBase,-318}(signalSet{0}  : LONGSET): LONGSET;
PROCEDURE Signal       *{SysBase,-324}(task{9}       : TaskPtr;
                                       signalSet{0}  : LONGSET);
PROCEDURE AllocSignal  *{SysBase,-330}(signalNum{0}  : LONGINT): SHORTINT;
PROCEDURE FreeSignal   *{SysBase,-336}(signalNum{0}  : LONGINT);
PROCEDURE AllocTrap    *{SysBase,-342}(trapNum{0}    : LONGINT): SHORTINT;
PROCEDURE FreeTrap     *{SysBase,-348}(trapNum{0}    : LONGINT);
(* ------ messages -----------------------------------------------------*)
PROCEDURE AddPort      *{SysBase,-354}(port{9}       : MsgPortPtr);
PROCEDURE RemPort      *{SysBase,-360}(port{9}       : MsgPortPtr);
PROCEDURE PutMsg       *{SysBase,-366}(port{8}       : MsgPortPtr;
                                       message{9}    : MessagePtr);
PROCEDURE GetMsg       *{SysBase,-372}(port{8}       : MsgPortPtr): MessagePtr;
PROCEDURE ReplyMsg     *{SysBase,-378}(message{9}    : MessagePtr);
PROCEDURE WaitPort     *{SysBase,-384}(port{8}       : MsgPortPtr);
PROCEDURE FindPort     *{SysBase,-390}(name{9}       : ARRAY OF CHAR): MsgPortPtr;
(* ------ libraries ----------------------------------------------------*)
PROCEDURE AddLibrary   *{SysBase,-396}(library{9}    : LibraryPtr);
PROCEDURE RemLibrary   *{SysBase,-402}(library{9}    : LibraryPtr);
PROCEDURE OldOpenLibrary*{SysBase,-408}(name{9}      : ARRAY OF CHAR): LibraryPtr;
PROCEDURE CloseLibrary *{SysBase,-414}(library{9}    : LibraryPtr);
PROCEDURE SetFunction  *{SysBase,-420}(library{9}    : LibraryPtr;
                                       funcOffset{8} : LONGINT;
                                       newFunction{0}: PROC): PROC;
PROCEDURE SumLibrary   *{SysBase,-426}(library{9}    : LibraryPtr);
(* ------ devices ------------------------------------------------------*)
PROCEDURE AddDevice    *{SysBase,-432}(device{9}     : DevicePtr);
PROCEDURE RemDevice    *{SysBase,-438}(device{9}     : DevicePtr);
PROCEDURE OpenDevice   *{SysBase,-444}(devName{8}    : ARRAY OF CHAR;
                                       unit{0}       : LONGINT;
                                       ioRequest{9}  : MessagePtr;
                                       flags{1}      : LONGSET): SHORTINT;
PROCEDURE CloseDevice  *{SysBase,-450}(ioRequest{9}  : MessagePtr);
PROCEDURE DoIO         *{SysBase,-456}(ioRequest{9}  : MessagePtr): SHORTINT;
PROCEDURE OldDoIO      *{SysBase,-456}(ioRequest{9}  : MessagePtr); (* same w/o result *)
PROCEDURE SendIO       *{SysBase,-462}(ioRequest{9}  : MessagePtr);
PROCEDURE CheckIO      *{SysBase,-468}(ioRequest{9}  : MessagePtr): IORequestPtr;
PROCEDURE WaitIO       *{SysBase,-474}(ioRequest{9}  : MessagePtr): SHORTINT;
PROCEDURE OldWaitIO    *{SysBase,-474}(ioRequest{9}  : MessagePtr); (* same w/o result *)
PROCEDURE AbortIO      *{SysBase,-480}(ioRequest{9}  : MessagePtr);
(* ------ resources ----------------------------------------------------*)
PROCEDURE AddResource  *{SysBase,-486}(resource{9}   : APTR);
PROCEDURE RemResource  *{SysBase,-492}(resource{9}   : APTR);
PROCEDURE OpenResource *{SysBase,-498}(resName{9}    : ARRAY OF CHAR): APTR;
(* ------ private diagnostic support -----------------------------------*)
(* ------ misc ---------------------------------------------------------*)
PROCEDURE RawIOInit    *{SysBase,-504};
PROCEDURE RawMayGetChar*{SysBase,-510};
PROCEDURE RawPutChar   *{SysBase,-516};
PROCEDURE RawDoFmt     *{SysBase,-522}(formatStr{8}  : ARRAY OF CHAR;
                                       dataStream{9} : APTR;
                                       putChProc{10} : PROC;
                                       putChData{11} : APTR): APTR;
PROCEDURE RawDoFmtL    *{SysBase,-522}(formatStr{8}  : ARRAY OF CHAR;
                                       dataStream{9} : ARRAY OF SYSTEM.BYTE;
                                       putChProc{10} : PROC;
                                       putChData{11} : APTR): APTR;
PROCEDURE OldRawDoFmt  *{SysBase,-522}(formatStr{8}  : ARRAY OF CHAR;
                                       dataStream{9} : APTR;
                                       putChProc{10} : PROC;
                                       putChData{11} : APTR);
PROCEDURE OldRawDoFmtL *{SysBase,-522}(formatStr{8}  : ARRAY OF CHAR;
                                       dataStream{9} : ARRAY OF SYSTEM.BYTE;
                                       putChProc{10} : PROC;
                                       putChData{11} : APTR);
PROCEDURE GetCC        *{SysBase,-528}(): SET;
PROCEDURE TypeOfMem    *{SysBase,-534}(address{9}    : APTR): LONGSET;
PROCEDURE Procure      *{SysBase,-540}(VAR sigSem{8} : Semaphore;
                                       bidMsg{9}     : SemaphoreMessagePtr): BOOLEAN;
PROCEDURE Vacate       *{SysBase,-546}(VAR sigSem{8} : Semaphore;
                                       bidMsg{9}     : SemaphoreMessagePtr): BOOLEAN;
PROCEDURE OpenLibrary  *{SysBase,-552}(libName{9}    : ARRAY OF CHAR;
                                       version{0}    : LONGINT): LibraryPtr;
(* --- functions in V33 or higher (Release 1.2) ---*)
(* ------ signal semaphores (note funny registers)----------------------*)
PROCEDURE InitSemaphore*{SysBase,-558}(VAR sigSem{8} : SignalSemaphore);
PROCEDURE ObtainSemaphore*{SysBase,-564}(VAR sigSem{8}: SignalSemaphore);
PROCEDURE ReleaseSemaphore*{SysBase,-570}(VAR sigSem{8}: SignalSemaphore);
PROCEDURE AttemptSemaphore*{SysBase,-576}(VAR sigSem{8}: SignalSemaphore): BOOLEAN;
PROCEDURE ObtainSemaphoreList*{SysBase,-582}(VAR sigSem{8}: List);
PROCEDURE ReleaseSemaphoreList*{SysBase,-588}(VAR sigSem{8}: List);
PROCEDURE FindSemaphore*{SysBase,-594}(sigSem{9}     : ARRAY OF CHAR): SignalSemaphorePtr;
PROCEDURE AddSemaphore *{SysBase,-600}(VAR sigSem{9} : SignalSemaphore);
PROCEDURE RemSemaphore *{SysBase,-606}(VAR sigSem{9} : SignalSemaphore);
(* ------ kickmem support ----------------------------------------------*)
PROCEDURE SumKickData  *{SysBase,-612}(): LONGINT;
(* ------ more memory support ------------------------------------------*)
PROCEDURE AddMemList   *{SysBase,-618}(size{0}       : LONGINT;
                                       attributes{1} : LONGSET;
                                       pri{2}        : LONGINT;
                                       base{8}       : APTR;
                                       name{9}       : ARRAY OF CHAR);
PROCEDURE CopyMem      *{SysBase,-624}(source{8}     : ARRAY OF BYTE;
                                       dest{9}       : ARRAY OF BYTE;
                                       size{0}       : LONGINT);
PROCEDURE CopyMemAPTR  *{SysBase,-624}(source{8}     : APTR;   (* equivalent to CopyMem, uses ptrs instead *)
                                       dest{9}       : APTR;
                                       size{0}       : LONGINT);
PROCEDURE CopyMemQuick *{SysBase,-630}(source{8}     : ARRAY OF BYTE;
                                       dest{9}       : ARRAY OF BYTE;
                                       size{0}       : LONGINT);
PROCEDURE CopyMemQuickAPTR*{SysBase,-630}(source{8}  : APTR;   (* equivalent to CopyMemQuick, uses ptrs instead *)
                                       dest{9}       : APTR;
                                       size{0}       : LONGINT);

(* --- functions in V36 or higher (dRelease 2.0)      --- *)
(* --- REMEMBER: You are to check the version BEFORE you use this ! --- *)

(* ------ cache --------------------------------------------------------*)
PROCEDURE CacheClearU  *{SysBase,-636}();
PROCEDURE CacheClearE  *{SysBase,-642}(address{8}    : APTR;
                                       length{0}     : LONGINT;
                                       caches{1}     : LONGSET);
PROCEDURE CacheControl *{SysBase,-648}(cacheBits{0}  : LONGSET;
                                       cacheMask{1}  : LONGSET): LONGSET;
(* ------ misc ---------------------------------------------------------*)
PROCEDURE CreateIORequest*{SysBase,-654}(port{8}     : MsgPortPtr;
                                         size{0}     : LONGINT): MessagePtr;
PROCEDURE DeleteIORequest*{SysBase,-660}(iorequest{8}: MessagePtr);
PROCEDURE CreateMsgPort*{SysBase,-666}(): MsgPortPtr;
PROCEDURE DeleteMsgPort*{SysBase,-672}(port{8}: MsgPortPtr);
PROCEDURE ObtainSemaphoreShared*{SysBase,-678}(VAR sigSem{8}: SignalSemaphore);
(* ------ even more memory support -------------------------------------*)
PROCEDURE AllocVec     *{SysBase,-684}(byteSize{0}   : LONGINT;
                                       requirements{1}:LONGSET ): APTR;
PROCEDURE FreeVec      *{SysBase,-690}(memoryBlock{9}: APTR);
(*------ V39 Pool LVOs...*)
PROCEDURE CreatePool   *{SysBase,-696}(requirements{0}: LONGSET;
                                       puddleSize{1} : LONGINT;
                                       threshSize{2} : LONGINT): MemPoolPtr;
PROCEDURE DeletePool   *{SysBase,-702}(poolHeader{8} : MemPoolPtr);
PROCEDURE AllocPooled  *{SysBase,-708}(poolHeader{8} : MemPoolPtr;
                                       memSize{0}    : LONGINT): APTR;
PROCEDURE FreePooled   *{SysBase,-714}(poolHeader{8} : MemPoolPtr;
                                       memory{9}     : APTR;
                                       memSize{0}    : LONGINT);
(* ------ misc ---------------------------------------------------------*)
PROCEDURE AttemptSemaphoreShared*{SysBase,-720}(VAR sigSem{8}: SignalSemaphore): BOOLEAN;
PROCEDURE ColdReboot   *{SysBase,-726};
PROCEDURE StackSwap    *{SysBase,-732}(VAR newStack{8}: StackSwapStruct);
(* ------ task trees ---------------------------------------------------*)
PROCEDURE ChildFree    *{SysBase,-738}(tid{0}        : APTR);
PROCEDURE ChildOrphan  *{SysBase,-744}(tid{0}        : APTR);
PROCEDURE ChildStatus  *{SysBase,-750}(tid{0}        : APTR);
PROCEDURE ChildWait    *{SysBase,-756}(tid{0}        : APTR);
(*------ future expansion ---------------------------------------------*)
PROCEDURE CachePreDMA  *{SysBase,-762}(address{8}   : APTR;
                                       VAR length{9}: LONGINT;
                                       flags{0}     : LONGINT): APTR;
PROCEDURE CachePostDMA *{SysBase,-768}(address{8}   : APTR;
                                       VAR length{9}: LONGINT;
                                       flags{0}     : LONGINT);
(*------ New, for V39 -------------------------------------------------*)
(*--- functions in V39 or higher (Release 3) ---*)
(*------ Low memory handler functions ---------------------------------*)
PROCEDURE AddMemHandler  *{SysBase,-774}(memHand{1} : InterruptPtr);
PROCEDURE RemMemHandler  *{SysBase,-780}(memHand{1} : InterruptPtr);
(*------ Function to attempt to obtain a Quick Interrupt Vector...*)
PROCEDURE ObtainQuickVector *{SysBase,-786}(interruptCode{8}: APTR): LONGINT;

(* $IF Implementation *)
BEGIN
  SysBase := AbsExecBase;
  exec    := SysBase;
(* $END *)

END Exec.

