(*
(*
**  Amiga Oberon Library Module: ARP
**
**   © 1993 by Fridtjof Siebert
**
**  $VER: Arp.mod 39.1 (2.11.92)
*)
*)
(*
 ************************************************************************
 *                                                                      *
 * 21/2/90      Arp.mod         ported to Oberon by Fridtjof Siebert    *
 *                                                                      *
 * 5/3/89       ARPbase.h       by MKSoft from ARPbase.i by SDB         *
 *                                                                      *
 ************************************************************************
 *                                                                      *
 *      AmigaDOS Resource Project -- Library Module File                *
 *                                   for the AMOK Oberon Compiler       *
 *                                                                      *
 ************************************************************************
 *                                                                      *
 *      Copyright (c) 1987/1988/1989 by Scott Ballantyne                *
 *                                                                      *
 *      The arp.library, and related code and files may be freely used  *
 *      by supporters of ARP.  Modules in the arp.library may not be    *
 *      extracted for use in independent code, but you are welcome to   *
 *      provide the arp.library with your work and call on it freely.   *
 *                                                                      *
 *      You are equally welcome to add new functions, improve the ones  *
 *      within, or suggest additions.                                   *
 *                                                                      *
 *      BCPL programs are not welcome to call on the arp.library.       *
 *      The welcome mat is out to all others.                           *
 *                                                                      *
 ************************************************************************
 *)

MODULE ARP;

(*
 ************************************************************************
 *      First we need to import the Amiga Interface Modules             *
 ************************************************************************
 *)

IMPORT e := Exec,
       d := Dos,
       I := Intuition,
       g := Graphics,
       s := SYSTEM;

(*
 ************************************************************************
 *      Standard definitions for arp library information                *
 ************************************************************************
 *)

CONST
 arpName     * =   "arp.library";   (* Name of library... *)
 arpVersion  * =   39;              (* Current version... *)


(*
 ************************************************************************
 *      Forward declaration of some Pointers:                           *
 ************************************************************************
 *)

TYPE
  ArpBasePtr * = UNTRACED POINTER TO ArpBase;
  EnvBasePtr * = UNTRACED POINTER TO EnvBase;
  FileRequesterPtr * = UNTRACED POINTER TO FileRequester;
  AChainPtr * = UNTRACED POINTER TO AChain;
  DirectoryEntryPtr * = UNTRACED POINTER TO DirectoryEntry;
  TrackedResourcePtr * = UNTRACED POINTER TO TrackedResource;
  DefaultTrackerPtr * = UNTRACED POINTER TO DefaultTracker;
  ResListPtr * = UNTRACED POINTER TO ResList;
  ZombieMsgPtr * = UNTRACED POINTER TO ZombieMsg;
  ResidentProgramNodePtr * = UNTRACED POINTER TO ResidentProgramNode;
  ProcessControlBlockPtr * = UNTRACED POINTER TO ProcessControlBlock;
  AnchorPathPtr * = UNTRACED POINTER TO AnchorPath;

