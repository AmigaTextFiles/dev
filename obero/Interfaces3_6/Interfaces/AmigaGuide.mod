(*
(*  Amiga Oberon Interface Module:
**  $VER: AmigaGuide.mod 40.15 (28.12.93) Oberon 3.0
**
**      (C) Copyright 1991-1993 Commodore-Amiga, Inc.
**          All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993 by hartmut Goebel
**          All Rights Reserved
**
*)      Thanks to Lars Düning for suppling this module
*)

MODULE AmigaGuide;

IMPORT
  d  * := Dos,
  e  * := Exec,
  I  * := Intuition,
  rx * := Rexx,
  u  * := Utility;

(*-------------------------------------------------------------------------*)
CONST
  amigaguideName * = "amigaguide.library";

TYPE
  AmigaGuideHostPtr  * = UNTRACED POINTER TO AmigaGuideHost;
  AmigaGuideMsgPtr   * = UNTRACED POINTER TO AmigaGuideMsg;
  ContextTablePtr    * = UNTRACED POINTER TO ContextTable;
  MethodPtr          * = UNTRACED POINTER TO Method;
  Msg                * = MethodPtr;                   (* The official name *)
    OpFindHostPtr    * = UNTRACED POINTER TO OpFindHost;
    OpNodeIOPtr      * = UNTRACED POINTER TO OpNodeIO;
    OpExpungeNodePtr * = UNTRACED POINTER TO OpExpungeNode;
  NewAmigaGuidePtr   * = UNTRACED POINTER TO NewAmigaGuide;
  XRefPtr            * = UNTRACED POINTER TO XRef;

CONST

(* AmigaGuideMsg.type *)
  apshToolID       * = 11000;

  startupMsgID     * = apshToolID + 1;   (* Startup message *)
  loginToolID      * = apshToolID + 2;   (* Login a tool SIPC port *)
  logoutToolID     * = apshToolID + 3;   (* Logout a tool SIPC port *)
  shutdownMsgID    * = apshToolID + 4;   (* Shutdown message *)
  activateToolID   * = apshToolID + 5;   (* Activate tool *)
  deactivateToolID * = apshToolID + 6;   (* Deactivate tool *)
  activeToolID     * = apshToolID + 7;   (* Tool Active *)
  inactiveToolID   * = apshToolID + 8;   (* Tool Inactive *)
  toolStatusID     * = apshToolID + 9;   (* Status message *)
  toolCmdID        * = apshToolID + 10;  (* Tool command message *)
  toolCmdReplyID   * = apshToolID + 11;  (* Reply to tool command *)
  shutdownToolID   * = apshToolID + 12;  (* Shutdown tool *)


(* Attributes accepted by GetAmigaGuideAttr() *)
  agaDummy    * = u.user;

  path      * = agaDummy+1;
  xrefList  * = agaDummy+2;
  activate  * = agaDummy+3;
  context   * = agaDummy+4;
  helpGroup * = agaDummy+5;    (* (ULONG) Unique identifier *)

  agaReserved1 * = agaDummy+6;
  agaReserved2 * = agaDummy+7;
  agaReserved3 * = agaDummy+8;

  arexxPort * = agaDummy+9;
    (* MsgPortPtr Pointer to the ARexx message port (V40) *)

  arexxPortName * = agaDummy+10;
    (* (LSTRPTR) Used to specify the ARexx port name (V40) (not copied) *)

TYPE
  AGContext  * = UNTRACED POINTER TO STRUCT END;

  AmigaGuideMsg * = STRUCT (msg * : e.Message)
    type    * : LONGINT;         (* Type of message *)
    data    * : e.APTR;          (* Pointer to message data *)
    dSize   * : LONGINT;         (* Size of message data *)
    dType   * : LONGINT;         (* Type of message data *)
    priRet  * : LONGINT;         (* Primary return value *)
    secRet  * : LONGINT;         (* Secondary return value *)
    system1 * : e.APTR;
    system2 * : e.APTR;
  END;

