(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Workbench.mod 40.15 (12.1.95) Oberon 3.6
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Workbench;

IMPORT
  e   * := Exec,
  I   * := Intuition,
  d   * := Dos,
  u   * := Utility,
  sys * := SYSTEM;


TYPE

  WBArgPtr * = UNTRACED POINTER TO WBArg;
  WBArg * = STRUCT
    lock * : d.FileLockPtr;     (* a lock descriptor *)
    name * : e.LSTRPTR;         (* a string relative to that lock *)
  END;

  WBArguments * = ARRAY MAX(LONGINT) DIV SIZE(WBArg) -1 OF WBArg;
  WBArgumentsPtr * = UNTRACED POINTER TO WBArguments;

  WBStartupPtr * = UNTRACED POINTER TO WBStartup;
  WBStartup * = STRUCT (message * : e.Message) (* a standard message structure *)
    process * : d.ProcessId;     (* the process descriptor for you *)
    segment * : e.BPTR;          (* a descriptor for your code *)
    numArgs * : LONGINT;         (* the number of elements in ArgList *)
    toolWindow * : e.LSTRPTR;    (* description of window *)
    argList * : WBArgumentsPtr;  (* the arguments themselves *)
  END;

CONST

  disk      * = 1;
  drawer    * = 2;
  tool      * = 3;
  project   * = 4;
  garbage   * = 5;
  device    * = 6;
  kick      * = 7;
  wbAppIcon * = 8;

TYPE

  OldDrawerDataPtr * = UNTRACED POINTER TO OldDrawerData;
  OldDrawerData * = STRUCT       (* pre V36 definition *)
   (newWindow * : I.NewWindow)   (* args to open window *)
    currentX  * : LONGINT;       (* current x coordinate of origin *)
    currentY  * : LONGINT;       (* current y coordinate of origin *)
  END;

CONST

(* the amount of DrawerData actually written to disk *)
  oldDrawerDataFileSize * = sys.SIZE(OldDrawerData);

TYPE

  DrawerDataPtr * = UNTRACED POINTER TO DrawerData;
  DrawerData * = STRUCT (newWindow * : I.NewWindow) (* args to open window *)
    currentX * : LONGINT;        (* current x coordinate of origin *)
    currentY * : LONGINT;        (* current y coordinate of origin *)
    flags * : LONGSET;           (* flags for drawer *)
    viewModes * : SET;           (* view mode for drawer *)
  END;

CONST

(* the amount of DrawerData actually written to disk *)
  drawerDataFileSize * = sys.SIZE(DrawerData);

TYPE

  DiskObjectPtr * = UNTRACED POINTER TO DiskObject;
  DiskObject * = STRUCT
    magic * : INTEGER; (* a magic number at the start of the file *)
    version * : INTEGER; (* a version number, so we can change it *)
    gadget * : I.Gadget;      (* a copy of in core gadget *)
    type * : SHORTINT;
    defaultTool * : e.LSTRPTR;
    toolTypes * : e.APTR;
    currentX * : LONGINT;
    currentY * : LONGINT;
    drawerData * : DrawerDataPtr;
    toolWindow * : e.LSTRPTR; (* only applies to tools *)
    stackSize * : LONGINT;    (* only applies to tools *)
  END;

CONST
  
  diskMagic    * = 0E310U;  (* a magic number, not easily impersonated *)
  diskVersion  * = 1;       (* our current version number *)
  diskRevision * = 1;       (* our current revision number *)
(* I only use the lower 8 bits of Gadget.userData for the revision # *)
  diskRevisionMask * = 0FFH;

TYPE

  FreeListPtr * = UNTRACED POINTER TO FreeList;
  FreeList * = STRUCT
    numFree * : INTEGER;
    memList * : e.List;
  END;

CONST

(* each message that comes into the WorkBenchPort must have a type field
** in the preceeding short.  These are the defines for this type
*)

  appWindow     * = 7;      (* msg from an app window *)
  appIcon       * = 8;      (* msg from an app icon *)
  appMenuItem   * = 9;      (* msg from an app menuitem *)

(* workbench does different complement modes for its gadgets.
** It supports separate images, complement mode, and backfill mode.
** The first two are identical to intuitions GFLG_GADGIMAGE and GFLG_GADGHCOMP.
** backfill is similar to GFLG_GADGHCOMP, but the region outside of the
** image (which normally would be color three when complemented)
** is flood-filled to color zero.
*)
  gadgBackFill * = {0};

(* if an icon does not really live anywhere, set its current position
** to here
*)
  noIconPosition * = 80000000H;

(* workbench now is a library.  this is it's name *)
  workbenchName * = "workbench.library";

(* If you find AppMessage.Version >= amVersion, you know this structure has
 * at least the fields defined in this version of the include file
 *)
  amVersion * = 1;

TYPE

  AppMessagePtr * = UNTRACED POINTER TO AppMessage;
  AppMessage * = STRUCT (message * : e.Message) (* standard message structure *)
    type * : INTEGER;             (* message type               *)
    userData * : e.APTR;          (* application specific       *)
    id * : LONGINT;               (* application definable ID   *)
    numArgs * : LONGINT;          (* # of elements in arglist   *)
    argList * : WBArgumentsPtr;   (* the arguements themselves  *)
    version * : INTEGER;          (* will be AM_VERSION         *)
    class * : SET;                (* message class              *)
    mouseX * : INTEGER;           (* mouse x position of event  *)
    mouseY * : INTEGER;           (* mouse y position of event  *)
    seconds * : LONGINT;          (* current system clock time  *)
    micros * : LONGINT;           (* current system clock time  *)
    reserved * : ARRAY 8 OF LONGINT;    (* avoid recompilation  *)
  END;

(*
 * The following structures are private.  These are just stub
 * structures for code compatibility...
 *)

  AppWindowPtr * = UNTRACED POINTER TO STRUCT END;
  AppIconPtr * = UNTRACED POINTER TO STRUCT END;
  AppMenuItemPtr * = UNTRACED POINTER TO STRUCT END;

VAR
  base * : e.LibraryPtr;

(* --- functions in V36 or higher (Release 2.0) --- *)
(* --- REMEMBER: You have to ensure that Workbench.base#NIL    --- *)
(* ---           BEFORE you use the following Prozedures!      --- *)
PROCEDURE StartWorkbench   *{base,- 42}(flags{0}      : LONGSET;
                                        ptr{1}        : LONGINT): BOOLEAN;
PROCEDURE AddAppWindowA    *{base,- 48}(id{0}         : LONGINT;
                                        userdata{1}   : e.APTR;
                                        window{8}     : I.WindowPtr;
                                        msgport{9}    : e.MsgPortPtr;
                                        taglist{10}   : ARRAY OF u.TagItem): AppWindowPtr;
PROCEDURE AddAppWindow     *{base,- 48}(id{0}         : LONGINT;
                                        userdata{1}   : e.APTR;
                                        window{8}     : I.WindowPtr;
                                        msgport{9}    : e.MsgPortPtr;
                                        tag1{10}..    : u.Tag): AppWindowPtr;
PROCEDURE RemoveAppWindow  *{base,- 54}(appWindow{8}  : AppWindowPtr): BOOLEAN;
PROCEDURE AddAppIconA      *{base,- 60}(id{0}         : LONGINT;
                                        userdata{1}   : e.APTR;
                                        text{8}       : ARRAY OF CHAR;
                                        msgport{9}    : e.MsgPortPtr;
                                        lock{10}      : d.FileLockPtr;
                                        diskobj{11}   : DiskObjectPtr;
                                        taglist{12}   : ARRAY OF u.TagItem): AppIconPtr;
PROCEDURE AddAppIcon       *{base,- 60}(id{0}         : LONGINT;
                                        userdata{1}   : e.APTR;
                                        text{8}       : ARRAY OF CHAR;
                                        msgport{9}    : e.MsgPortPtr;
                                        lock{10}      : d.FileLockPtr;
                                        diskobj{11}   : DiskObjectPtr;
                                        tag1{12}..    : u.Tag): AppIconPtr;
PROCEDURE RemoveAppIcon    *{base,- 66}(appIcon{8}    : AppIconPtr): BOOLEAN;
PROCEDURE AddAppMenuItemA  *{base,- 72}(id{0}         : LONGINT;
                                        userdata{1}   : e.APTR;
                                        text{8}       : ARRAY OF CHAR;
                                        msgport{9}    : e.MsgPortPtr;
                                        taglist{10}   : ARRAY OF u.TagItem): AppMenuItemPtr;
PROCEDURE AddAppMenuItem   *{base,- 72}(id{0}         : LONGINT;
                                        userdata{1}   : e.APTR;
                                        text{8}       : ARRAY OF CHAR;
                                        msgport{9}    : e.MsgPortPtr;
                                        tag1{10}..    : u.Tag): AppMenuItemPtr;
PROCEDURE RemoveAppMenuItem*{base,- 78}(appMenuItem{8}: AppMenuItemPtr): BOOLEAN;

(*--- functions in V39 or higher (Release 3) ---*)

PROCEDURE WBInfo           *{base,-05AH}(lock{8}      : d.FileLockPtr;
                                         name{9}      : ARRAY OF CHAR;
                                         screen{10}   : I.ScreenPtr);


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base :=  e.OpenLibrary(workbenchName,37);

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END Workbench.