(*
 ************************************************************************
 *      The current ARP library node...                                 *
 ************************************************************************
    stamp* : d.Date;         (* DOS Datestamp                        *)
    format* : s.BYTE;        (* controls appearance ot dat_StrDate   *)
    flags* : SET;            (* See BITDEF's below                   *)
    strDay* : e.ADDRESS;     (* day of the week string               *)
    strData* : e.ADDRESS;    (* date string                          *)
    strTime* : e.ADDRESS;    (* time string                          *)
  END;
 *)

TYPE
  ArpBase * = STRUCT (libNode *: e.Library)(* Standard library node    *)
    dosRootNode* :     d.RootNodePtr;      (* Copy of dl_Root          *)
    flags* :           SHORTSET;           (* See bitdefs below        *)
    escChar* :         CHAR;               (* Character for escaping   *)
    arpReserved1* :    LONGINT;            (* ArpLib's use only!!      *)
    envBase* :         e.LibraryPtr;       (* Dummy library for MANX   *)
    dosBase* :         d.DosLibraryPtr;    (* Cached DosBase           *)
    gfxBase* :         g.GfxBasePtr;       (* Cached GfxBase           *)
    intuiBase* :       I.IntuitionBasePtr; (* Cached IntuitionBase     *)
    resLists* :        e.MinList;          (* Resource trackers        *)
    residentPrgList* : ResidentProgramNodePtr; (* Resident Programs.   *)
    resPrgProtection* :e.SignalSemaphore;  (* protection for above     *)
    segList* :         e.BPTR;             (* Ptr to loaded lib (BPTR) *)
  END;


(*
 ************************************************************************
 *      The following is here *ONLY* for information and for            *
 *      compatibility with MANX.  DO NOT use in new code!               *
 ************************************************************************
 *)

  EnvBase * = STRUCT
    libNode* : e.Library;      (* Standard library node for linkage    *)
    envSpace* : e.ADDRESS;     (* Access only when Forbidden!          *)
    envSize* : LONGINT;        (* Total allocated mem for EnvSpace     *)
    arpbase* : ArpBasePtr;     (* Added in V32 for Resource Tracking   *)
  END;

(*
 ************************************************************************
 *      These are used in release 33.4 but not by the library code.     *
 *      Instead, individual programs check for these flags.             *
 ************************************************************************
 *)

CONST  (* ArpBase.flags: *)

  arpWildWorld * = 0; (* Mixed BCPL/Normal wildcards. *)
  arpWildBCPL  * = 1; (* Pure BCPL wildcards.         *)

(*
 ************************************************************************
 * The alert object is what you use if you really must return an alert  *
 * to the user. You would normally OR this with another alert number    *
 * from the alerts.h file. Generally, should be NON deadend alerts.     *
 *                                                                      *
 * For example, if you can't open ArpLibrary:                           *
 *      Alert( (AG_OpenLib|AO_ArpLib), 0L);                             *
 ************************************************************************
 *)

  aoArpLib     * = 00008036H;           (* Alert object *)

(*
 ************************************************************************
 *      Alerts that arp.library may return...                           *
 ************************************************************************
 *)

  deadEnd * = MIN(LONGINT);

  anArpLib       * =           03600000H; (* Alert number              *)
  anArpNoMem     * =           03610000H; (* No more memory            *)
  anArpInputMem  * =           03610002H; (* No memory for input buffer*)
  anArpNoMakeEnv * = deadEnd + 03610003H; (* No memory to make EnvLib  *)

  anArpNoDOS     * = deadEnd + 03630001H; (* Can't open dos.library    *)
  anArpNoGfx     * = deadEnd + 03630002H; (* Can't open gfx.library    *)
  anArpNoIntuit  * = deadEnd + 03630003H; (* Can't open intuition      *)
  anBadPackBlues * = deadEnd + 03640000H; (* Bad packet to SendPacket()*)
  anZombie       * = deadEnd + 03600003H; (* Zombie roaming around sys.*)

  anArpScattered * = deadEnd + 03600002H; (* Scatter load not allowed  *)

(*
 ************************************************************************
 *      Return codes you can get from calling ARP Assign()...           *
 ************************************************************************
 *)

CONST
  assignOK      * = 0;      (* Everything is cool and groovey          *)
  assignNODEV   * = 1;      (* "Physical" is not valid for assignment  *)
  assignFATAL   * = 2;      (* Something really icky happened          *)
  assignCANCEL  * = 3;      (* Tried to cancel something but it didn't *)

(*
 ************************************************************************
 *      Size of buffer you need if you are going to call ReadLine()     *
 ************************************************************************
 *)

  maxInputBuf   * = 256;

(*
 ************************************************************************
 *      The ARP file requester data structure...                        *
 ************************************************************************
 *)

TYPE
  FileRequester * = STRUCT
    hail* :   e.ADDRESS;              (* Hailing text                 *)
    file* :    e.ADDRESS;             (* Filename array (FCHARS + 1)  *)
    dir* :    e.ADDRESS;              (* Directory array (DSIZE + 1)  *)
    window* : I.WindowPtr;            (* Window requesting or NULL    *)
    funcFlags* : SHORTSET;            (* Set bitdef's below           *)
    flags2* : SHORTSET;               (* New flags...                 *)
    function* : PROCEDURE();          (* Your function, see bitdef's  *)
    leftEdge* : INTEGER;              (* To be used later...          *)
    topEdge* : INTEGER;
  END;



(*
 ************************************************************************
 * The following are the defines for fr_FuncFlags.  These bits tell     *
 * FileRequest() what your fr_UserFunc is expecting, and what           *
 * FileRequest() should call it for.                                    *
 *                                                                      *
 * You are called like so:                                              *
 * fr_Function(Mask, Object)                                            *
 * ULONG        Mask;                                                   *
 * CPTR         *Object;                                                *
 *                                                                      *
 * The Mask is a copy of the flag value that caused FileRequest() to    *
 * call your function. You can use this to determine what action you    *
 * need to perform, and exactly what Object is, so you know what to do  *
 * and what to return.                                                  *
 ************************************************************************
 *)

CONST

  doWildFunc  * = 7; (* Call me with a FIB and a name, 0 return accepts*)
  doMsgFunc   * = 6; (* You get all IDCMP messages not for FileRequest *)
  doColor     * = 5; (* Set this bit for that new and different look   *)
  newIDCMP    * = 4; (* Force a new IDCMP (only if fr_Window != NULL)  *)
  newWindFunc * = 3; (* You get to modify the newwindow structure.     *)
  addGadFunc  * = 2; (* You get to add gadgets.                        *)
  gEventFunc  * = 1; (* Function to call if one of your gadg is selectd*)
  listFunc    * = 0; (* Not implemented yet.                           *)

(*
 ************************************************************************
 * The FR2B_ bits are for fr_Flags2 in the file requester structure     *
 ************************************************************************
 *)

  longPath * = 0; (* Specify the fr_Dir buffer is 256 bytes long *)

(*
 ************************************************************************
 *      The sizes of the different buffers...                           *
 ************************************************************************
 *)

  fChars     * =     32; (* Filename size                              *)
  dSize      * =     33; (* Directory name size if not FR2B_LongPath   *)

  longDSize  * =    254; (* If FR2B_LongPath is set, use LONG_DSIZE    *)
  longFSize  * =    126; (* For compatibility with ARPbase.i           *)

  firstGadget * = 7680H; (* User gadgetID's must be < this value       *)

(*
 ************************************************************************
 * Structure expected by FindFirst()/FindNext()                         *
 *                                                                      *
 * You need to allocate this structure and initialize it as follows:    *
 *                                                                      *
 * Set ap_BreakBits to the signal bits (CDEF) that you want to take a   *
 * break on, or NULL, if you don't want to convenience the user.        *
 *                                                                      *
 * if you want to have the FULL PATH NAME of the files you found,       *
 * allocate a buffer at the END of this structure, and put the size of  *
 * it into ap_StrLen.  If you don't want the full path name, make sure  *
 * you set ap_StrLen to zero.  In this case, the name of the file, and  *
 * stats are available in the ap_Info, as per usual.                    *
 *                                                                      *
 * Then call FindFirst() and then afterwards, FindNext() with this      *
 * structure.  You should check the return value each time (see below)  *
 * and take the appropriate action, ultimately calling                  *
 * FreeAnchorChain() when there are no more files and you are done.     *
 * You can tell when you are done by checking for the normal AmigaDOS   *
 * return code ERROR_NO_MORE_ENTRIES.                                   *
 *                                                                      *
 * You will also have to check the DirEntryType variable in the ap_Info *
 * structure to determine what exactly you have received.               *
 ************************************************************************
 *)

TYPE
  AnchorPath * = STRUCT
    base* : AChainPtr;       (* Pointer to first anchor                *)
    last* : AChainPtr;       (* Pointer to last anchor                 *)
    breakBits* : LONGSET;    (* Bits to break on                       *)
    foundBreak* : LONGSET;   (* Bits we broke on. returns ERROR_BREAK  *)
    flags* : SHORTSET;       (* New use for the extra word...          *)
    reserved* : s.BYTE;      (* To fill it out...                      *)
    strLen* : INTEGER;       (* This is what used to be ap_Length      *)
    info* : d.FileInfoBlock;
(*  buf* : ARRAY OF s.BYTE; *)(* Allocate a buffer here, if desired     *)
  END;

(*
 ************************************************************************
 *      Bit definitions for the new ap_Flags...                         *
 ************************************************************************
 *)

CONST
  doWild    * =  0;    (* User option ALL                              *)
  itsWild   * =  1;    (* Set by FindFirst, used by FindNext           *)
  doDir     * =  2;    (* Bit is SET if a DIR node should be entered   *)
                       (* Application can RESET this bit to AVOID      *)
                       (* entering a dir.                              *)
  didDir    * =  3;    (* Bit is set for an "expired" dir node         *)
  noMemErr  * =  4;    (* Set if there was not enough memory           *)
  doDot     * =  5;    (* If set, '.' (DOT) will convert to CurrentDir *)

(*
 ************************************************************************
 * Structure used by the pattern matching functions, no need to obtain, *
 * diddle or allocate this yourself.                                    *
 *                                                                      *
 * Note:  If you did, you will now break as it has changed...           *
 ************************************************************************
 *)

TYPE
  AChain * = STRUCT
             child* : AChainPtr;
             paren* : AChainPtr;
             lock* :  d.FileLockPtr;
             info* :  d.FileInfoBlockPtr;
             flags* : SHORTSET;
             string* :ARRAY 1 OF CHAR;   (* Just as is .i file   *)
           END;                          (* ???  Don't use this! *)

CONST

  patternBit  * = 0;
  examinedBit * = 1;
  completed   * = 2;
  allBit      * = 3;

(*
 ************************************************************************
 * Constants used by wildcard routines                                  *
 *                                                                      *
 * These are the pre-parsed tokens referred to by pattern match.  It    *
 * is not necessary for you to do anything about these, FindFirst()     *
 * FindNext() handle all these for you.                                 *
 ************************************************************************
 *)

CONST
  any      * =  80X;   (* Token for '*' | '#?' *)
  single   * =  81X;   (* Token for '?'        *)

(*
 ************************************************************************
 * No need to muck with these as they may change...                     *
 ************************************************************************
 *)

CONST

  orStart    * =  82X;  (* Token for '('        *)
  orNext     * =  83X;  (* Token for '|'        *)
  OrEnd      * =  84X;  (* Token for ')'        *)
  not        * =  85X;  (* Token for '~'        *)
  notClass   * =  87X;  (* Token for '^'        *)
  class      * =  88X;  (* Token for '[]'       *)
  repBeg     * =  89X;  (* Token for '['        *)
  repEnd     * =  8AX;  (* Token for ']'        *)

(*
 ************************************************************************
 * Structure used by AddDANode(), AddDADevs(), FreeDAList().            *
 *                                                                      *
 * This structure is used to create lists of names, which normally      *
 * are devices, assigns, volumes, files, or directories.                *
 ************************************************************************
 *)

TYPE
  DirectoryEntry * = STRUCT
    next* : DirectoryEntryPtr;  (* Next in list                       *)
    type* : SHORTINT;           (* DLX_mumble                         *)
    flags* : SHORTSET;          (* For future expansion, DO NOT USE!  *)
    name* : ARRAY 256 OF CHAR;  (* The name of the thing found        *)
  END;

(*
 ************************************************************************
 * Defines you use to get a list of the devices you want to look at.    *
 * For example, to get a list of all directories and volumes, do:       *
 *                                                                      *
 *      AddDADevs( mydalist, (DLF_DIRS | DLF_VOLUMES) )                 *
 *                                                                      *
 * After this, you can examine the de_type field of the elements added  *
 * to your list (if any) to discover specifics about the objects added. *
 *                                                                      *
 * Note that if you want only devices which are also disks, you must    *
 * (DLF_DEVICES | DLF_DISKONLY).                                        *
 ************************************************************************
 *)

CONST
  devices   * =  0;  (* Return devices                               *)
  diskOnly  * =  1;  (* Modifier for above: Return disk devices only *)
  volumes   * =  2;  (* Return volumes only                          *)
  dirs      * =  3;  (* Return assigned devices only                 *)

(*
 ************************************************************************
 * Legal de_Type values, check for these after a call to AddDADevs(),   *
 * or use on your own as the ID values in AddDANode().                  *
 ************************************************************************
 *)

  file      * = 0H;     (* AddDADevs() can't determine this     *)
  dir       * = 8H;     (* AddDADevs() can't determine this     *)
  device    * = 16H;    (* It's a resident device               *)

  volume    * = 24H;    (* Device is a volume                   *)
  ummounted * = 32H;    (* Device is not resident               *)

  assign    * = 40H;    (* Device is a logical assignment       *)

(*
 ************************************************************************
 *      Resource Tracking stuff...                                      *
 ************************************************************************
 *                                                                      *
 * There are a few things in arp.library that are only directly         *
 * acessable from assembler.  The glue routines provided by us for      *
 * all 'C' compilers use the following conventions to make these        *
 * available to C programs.  The glue for other language's should use   *
 * as similar a mechanism as possible, so that no matter what language  *
 * or compiler we speak, when talk about arp, we will know what the     *
 * other guy is saying.                                                 *
 *                                                                      *
 * Here are the cases:                                                  *
 *                                                                      *
 * Tracker calls...                                                     *
 *              These calls return the Tracker pointer as a secondary   *
 *              result in the register A1.  For C, there is no clean    *
 *              way to return more than one result so the tracker       *
 *              pointer is returned in IoErr().  For ease of use,       *
 *              there is a define that typecasts IoErr() to the correct *
 *              pointer type.  This is called LastTracker and should    *
 *              be source compatible with the earlier method of storing *
 *              the secondary result.                                   *
 *                                                                      *
 * GetTracker() -                                                       *
 *              Syntax is a bit different for C than the assembly call  *
 *              The C syntax is GetTracker(ID).  The binding routines   *
 *              will store the ID into the tracker on return.  Also,    *
 *              in an effort to remain consistant, the tracker will     *
 *              also be stored in LastTracker.                          *
 *                                                                      *
 * In cases where you have allocated a tracker before you have obtained *
 * a resource (usually the most efficient method), and the resource has *
 * not been obtained, you will need to clear the tracker id.  The macro *
 * CLEAR_ID() has been provided for that purpose.  It expects a pointer *
 * to a DefaultTracker sort of struct.                                  *
 ************************************************************************

#define CLEAR_ID(t)     ((SHORT * ) t)[-1]* =NULL

 ************************************************************************
 * You MUST prototype IoErr() to prevent the possible error in defining *
 * IoErr() and thus causing LastTracker to give you trash...            *
 *                                                                      *
 * N O T E !  You MUST! have IoErr() defined as LONG to use LastTracker *
 *            If your compiler has other defines for this, you may wish *
 *            to remove the prototype for IoErr().                      *
 ************************************************************************

#define LastTracker     ((struct DefaultTracker * )IoErr())

 ************************************************************************
 * The rl_FirstItem list (ResList) is a list of TrackedResource (below) *
 * It is very important that nothing in this list depend on the task    *
 * existing at resource freeing time (i.e., RemTask(0L) type stuff,     *
 * DeletePort() and the rest).                                          *
 *                                                                      *
 * The tracking functions return a struct Tracker *Tracker to you, this *
 * is a pointer to whatever follows the tr_ID variable.                 *
 * The default case is reflected below, and you get it if you call      *
 * GetTracker() ( see DefaultTracker below).                            *
 *                                                                      *
 * NOTE: The two user variables mentioned in an earlier version don't   *
 * exist, and never did. Sorry about that (SDB).                        *
 *                                                                      *
 * However, you can still use ArpAlloc() to allocate your own tracking  *
 * nodes and they can be any size or shape you like, as long as the     *
 * base structure is preserved. They will be freed automagically just   *
 * like the default trackers.                                           *
 ************************************************************************
 *)

TYPE TrackedResource * = STRUCT
       node* : e.MinNode;   (* Double linked pointer                *)
       flags* : SHORTSET;   (* Don't touch                          *)
       lock* : s.BYTE;      (* Don't touch, for Get/FreeAccess()    *)
       id* : INTEGER;       (* Item's ID                            *)
(*
 ************************************************************************
 * The struct DefaultTracker *Tracker portion of the structure.         *
 * The stuff below this point can conceivably vary, depending           *
 * on user needs, etc.  This reflects the default.                      *
 ************************************************************************
 *)

       object* : e.ADDRESS; (* The thing being tracked              *)
       extra* :  e.ADDRESS; (* Only needed sometimes                *)
     END;


(*
 ************************************************************************
 * You get a pointer to a struct of the following type when you call    *
 * GetTracker().  You can change this, and use ArpAlloc() instead of    *
 * GetTracker() to do tracking. Of course, you have to take a wee bit   *
 * more responsibility if you do, as well as if you use TRAK_GENERIC    *
 * stuff.                                                               *
 *                                                                      *
 * TRAK_GENERIC folks need to set up a task function to be called when  *
 * an item is freed.  Some care is required to set this up properly.    *
 *                                                                      *
 * Some special cases are indicated by the unions below, for            *
 * TRAK_WINDOW, if you have more than one window opened, and don't      *
 * want the IDCMP closed particularly, you need to set a ptr to the     *
 * other window in dt_Window2.  See CloseWindowSafely() for more info.  *
 * If only one window, set this to NULL.                                *
 ************************************************************************
 *)

TYPE DefaultTracker * = STRUCT;
       object* : e.ADDRESS;     (* The object being tracked  *)
       extra* :  e.ADDRESS;
     END;

(*
 ************************************************************************
 *      Items the tracker knows what to do about                        *
 ************************************************************************
 *)

CONST
  aAMem    * =  0;      (* Default (ArpAlloc) element           *)
  lock     * =  1;      (* File lock                            *)
  trFile   * =  2;      (* Opened file                          *)
  window   * =  3;      (* Window -- see docs                   *)
  screen   * =  4;      (* Screen                               *)
  library  * =  5;      (* Opened library                       *)
  dAMem    * =  6;      (* Pointer to DosAllocMem block         *)
  memNode  * =  7;      (* AllocEntry() node                    *)
  segList  * =  8;      (* Program segment                      *)
  resList  * =  9;      (* ARP (nested) ResList                 *)
  mem      * =  10;     (* Memory ptr/length                    *)
  generic  * =  11;     (* Generic Element, your choice         *)
  dAList   * =  12;     (* DAlist ( aka file request )          *)
  anchor   * =  13;     (* Anchor chain (pattern matching)      *)
  fReq     * =  14;     (* FileRequest struct                   *)
  font     * =  15;     (* GfxBase CloseFont()                  *)
  max      * =  15;     (* Poof, anything higher is tossed      *)

  unlink   * =   7;     (* Free node bit                        *)
  reloc    * =   6;     (* This may be relocated (not used yet) *)
  moved    * =   5;     (* Item moved                           *)

(*
 ************************************************************************
 * Note: ResList MUST be a DosAllocMem'ed list!, this is done for       *
 * you when you call CreateTaskResList(), typically, you won't need     *
 * to access/allocate this structure.                                   *
 ************************************************************************
 *)

TYPE
  ResList * = STRUCT
    node* : e.MinNode;        (* Used by arplib to link reslists      *)
    taskid* : e.TaskPtr;      (* Owner of this list                   *)
    firstItem* : e.MinList;   (* List of Tracked Resources            *)
    link* : ResListPtr;       (* SyncRun's use - hide list here       *)
  END;

(*
 ************************************************************************
 *      Returns from CompareLock()                                      *
 ************************************************************************
 *)

CONST

  equal    * = 0;  (* The two locks refer to the same object       *)
  clVolume * = 1;  (* Locks are on the same volume                 *)
  difVol1  * = 2;  (* Locks are on different volumes               *)
  difVol2  * = 3;  (* Locks are on different volumes               *)

(*
 ************************************************************************
 *      ASyncRun() stuff...                                             *
 ************************************************************************
 * Message sent back on your request by an exiting process.             *
 * You request this by putting the address of your message in           *
 * pcb_LastGasp, and initializing the ReplyPort variable of your        *
 * ZombieMsg to the port you wish the message posted to.                *
 ************************************************************************
 *)

TYPE
  ZombieMsg * = STRUCT
    execMessage* : e.Message;
    taskNum* :     LONGINT;     (* Task ID                      *)
    returnCode* :  LONGINT;     (* Process's return code        *)
    result2* :     LONGINT;     (* System return code           *)
    exitTime* :    d.Date;      (* Date stamp at time of exit   *)
    userInfo* :    LONGINT;     (* For whatever you wish        *)
  END;

(*
 ************************************************************************
 * Structure required by ASyncRun() -- see docs for more info.          *
 ************************************************************************
 *)

  ProcessControlBlock * = STRUCT
    stackSize* : LONGINT;     (* Stacksize for new process             *)
    pri* : SHORTINT;          (* Priority of new task                  *)
    control* : SHORTSET;      (* Control bits, see defines below       *)
    trapCode* : e.ADDRESS;    (* Optional Trap Code                    *)
    input* : e.BPTR;
    output* : e.BPTR;         (* Optional stdin, stdout                *)
    console* : LONGINT;
    loadedCode* : e.ADDRESS;  (* If not null, will not load/unload code*)
    lastGasp* : ZombieMsgPtr; (* ReplyMsg() to be filled in by exit    *)
    wbProcess* : e.MsgPort;   (* Valid only when PRB_NOCLI             *)
  END;

(*
 ************************************************************************
 * Formerly needed to pass NULLCMD to a child.  No longer needed.       *
 * It is being kept here for compatibility only...                      *
 ************************************************************************
 *)

CONST
  NoCmd * = "\n";

(*
 ************************************************************************
 * The following control bits determine what ASyncRun() does on         *
 * Abnormal Exits and on background process termination.                *
 ************************************************************************
 *)

  saveio      * = 0;      (* Don't free/check file handles on exit     *)
  closeSplat  * = 1;      (* Close Splat file, must request explicitly *)
  noCLI       * = 2;      (* Don't create a CLI process                *)
(*interactive * = 3;       This is now obsolete...                     *)
  code        * = 4;      (* Dangerous yet enticing                    *)
  stdio       * = 5;      (* Do the stdio thing, splat * = CON:Filename*)

(*
 ************************************************************************
 *      Error returns from SyncRun() and ASyncRun()                     *
 ************************************************************************
 *)

  noFile    * =  -1;     (* Could not LoadSeg() the file        *)
  noMem     * =  -2;     (* No memory for something             *)
(*noCLI     * =  -3;        This is now obsolete                *)
  noSlot    * =  -4;     (* No room in TaskArray                *)
  noInput   * =  -5;     (* Could not open input file           *)
  noOutPut  * =  -6;     (* Could not get output file           *)
(*noClock   * =  -7;        This is now obsolete                *)
(*argErr    * =  -8;        This is now obsolete                *)
(*noBCPL    * =  -9;        This is now obsolete                *)
(*badLib    * =  -10;       This is now obsolete                *)
  noStdio   * =  -11;    (* Couldn't get stdio handles          *)

(*
 ************************************************************************
 *      Added V35 of arp.library                                        *
 ************************************************************************
 *)

  wantSMessage * = -12; (* Child wants you to report IoErr() to user   *)
                        (* for SyncRun() only...                       *)
  noShellProc  * = -13; (* Can't create a shell/cli process            *)
  noExec       * = -14; (* 'E' bit is clear                            *)
  script       * = -15; (* S and E are set, IoErr() contains directory *)

(*
 ************************************************************************
 * Version 35 ASyncRun() allows you to create an independent            *
 * interactive or background Shell/CLI. You need this variant of the    *
 * pcb structure to do it, and you also have new values for nsh_Control,*
 * see below.                                                           *
 *                                                                      *
 * Syntax for Interactive shell is:                                     *
 *                                                                      *
 * rc=ASyncRun("Optional Window Name","Optional From File",&NewShell);  *
 *                                                                      *
 * Syntax for a background shell is:                                    *
 *                                                                      *
 * rc=ASyncRun("Command line",0L,&NewShell);                            *
 *                                                                      *
 * Same syntax for an Execute style call, but you have to be on drugs   *
 * if you want to do that.                                              *
 ************************************************************************
 *)

TYPE
  NewShell * = STRUCT
    stackSize* : LONGINT; (* Stacksize shell will use for children     *)
    pri* : SHORTINT;      (* ignored by interactive shells             *)
    control* : SHORTSET;  (* bits/values* : see above                  *)
    logMsg* : e.ADDRESS;  (* Optional login message, if 0, use default *)
    input* : e.BPTR;      (* ignored by interactive shells, but        *)
    output* : e.BPTR;     (* used by background and execute options.   *)
    reserved* : ARRAY 5 OF LONGINT;
  END;

(*
 ************************************************************************
 * Bit Values for nsh_Control, you should use them as shown below, or   *
 * just use the actual values indicated.                                *
 ************************************************************************
 *)

CONST
  cli         * = 0;      (* Do a CLI, not a shell        *)
  backGround  * = 1;      (* Background shell             *)
  execute     * = 2;      (* Do as EXECUTE...             *)
  interactive * = 3;      (* Run an interactive shell     *)
  fb          * = 7;      (* Alt function bit...          *)

(*
 ************************************************************************
 *      Common values for sh_Control which allow you to do usefull      *
 *      and somewhat "standard" things...                               *
 ************************************************************************
 *)

TYPE SS = SHORTSET;

CONST
  interactiveShell*=SS{fb,interactive};       (* Gimme a newshell!     *)
  interactiveCli  *=SS{fb,interactive,cli};   (* Gimme that ol newcli! *)
  backGroundShell *=SS{fb,backGround};        (* gimme a backgrnd shell*)
  executeMe       *=SS{fb,backGround,execute};(* aptly named           *)

(*
 ************************************************************************
 *      Additional IoErr() returns added by ARP...                      *
 ************************************************************************
 *)
  errorBufferOverflow  * = 303; (* User or internal buffer overflow  *)
  errorBreak           * = 304; (* A break character was received    *)
  errorNotExecuteable  * = 305; (* A file has E bit cleared          *)
  errorNotCLI          * = 400; (* Program/function neeeds to be cli *)

(*
 ************************************************************************
 *      Resident Program Support                                        *
 ************************************************************************
 * This is the kind of node allocated for you when you AddResidentPrg() *
 * a code segment.  They are stored as a single linked list with the    *
 * root in ArpBase.  If you absolutely *must* wander through this list  *
 * instead of using the supplied functions, then you must first obtain  *
 * the semaphore which protects this list, and then release it          *
 * afterwards.  Do not use Forbid() and Permit() to gain exclusive      *
 * access!  Note that the supplied functions handle this locking        *
 * protocol for you.                                                    *
 ************************************************************************
 *)

TYPE
  ResidentProgramNode * = STRUCT
    next* : ResidentProgramNodePtr;  (* next or NULL                 *)
    usage* : LONGINT;                (* Number of current users      *)
    accessCnt* : INTEGER;            (* Total times used...          *)
    checkSum* : LONGINT;             (* Checksum of code             *)
    segment* : e.BPTR;               (* Actual segment               *)
    flags* : SET;                    (* See definitions below...     *)
 (* name* : ARRAY OF CHAR;              Allocated as needed          *)
  END;

(*
 ************************************************************************
 *      Bit definitions for rpn_Flags....                               *
 ************************************************************************
 *)

CONST
  noCheck  * =  0;      (* Set in rpn_Flags for no checksumming...   *)
  cache    * =  1;      (* Private usage in v1.3...                  *)

(*
 ************************************************************************
 * If your program starts with this structure, ASyncRun() and SyncRun() *
 * will override a users stack request with the value in rpt_StackSize. *
 * Furthermore, if you are actually attached to the resident list, a    *
 * memory block of size rpt_DataSize will be allocated for you, and     *
 * a pointer to this data passed to you in register A4.  You may use    *
 * this block to clone the data segment of programs, thus resulting in  *
 * one copy of text, but multiple copies of data/bss for each process   *
 * invocation.  If you are resident, your program will start at         *
 * rpt_Instruction, otherwise, it will be launched from the initial     *
 * branch.                                                              *
 ************************************************************************
 *)
TYPE ResidentProgramTag * = STRUCT
       nextSeg* : e.BPTR;     (* Provided by DOS at LoadSeg time      *)
(*
 ************************************************************************
 * The initial branch destination and rpt_Instruction do not have to be *
 * the same.  This allows different actions to be taken if you are      *
 * diskloaded or resident.  DataSize memory will be allocated only if   *
 * you are resident, but StackSize will override all user stack         *
 * requests.                                                            *
 ************************************************************************
 *)
       bra* : INTEGER;        (* Short branch to executable           *)
       magic* : INTEGER;      (* Resident majik value                 *)
       stacksize* : LONGINT;  (* min stack for this process           *)
       dataSie* : LONGINT;    (* Data size to allocate if resident    *)
    (* instruction;            Start here if resident          *)
     END;

(*
 ************************************************************************
 * The form of the ARP allocated node in your tasks memlist when        *
 * launched as a resident program. Note that the data portion of the    *
 * node will only exist if you have specified a nonzero value for       *
 * rpt_DataSize. Note also that this structure is READ ONLY, modify     *
 * values in this at your own risk.  The stack stuff is for tracking,   *
 * if you need actual addresses or stack size, check the normal places  *
 * for it in your process/task struct.                                  *
 ************************************************************************
 *)

  ProcessMemory * = STRUCT
    node* : e.Node;
    num* : INTEGER;       (* This is 1 if no data, two if data    *)
    stack* : e.ADDRESS;
    stackSize* : LONGINT;
    data* : e.ADDRESS;    (* Only here if pm_Num * =* = 2         *)
    dataSize* : LONGINT;
  END;

(*
 ************************************************************************
 * To find the above on your memlist, search for the following name.    *
 * We guarantee this will be the only arp.library allocated node on     *
 * your memlist with this name.                                         *
 * i.e. FindName(task->tcb_MemEntry, PMEM_NAME);                        *
 ************************************************************************
 *)

CONST
  pMemName * = "ARP_MEM";

  residentMagic * = 4AFCH;    (* same as RTC_MATCHWORD (trapf) *)

(*
 ************************************************************************
 *      Date String/Data structures                                     *
 ************************************************************************
 *)

TYPE
  DateTime * = STRUCT
    stamp* : d.Date;         (* DOS Datestamp                        *)
    format* : s.BYTE;        (* controls appearance ot dat_StrDate   *)
    flags* : SET;            (* See BITDEF's below                   *)
    strDay* : e.ADDRESS;     (* day of the week string               *)
    strData* : e.ADDRESS;    (* date string                          *)
    strTime* : e.ADDRESS;    (* time string                          *)
  END;

(*
 ************************************************************************
 *      Size of buffer you need for each DateTime strings:              *
 ************************************************************************
 *)

CONST
  lenDatString * = 10;

(*
 ************************************************************************
 *      For dat_Flags                                                   *
 ************************************************************************
 *)

  subSt  * = 0;  (* Substitute "Today" "Tomorrow" where appropriate  *)
  future * = 1;  (* Day of the week is in future                     *)

(*
 ************************************************************************
 *      For dat_Format                                                  *
 ************************************************************************
 *)

  formatDos * = 0;        (* dd-mmm-yy AmigaDOS's own, unique style  *)
  formatInt * = 1;        (* yy-mm-dd International format           *)
  formatUSA * = 2;        (* mm-dd-yy The good'ol'USA.               *)
  formatCDN * = 3;        (* dd-mm-yy Our friends to the north       *)
  formatMAX * = formatCDN;(* Larger than this? Defaults to AmigaDOS  *)


(*
 ************************************************************************
 *  ARP Library Base                                                    *
 ************************************************************************
 *)

VAR
  arp *, base * : ArpBasePtr;  (* synonyms *)

(*
 ************************************************************************
 *      These duplicate the calls in dos.library                        *
 *      Only include if you can use arp.library without dos.library     *
 ************************************************************************
 *)

TYPE PROC * = PROCEDURE();

PROCEDURE Close* {arp,- 36}(file{1}:  d.FileHandlePtr);
PROCEDURE CreateDir* {arp,-120}(name{1}: ARRAY OF CHAR): d.FileLockPtr;
PROCEDURE CreateProc* {arp,-138}(name{1}: ARRAY OF CHAR;
                                 pri{2}: LONGINT;
                                 segment{3}: e.BPTR;
                                 stackSize{4}: LONGINT): d.ProcessId;
PROCEDURE CurrentDir* {arp,-126}(lock{1}: d.FileLockPtr): d.FileLockPtr;
PROCEDURE DateStamp* {arp,-192}(VAR v{1}: d.Date);
PROCEDURE Delay* {arp,-198}(ticks{1}: LONGINT);
PROCEDURE DeleteFile* {arp,- 72}(name{1}: ARRAY OF CHAR): BOOLEAN;
PROCEDURE DeviceProc* {arp,-174}(name{1}: ARRAY OF CHAR): d.ProcessId;
PROCEDURE DupLock* {arp,- 96}(lock{1}: d.FileLockPtr): d.FileLockPtr;
PROCEDURE Examine* {arp,-102}(lock{1}: d.FileLockPtr;
           infoBlock{2}: d.FileInfoBlockPtr): BOOLEAN;
PROCEDURE Execute* {arp,-222}(commandString{1}: ARRAY OF CHAR;
           input{2}: d.FileHandlePtr;
           output{3}: d.FileHandlePtr): LONGINT;
PROCEDURE Exit* {arp,-144}(returnCode{1}: LONGINT);
PROCEDURE ExNext* {arp,-108}(lock{1}: d.FileLockPtr;
           infoBlock{2}: d.FileInfoBlockPtr): BOOLEAN;
PROCEDURE GetPacket* {arp,-162}(wait{1}: LONGINT): d.DosPacketPtr;
PROCEDURE Info* {arp,-114}(lock{1}: d.FileLockPtr;
           parameterBlock{2}: d.InfoDataPtr): BOOLEAN;
PROCEDURE Input* {arp,- 54}(): d.FileHandlePtr;
PROCEDURE IoErr* {arp,-132}(): LONGINT;
PROCEDURE IsInteractive* {arp,-216}(file{1}: d.FileHandlePtr): BOOLEAN;
PROCEDURE LoadSeg* {arp,-150}(name{1}: ARRAY OF CHAR): e.BPTR;
PROCEDURE Lock* {arp,- 84}(name{1}: ARRAY OF CHAR;
               accessMode{2}: LONGINT): d.FileLockPtr;
PROCEDURE Open* {arp,- 30}(name{1}: ARRAY OF CHAR;
           accessMode{2}: LONGINT): d.FileHandlePtr;
PROCEDURE Output* {arp,- 60}(): d.FileHandlePtr;
PROCEDURE ParentDir* {arp,-210}(lock{1}: d.FileLockPtr): d.FileLockPtr;
PROCEDURE QueuePacket* {arp,-168}(packet{1}: d.DosPacketPtr): LONGINT;
PROCEDURE Read* {arp,- 42}(file{1}: d.FileHandlePtr;
               buffer{2}: ARRAY OF s.BYTE;
               length{3}: LONGINT): LONGINT;
PROCEDURE Rename* {arp,- 78}(oldName{1},newName{2}: ARRAY OF CHAR): BOOLEAN;
PROCEDURE Seek* {arp,- 66}(file{1}: d.FileHandlePtr;
               position{2}: LONGINT;
               mode{3}: LONGINT): LONGINT;
PROCEDURE SetComment* {arp,-180}(name{1},comment{2}: ARRAY OF CHAR): BOOLEAN;
PROCEDURE SetProtection* {arp,-186}(name{1}: ARRAY OF CHAR;
                                    mask{2}: LONGSET (* ProtectionFlags *)
                                    ): BOOLEAN;
PROCEDURE UnLoadSeg* {arp,-156}(segment{1}: e.BPTR);
PROCEDURE UnLock* {arp,- 90}(lock{1}: d.FileLockPtr);
PROCEDURE WaitForChar* {arp,-204}(file{1}: d.FileHandlePtr;
                                  timeout{2}: LONGINT): BOOLEAN;
PROCEDURE Write* {arp,- 48}(file{1}: d.FileHandlePtr;
                            buffer{2}: ARRAY OF s.BYTE;
                            length{3}: LONGINT): LONGINT;


(*
 ************************************************************************
 *      Now for the stuff that only exists in arp.library...            *
 ************************************************************************
 *)

PROCEDURE AddDADevs* {arp,-516}(dalist{8}: DirectoryEntryPtr;
                    select{0}: LONGSET (* DirEntryType *)): LONGINT;
PROCEDURE AddDANode* {arp,-510}(data{8}: e.ADDRESS;
                    dalist{9}: DirectoryEntryPtr;
                    length{0}: LONGINT;
                    id{1}: LONGSET (* DirEntryType *)): DirectoryEntryPtr;
PROCEDURE AddResidentPrg* {arp,-582}(segment{1}: e.BPTR;
                         name{8}: ARRAY OF CHAR): ResidentProgramNodePtr;
PROCEDURE ArpAlloc* {arp,-384}(size{0}: LONGINT): e.ADDRESS;
PROCEDURE ArpAllocMem* {arp,-390}(size{0}: LONGINT;
                      reqs{1}: LONGSET (* e.MemReqs *)): e.ADDRESS;
PROCEDURE ArpDupLock* {arp,-402}(lock{1}: d.FileLockPtr): d.FileLockPtr;
PROCEDURE ArpExit* {arp,-378}(returncode{0}: LONGINT;
                  fault{2}: LONGINT);
PROCEDURE ArpLock* {arp,-408}(name{1}: ARRAY OF CHAR;
                  accessMode{2}: LONGINT): d.FileLockPtr;
PROCEDURE ArpOpen* {arp,-396}(name{1}: ARRAY OF CHAR;
                  accessmode{2}: LONGINT): d.FileHandlePtr;
PROCEDURE Assign* {arp,-336}(name{8}: ARRAY OF CHAR;
                 phys{9}: ARRAY OF CHAR): LONGINT;
PROCEDURE ASyncRun* {arp,-546}(command{8}: ARRAY OF CHAR;
                   args{9}: ARRAY OF CHAR;
                   pcb{10}: ProcessControlBlockPtr): LONGINT;
PROCEDURE Atol* {arp,-258}(string{8}: ARRAY OF CHAR): LONGINT;
PROCEDURE BaseName* {arp,-630}(pathname{8}: ARRAY OF CHAR): e.ADDRESS;
PROCEDURE BtoCStr* {arp,-354}(cstring{8}: ARRAY OF CHAR;
                  bstr{0}: d.BSTR;
                  maxlength{1}: LONGINT): LONGINT;
PROCEDURE CheckAbort* {arp,-270}(func{9}: PROC): LONGSET;
PROCEDURE CheckBreak* {arp,-276}(mask{1}: LONGSET;
                     func{9}: PROC): LONGSET;
PROCEDURE CheckSumPrg* {arp,-618}(
                  node{1}: ResidentProgramNodePtr): LONGINT;
PROCEDURE CloseWindowSafely* {arp,-300}(window{8}: I.WindowPtr;
                            morewindows{9}: BOOLEAN);
PROCEDURE CompareLock* {arp,-456}(
                  lock1{0},lock2{1}: d.FileLockPtr): LONGINT;
PROCEDURE CreatePort* {arp,-306}(name{8}: e.ADDRESS;
                     priority{0}: SHORTINT): e.MsgPortPtr;
PROCEDURE CreateTaskResList* {arp,-468}(): ResListPtr;
PROCEDURE CtoBStr* {arp,-360}(cstring{8}: ARRAY OF CHAR;
                  bstr{0}: d.BSTR;
                  maxlength{1}: LONGINT): LONGINT;
PROCEDURE DeletePort* {arp,-312}(port{9}: e.MsgPortPtr);
PROCEDURE DosAllocMem* {arp,-342}(size{0}: LONGINT): e.ADDRESS;
PROCEDURE DosFreeMem* {arp,-348}(memBlk{9}: e.ADDRESS);
PROCEDURE EscapeString* {arp,-264}(string{8}: ARRAY OF CHAR): LONGINT;
PROCEDURE FileRequest* {arp,-294}(
                  filereq{8}: FileRequesterPtr): e.ADDRESS;
PROCEDURE FindCLI* {arp,-420}(tasknum{0}: LONGINT): d.ProcessPtr;
PROCEDURE FindFirst* {arp,-438}(pat{0}: ARRAY OF CHAR;
                    chain{8}: AnchorPathPtr): LONGINT;
PROCEDURE FindNext* {arp,-444}(chain{8}: AnchorPathPtr): LONGINT;
PROCEDURE FindTaskResList* {arp,-462}(): ResListPtr;
PROCEDURE VFPrintf* {arp,-234}(file{0}: d.FileHandlePtr;
                  string{8}: ARRAY OF CHAR;
                  argarray{9}: ARRAY OF e.APTR): LONGINT;
PROCEDURE FPrintf* {arp,-234}(file{0}: d.FileHandlePtr;
                  string{8}: ARRAY OF CHAR;
                  args{9}..: e.APTR): LONGINT;
PROCEDURE FreeAccess* {arp,-498}(tracker{9}: DefaultTrackerPtr);
PROCEDURE FreeAnchorChain* {arp,-450}(chain{8}: AnchorPathPtr);
PROCEDURE FreeDAList* {arp,-504}(dalist{9}: e.ADDRESS);
PROCEDURE FreeResList* {arp,-474}(freelist{9}: e.ADDRESS);
PROCEDURE FreeTaskResList* {arp,-372}(): BOOLEAN;
PROCEDURE FreeTrackedItem* {arp,-480}(item{9}: DefaultTrackerPtr);
PROCEDURE GADS* {arp,-252}(cmdLine{8}: ARRAY OF CHAR;
               cmdLen{0}: LONGINT;
               help{9}: ARRAY OF CHAR;
               argarray{10}: e.ADDRESS;
               tplate{11}: ARRAY OF CHAR): LONGINT;
PROCEDURE GetAccess* {arp,-492}(
               tracker{9}: DefaultTrackerPtr): DefaultTrackerPtr;
PROCEDURE GetDevInfo* {arp,-366}(
               devinfo{10}: d.DeviceListPtr): d.DeviceListPtr;
PROCEDURE GetEnv* {arp,-282}(string{8}: ARRAY OF CHAR;
                 buffer{9}: ARRAY OF CHAR;
                 size{0}: LONGINT): e.ADDRESS;
PROCEDURE GetTracker* {arp,-486}(id{9}: LONGINT): DefaultTrackerPtr;
PROCEDURE InitStdPacket* {arp,-324}(action{0}: LONGINT;
                        args{8}: e.ADDRESS;
                        packet{9}: e.ADDRESS;
                        replyport{10}: e.MsgPortPtr);
PROCEDURE LDiv* {arp,-606}(dividend{0},divisor{1}: LONGINT): LONGINT;
PROCEDURE LMod* {arp,-612}(dividend{0},divisor{1}: LONGINT): LONGINT;
PROCEDURE LMult* {arp,-600}(num1{0},num2{1}: LONGINT): LONGINT;
PROCEDURE LoadPrg* {arp,-552}(name{1}: ARRAY OF CHAR): e.BPTR;
PROCEDURE ObtainResidentPrg* {arp,-576}(
                   name{8}: ARRAY OF CHAR): ResidentProgramNodePtr;
PROCEDURE PathName* {arp,-330}(lock{0}: d.FileLockPtr;
                   VAR dest{8}: ARRAY OF CHAR;
                   numberNames{1}: LONGINT): LONGINT;
PROCEDURE PatternMatch* {arp,-432}(pat{8}: ARRAY OF CHAR;
                       str{9}: ARRAY OF CHAR): BOOLEAN;
PROCEDURE PreParse* {arp,-558}(source{8}: ARRAY OF CHAR;
                   dest{9}: ARRAY OF CHAR): BOOLEAN;
PROCEDURE VPrintf* {arp,-228}(string{8}: ARRAY OF CHAR;
                 argarray{9}: ARRAY OF e.ADDRESS): LONGINT;
PROCEDURE Printf* {arp,-228}(string{8}: ARRAY OF CHAR;
                 args{9}..: e.APTR): LONGINT;
PROCEDURE Puts* {arp,-240}(string{9}: ARRAY OF CHAR): LONGINT;
PROCEDURE QSort* {arp,-426}(baseptr{8}: e.ADDRESS;
                regionsize{0}: LONGINT;
                bytesize{1}: LONGINT;
                userfunction{9}: PROC): BOOLEAN;
PROCEDURE ReadLine* {arp,-246}(buffer{8}: ARRAY OF s.BYTE): LONGINT;
PROCEDURE ReleaseResidentPrg* {arp,-636}(segment{1}: e.BPTR):
                                      ResidentProgramNodePtr;
PROCEDURE RemResidentPrg* {arp,-588}(name{8}: ARRAY OF CHAR): LONGINT;
PROCEDURE RListAlloc* {arp,-414}(reslist{8}: ResListPtr;
                     size{0}: LONGINT): e.ADDRESS;
PROCEDURE SendPacket* {arp,-318}(action{0}: LONGINT;
                     args{8}: e.ADDRESS;
                     handler{9}: e.MsgPortPtr): LONGINT;
PROCEDURE SetEnv* {arp,-288}(string{8}: ARRAY OF CHAR;
                 buffer{9}: ARRAY OF CHAR): BOOLEAN;
PROCEDURE StampToStr* {arp,-564}(datetime{8}: d.DatePtr): BOOLEAN;
PROCEDURE Strcmp* {arp,-522}(s1{8},s2{9}: ARRAY OF CHAR): LONGINT;
PROCEDURE Strncmp* {arp,-528}(st{8},s2{9}: ARRAY OF CHAR;
                  n{0}: LONGINT): LONGINT;
PROCEDURE StrToStamp* {arp,-570}(datetime{8}: d.DatePtr): BOOLEAN;
PROCEDURE SyncRun* {arp,-540}(filename{8}: ARRAY OF CHAR;
                  args{9}: ARRAY OF CHAR;
                  input{0}: d.FileHandlePtr;
                  output{1}: d.FileHandlePtr): LONGINT;
PROCEDURE TackOn* {arp,-624}(pathname{8},filename{9}: ARRAY OF CHAR);
PROCEDURE ToUpper* {arp,-534}(old{0}: CHAR): CHAR;
PROCEDURE UnLoadPrg* {arp,-594}(segment{1}: e.BPTR);

PROCEDURE SPrintf* {arp,-642}(file{0}: e.ADDRESS;
                            str{8}: ARRAY OF CHAR;
                            stream{9}: e.ADDRESS): LONGINT;
PROCEDURE GetKeywordIndex* {arp,-648}(
                  str1{8},str2{9}: ARRAY OF CHAR): LONGINT;
PROCEDURE ArpOpenLibrary* {arp,-654}(name{9}: ARRAY OF CHAR;
                                   vers{0}: LONGINT): e.LibraryPtr;
PROCEDURE ArpAllocFreq* {arp,-660}(): FileRequesterPtr;


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
 arp := e.OpenLibrary(arpName,arpVersion);
 IF arp = NIL THEN
   IF I.DisplayAlert(0,"\x00\x64\x14missing arp.library V39\o\o",50) THEN END;
   HALT(d.fail)
 END;
 base := arp;

CLOSE
 IF arp#NIL THEN e.CloseLibrary(arp) END;

END ARP.

