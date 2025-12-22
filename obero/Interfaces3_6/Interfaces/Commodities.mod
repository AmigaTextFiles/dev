(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Commodities.mod 40.15 (3.1.94) Oberon 3.1
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Commodities;

IMPORT
  e  * := Exec,
  ie * := InputEvent,
  km * := KeyMap,
  sys  := SYSTEM;

(*****************************************************************************)
CONST
  commoditiesName * = "commodities.library";

(* Sizes for various buffers *)
  nameLen   * = 24;
  titleLen  * = 40;
  descrLen  * = 40;

TYPE
  NameStr * = ARRAY nameLen OF CHAR;
  TitleStr * = ARRAY titleLen OF CHAR;
  DescrStr * = ARRAY descrLen OF CHAR;

  NewBrokerPtr * = UNTRACED POINTER TO NewBroker;
  NewBroker * = STRUCT;
    version * : SHORTINT;                  (* must be set to NB_VERSION *)
    name  * : UNTRACED POINTER TO NameStr;
    title * : UNTRACED POINTER TO TitleStr;
    descr * : UNTRACED POINTER TO DescrStr;
    unique * : SET;
    flags  * : SET;
    pri    * : SHORTINT;
    (* new in V5   *)
    port * : e.MsgPortPtr;
    reservedChannel * : INTEGER;
  END;

CONST

(* constant for NewBroker.version *)
  nbVersion * = 5;        (* Version of NewBroker structure   *)

(* Flags for NewBroker.unique *)
  duplicate  * = {};
  unique     * = 0;        (* will not allow duplicates           *)
  notify     * = 1;        (* sends CXM_UNIQUE to existing broker *)

(* Flags for NewBroker.flags *)
  showHide * = 2;

(*****************************************************************************)
TYPE

(* Fake data types for system private objects  *)
  CxObj * = STRUCT END;
  CxMsg * = STRUCT END;
  CxObjPtr * = UNTRACED POINTER TO CxObj;
  CxMsgPtr * = UNTRACED POINTER TO CxMsg;

(* Pointer to a function returning a LONG *)
  PFL * = PROCEDURE(): LONGINT;

(*****************************************************************************)
CONST

(* Commodities Object Types *)
  invalid     * = 0;  (* not a valid object (probably null)  *)
  filter      * = 1;  (* input event messages only           *)
  typeFilter  * = 2;  (* obsolete, do not use                *)
  send        * = 3;  (* sends a message                     *)
  signal      * = 4;  (* sends a signal                      *)
  translate   * = 5;  (* translates input event into chain   *)
  broker      * = 6;  (* application representative          *)
  debug       * = 7;  (* dumps info to serial port           *)
  custom      * = 8;  (* application provides function       *)
  zero        * = 9;  (* system terminator node              *)


(*****************************************************************************)


(* Commodities message types *)
  cxmIEvent   * = 5;
  cxmCommand  * = 6;

(* Only CXM_IEVENT messages are passed through the input network. Other types
 * of messages are sent to an optional port in your broker. This means that
 * you must test the message type in your message handling, if input messages
 * and command messages come to the same port.
 *
 * CXM_IEVENT: Messages of this type rattle around the Commodities input
 *             network. They are sent to you by a Sender object, and passed
 *             to you as a synchronous function call by a Custom object.
 *
 *             The message port or function entry point is stored in the
 *             object, and the ID field of the message will be set to what
 *             you arrange issuing object.
 *
 *             The data section of the message will point to the input event
 *             triggering the message.
 *
 * CXM_COMMAND: These messages are sent to a port attached to your Broker.
 *              They are sent to you when the controller program wants your
 *              program to do something. The ID value identifies the command.
 *)

(* ID values associated with a message of type CXM_COMMAND *)
  cmdDisable   * = 15;  (* please disable yourself       *)
  cmdEnable    * = 17;  (* please enable yourself        *)
  cmdAppear    * = 19;  (* open your window, if you can  *)
  cmdDisappear * = 21;  (* go dormant                    *)
  cmdKill      * = 23;  (* go away for good              *)
  cmdListChg   * = 27;  (* Someone changed the broker list *)
  cmdUnique    * = 25;  (* someone tried to create a broker
                         * with your name. Suggest you appear.
                         *)

(*****************************************************************************)
TYPE

  InputXpressionPtr * = UNTRACED POINTER TO InputXpression;
  InputXpression * = STRUCT
    version * : SHORTINT;     (* must be set to IX_VERSION  *)
    class   * : SHORTINT;     (* class must match exactly   *)

    code     * : SET;         (* Bits that we want          *)
    codeMask * : INTEGER;     (* Set bits here to indicate  *)
                              (* which bits in ix_Code are  *)
                              (* don't care bits.           *)
    qualifier * : SET;        (* Bits that we want          *)
    qualMask  * : SET;        (* Set bits here to indicate  *)
                              (* which bits in ix_Qualifier *)
                              (* are don't care bits        *)
    qualSame * : SET;         (* synonyms in qualifier      *)
  END;

  IX * = InputXpression;
  IXPtr * = UNTRACED POINTER TO IX;

CONST
(* constant for InputXpression.ix_Version *)
  ixVersion * = 2;

(* constants for InputXpression.ix_QualSame *)
  ixSymShift   * = 0;     (* left- and right- shift are equivalent     *)
  ixSymCaps    * = 1;     (* either shift or caps lock are equivalent  *)
  ixSymAlt     * = 2;     (* left- and right- alt are equivalent       *)

  ixSymShiftMask * = {ie.lShift,ie.rShift};
  ixSymCapsMask  * = ixSymShiftMask + {ie.capsLock};
  ixSymAltMask   * = {ie.lAlt,ie.rAlt};

(* constant for InputXpression.ix_QualMask *)
  ixNormalQuals * = -{ie.relativeMouse}; (* avoid RELATIVEMOUSE *)

(*****************************************************************************)


(* Error returns from CxBroker() *)
  errOk       * = 0;  (* No error                             *)
  errSysErr   * = 1;  (* System error, no memory, etc         *)
  errDup      * = 2;  (* uniqueness violation                 *)
  errVersion  * = 3;  (* didn't understand NewBroker.version  *)


(*****************************************************************************)


(* Return values from CxObjError() *)
  coErrIsNull      * = 0;  (* you called CxError(NULL)            *)
  coErrNullAttach  * = 1;  (* someone attached NULL to my list    *)
  coErrBadFilter   * = 2;  (* a bad filter description was given  *)
  coErrBadType     * = 3;  (* unmatched type-specific operation   *)

TYPE
  LONGBOOL * = e.LONGBOOL;

CONST
  LTRUE * = e.LTRUE;
  LFALSE * = e.LFALSE;


VAR
  base * : e.LibraryPtr;

(*--- functions in V36 or higher (Release 2.0) ---*)
(*
 *  OBJECT UTILITIES
 *)
PROCEDURE CreateCxObj    *{base,- 30}(type{0}      : LONGINT;
                                      arg1{8}      : e.APTR;
                                      arg2{9}      : e.APTR): CxObjPtr;
PROCEDURE CxBroker       *{base,- 36}(VAR nb{8}    : NewBroker;
                                      VAR error{0} : LONGINT): CxObjPtr;
PROCEDURE ActivateCxObj  *{base,- 42}(co{8}        : CxObjPtr;
                                      true{0}      : LONGBOOL): LONGBOOL;
PROCEDURE DeleteCxObj    *{base,- 48}(co{8}        : CxObjPtr);
PROCEDURE DeleteCxObjAll *{base,- 54}(co{8}        : CxObjPtr);
PROCEDURE CxObjType      *{base,- 60}(co{8}        : CxObjPtr): LONGINT;
PROCEDURE CxObjError     *{base,- 66}(co{8}        : CxObjPtr): LONGSET;
PROCEDURE ClearCxObjError*{base,- 72}(co{8}        : CxObjPtr);
PROCEDURE SetCxObjPri    *{base,- 78}(co{8}        : CxObjPtr;
                                      pri{0}       : LONGINT): LONGINT;
(*
 *  OBJECT ATTACHMENT
*)
PROCEDURE AttachCxObj    *{base,- 84}(headobj{8}   : CxObjPtr;
                                      co{9}        : CxObjPtr);
PROCEDURE EnqueueCxObj   *{base,- 90}(headobj{8}   : CxObjPtr;
                                      co{9}        : CxObjPtr);
PROCEDURE InsertCxObj    *{base,- 96}(headobj{8}   : CxObjPtr;
                                      co{9}        : CxObjPtr;
                                      pred{10}     : CxObjPtr);
PROCEDURE RemoveCxObj    *{base,-102}(co{8}        : CxObjPtr);
(*
 *  TYPE SPECIFIC
 *)
PROCEDURE SetTranslate   *{base,-114}(translator{8}: CxObjPtr;
                                      VAR ie{9}    : ie.InputEvent);
PROCEDURE SetFilter      *{base,-120}(filter{8}    : CxObjPtr;
                                      text{9}      : ARRAY OF CHAR);
PROCEDURE SetFilterIX    *{base,-126}(filter{8}    : CxObjPtr;
                                      VAR ix{9}    : IX);
PROCEDURE ParseIX        *{base,-132}(description{8}: ARRAY OF CHAR;
                                      VAR ix{9}    : IX): LONGINT;
(*
 *  COMMON MESSAGE
 *)
PROCEDURE CxMsgType      *{base,-138}(cxm{8}       : CxMsgPtr): LONGSET;
PROCEDURE CxMsgData      *{base,-144}(cxm{8}       : CxMsgPtr): e.APTR;
PROCEDURE CxMsgID        *{base,-150}(cxm{8}       : CxMsgPtr): LONGINT;
(*
 *  MESSAGE ROUTING
 *)
PROCEDURE DivertCxMsg    *{base,-156}(cxm{8}       : CxMsgPtr;
                                      headObj{9}   : CxObjPtr;
                                      returnObj{10}: CxObjPtr);
PROCEDURE RouteCxMsg     *{base,-162}(cxm{8}       : CxMsgPtr;
                                      co{9}        : CxObjPtr);
PROCEDURE DisposeCxMsg   *{base,-168}(cxm{8}       : CxMsgPtr);
(*
 *  INPUT EVENT HANDLING
 *)
PROCEDURE InvertKeyMap   *{base,-174}(ansiCode{0}  : LONGINT;
                                      ie{8}        : ie.InputEventDummyPtr;
                                      km{9}        : km.KeyMapPtr): BOOLEAN;
PROCEDURE AddIEvents     *{base,-180}(ie{8}        : ie.InputEventDummyPtr);

(*--- functions in V38 or higher (Release 2.1) ---*)
(*
 * MORE INPUT EVENT HANDLING
 *)
PROCEDURE MatchIX        *{base,-204}(event{8}     : ie.InputEventDummyPtr;
                                      ix{9}        : IXPtr): BOOLEAN;

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

(*************************
 * object creation macros
 *************************)

PROCEDURE CxFilter * (d{8}: e.APTR): CxObjPtr;
BEGIN RETURN CreateCxObj(filter, d, NIL); END CxFilter;

(*  obsolete since V38, so do not use
PROCEDURE CxTypeFilter * (type{8}: e.APTR): CxObjPtr;
BEGIN RETURN CreateCxObj(typeFilter,type, NIL); END CxTypeFilter;
*)

PROCEDURE CxSender * (port{8}: e.MsgPortPtr; id{9}: e.APTR): CxObjPtr;
BEGIN RETURN CreateCxObj(send,port,id); END CxSender;

PROCEDURE CxSignal * (task{8}: e.TaskPtr; sig{9}: INTEGER): CxObjPtr;
BEGIN RETURN CreateCxObj(signal,task,sig); END CxSignal;

PROCEDURE CxTranslate * (ie{8}: ie.InputEventDummyPtr): CxObjPtr;
BEGIN RETURN CreateCxObj(translate,ie,NIL); END CxTranslate;

PROCEDURE CxDebug * (id{8}: e.APTR): CxObjPtr;
BEGIN RETURN CreateCxObj(debug,id, NIL); END CxDebug;

TYPE
  CustomProcType * = PROCEDURE(obj: CxObjPtr; msg: CxMsgPtr);

PROCEDURE CxCustom * (action{8}: CustomProcType; id{9}: e.APTR): CxObjPtr;
BEGIN RETURN CreateCxObj(custom,sys.VAL(e.APTR,action),id); END CxCustom;

(* matches nothing   *)
PROCEDURE NullIx * (VAR i{8}: IX): BOOLEAN;
BEGIN RETURN i.class = ie.null; END NullIx;


BEGIN
  base :=  e.OpenLibrary(commoditiesName,37);

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END Commodities.