(* Allocation description structure *)
  NewAmigaGuide * = STRUCT
    lock       * : d.FileLockPtr;    (* Lock on the document directory *)
    name       * : e.LSTRPTR;        (* Name of document file *)
    screen     * : I.ScreenPtr;      (* Screen to place windows within *)
    pubScreen  * : e.LSTRPTR;        (* Public screen name to open on *)
    hostPort   * : e.LSTRPTR;        (* Application's ARexx port name *)
    clientPort * : e.LSTRPTR;        (* Name to assign to the clients ARexx port *)
    baseName   * : e.LSTRPTR;        (* Base name of the application *)
    flags      * : LONGSET;          (* Flags *)
    context    * : ContextTablePtr;  (* NIL terminated context table *)
    node       * : e.LSTRPTR;        (* Node to align on first (defaults to Main) *)
    line       * : LONGINT;          (* Line to align on *)
    extens     * : u.TagListPtr;     (* Tag array extension *)
    client     * : e.APTR;           (* Private! MUST be NULL *)
  END;


(* The ContextTable in NewAmigaGuide is an array of e.LSTRPTRs, terminated
 * by a NIL pointer.
 * This definition keeps the array character, but can't be allocated
 * directly with NEW()!
 *)
  ContextTable * = ARRAY MAX(INTEGER) OF e.LSTRPTR;


CONST

(* public Client flags (NewAmigaGuide.flags) *)
  loadIndex  * = 0;     (* Force load the index at init time *)
  loadAll    * = 1;     (* Force load the entire database at init *)
  cacheNode  * = 2;     (* Cache each node as visited *)
  cacheDB    * = 3;     (* Keep the buffers around until expunge *)
  unique     * = 15;    (* Unique ARexx port name *)
  noActivate * = 16;    (* Don't activate window *)
  sysGads    * = 31;


(* Callback function ID's *)
  open  * = 0;
  close * = 1;


(* Callback error codes *)
  notEnoughMemory  * = 100;
  cantOpenDataBase * = 101;
  cantFindNode     * = 102;
  cantOpenNode     * = 103;
  cantOpenWindow   * = 104;
  invalidCommand   * = 105;
  cantComplete     * = 106;
  portClosed       * = 107;
  cantCreatePort   * = 108;
  keywordNotFound  * = 113;


TYPE

(* Cross reference node *)
  XRef * = STRUCT (node * : e.Node)
    pad  * : INTEGER;     (* Padding *)
    df   * : e.APTR;      (* Document defined in ('DocFilePtr') *)
    file * : e.LSTRPTR;   (* Name of document file *)
    name * : e.LSTRPTR;   (* Name of item *)
    line * : LONGINT;     (* Line defined at *)
  END;


CONST

  XRSize * = SIZE (XRef);    (* A neato... *)

(* Types of cross reference nodes *)
  generic  * = 0;
  function * = 1;
  command  * = 2;
  include  * = 3;
  macro    * = 4;
  struct   * = 5;
  field    * = 6;
  typedef  * = 7;
  define   * = 8;


TYPE

(* Callback handle *)
  AmigaGuideHost * = STRUCT (dispatcher * : u.Hook)
    reserved   * : LONGINT;   (* Must be 0 *)
    flags      * : LONGSET;
    useCnt     * : LONGINT;   (* Number of open nodes *)
    systemData * : e.APTR;    (* Reserved for system use *)
    userData   * : e.APTR;    (* Anything you want... *)
  END;


CONST

(* methods *)
  findNode  * = 1;
  openNode  * = 2;
  closeNode * = 3;
  expunge   * = 10;   (* Expunge DataBase *)


TYPE

(* Basetype of the command structures *)
  Method * = STRUCT
    ID * : LONGINT;
  END;


(* Method 'findNode' *)
  OpFindHost * = STRUCT (method * : Method)
    attrs - : u.TagListPtr;    (*  R: Additional attributes *)
    node  - : e.LSTRPTR;       (*  R: Name of node *)
    toc   * : e.LSTRPTR;       (*  W: Table of Contents *)
    title * : e.LSTRPTR;       (*  W: Title to give to the node *)
    next  * : e.LSTRPTR;       (*  W: Next node to browse to *)
    prev  * : e.LSTRPTR;       (*  W: Previous node to browse to *)
  END;


(* Methods 'openNode', 'closeNode' *)
  OpNodeIO * = STRUCT (method * : Method)
    attrs     - : u.TagListPtr; (*  R: Additional attributes *)
    node      - : e.LSTRPTR;    (*  R: Node name and arguments *)
    fileName  * : e.LSTRPTR;    (*  W: File name buffer *)
    docBuffer * : e.LSTRPTR;    (*  W: Node buffer *)
    buffLen   * : LONGINT;      (*  W: Size of buffer *)
    flags     * : LONGSET;      (* RW: Control flags *)
  END;


CONST

(* NodeIO.flags *)
  keep      * = 0;    (* Don't flush this node until database is closed. *)
  reserved1 * = 1;    (* Reserved for system use *)
  reserved2 * = 2;    (* Reserved for system use *)
  ascii     * = 3;    (* Node is straight ASCII *)
  reserved3 * = 4;    (* Reserved for system use *)
  clean     * = 5;    (* Remove the node from the database *)
  done      * = 6;    (* Done with node *)

(* NodeIO.attrs (Tag IDs) *)
  htnaDummy     * = u.user;
  htnaScreen    * = htnaDummy + 1;    (* (ScreenPtr) Screen that window resides in *)
  htnaPens      * = htnaDummy + 2;    (* Pen array (from DrawInfo) *)
  rhtnaEctangle * = htnaDummy + 3;    (* Window box *)


TYPE

(* Method 'expunge' *)
  OpExpungeNode * = STRUCT (method * : Method)
    attrs * : u.TagListPtr;    (*  R: Additional attributes *)
  END;


(*-------------------------------------------------------------------------*)

VAR
  base * : e.LibraryPtr;

(*--- functions in V40 or higher (Release 3.1) ---*)

(* Public entries *)

PROCEDURE LockAmigaGuideBase   *{base,-36}(handle{8}  : AGContext): LONGINT;
PROCEDURE UnlockAmigaGuideBase *{base,-42}(key{0}     : LONGINT);
PROCEDURE OpenAmigaGuideA      *{base,-54}(nag{8}     : NewAmigaGuide;
                                           tagList{9} : ARRAY OF u.TagItem): AGContext;
PROCEDURE OpenAmigaGuide       *{base,-54}(nag{8}     : NewAmigaGuide;
                                           tag1{9}    : u.Tag): AGContext;
PROCEDURE OpenAmigaGuideAsyncA *{base,-60}(nag{8}     : NewAmigaGuide;
                                           attrs{0}   : ARRAY OF u.TagItem): AGContext;
PROCEDURE OpenAmigaGuideAsync  *{base,-60}(nag{8}     : NewAmigaGuide;
                                           tag1{0}..  : u.Tag): AGContext;
PROCEDURE CloseAmigaGuide      *{base,-66}(handle{8}  : AGContext);
PROCEDURE AmigaGuideSignal     *{base,-72}(handle{8}  : AGContext): LONGSET;
PROCEDURE GetAmigaGuideMsg     *{base,-78}(handle{8}  : AGContext): AmigaGuideMsgPtr;
PROCEDURE ReplyAmigaGuideMsg   *{base,-84}(msg{8}     : AmigaGuideMsgPtr);
PROCEDURE SetAmigaGuideContextA*{base,-90}(handle{8}  : AGContext;
                                           id{0}      : LONGINT;
                                           tagList{1} : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE SetAmigaGuideContext *{base,-90}(handle{8}  : AGContext;
                                           id{0}      : LONGINT;
                                           tag1{1}..  : u.Tag): BOOLEAN;
PROCEDURE SendAmigaGuideContextA*{base,-96}(handle{8} : AGContext;
                                           tagList{0} : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE SendAmigaGuideContext*{base,-96}(handle{8}  : AGContext;
                                           tag1{0}..  : u.Tag): BOOLEAN;
PROCEDURE SendAmigaGuideCmdA   *{base,-102}(handle{8} : AGContext;
                                            cmd{0}    : ARRAY OF CHAR;
                                            tagList{1}: ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE SendAmigaGuideCmd    *{base,-102}(handle{8} : AGContext;
                                            cmd{0}    : ARRAY OF CHAR;
                                            tag1{1}   : u.Tag): BOOLEAN;
PROCEDURE SetAmigaGuideAttrsA  *{base,-108}(handle{8} : AGContext;
                                            tagList{9}: ARRAY OF u.TagItem): LONGINT;
PROCEDURE SetAmigaGuideAttrs   *{base,-108}(handle{8} : AGContext;
                                            tag1{9}.. : u.Tag): LONGINT;
PROCEDURE GetAmigaGuideAttr    *{base,-114}(tag{0}    : u.Tag;
                                            handle{8} : AGContext;
                                            VAR storage{9}: e.APTR): LONGINT;
(* next two are not dokumented in autodocs 40.15, but are in the fd-file
 * hope, they are correct [hG]
 *)
PROCEDURE LoadXRef             *{base,-007EH}(lock{8}: d.FileLockPtr;
                                              name{9}: ARRAY OF CHAR): LONGINT;
PROCEDURE ExpungeXRef          *{base,-0084H}();

PROCEDURE AddAmigaGuideHostA   *{base,-138}(hook{8}   : u.HookPtr;
                                            name{0}   : ARRAY OF CHAR;
                                            tagList{9}: ARRAY OF u.TagItem): AmigaGuideHostPtr;
PROCEDURE AddAmigaGuideHost    *{base,-138}(hook{8}   : u.HookPtr;
                                            name{0}   : ARRAY OF CHAR;
                                            tag1{9}.. : u.Tag): AmigaGuideHostPtr;
PROCEDURE RemoveAmigaGuideHostA *{base,-144}(hh{8}    : AmigaGuideHostPtr;
                                            tagList{9}: ARRAY OF u.TagItem): LONGINT;
PROCEDURE RemoveAmigaGuideHost *{base,-144}(hh{8}     : AmigaGuideHostPtr;
                                            tag1{9}.. : u.Tag): LONGINT;
PROCEDURE GetAmigaGuideString  *{base,-210}(id{0}     : LONGINT): e.LSTRPTR;

(*-------------------------------------------------------------------------*)

(* $StackChk- $RangeChk- $NilChk- $OvflChk- $ReturnChk- $CaseChk- *)

BEGIN
  base := e.OpenLibrary (amigaguideName, 33);
CLOSE
  IF base # NIL THEN e.CloseLibrary (base); END;

END AmigaGuide.

