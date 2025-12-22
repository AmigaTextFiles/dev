(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Dos.mod 40.15 (12.1.95) Oberon 3.6
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Dos;

IMPORT
  e * := Exec,
  t * := Timer,
  u * := Utility,
  y * := SYSTEM;


CONST
  dosName * = "dos.library";
  DOSTRUE * = e.LTRUE;
  DOSFALSE * = e.LFALSE;

(* Mode parameter to Open() *)
  oldFile    * =  1005;  (* Open existing file read/write
                          * positioned at beginning of file. *)
  newFile    * =  1006;  (* Open freshly created file (delete
                          * old file) read/write, exclusive lock. *)
  readWrite  * =  1004;  (* Open old file w/shared lock,
                          * creates file if doesn't exist. *)

(* Relative position to Seek() *)
  beginning  * =  -1;      (* relative to Begining Of File *)
  current    * =   0;      (* relative to Current file position *)
  end        * =   1;      (* relative to End Of File    *)

  bitsPerByte     * =  8;
  bytesPerLong    * =  4;
  bitsPerLong     * =  32;
  maxInt          * =  7FFFFFFFH;
  minInt          * =  80000000H;

(* Passed as type to Lock() *)
  sharedLock      * =  -2;    (* File is readable by others *)
  accessRead      * =  -2;    (* Synonym *)
  exclusiveLock   * =  -1;    (* No other access allowed    *)
  accessWrite     * =  -1;    (* Synonym *)


TYPE

  DatePtr                 * = UNTRACED POINTER TO Date;
  FileInfoBlockPtr        * = UNTRACED POINTER TO FileInfoBlock;
  InfoDataPtr             * = UNTRACED POINTER TO InfoData;
  DateTimePtr             * = UNTRACED POINTER TO DateTime;
  AnchorPathPtr           * = UNTRACED POINTER TO AnchorPath;
  AChainPtr               * = UNTRACED POINTER TO AChain;
  ProcessPtr              * = UNTRACED POINTER TO Process;
  DosPacketPtr            * = UNTRACED POINTER TO DosPacket;
  StandardPacketPtr       * = UNTRACED POINTER TO StandardPacket;
  ErrorStringPtr          * = UNTRACED POINTER TO ErrorString;
  DosLibraryPtr           * = UNTRACED POINTER TO DosLibrary;
  RootNodePtr             * = UNTRACED POINTER TO RootNode;
  CliProcListPtr          * = UNTRACED POINTER TO CliProcList;
  AssignListPtr           * = UNTRACED POINTER TO AssignList;
  DevProcPtr              * = UNTRACED POINTER TO DevProc;
  ExAllDataPtr            * = UNTRACED POINTER TO ExAllData;
  ExAllControlPtr         * = UNTRACED POINTER TO ExAllControl;
  DeviceNodePtr           * = UNTRACED POINTER TO DeviceNode;
  NotifyMessagePtr        * = UNTRACED POINTER TO NotifyMessage;
  NotifyRequestPtr        * = UNTRACED POINTER TO NotifyRequest;
  CSourcePtr              * = UNTRACED POINTER TO CSource;
  RDArgsPtr               * = UNTRACED POINTER TO RDArgs;
  RecordLockPtr           * = UNTRACED POINTER TO RecordLock;
  LocalVarPtr             * = UNTRACED POINTER TO LocalVar;
  SegmentPtr              * = UNTRACED POINTER TO Segment;
  DosListNodePtr          * = UNTRACED POINTER TO DosListNode;
  DeviceListAPtr          * = UNTRACED POINTER TO DeviceList;
  DevInfoAPtr             * = UNTRACED POINTER TO DevInfo;
  DosListAPtr             * = UNTRACED POINTER TO DosList;
  CommandLineInterfaceAPtr* = UNTRACED POINTER TO CommandLineInterface;
  FileLockPtr             * = BPOINTER TO FileLock;
  FileHandlePtr           * = BPOINTER TO FileHandle;
  DosEnvecPtr             * = BPOINTER TO DosEnvec;
  DeviceListPtr           * = BPOINTER TO DeviceList;
  DevInfoPtr              * = BPOINTER TO DevInfo;
  DosListPtr              * = BPOINTER TO DosList;
  CommandLineInterfacePtr * = BPOINTER TO CommandLineInterface;
  TaskArrayPtr            * = BPOINTER TO TaskArray;
  DosInfoPtr              * = BPOINTER TO DosInfo;
  FileSysStartupMsgPtr    * = BPOINTER TO FileSysStartupMsg;
  PathLockPtr             * = BPOINTER TO PathLock;

  Date * = STRUCT
    days * : LONGINT;          (* Number of days since Jan. 1, 1978 *)
    minute * : LONGINT;        (* Number of minutes past midnight *)
    tick * : LONGINT;          (* Number of ticks past minute *)
  END;

CONST
  ticksPerSecond * = 50;       (* Number of ticks in one second *)

TYPE

(* Returned by Examine() and ExNext(), must be on a 4 byte boundary *)
  FileInfoBlock * = STRUCT
    diskKey * : LONGINT;
    dirEntryType * : LONGINT;       (* Type of Directory. If < 0, then a plain file.
                                     * If > 0 a directory *)
    fileName * : ARRAY 108 OF CHAR; (* Null terminated. Max 30 chars used for now *)
    protection * : LONGSET;         (* bit mask of protection, rwxd are 3-0.      *)
    entryType * : LONGINT;
    size * : LONGINT;               (* Number of bytes in file *)
    numBlock * : LONGINT;           (* Number of blocks in file *)
    date * : Date;                  (* Date file last changed *)
    comment * : ARRAY 80 OF CHAR;   (* Null terminated comment associated with file *)

   (* Note: the following fields are not supported by all filesystems.        *)
   (* They should be initialized to 0 sending an ACTION_EXAMINE packet.       *)
   (* When Examine() is called, these are set to 0 for you.           *)
   (* AllocDosObject() also initializes them to 0.                    *)
    ownerUID *: INTEGER;            (* owner's UID *)
    ownerGID *: INTEGER;            (* owner's GID *)

    reserved * : ARRAY 32 OF CHAR;
  END;

CONST

(* FileInfoBLock.protection flag definitions: *)
(* Regular RWED bits are 0 == allowed. *)
(* NOTE: GRP and OTR RWED permissions are 0 == not allowed! *)
(* Group and Other permissions are not directly handled by the filesystem *)
  otrRead    * = 15;  (* Other: file is readable *)
  otrWrite   * = 14;  (* Other: file is writable *)
  otrExecute * = 13;  (* Other: file is executable *)
  otrDelete  * = 12;  (* Other: prevent file from being deleted *)
  grpRead    * = 11;  (* Group: file is readable *)
  grpWrite   * = 10;  (* Group: file is writable *)
  grpExecute * =  9;  (* Group: file is executable *)
  grpDelete  * =  8;  (* Group: prevent file from being deleted *)

  script   * = 6;        (* program is a script (execute) file *)
  pure     * = 5;        (* program is reentrant and rexecutable *)
  archive  * = 4;        (* cleared whenever file is changed *)
  readProt * = 3;        (* ignored by old filesystem *)
  writeProt* = 2;        (* ignored by old filesystem *)
  execute  * = 1;        (* ignored by system, used by Shell *)
  delete   * = 0;        (* prevent file from being deleted *)

(* Standard maximum length for an error string from fault.  However, most *)
(* error strings should be kept under 60 characters if possible.  Don't   *)
(* forget space for the header you pass in. *)
  faultMax * = 82;

TYPE

(* All BCPL data must be long word aligned.  BCPL pointers are the long word
 *  address (i.e byte address divided by 4 (>>2)) *)
  BPTR * = e.BPTR;                   (* Long word pointer *)
  BSTR * = BPOINTER TO e.STRING;     (* Long word pointer to BCPL string  *)

(* BCPL strings have a length in the first byte and then the characters.
 * For example:  s[0]=3 s[1]=S s[2]=Y s[3]=S                             *)

TYPE

(* returned by Info(), must be on a 4 byte boundary *)
  InfoData * = STRUCT
    numSoftErrors * : LONGINT;   (* number of soft errors on disk *)
    unitNumber    * : LONGINT;   (* Which unit disk is (was) mounted on *)
    diskState     * : LONGINT;   (* See defines below *)
    numBlock      * : LONGINT;   (* Number of blocks on disk *)
    numBlockUsed  * : LONGINT;   (* Number of block in use *)
    bytesPerBlock * : LONGINT;
    diskType      * : LONGINT;   (* Disk Type code *)
    volumeNode    * : DeviceListPtr; (* BCPL pointer to volume node *)
    inUse         * : LONGINT;   (* Flag, zero if not in use *)
  END;

CONST

(* InfoData.diskState *)
  writeProtect * = 80;    (* Disk is write protected *)
  validating   * = 81;    (* Disk is currently being validated *)
  validated    * = 82;    (* Disk is consistent and writeable *)

(* InfoData.diskType *)
(* Any other new filesystems should also, if possible. *)
  noDiskPresent        * = -1;
  unreadableDisk       * = y.VAL(LONGINT,'BAD\o');
  dosDisk              * = y.VAL(LONGINT,'DOS\o');
  ffsDisk              * = y.VAL(LONGINT,'DOS\x01');
  interDosDisk         * = y.VAL(LONGINT,'DOS\x02');
  interFFSDisk         * = y.VAL(LONGINT,'DOS\x03');
  fastDirDosDisk       * = y.VAL(LONGINT,'DOS\x04');
  fastDirFFSDisk       * = y.VAL(LONGINT,'DOS\x05');
  notReallyDos         * = y.VAL(LONGINT,'NDOS' );
  kickStartDisk        * = y.VAL(LONGINT,'KICK' );
  msdosDisk            * = y.VAL(LONGINT,'MSD\o');

(* Errors from IoErr(), etc. *)
  noFreeStore                * = 103;
  taskTableFull              * = 105;
  badTemplate                * = 114;
  badNumber                  * = 115;
  requiredArgMissing         * = 116;
  keyNeedsArg                * = 117;
  tooManyArgs                * = 118;
  unmatchedQuotes            * = 119;
  lineTooLong                * = 120;
  fileNotObject              * = 121;
  invalidResidentLibrary     * = 122;
  noDefaultDir               * = 201;
  objectInUse                * = 202;
  objectExists               * = 203;
  dirNotFound                * = 204;
  objectNotFound             * = 205;
  badStreamName              * = 206;
  objectTooLarge             * = 207;
  actionNotKnown             * = 209;
  invalidComponentName       * = 210;
  invalidLock                * = 211;
  objectWrongType            * = 212;
  diskNotValidated           * = 213;
  diskWriteProtected         * = 214;
  renameAcrossDevices        * = 215;
  directoryNotEmpty          * = 216;
  tooManyLevels              * = 217;
  deviceNotMounted           * = 218;
  seekError                  * = 219;
  commentTooBig              * = 220;
  diskFull                   * = 221;
  deleteProtected            * = 222;
  writeProtected             * = 223;
  readProtected              * = 224;
  notADosDisk                * = 225;
  noDisk                     * = 226;
  noMoreEntries              * = 232;
(* added for 1.4 *)
  isSoftLink                 * = 233;
  objectLinked               * = 234;
  badHunk                    * = 235;
  notImplemented             * = 236;
  recordNotLocked            * = 240;
  lockCollision              * = 241;
  lockTimeOut                * = 242;
  unLockError                * = 243;

(* These are the return codes used by convention by AmigaDOS commands *)
(* See FAILAT and IF for relvance to EXECUTE files                    *)
  ok                    * =  0; (* No problems, success *)
  warn                  * =  5; (* A warning only *)
  error                 * = 10; (* Something wrong *)
  fail                  * = 20; (* Complete or severe failure*)

(* Bit numbers that signal you that a user has issued a break *)
  ctrlC  * = 12;
  ctrlD  * = 13;
  ctrlE  * = 14;
  ctrlF  * = 15;

(* Values returned by SameLock() *)
  same          * = 0;
  sameHandler   * = 1;      (* actually same volume *)
  different     * = -1;

(* types for ChangeMode() *)
  changeLock  * = 0;
  changeFH    * = 1;

(* Values for MakeLink() *)
  hard   * = 0;
  soft   * = 1;      (* softlinks are not fully supported yet *)

(* values returned by ReadItem *)
  equal      * =  -2;              (* "=" Symbol *)
  itemError  * =  -1;              (* error *)
  nothing    * =  0;               (* *N, ;, endstreamch *)
  unQuoted   * =  1;               (* unquoted item *)
  quoted     * =  2;               (* quoted item *)

(* types for AllocDosObject/FreeDosObject *)
  fileHandle      * = 0;      (* few people should use this *)
  exAllControl    * = 1;      (* Must be used to allocate this! *)
  fib             * = 2;      (* useful *)
  stdpkt          * = 3;      (* for doing packet-level I/O *)
  cli             * = 4;      (* for shell-writers, etc *)
  rdArgs          * = 5;      (* for ReadArgs if you pass it in *)

TYPE

(*
 *      Data structures and equates used by the V1.4 DOS functions
 * StrtoDate() and DatetoStr()
 *)

CONST

(* You need this much room for each of the DateTime strings: *)
  lenDatString * = 16;

TYPE
  DatString * = ARRAY 16 OF CHAR;
  DatStringPtr * = UNTRACED POINTER TO DatString;

(*--------- String/Date structures etc *)
  DateTime * = STRUCT (stamp * : Date)              (* DOS Date *)
    format * : SHORTINT;            (* controls appearance of dat_StrDate *)
    flags  * : SHORTSET;            (* see BITDEF's below *)
    strDay * : DatStringPtr;        (* day of the week string *)
    strDate* : DatStringPtr;        (* date string *)
    strTime* : DatStringPtr;        (* time string *)
  END;

CONST

(* flags for DateTime.flags *)

  subst   * = 0;              (* substitute Today, Tomorrow, etc. *)
  future  * = 1;              (* day of the week is in future *)

(*
 *      date format values
 *)

  formatDos   * = 0;              (* dd-mmm-yy *)
  formatInt   * = 1;              (* yy-mm-dd  *)
  formatUSA   * = 2;              (* mm-dd-yy  *)
  formatCDN   * = 3;              (* dd-mm-yy  *)
  formatMax   * = formatCDN;


(***********************************************************************
************************ PATTERN MATCHING ******************************
************************************************************************

* structure expected by MatchFirst, MatchNext.
* Allocate this structure and initialize it as follows:
*
* Set ap_BreakBits to the signal bits (CDEF) that you want to take a
* break on, or NULL, if you don't want to convenience the user.
*
* If you want to have the FULL PATH NAME of the files you found,
* allocate a buffer at the END of this structure, and put the size of
* it into ap_Length.  If you don't want the full path name, make sure
* you set ap_Length to zero.  In this case, the name of the file, and stats
* are available in the ap_Info, as per usual.
*
* Then call MatchFirst() and then afterwards, MatchNext() with this structure.
* You should check the return value each time (see below) and take the
* appropriate action, ultimately calling MatchEnd() when there are
* no more files and you are done.  You can tell when you are done by
* checking for the normal AmigaDOS return code ERROR_NO_MORE_ENTRIES.
*
*)

TYPE
  AnchorPath * = STRUCT
        base * : AChainPtr;        (* pointer to first anchor *)
        last * : AChainPtr;        (* pointer to last anchor *)
        breakBits * : LONGSET;     (* Bits we want to break on *)
        foundBreak * : LONGSET;    (* Bits we broke on. Also returns ERROR_BREAK *)
        flags * : SHORTSET;        (* New use for extra word. *)
        reserved * : e.BYTE;
        strLen * : INTEGER;        (* This is what AnchoPath.length used to be *)
        info * : FileInfoBlock;
        buf * : e.STRING;          (* Buffer for path name *)
  END;

CONST
(* AnchorPath.flags *)
  doWild  * = 0;       (* User option ALL *)
  itsWild * = 1;       (* Set by MatchFirst, used by MatchNext *)
                       (* Application can test itsWild, too *)
  doDir   * = 2;       (* Bit is SET if a DIR node should be *)
                       (* entered. Application can RESET this *)
                       (* bit after MatchFirst/MatchNext to AVOID *)
                       (* entering a dir. *)
  didDir  * = 3;       (* Bit is SET for an "expired" dir node. *)
  noMemErr* = 4;       (* Set on memory error *)
  doDot   * = 5;       (* If set, allow conversion of '.' to *)
                       (* CurrentDir *)
  dirChanged * = 6;    (* ap_Current->an_Lock changed *)
                       (* since last MatchNext call *)

TYPE
  AChain * = STRUCT
        child  * : AChainPtr;
        parent * : AChainPtr;
        lock   * : FileLockPtr;
        info   * : FileInfoBlock;
        flags  * : SHORTSET;
        string * : e.STRING;
  END;

CONST

  patternBit  * = 0;
  examinedBit * = 1;
  completed   * = 2;
  allBit      * = 3;
  single      * = 4;

(*
 * Constants used by wildcard routines, these are the pre-parsed tokens
 * referred to by pattern match.  It is not necessary for you to do
 * anything about these, MatchFirst() MatchNext() handle all these for you.
 *)

  pAny           * = 80H;    (* Token for '*' or '#?  *)
  pSingle        * = 81H;    (* Token for '?' *)
  pOrStart       * = 82H;    (* Token for '(' *)
  pOrNext        * = 83H;    (* Token for '|' *)
  pOrEnd         * = 84H;    (* Token for ')' *)
  pNot           * = 85H;    (* Token for '~' *)
  pNotEnd        * = 86H;    (* Token for *)
  pNotClass      * = 87H;    (* Token for '^' *)
  pClass         * = 88H;    (* Token for '[]' *)
  pRepBeg        * = 89H;    (* Token for '[' *)
  pRepEnd        * = 8AH;    (* Token for ']' *)
  pStop          * = 8BH;    (* Token to force end of evaluation *)

(* Values for an_Status, NOTE: These are the actual bit numbers *)

  complexBit   * = 1;       (* Parsing complex pattern *)
  examineBit   * = 2;       (* Searching directory *)

(*
 * Returns from MatchFirst(), MatchNext()
 * You can also get dos error returns, such as ERROR_NO_MORE_ENTRIES,
 * these are in the dos.h file.
 *)

  bufferOverflow * = 303;     (* User or internal buffer overflow *)
  break          * = 304;     (* A break character was received *)
  notExecutable  * = 305;     (* A file has E bit cleared *)

TYPE

  ProcessId * = e.MsgPortPtr; (* Points to Process.msgPort *)

(* All DOS processes have this structure *)
(* Create and Device Proc returns pointer to the MsgPort in this structure *)
(* dev_proc = (struct Process * ) (DeviceProc(..) - sizeof(struct Task)); *)

  Process * = STRUCT (task * : e.Task)
    msgPort        * : e.MsgPort;     (* This is BPTR address from DOS functions  *)
    pad            * : INTEGER;       (* Remaining variables on 4 byte boundaries *)
    segList        * : e.BPTR;        (* Array of seg lists used by this process  *)
    stackSize      * : LONGINT;       (* Size of process stack in bytes           *)
    globVec        * : e.APTR;        (* Global vector for this process (BCPL)    *)
    taskNum        * : LONGINT;       (* CLI task number of zero if not a CLI     *)
    stackBase      * : e.BPTR;        (* Ptr to high memory end of process stack  *)
    result2        * : LONGINT;       (* Value of secondary result from last call *)
    currentDir     * : FileLockPtr;   (* Lock associated with current directory   *)
    cis            * : FileHandlePtr; (* Current CLI Input Stream                 *)
    cos            * : FileHandlePtr; (* Current CLI Output Stream                *)
    consoleTask    * : ProcessId;     (* Console handler process for current window*)
    fileSystemTask * : ProcessId;     (* File handler process for current drive   *)
    cli            * : CommandLineInterfacePtr;  (* pointer to CommandLineInterface          *)
    returnAddr     * : e.APTR;        (* pointer to previous stack frame          *)
    pktWait        * : e.APTR;        (* Function to be called when awaiting msg  *)
    windowPtr      * : e.APTR;        (* Window for error printing                *)

    (* following definitions are new with 2.0 *)
    homeDir        * : FileLockPtr;   (* Home directory of executing program      *)
    flags          * : LONGSET;       (* flags telling dos about process          *)
    exitCode       * : e.PROC;        (* code to call on exit of program or NULL  *)
    exitData       * : LONGINT;       (* Passed as an argument to pr_ExitCode.    *)
    arguments      * : e.LSTRPTR;     (* Arguments passed to the process at start *)
    localVars      * : e.MinList;     (* Local environment variables             *)
    shellPrivate   * : LONGINT;       (* for the use of the current shell         *)
    ces            * : FileHandlePtr; (* Error stream - if NULL, use pr_COS       *)
  END;

CONST

(*
 * Flags for Process.flags
 *)
  freeSegList     * = 0;
  freeCurrDir     * = 1;
  freeCLI         * = 2;
  closeInput      * = 3;
  closeOutput     * = 4;
  freeArgs        * = 5;

TYPE

(* The long word address (BPTR) of this structure is returned by
 * Open() and other routines that return a file.  You need only worry
 * about this struct to do async io's via PutMsg() instead of
 * standard file system calls *)

  FileHandle * = STRUCT
    link * : e.MessagePtr;      (* EXEC message              *)
    port * : e.MsgPortPtr;      (* Reply port for the packet *)
    type * : ProcessId;         (* Port to do PutMsg() to
                                 * Address is negative if a plain file *)
    buf  * : LONGINT;
    pos  * : LONGINT;
    end  * : LONGINT;
    func1* : LONGINT;
    func2* : LONGINT;
    func3* : LONGINT;
    arg1 * : LONGINT;
    arg2 * : LONGINT;
  END;

(* This is the extension to EXEC Messages used by DOS *)

  DosPacket * = STRUCT
    link * : e.MessagePtr;      (* EXEC message              *)
    port * : e.MsgPortPtr;      (* Reply port for the packet *)
                                (* Must be filled in each send. *)
    type * : LONGINT;           (* See ACTION_... below and                    (* action *)
                                 * 'R' means Read, 'W' means Write to the
                                 * file system *)
    res1 * : LONGINT;           (* For file system calls this is the result    (* status *)
                                 * that would have been returned by the
                                 * function, e.g. Write ('W') returns actual
                                 * length written *)
    res2 * : LONGINT;           (* For file system calls this is what would    (* status2 *)
                                 * have been returned by IoErr() *)
    arg1 * : LONGINT;                                                          (* bufAddr *)
    arg2 * : LONGINT;
    arg3 * : LONGINT;
    arg4 * : LONGINT;
    arg5 * : LONGINT;
    arg6 * : LONGINT;
    arg7 * : LONGINT;
  END;

(* A Packet does not require the Message to be before it in memory, but
 * for convenience it is useful to associate the two.
 * Also see the function init_std_pkt for initializing this structure *)

  StandardPacket * = STRUCT (msg * : e.Message)
    pkt * : DosPacket;
  END;

CONST

(* DosPacket.type *)
  nil              * = 0;
  startup          * = 0;
  getBlock         * = 2;       (* OBSOLETE *)
  setMap           * = 4;
  die              * = 5;
  event            * = 6;
  currentVolume    * = 7;
  locateObject     * = 8;
  renameDisk       * = 9;
  write            * = ORD('W');
  read             * = ORD('R');
  freeLock         * = 15;
  deleteObject     * = 16;
  renameObject     * = 17;
  moreCache        * = 18;
  copyDir          * = 19;
  waitChar         * = 20;
  setProtect       * = 21;
  createDir        * = 22;
  examineObject    * = 23;
  examineNext      * = 24;
  diskInfo         * = 25;
  info             * = 26;
  flush            * = 27;
  setComment       * = 28;
  parent           * = 29;
  timer            * = 30;
  inhibit          * = 31;
  diskType         * = 32;
  diskChange       * = 33;
  setDate          * = 34;

  screenMode       * = 994;

  readReturn       * = 1001;
  writeReturn      * = 1002;
  seek             * = 1008;
  findUpdate       * = 1004;
  findInput        * = 1005;
  findOutput       * = 1006;
  actionEnd        * = 1007;
  setFileSize      * = 1022;    (* fast file system only in 1.3 *)
  writeprotect     * = 1023;    (* fast file system only in 1.3 *)

(* new 2.0 packets *)
  sameLock         * = 40;
  changeSignal     * = 995;
  format           * = 1020;
  makeLink         * = 1021;
  (**)
  (**)
  readLink         * = 1024;
  fhFromLock       * = 1026;
  isFileSystem     * = 1027;
  changeMode       * = 1028;
  (**)
  copyDirFH        * = 1030;
  parentFH         * = 1031;
  examineAll       * = 1033;
  examineFH        * = 1034;

  lockRecord       * = 2008;
  freeRecord       * = 2009;

  addNotify        * = 4097;
  removeNotify     * = 4098;

(* Added in V39: *)
  examineAllEnd    * = 1035;
  setOwner         * = 1036;


TYPE

(*
 * A structure for holding error messages - stored as array with error == 0
 * for the last entry.
 *)

  ErrorString * = STRUCT
    nums    * : e.APTR;
    strings * : e.APTR;
  END;

(* DOS library node structure.
 * This is the data at positive offsets from the library node.
 * Negative offsets from the node is the jump table to DOS functions
 * node = (struct DosLibrary * ) OpenLibrary( "dos.library" .. )      *)

  DosLibrary * = STRUCT (lib * : e.Library)
    root * : RootNodePtr;       (* Pointer to RootNode, described below *)
    gv   * : e.APTR;            (* Pointer to BCPL global vector        *)
    a2     : LONGINT;           (* Private register dump of DOS         *)
    a5     : LONGINT;
    a6     : LONGINT;
    errors * : ErrorStringPtr; (* pointer to array of error msgs *)
    timeReq   : t.TimeRequestPtr; (* private pointer to timer request *)
    utilityBase   : e.LibraryPtr; (* private ptr to utility library *)
  END;

(*                             *)

  TaskArray * = STRUCT
    maxCLI * : LONGINT;
    cli    * : ARRAY 10000000H OF ProcessId;
  END;

  RootNode * = STRUCT
    taskArray * : TaskArrayPtr;      (* [0] is max number of CLI's
                                      * [1] is APTR to process id of CLI 1
                                      * [n] is APTR to process id of CLI n       *)
    consoleSegment * : e.BPTR;       (* SegList for the CLI                      *)
    time * : Date;                   (* Current time                             *)
    restartSeg * : e.BPTR;           (* SegList for the disk validator process   *)
    info * : DosInfoPtr;             (* Pointer to the Info structure            *)
    fileHandlerSegment * : e.BPTR;   (* segment for a file handler               *)
    cliList * : e.MinList;           (* new list of all CLI processes            *)
                                     (* the first cpl_Array is also rn_TaskArray *)
    bootProc  -: ProcessId;          (* private ptr to msgport of boot fs        *)
    shellSegment * : e.BPTR;         (* seglist for Shell (for NewShell)         *)
    flags * : LONGSET;               (* dos flags *)
  END;

CONST
(* RootNode.flags *)
  wildStar * = 24;
  private1 * = 1;

TYPE

(* ONLY to be allocated by DOS! *)
  CliProcList * = STRUCT (node * : e.MinNode)
        first * : LONGINT;      (* number of first entry in array *)
        array * : UNTRACED POINTER TO ARRAY 1FFFFFFFH OF ProcessId;
                             (* [0] is max number of CLI's in this entry (n)
                              * [1] is CPTR to process id of CLI cpl_First
                              * [n] is CPTR to process id of CLI cpl_First+n-1
                              *)
  END;

  DosInfo * = STRUCT
    mcName * : BSTR;           (* Network name of this machine; currently 0 *)
    devInfo * : DevInfoPtr;    (* Device List                               *)
    devices * : e.BPTR;        (* Currently zero                            *)
    handlers * : e.BPTR;       (* Currently zero                            *)
    nethand  * : ProcessId;          (* Network handler processid; currently zero *)
    devLock * : e.SignalSemaphore;   (* do NOT access directly! *)
    entryLock * : e.SignalSemaphore; (* do NOT access directly! *)
    deleteLock * : e.SignalSemaphore;(* do NOT access directly! *)
  END;


(* structure for the Dos resident list.  Do NOT allocate these, use       *)
(* AddSegment(), and heed the warnings in the autodocs!                   *)

  Segment * = STRUCT
    next * : e.BPTR;
    uc * : LONGINT;
    seg * : e.BPTR;
    name * : ARRAY 4 OF CHAR;     (* actually the first 4 chars of BSTR name *)
  END;

CONST

  cmdSystem   * = -1;
  cmdInternal * = -2;
  cmdDisabled * = -999;


TYPE

  PathLock    * = STRUCT
                    next * : PathLockPtr;
                    lock * : FileLockPtr;
                  END;

(* DOS Processes started from the CLI via RUN or NEWCLI have this additional
 * set to data associated with them *)

  CommandLineInterface * = STRUCT
    result2        * : LONGINT;       (* Value of IoErr from last command        *)
    setName        * : BSTR;          (* Name of current directory               *)
    commandDir     * : PathLockPtr;   (* Head of the path locklist               *)
    returnCode     * : LONGINT;       (* Return code from last command           *)
    commandName    * : BSTR;          (* Name of current command                 *)
    failLevel      * : LONGINT;       (* Fail level (set by FAILAT)              *)
    prompt         * : BSTR;          (* Current prompt (set by PROMPT)          *)
    standardInput  * : FileHandlePtr; (* Default (terminal) CLI input            *)
    currentInput   * : FileHandlePtr; (* Current CLI input                       *)
    commandFile    * : BSTR;          (* Name of EXECUTE command file            *)
    interactive    * : LONGINT;       (* Boolean; True if prompts required       *)
    background     * : LONGINT;       (* Boolean; True if CLI created by RUN     *)
    currentOutput  * : FileHandlePtr; (* Current CLI output                      *)
    defaultStack   * : LONGINT;       (* Stack size to be obtained in long words *)
    standardOutput * : FileHandlePtr; (* Default (terminal) CLI output           *)
    module         * : e.BPTR;        (* SegList of currently loaded command     *)


  END;

(* This structure can take on different values depending on whether it is
 * a device, an assigned directory, or a volume.  Below is the structure
 * reflecting volumes only.  Following that is the structure representing
 * only devices. Following that is the unioned structure representing all
 * the values
 *)

  DosListNode * = STRUCT END; (* Dummy to make the following STRUCTs compatible *)

(* structure representing a volume *)

  DeviceList * = STRUCT (dummy: DosListNode)
    next       * : DeviceListPtr;  (* bptr to next device list *)
    type       * : LONGINT;        (* see DLT below *)
    task       * : ProcessId;      (* ptr to handler task *)
    lock       * : FileLockPtr;    (* not for volumes *)
    volumeDate * : Date;           (* creation date *)
    lockList   * : FileLockPtr;    (* outstanding locks *)
    diskType   * : LONGINT;        (* 'DOS', etc *)
    unused     * : LONGINT;
    name       * : BSTR;           (* bptr to bcpl name *)
  END;

(* device structure (same as the DeviceNode structure in filehandler.h) *)

  DevInfo * = STRUCT (dummy: DosListNode)
    next      * : DevInfoPtr;
    type      * : LONGINT;
    task      * : ProcessId;
    lock      * : FileLockPtr;
    handler   * : BSTR;
    stackSize * : LONGINT;
    priority  * : LONGINT;
    startup   * : FileSysStartupMsgPtr;
    segList   * : e.BPTR;
    globVec   * : e.BPTR;
    name      * : BSTR;
  END;

(* combined structure for devices, assigned directories, volumes *)

  DosList * = STRUCT (dummy: DosListNode)
    next      * : DevInfoPtr;
    type      * : LONGINT;
    task      * : ProcessId;
    lock      * : FileLockPtr;

    assignName* : e.LSTRPTR;      (* name for non-or-late-binding assign *)
    list      * : AssignListPtr;  (* for multi-directory assigns (regular) *)
    unused    * : ARRAY 4 OF LONGINT;
    name      * : BSTR;
  END;

(* structure used for multi-directory assigns. AllocVec()ed. *)

  AssignList * = STRUCT
    next * : AssignListPtr;
    lock * : FileLockPtr;
  END;

CONST

(* definitions for DosList.type *)
  device      * = 0;
  directory   * = 1;       (* assign *)
  volume      * = 2;
  late        * = 3;       (* late-binding assign *)
  nonBinding  * = 4;       (* non-binding assign *)
  private     * = -1;      (* for internal use only *)

TYPE

(* structure return by GetDeviceProc() *)
  DevProc * = STRUCT
    port * : e.MsgPortPtr;
    lock * : FileLockPtr;
    flags * : LONGSET;
    devNode : DosListNodePtr;    (* DON'T TOUCH OR USE! *)
  END;

CONST

(* definitions for DevProc.flags *)
  unLock  * = 0;
  assign  * = 1;

(* Flags to be passed to LockDosList(), etc *)
  devices   * = 2;
  volumes   * = 3;
  assigns   * = 4;
  entry     * = 5;
  ldDelete  * = 6;

(* you MUST specify one of read or write *)
  dosListRead * = 0;
  dosListWrite * = 1;

(* actually all but entry (which is used for internal locking) *)
  all * = LONGSET{devices,volumes,assigns};

TYPE

(* a lock structure, as returned by Lock() or DupLock() *)
  FileLock * = STRUCT
    link   * : FileLockPtr;   (* bcpl pointer to next lock *)
    key    * : LONGINT;       (* disk block number *)
    access * : LONGINT;       (* exclusive or shared *)
    task   * : ProcessId;     (* handler task's port *)
    volume * : DeviceListPtr; (* bptr to DLT_VOLUME DosList entry *)
  END;

CONST

(* error report types for ErrorReport() *)
  reportStream * = 0;      (* a stream *)
  reportTask   * = 1;      (* a process - unused *)
  reportLock   * = 2;      (* a lock *)
  reportVolume * = 3;      (* a volume node *)
  reportInsert * = 4;      (* please insert volume *)

(* Special error codes for ErrorReport() *)
  diskError  * = 296;     (* Read/write error *)
  abortBusy  * = 288;     (* You MUST replace... *)

(* types for initial packets to shells from run/newcli/execute/system. *)
(* For shell-writers only *)
  runExecute         * = -1;
  runSystem          * = -2;
  runSystemAsynch    * = -3;

(* Types for FileInfoBlock.dirEntryType. NOTE that both USERDIR and ROOT are  *)
(* directories, and that directory/file checks should use <0 and >=0.    *)
(* This is not necessarily exhaustive!  Some handlers may use other      *)
(* values as needed, though <0 and >=0 should remain as supported as     *)
(* possible.                                                             *)
  root       * = 1;
  userDir    * = 2;
  softLink   * = 3;       (* looks like dir, but may point to a file! *)
  linkDir    * = 4;       (* hard link to dir *)
  file       * = -3;      (* must be negative for FIB! *)
  linkFile   * = -4;      (* hard link to file *)


(* hunk types *)
  hunkUnit       * = 999;
  hunkName       * = 1000;
  hunkCode       * = 1001;
  hunkData       * = 1002;
  hunkBSS        * = 1003;
  hunkReloc32    * = 1004;
  hunkAbsReloc32 * = hunkReloc32;
  hunkReloc16    * = 1005;
  hunkRelReloc16 * = hunkReloc16;
  hunkReloc8     * = 1006;
  hunkRelReloc8  * = hunkReloc8;
  hunkExt        * = 1007;
  hunkSymbol     * = 1008;
  hunkDebug      * = 1009;
  hunkEnd        * = 1010;
  hunkHeader     * = 1011;

  hunkOverlay    * = 1013;
  hunkBreak      * = 1014;

  hunkDRel32     * = 1015;
  hunkDRel16     * = 1016;
  hunkDRel8      * = 1017;

  hunkLib        * = 1018;
  hunkIndex      * = 1019;

(*
 * Note: V37 LoadSeg uses 1015 (HUNK_DREL32) by mistake.  This will continue
 * to be supported in future versions, since HUNK_DREL32 is illegal in load files
 * anyways.  Future versions will support both 1015 and 1020, though anything
 * that should be usable under V37 should use 1015.
 *)
  hunkReloc32Short * = 1020;

(* see ext_xxx below.  New for V39 (note that LoadSeg only handles RELRELOC32).*)
  hunkRelReloc32   * = 1021;
  hunkAbsReloc16   * = 1022;

(*
 * Any hunks that have the HUNKB_ADVISORY bit set will be ignored if they
 * aren't understood.  When ignored, they're treated like HUNK_DEBUG hunks.
 * NOTE: this handling of HUNKB_ADVISORY started as of V39 dos.library!  If
 * lading such executables is attempted under <V39 dos, it will fail with a
 * bad hunk type.
 *)
  hunkBAdvisory    * = 29;
  hunkBChip        * = 30;
  hunkBFast        * = 31;


(* hunk_ext sub-types *)
  extSymb        * = 0;       (* symbol table *)
  extDef         * = 1;       (* relocatable definition *)
  extAbs         * = 2;       (* Absolute definition *)
  extRes         * = 3;       (* no longer supported *)
  extRef32       * = 129;     (* 32 bit reference to symbol *)
  extAbsRef32    * = extRef32;
  extCommon      * = 130;     (* 32 bit reference to COMMON block *)
  extAbsCommon   * = extCommon;
  extRef16       * = 131;     (* 16 bit reference to symbol *)
  extRelRef16    * = extRef16;
  extRef8        * = 132;     (*  8 bit reference to symbol *)
  extRelRef8     * = extRef8;
  extDExt32      * = 133;     (* 32 bit data releative reference *)
  extDExt16      * = 134;     (* 16 bit data releative reference *)
  extDExt8       * = 135;     (*  8 bit data releative reference *)

(* These are to support some of the '020 and up modes that are rarely used *)
  extRelRef32    * = 136;     (* 32 bit PC-relative reference to symbol *)
  extRelCommon   * = 137;     (* 32 bit PC-relative reference to COMMON block *)

(* for completeness... All 680x0's support this *)
  extAbsRef16    * = 138;     (* 16 bit absolute reference to symbol *)

(* this only exists on '020's and above, in the (d8,An,Xn) address mode *)
  extAbsRef8     * = 139;     (* 8 bit absolute reference to symbol *)


(*****************************************************************************)
(* definitions for the System() call *)

  sysDummy       * = u.user + 32;
  sysInput       * = sysDummy + 1;      (* specifies the input filehandle  *)
  sysOutput      * = sysDummy + 2;      (* specifies the output filehandle *)
  sysAsynch      * = sysDummy + 3;      (* run asynch, close input/output on exit(!) *)
  sysUserShell   * = sysDummy + 4;      (* send to user shell instead of boot shell *)
  sysCustomShell * = sysDummy + 5;      (* send to a specific shell (data is name) *)


(*****************************************************************************)
(* definitions for the CreateNewProc() call *)
(* you MUST specify one of NP_Seglist or NP_Entry.  All else is optional. *)

  npDummy        * = u.user + 1000;
  npSeglist      * = npDummy + 1; (* seglist of code to run for the process  *)
  npFreeSeglist  * = npDummy + 2; (* free seglist on exit - only valid for   *)
                                  (* for NP_Seglist.  Default is TRUE.       *)
  npEntry        * = npDummy + 3; (* entry point to run - mutually exclusive *)
                                  (* with NP_Seglist! *)
  npInput        * = npDummy + 4; (* filehandle - default is Open("NIL:"...) *)
  npOutput       * = npDummy + 5; (* filehandle - default is Open("NIL:"...) *)
  npCloseInput   * = npDummy + 6; (* close input filehandle on exit          *)
                                  (* default TRUE                            *)
  npCloseOutput  * = npDummy + 7; (* close output filehandle on exit         *)
                                  (* default TRUE                            *)
  npError        * = npDummy + 8; (* filehandle - default is Open("NIL:"...) *)
  npCloseError   * = npDummy + 9; (* close error filehandle on exit          *)
                                  (* default TRUE                            *)
  npCurrentDir   * = npDummy + 10; (* lock - default is parent's current dir  *)
  npStackSize    * = npDummy + 11; (* stacksize for process - default 4000    *)
  npName         * = npDummy + 12; (* name for process - default "New Process"*)
  npPriority     * = npDummy + 13; (* priority - default same as parent       *)
  npConsoleTask  * = npDummy + 14; (* consoletask - default same as parent    *)
  npWindowPtr    * = npDummy + 15; (* window ptr - default is same as parent  *)
  npHomeDir      * = npDummy + 16; (* home directory - default curr home dir  *)
  npCopyVars     * = npDummy + 17; (* boolean to copy local vars-default TRUE *)
  npCli          * = npDummy + 18; (* create cli structure - default FALSE    *)
  npPath         * = npDummy + 19; (* path - default is copy of parents path  *)
                                   (* only valid if a cli process!    *)
  npCommandName  * = npDummy + 20; (* commandname - valid only for CLI        *)
  npArguments    * = npDummy + 21; (* cstring of arguments - passed with str  *)
                                   (* in a0, length in d0.  (copied and freed *)
                                   (* on exit.  Default is empty string.      *)
                                   (* NOTE: not operational until 2.04 - see  *)
                                   (* BIX/TechNotes for more info/workarounds *)
                                   (* NOTE: in 2.0, it DIDN'T pass "" - the   *)
                                   (* registers were random.                  *)
(* FIX! should this be only for cli's? *)
  npNotifyOnDeath * = npDummy + 22; (* notify parent on death - default FALSE  *)
                                    (* Not functional yet. *)
  npSynchronous  * = npDummy + 23; (* don't return until process finishes -   *)
                                   (* default FALSE.                          *)
                                   (* Not functional yet. *)
  npExitCode     * = npDummy + 24; (* code to be called on process exit       *)
  npExitData     * = npDummy + 25; (* optional argument for NP_EndCode rtn -  *)
                                   (* default NULL                            *)


(*****************************************************************************)
(* tags for AllocDosObject *)

  adoDummy       * = u.user + 2000;
  adoFHMode      * = adoDummy + 1;
                                (* for type DOS_FILEHANDLE only            *)
                                (* sets up FH for mode specified.
                                   This can make a big difference for buffered
                                   files.                                  *)
        (* The following are for DOS_CLI *)
        (* If you do not specify these, dos will use it's preferred values *)
        (* which may change from release to release.  The BPTRs to these   *)
        (* will be set up correctly for you.  Everything will be zero,     *)
        (* except cli_FailLevel (10) and cli_Background (DOSTRUE).         *)
        (* NOTE: you may also use these 4 tags with CreateNewProc.         *)

  adoDirLen      * = adoDummy + 2; (* size in bytes for current dir buffer    *)
  adoCommNameLen * = adoDummy + 3; (* size in bytes for command name buffer   *)
  adoCommFileLen * = adoDummy + 4; (* size in bytes for command file buffer   *)
  adoPromptLen   * = adoDummy + 5; (* size in bytes for the prompt buffer     *)

(*****************************************************************************)
(* tags for NewLoadSeg *)
(* no tags are defined yet for NewLoadSeg *)

(* NOTE: V37 dos.library, when doing ExAll() emulation, and V37 filesystems  *)
(* will return an error if passed ED_OWNER.  If you get ERROR_BAD_NUMBER,    *)
(* retry with ED_COMMENT to get everything but owner info.  All filesystems  *)
(* supporting ExAll() must support through ED_COMMENT, and must check Type   *)
(* and return ERROR_BAD_NUMBER if they don't support the type.                     *)

(* values that can be passed for what data you want from ExAll() *)
(* each higher value includes those below it (numerically)       *)
(* you MUST chose one of these values *)
  name        * = 1;
  type        * = 2;
  size        * = 3;
  protection  * = 4;
  date        * = 5;
  comment     * = 6;
  owner       * = 7;

TYPE

(*
 *   Structure in which exall results are returned in.  Note that only the
 *   fields asked for will exist!
 *)

  ExAllData * = STRUCT
        next * : ExAllDataPtr;
        name * : e.LSTRPTR;
        type * : LONGINT;
        size * : LONGINT;
        prot * : LONGSET;
        days * : LONGINT;
        mins * : LONGINT;
        ticks    * : LONGINT;
        comment  * : e.LSTRPTR;  (* strings will be after last used field *)
        ownerUID * : INTEGER;    (* new for V39 *)
        ownerGID * : INTEGER;
  END;

(*
 *   Control structure passed to ExAll.  Unused fields MUST be initialized to
 *   0, expecially eac_LastKey.
 *
 *   eac_MatchFunc is a hook (see utility.library documentation for usage)
 *   It should return true if the entry is to returned, false if it is to be
 *   ignored.
 *
 *   This structure MUST be allocated by AllocDosObject()!
 *)

  ExAllControl * = STRUCT
    entries     * : LONGINT;    (* number of entries returned in buffer      *)
    lastKey     * : LONGINT;    (* Don't touch inbetween linked ExAll calls! *)
    matchString * : e.LSTRPTR;  (* wildcard string for pattern match or NULL *)
    matchFunc   * : u.HookPtr;  (* optional private wildcard function        *)
  END;


(* The disk "environment" is a longword array that describes the
 * disk geometry.  It is variable sized, with the length at the beginning.
 * Here are the constants for a standard geometry.
 *)

  DosEnvec * = STRUCT
    tableSize      * : LONGINT; (* size of Environment vector *)
    sizeBlock      * : LONGINT; (* in longwords: standard value is 128 *)
    secOrg         * : LONGINT; (* not used; must be 0 *)
    surfaces       * : LONGINT; (* # of heads (surfaces). drive specific *)
    sectorPerBlock * : LONGINT; (* not used; must be 1 *)
    blocksPerTrack * : LONGINT; (* blocks per track. drive specific *)
    reserved       * : LONGINT; (* DOS reserved blocks at start of partition. *)
    preAlloc       * : LONGINT; (* DOS reserved blocks at end of partition *)
    interleave     * : LONGINT; (* usually 0 *)
    lowCyl         * : LONGINT; (* starting cylinder. typically 0 *)
    highCyl        * : LONGINT; (* max cylinder. drive specific *)
    numBuffers     * : LONGINT; (* Initial # DOS of buffers.  *)
    bufMemType     * : LONGINT; (* type of mem to allocate for buffers *)
    maxTransfer    * : LONGINT; (* Max number of bytes to transfer at a time *)
    mask           * : LONGSET; (* Address Mask to block out certain memory *)
    bootPri        * : LONGINT; (* Boot priority for autoboot *)
    dosType        * : LONGINT; (* ASCII (HEX) string showing filesystem type;
                                 * 0X444F5300 is old filesystem,
                                 * 0X444F5301 is fast file system *)
    baud           * : LONGINT; (* Baud rate for serial handler *)
    control        * : LONGINT; (* Control word for handler/filesystem *)
    bootBlocks     * : LONGINT; (* Number of blocks containing boot code *)
  END;

CONST

(* these are the offsets into the array *)
(* DE_TABLESIZE is set to the number of longwords in the table minus 1 *)

  tableSize    * = 0;       (* minimum value is 11 (includes NumBuffers) *)
  sizeBlock    * = 1;       (* in longwords: standard value is 128 *)
  secOrg       * = 2;       (* not used; must be 0 *)
  numHeads     * = 3;       (* # of heads (surfaces). drive specific *)
  secsPerBlk   * = 4;       (* not used; must be 1 *)
  blksPerTrack * = 5;       (* blocks per track. drive specific *)
  reservedBlks * = 6;       (* unavailable blocks at start.  usually 2 *)
  preFac       * = 7;       (* not used; must be 0 *)
  interLeave   * = 8;       (* usually 0 *)
  lowCyl       * = 9;       (* starting cylinder. typically 0 *)
  upperCyl     * = 10;      (* max cylinder.  drive specific *)
  numBuffers   * = 11;      (* starting # of buffers.  typically 5 *)
  memBufType   * = 12;      (* type of mem to allocate for buffers. *)
  bufMemType   * = 12;      (* same as above, better name
                             * 1 is public, 3 is chip, 5 is fast *)
  maxTransfer  * = 13;      (* Max number bytes to transfer at a time *)
  mask         * = 14;      (* Address Mask to block out certain memory *)
  bootPri      * = 15;      (* Boot priority for autoboot *)
  dosType      * = 16;      (* ASCII (HEX) string showing filesystem type;
                             * 0X444F5300 is old filesystem,
                             * 0X444F5301 is fast file system *)
  baud         * = 17;      (* Baud rate for serial handler *)
  control      * = 18;      (* Control word for handler/filesystem *)
  bootBlocks   * = 19;      (* Number of blocks containing boot code *)

TYPE

(* The file system startup message is linked into a device node's startup
** field.  It contains a pointer to the above environment, plus the
** information needed to do an exec OpenDevice().
*)
  FileSysStartupMsg * = STRUCT
    unit    * : LONGINT;     (* exec unit number for this device *)
    device  * : BSTR;        (* null terminated bstring to the device name *)
    environ * : DosEnvecPtr; (* ptr to environment table (see above) *)
    flags   * : LONGSET;     (* flags for OpenDevice() *)
  END;


(* The include file "libraries/dosextens.h" has a DeviceList structure.
 * The "device list" can have one of three different things linked onto
 * it.  Dosextens defines the structure for a volume.  DLT_DIRECTORY
 * is for an assigned directory.  The following structure is for
 * a dos "device" (DLT_DEVICE).
*)

  DeviceNode * = STRUCT
    next      * : DeviceNodePtr;        (* singly linked list *)
    type      * : LONGINT;              (* always 0 for dos "devices" *)
    task      * : ProcessId;            (* standard dos "task" field.  If this is
                                         * null when the node is accesses, a task
                                         * will be started up *)
    lock      * : FileLockPtr;          (* not used for devices -- leave null *)
    handler   * : BSTR;                 (* filename to loadseg (if seglist is null) *)
    stackSize * : LONGINT;              (* stacksize to use when starting task *)
    priority  * : LONGINT;              (* task priority when starting task *)
    startup   * : FileSysStartupMsgPtr; (* startup msg: FileSysStartupMsg for disks *)
    segList   * : e.BPTR;               (* code to run to start new task (if necessary).
                                         * if null then dn_Handler will be loaded. *)
    globalVec * : e.BPTR;               (* BCPL global vector to use when starting
                                         * a task.  -1 means that dn_SegList is not
                                         * for a bcpl program, so the dos won't
                                         * try and construct one.  0 tell the
                                         * dos that you obey BCPL linkage rules,
                                         * and that it should construct a global
                                         * vector for you.
                                         *)
    name      * : BSTR;                 (* the node name, e.g. '\3','D','F','3' *)
  END;

CONST

(* use of Class and code is discouraged for the time being - we might want to
   change things *)
(* --- NotifyMessage Class ------------------------------------------------ *)
  class  * = 40000000H;

(* --- NotifyMessage Codes ------------------------------------------------ *)
  code   * = 1234H;

TYPE

(* Sent to the application if SEND_MESSAGE is specified.                    *)

  NotifyMessage * = STRUCT (execMessage * : e.Message)
    class       * : LONGINT;
    code        * : INTEGER;
    nReq        * : NotifyRequestPtr;      (* don't modify the request! *)
    doNotTouch    : LONGINT;               (* like it says!  For use by handlers *)
    doNotTouch2   : LONGINT;               (* dito *)
  END;

(* Do not modify or reuse the notifyrequest while active.                   *)
(* note: the first LONG of nr_Data has the length transfered                *)

  NotifyRequest * = STRUCT
    name * : e.LSTRPTR;
    fullName * : e.LSTRPTR;          (* set by dos - don't touch *)
    userData * : e.APTR;             (* for applications use *)
    flags * : LONGSET;

    task * : e.TaskPtr;              (* could also be: port * : e.MsgPortPtr *)
    signalNum * : SHORTINT;
    pad1,pad2,pad3: SHORTINT;

    reserved * : ARRAY 4 OF LONGINT; (* leave 0 for now *)

    (* internal use by handlers *)
    msgCount * : LONGINT;            (* # of outstanding msgs *)
    handler  * : e.MsgPortPtr;       (* handler sent to (for EndNotify) *)
  END;

CONST

(* --- NotifyRequest.flags ------------------------------------------------ *)


  sendMessage     * = 0;
  sendSignal      * = 1;
  waitReply       * = 3;
  notifyInitial   * = 4;

(* do NOT set or remove MAGIC!  Only for use by handlers! *)
  magic           * = 31;

(* Flags reserved for private use by the handler: *)
  handlerFlags    * = LONGSET{16..31};

TYPE

(**********************************************************************
 *
 * The CSource data structure defines the input source for "ReadItem()"
 * as well as the ReadArgs call.  It is a publicly defined structure
 * which may be used by applications which use code that follows the
 * conventions defined for access.
 *
 * When passed to the dos.library functions, the value passed as
 * struct *CSource is defined as follows:
 *      if ( CSource == 0)      Use buffered IO "ReadChar()" as data source
 *      else                    Use CSource for input character stream
 *
 * The following two pseudo-code routines define how the CSource structure
 * is used:
 *
 * long CS_ReadChar( struct CSource *CSource )
 * {
 *      if ( CSource == 0 )     return ReadChar();
 *      if ( CSource->CurChr >= CSource->Length )       return ENDSTREAMCHAR;
 *      return CSource->Buffer[ CSource->CurChr++ ];
 * }
 *
 * BOOL CS_UnReadChar( struct CSource *CSource )
 * {
 *      if ( CSource == 0 )     return UnReadChar();
 *      if ( CSource->CurChr <= 0 )     return FALSE;
 *      CSource->CurChr--;
 *      return TRUE;
 * }
 *
 * To initialize a struct CSource, you set CSource->CS_Buffer to
 * a string which is used as the data source, and set CS_Length to
 * the number of characters in the string.  Normally CS_CurChr should
 * be initialized to ZERO, or left as it was from prior use as
 * a CSource.
 *
 **********************************************************************)

  CSource * = STRUCT
    buffer * : e.LSTRPTR;
    length * : LONGINT;
    curChr * : LONGINT;
  END;

(**********************************************************************
 *
 * The RDArgs data structure is the input parameter passed to the DOS
 * ReadArgs() function call.
 *
 * The RDA_Source structure is a CSource as defined above;
 * if RDA_Source.CS_Buffer is non-null, RDA_Source is used as the input
 * character stream to parse, else the input comes from the buffered STDIN
 * calls ReadChar/UnReadChar.
 *
 * RDA_DAList is a private address which is used internally to track
 * allocations which are freed by FreeArgs().  This MUST be initialized
 * to NULL prior to the first call to ReadArgs().
 *
 * The RDA_Buffer and RDA_BufSiz fields allow the application to supply
 * a fixed-size buffer in which to store the parsed data.  This allows
 * the application to pre-allocate a buffer rather than requiring buffer
 * space to be allocated.  If either RDA_Buffer or RDA_BufSiz is NULL,
 * the application has not supplied a buffer.
 *
 * RDA_ExtHelp is a text string which will be displayed instead of the
 * template string, if the user is prompted for input.
 *
 * RDA_Flags bits control how ReadArgs() works.  The flag bits are
 * defined below.  Defaults are initialized to ZERO.
 *
 **********************************************************************)

  RDArgs * = STRUCT
    source  * : CSource;       (* Select input source *)
    daList  * : LONGINT;       (* PRIVATE. must be initiaized to 0 *)
    buffer  * : e.LSTRPTR;     (* Optional string parsing space. *)
    bufSiz  * : LONGINT;       (* Size of RDA_Buffer (0..n) *)
    extHelp * : e.LSTRPTR;     (* Optional extended help *)
    flags   * : LONGSET;       (* Flags for any required control *)
  END;

CONST

(* RDArgs.flags *)
  stdIn    * = 0;       (* Use "STDIN" rather than "COMMAND LINE" *)
  noAlloc  * = 1;       (* If set, do not allocate extra string space.*)
  noPrompt * = 2;       (* Disable reprompting for string input. *)

(**********************************************************************
 * Maximum number of template keywords which can be in a template passed
 * to ReadArgs(). IMPLEMENTOR NOTE - must be a multiple of 4.
 **********************************************************************)
  maxTemplateItems * = 100;

(**********************************************************************
 * Maximum number of MULTIARG items returned by ReadArgs(), before
 * an ERROR_LINE_TOO_LONG.  These two limitations are due to stack
 * usage.  Applications should allow "a lot" of stack to use ReadArgs().
 **********************************************************************)
  maxMultiArgs * = 128;

TYPE
(*
 * use an extension of this and pass it to ReadArgs()
 * use one entry (see definitions below) for every template keyword
 * according to it's type.
 *
 * NOTE: This has been introduced to improof type safety since somebody
 *       tried to pass a POINTER TO ARRAY OF CHAR, what totaly confused the
 *       garbage collector.
 *)

  ArgsStruct * = STRUCT END;

  (* these are UNTRACED 'cause allocated by DOS *)
  ArgLong        * = UNTRACED POINTER TO ARRAY 1 OF LONGINT;   (* /N *)
  ArgLongArray   * = UNTRACED POINTER TO ARRAY maxMultiArgs OF ArgLong;   (* /M/N*)
  ArgBool        * = e.LONGBOOL;   (* /S, /T *)
  ArgString      * = e.LSTRPTR;    (* /K, or nothing *)
  ArgStringArray * = UNTRACED POINTER TO ARRAY maxMultiArgs OF ArgString; (* /K/M, /M *)


CONST
(* Modes for LockRecord/LockRecords() *)
  recExclusive       * = 0;
  recExclusiveImmed  * = 1;
  recShared          * = 2;
  recSharedImmed     * = 3;

TYPE

(* struct to be passed to LockRecords()/UnLockRecords() *)

  RecordLock * = STRUCT
    fh     * : FileHandlePtr; (* filehandle *)
    offset * : LONGINT;       (* offset in file *)
    lenght * : LONGINT;       (* length of file to be locked *)
    mode   * : LONGINT;       (* Type of lock *)
  END;

CONST

(* types for SetVBuf *)
  bufLine     * = 0;      (* flush on \n, etc *)
  bufFull     * = 1;      (* never flush except when needed *)
  bufNone     * = 2;      (* no buffering *)


(* the structure in the pr_LocalVars list *)
(* Do NOT allocate yourself, use SetVar()!!! This structure may grow in *)
(* future releases!  The list should be left in alphabetical order, and *)
(* may have multiple entries with the same name but different types.    *)

TYPE
  LocalVar * = STRUCT (node * : e.Node)
    flags * : SET;
    value * : e.LSTRPTR;
    len   * : LONGINT;
  END;

(*
 * The lv_Flags bits are available to the application.  The unused
 * lv_Node.ln_Pri bits are reserved for system use.
 *)

CONST

(* definitions for LocalVar.node.type: *)
  var        * = 0;       (* an variable *)
  alias      * = 1;       (* an alias    *)
(* to be or'ed into type: *)
  ingnore    * = -80H;    (* ignore this entry on GetVar, etc *)

(* definitions of flags passed to GetVar()/SetVar()/DeleteVar() *)
(* bit defs to be OR'ed with the type: *)
(* item will be treated as a single line of text unless BINARY_VAR is used *)
  globalOnly      * = 8;
  localOnly       * = 9;
  binaryVar       * = 10;             (* treat variable as binary *)
  dontNullTerm    * = 11;      (* only with GVF_BINARY_VAR *)

(* this is only supported in >= V39 dos.  V37 dos ignores this. *)
(* this causes SetVar to affect ENVARC: as well as ENV:.      *)
  saveVar         * = 12;      (* only with GVF_GLOBAL_VAR *)

TYPE
  OwnerInfo * = STRUCT (* dummy for better access on SetOwner etc.*)
    uid *: INTEGER;
    gid *: INTEGER;
  END;

VAR
  dos*, base*: DosLibraryPtr;   (* synonyms *)


PROCEDURE Open          *{dos,- 30}(name{1}      : ARRAY OF CHAR;
                                    accessMode{2}: LONGINT): FileHandlePtr;
PROCEDURE Close         *{dos,- 36}(file{1}      : FileHandlePtr): BOOLEAN;
PROCEDURE OldClose      *{dos,- 36}(file{1}      : FileHandlePtr);      (* Version < 36 *)
PROCEDURE Read          *{dos,- 42}(file{1}      : FileHandlePtr;
                                    buffer{2}    : ARRAY OF y.BYTE;
                                    length{3}    : LONGINT): LONGINT;
PROCEDURE Write         *{dos,- 48}(file{1}      : FileHandlePtr;
                                    buffer{2}    : ARRAY OF y.BYTE;
                                    length{3}    : LONGINT): LONGINT;
PROCEDURE Input         *{dos,- 54}(): FileHandlePtr;
PROCEDURE Output        *{dos,- 60}(): FileHandlePtr;
PROCEDURE Seek          *{dos,- 66}(file{1}      : FileHandlePtr;
                                    position{2}  : LONGINT;
                                    offset{3}    : LONGINT): LONGINT;
PROCEDURE DeleteFile    *{dos,- 72}(name{1}      : ARRAY OF CHAR): BOOLEAN;
PROCEDURE Rename        *{dos,- 78}(oldName{1}   : ARRAY OF CHAR;
                                    newName{2}   : ARRAY OF CHAR): BOOLEAN;
PROCEDURE Lock          *{dos,- 84}(name{1}      : ARRAY OF CHAR;
                                    type{2}      : LONGINT): FileLockPtr;
PROCEDURE UnLock        *{dos,- 90}(lock{1}      : FileLockPtr);
PROCEDURE DupLock       *{dos,- 96}(lock{1}      : FileLockPtr): FileLockPtr;
PROCEDURE Examine       *{dos,-102}(lock{1}      : FileLockPtr;
                                    VAR info{2}  : FileInfoBlock): BOOLEAN;
PROCEDURE ExNext        *{dos,-108}(lock{1}      : FileLockPtr;
                                    VAR info{2}  : FileInfoBlock): BOOLEAN;
PROCEDURE Info          *{dos,-114}(lock{1}      : FileLockPtr;
                                    VAR info{2}  : InfoData): BOOLEAN;
PROCEDURE CreateDir     *{dos,-120}(name{1}      : ARRAY OF CHAR): FileLockPtr;
PROCEDURE CurrentDir    *{dos,-126}(lock{1}      : FileLockPtr): FileLockPtr;
PROCEDURE IoErr         *{dos,-132}(): LONGINT;
PROCEDURE CreateProc    *{dos,-138}(name{1}      : ARRAY OF CHAR;
                                    pri{2}       : LONGINT;
                                    segList{3}   : e.BPTR;
                                    stackSize{4} : LONGINT): ProcessId;
PROCEDURE Exit          *{dos,-144}(returnCode{1}: LONGINT);
PROCEDURE LoadSeg       *{dos,-150}(name{1}      : ARRAY OF CHAR): e.BPTR;
PROCEDURE UnLoadSeg     *{dos,-156}(segList{1}   : e.BPTR);
PROCEDURE DeviceProc    *{dos,-174}(name{1}      : ARRAY OF CHAR): ProcessId;
PROCEDURE SetComment    *{dos,-180}(name{1}      : ARRAY OF CHAR;
                                    comment{2}   : ARRAY OF CHAR): BOOLEAN;
PROCEDURE SetProtection *{dos,-186}(name{1}      : ARRAY OF CHAR;
                                    protect{2}   : LONGSET): BOOLEAN;
PROCEDURE DateStamp     *{dos,-192}(VAR date{1}  : Date);
PROCEDURE Delay         *{dos,-198}(timeout{1}   : LONGINT);
PROCEDURE WaitForChar   *{dos,-204}(file{1}      : FileHandlePtr;
                                    timeout{2}   : LONGINT): BOOLEAN;
PROCEDURE ParentDir     *{dos,-210}(lock{1}      : FileLockPtr): FileLockPtr;
PROCEDURE IsInteractive *{dos,-216}(file{1}      : FileHandlePtr): BOOLEAN;
PROCEDURE Execute       *{dos,-222}(string{1}    : ARRAY OF CHAR;
                                    file{2}      : FileHandlePtr;
                                    file2{3}     : FileHandlePtr): BOOLEAN;

(* ---   functions in V36 or higher (Release 2.0)    --- *)

(*      DOS Object creation/deletion *)
PROCEDURE AllocDosObject*{dos,-228}(type{1}      : LONGINT;
                                    tags{2}      : ARRAY OF u.TagItem): e.APTR;
PROCEDURE AllocDosObjectTags*{dos,-228}(type{1}  : LONGINT;
                                    tag1{2}..    : u.Tag): e.APTR;
PROCEDURE FreeDosObject *{dos,-234}(type{1}      : LONGINT;
                                    ptr{2}       : e.APTR);
(*      Packet Level routines *)
PROCEDURE DoPkt0        *{dos,-240}(port{1}      : ProcessId;
                                    action{2}    : LONGINT): LONGINT;
PROCEDURE DoPkt1        *{dos,-240}(port{1}      : ProcessId;
                                    action{2}    : LONGINT;
                                    arg1{3}      : LONGINT): LONGINT;
PROCEDURE DoPkt2        *{dos,-240}(port{1}      : ProcessId;
                                    action{2}    : LONGINT;
                                    arg1{3}      : LONGINT;
                                    arg2{4}      : LONGINT): LONGINT;
PROCEDURE DoPkt3        *{dos,-240}(port{1}      : ProcessId;
                                    action{2}    : LONGINT;
                                    arg1{3}      : LONGINT;
                                    arg2{4}      : LONGINT;
                                    arg3{5}      : LONGINT): LONGINT;
PROCEDURE DoPkt4        *{dos,-240}(port{1}      : ProcessId;
                                    action{2}    : LONGINT;
                                    arg1{3}      : LONGINT;
                                    arg2{4}      : LONGINT;
                                    arg3{5}      : LONGINT;
                                    arg4{6}      : LONGINT): LONGINT;
PROCEDURE DoPkt         *{dos,-240}(port{1}      : ProcessId;
                                    action{2}    : LONGINT;
                                    arg1{3}      : LONGINT;
                                    arg2{4}      : LONGINT;
                                    arg3{5}      : LONGINT;
                                    arg4{6}      : LONGINT;
                                    arg5{7}      : LONGINT): LONGINT;
PROCEDURE SendPkt       *{dos,-246}(VAR dp{1}    : DosPacket;
                                    port{2}      : ProcessId;
                                    replyport{3} : e.MsgPortPtr);
PROCEDURE WaitPkt       *{dos,-252}(): DosPacketPtr;
PROCEDURE ReplyPkt      *{dos,-258}(dp{1}        : DosPacketPtr;
                                    res1{2}      : LONGINT;
                                    res2{3}      : LONGINT);
PROCEDURE AbortPkt      *{dos,-264}(port{1}      : ProcessId;
                                    pkt{2}       : DosPacketPtr);
(*      Record Locking *)
PROCEDURE LockRecord    *{dos,-270}(fh{1}        : FileHandlePtr;
                                    offset{2}    : LONGINT;
                                    length{3}    : LONGINT;
                                    mode{4}      : LONGINT;
                                    timeout{5}   : LONGINT): BOOLEAN;
PROCEDURE LockRecords   *{dos,-276}(recArray{1}  : RecordLockPtr;
                                    timeout{2}   : LONGINT): BOOLEAN;
PROCEDURE UnLockRecord  *{dos,-282}(fh{1}        : FileHandlePtr;
                                    offset{2}    : LONGINT;
                                    length{3}    : LONGINT): BOOLEAN;
PROCEDURE UnLockRecords *{dos,-288}(recArray{1}  : RecordLockPtr): BOOLEAN;
(*      Buffered File I/O *)
PROCEDURE SelectInput   *{dos,-294}(fh{1}        : FileHandlePtr): FileHandlePtr;
PROCEDURE SelectOutput  *{dos,-300}(fh{1}        : FileHandlePtr): FileHandlePtr;
PROCEDURE FGetC         *{dos,-306}(fh{1}        : FileHandlePtr): LONGINT;
PROCEDURE FPutC         *{dos,-312}(fh{1}        : FileHandlePtr;
                                    ch{2}        : LONGINT): LONGINT;
PROCEDURE UnGetC        *{dos,-318}(fh{1}        : FileHandlePtr;
                                    character{2} : LONGINT): LONGINT;
PROCEDURE FRead         *{dos,-324}(fh{1}        : FileHandlePtr;
                                    block{2}     : ARRAY OF y.BYTE;
                                    blocklen{3}  : LONGINT;
                                    number{4}    : LONGINT): LONGINT;
PROCEDURE FWrite        *{dos,-330}(fh{1}        : FileHandlePtr;
                                    block{2}     : ARRAY OF y.BYTE;
                                    blocklen{3}  : LONGINT;
                                    number{4}    : LONGINT): LONGINT;
PROCEDURE FGets         *{dos,-336}(fh{1}        : FileHandlePtr;
                                    VAR buf{2}   : ARRAY OF CHAR;
                                    buflen{3}    : LONGINT): e.APTR;
(* NOTE: result of FPuts has inverted logic: TRUE means failture *)
PROCEDURE FPuts         *{dos,-342}(fh{1}        : FileHandlePtr;
                                    str{2}       : ARRAY OF CHAR): BOOLEAN; (* inverted logic!! *)
PROCEDURE VFWritef      *{dos,-348}(fh{1}        : FileHandlePtr;
                                    format{2}    : ARRAY OF CHAR;
                                    argarray{3}  : ARRAY OF y.BYTE): LONGINT;
PROCEDURE FWritef       *{dos,-348}(fh{1}        : FileHandlePtr;
                                    format{2}    : ARRAY OF CHAR;
                                    arg1{3}..    : e.APTR): LONGINT;
PROCEDURE VFPrintf      *{dos,-354}(fh{1}        : FileHandlePtr;
                                    format{2}    : ARRAY OF CHAR;
                                    argarray{3}  : ARRAY OF e.APTR): LONGINT;
PROCEDURE FPrintf       *{dos,-354}(fh{1}        : FileHandlePtr;
                                    format{2}    : ARRAY OF CHAR;
                                    arg1{3}..    : e.APTR): LONGINT;
PROCEDURE Flush         *{dos,-360}(fh{1}        : FileHandlePtr): BOOLEAN;
PROCEDURE SetVBuf       *{dos,-366}(fh{1}        : FileHandlePtr;
                                    VAR buff{2}  : ARRAY OF CHAR;
                                    type{3}      : LONGINT;
                                    size{4}      : LONGINT): LONGINT;
(*      DOS Object Management *)
PROCEDURE DupLockFromFH *{dos,-372}(fh{1}        : FileHandlePtr): FileLockPtr;
PROCEDURE OpenFromLock  *{dos,-378}(lock{1}      : FileLockPtr): FileHandlePtr;
PROCEDURE ParentOfFH    *{dos,-384}(fh{1}        : FileHandlePtr): FileLockPtr;
PROCEDURE ExamineFH     *{dos,-390}(fh{1}        : FileHandlePtr;
                                    VAR fib{2}   : FileInfoBlock): BOOLEAN;
PROCEDURE SetFileDate   *{dos,-396}(name{1}      : ARRAY OF CHAR;
                                    date{2}      : Date): BOOLEAN;
PROCEDURE NameFromLock  *{dos,-402}(lock{1}      : FileLockPtr;
                                    VAR buffer{2}: ARRAY OF CHAR;
                                    len{3}       : LONGINT): BOOLEAN;
PROCEDURE NameFromFH    *{dos,-408}(fh{1}        : FileHandlePtr;
                                    VAR buffer{2}: ARRAY OF CHAR;
                                    len{3}       : LONGINT): BOOLEAN;
PROCEDURE SplitName     *{dos,-414}(name{1}      : ARRAY OF CHAR;
                                    seperator{2} : CHAR;
                                    buf{3}       : ARRAY OF CHAR;
                                    oldpos{4}    : LONGINT;
                                    size{5}      : LONGINT): INTEGER;
PROCEDURE SameLock      *{dos,-420}(lock1{1}     : FileLockPtr;
                                    lock2{2}     : FileLockPtr): INTEGER;
PROCEDURE SetMode       *{dos,-426}(fh{1}        : FileHandlePtr;
                                    mode{2}      : LONGINT): BOOLEAN;
PROCEDURE ExAll         *{dos,-432}(lock{1}      : FileLockPtr;
                                    buffer{2}    : ARRAY OF y.BYTE;
                                    size{3}      : LONGINT;
                                    data{4}      : LONGINT;
                                    ctrl{5}      : ExAllControlPtr): BOOLEAN;
PROCEDURE ReadLink      *{dos,-438}(port{1}      : ProcessId;
                                    lock{2}      : FileLockPtr;
                                    path{3}      : ARRAY OF CHAR;
                                    buffer{4}    : ARRAY OF CHAR;
                                    size{5}      : LONGINT): LONGINT;
PROCEDURE MakeLink      *{dos,-444}(name{1}      : ARRAY OF CHAR;
                                    dest{2}      : LONGINT;
                                    soft{3}      : LONGINT): LONGINT;
PROCEDURE ChangeMode    *{dos,-450}(type{1}      : LONGINT; (* must be changeFH *)
                                    fh{2}        : FileHandlePtr;
                                    newmode{3}   : LONGINT): BOOLEAN;
PROCEDURE ChangeModeLock*{dos,-450}(type{1}      : LONGINT; (* must be changeLock *)
                                    lock{2}      : FileLockPtr;
                                    newmode{3}   : LONGINT): BOOLEAN;
PROCEDURE SetFileSize   *{dos,-456}(fh{1}        : FileHandlePtr;
                                    pos{2}       : LONGINT;
                                    mode{3}      : LONGINT): LONGINT;
(*      Error Handling *)
PROCEDURE SetIoErr      *{dos,-462}(result{1}    : LONGINT): LONGINT;
PROCEDURE Fault         *{dos,-468}(code{1}      : LONGINT;
                                    header{2}    : ARRAY OF CHAR;
                                    VAR buffer{3}: ARRAY OF CHAR;
                                    len{4}       : LONGINT): LONGINT;
PROCEDURE PrintFault    *{dos,-474}(code{1}      : LONGINT;
                                    header{2}    : ARRAY OF CHAR): BOOLEAN;
PROCEDURE ErrorReport   *{dos,-480}(code{1}      : LONGINT;
                                    type{2}      : LONGINT;   (* should be reportVolume *)
                                    arg1{3}      : DeviceListAPtr;
                                    device{4}    : ProcessId): LONGINT;
PROCEDURE ErrorReportLock*{dos,-480}(code{1}      : LONGINT;
                                    type{2}      : LONGINT;   (* should be reportLock *)
                                    arg1{3}      : FileLockPtr;
                                    device{4}    : ProcessId): LONGINT;
PROCEDURE ErrorReportFH *{dos,-480}(code{1}      : LONGINT;
                                    type{2}      : LONGINT;   (* should be reportStream *)
                                    arg1{3}      : FileHandlePtr;
                                    device{4}    : ProcessId): LONGINT;
PROCEDURE Requester     *{dos,-486}(s1{1}        : ARRAY OF CHAR;
                                    s2{2}        : ARRAY OF CHAR;
                                    s3{3}        : ARRAY OF CHAR;
                                    flags{4}     : LONGSET): LONGINT;
(*      Process Management *)
PROCEDURE Cli           *{dos,-492}(): CommandLineInterfaceAPtr;
PROCEDURE CreateNewProc *{dos,-498}(tags{1}      : ARRAY OF u.TagItem): ProcessPtr;
PROCEDURE CreateNewProcTags*{dos,-498}(tag1{1}.. : u.Tag): ProcessPtr;
PROCEDURE RunCommand    *{dos,-504}(seg{1}       : e.BPTR;
                                    stack{2}     : LONGINT;
                                    paramptr{3}  : ARRAY OF CHAR;
                                    paramlen{4}  : LONGINT): LONGINT;
PROCEDURE GetConsoleTask*{dos,-510}(): ProcessId ;
PROCEDURE SetConsoleTask*{dos,-516}(task{1}      : ProcessId): ProcessId;
PROCEDURE GetFileSysTask*{dos,-522}(): ProcessId;
PROCEDURE SetFileSysTask*{dos,-528}(task{1}      : ProcessId): ProcessId;
PROCEDURE GetArgStr     *{dos,-534}(): e.LSTRPTR;
PROCEDURE SetArgStr     *{dos,-540}(string{1}    : ARRAY OF CHAR): e.LSTRPTR;
PROCEDURE FindCliProc   *{dos,-546}(num{1}       : LONGINT): ProcessPtr;
PROCEDURE MaxCli        *{dos,-552}(): LONGINT;
PROCEDURE SetCurrentDirName*{dos,-558}(name{1}   : ARRAY OF CHAR): BOOLEAN;
PROCEDURE GetCurrentDirName*{dos,-564}(VAR buf{1}: ARRAY OF CHAR;
                                       len{2}    : LONGINT): BOOLEAN;
PROCEDURE SetProgramName*{dos,-570}(name{1}      : ARRAY OF CHAR): BOOLEAN;
PROCEDURE GetProgramName*{dos,-576}(VAR buf{1}   : ARRAY OF CHAR;
                                    len{2}       : LONGINT): BOOLEAN;
PROCEDURE SetPrompt     *{dos,-582}(name{1}      : ARRAY OF CHAR): BOOLEAN;
PROCEDURE GetPrompt     *{dos,-588}(VAR buf{1}   : ARRAY OF CHAR;
                                    len{2}       : LONGINT): BOOLEAN;
PROCEDURE SetProgramDir *{dos,-594}(lock{1}      : FileLockPtr): FileLockPtr;
PROCEDURE GetProgramDir *{dos,-600}(): FileLockPtr;
(*      Device List Management *)
PROCEDURE System        *{dos,-606}(command{1}   : ARRAY OF CHAR;
                                    tags{2}      : ARRAY OF u.TagItem): LONGINT;
PROCEDURE SystemTags    *{dos,-606}(command{1}   : ARRAY OF CHAR;
                                    tag1{2}..    : u.Tag): LONGINT;
PROCEDURE AssignLock    *{dos,-612}(name{1}      : ARRAY OF CHAR;
                                    lock{2}      : FileLockPtr): BOOLEAN;
PROCEDURE AssignLate    *{dos,-618}(name{1}      : ARRAY OF CHAR;
                                    path{2}      : ARRAY OF CHAR): BOOLEAN;
PROCEDURE AssignPath    *{dos,-624}(name{1}      : ARRAY OF CHAR;
                                    path{2}      : ARRAY OF CHAR): BOOLEAN;
PROCEDURE AssignAdd     *{dos,-630}(name{1}      : ARRAY OF CHAR;
                                    lock{2}      : FileLockPtr): BOOLEAN;
PROCEDURE RemAssignList *{dos,-636}(name{1}      : ARRAY OF CHAR;
                                    lock{2}      : FileLockPtr): LONGINT;
PROCEDURE GetDeviceProc *{dos,-642}(name{1}      : ARRAY OF CHAR;
                                    dp{2}        : DevProcPtr): DevProcPtr;
PROCEDURE FreeDeviceProc*{dos,-648}(dp{1}        : DevProcPtr);
PROCEDURE LockDosList   *{dos,-654}(flags{1}     : LONGSET): DosListNodePtr;
PROCEDURE UnLockDosList *{dos,-660}(flags{1}     : LONGSET);
PROCEDURE AttemptLockDosList*{dos,-666}(flags{1} : LONGSET): DosListNodePtr;
PROCEDURE RemDosEntry   *{dos,-672}(dlist{1}     : DosListNodePtr): BOOLEAN;
PROCEDURE AddDosEntry   *{dos,-678}(dlist{1}     : DosListNodePtr): DosListNodePtr;
PROCEDURE FindDosEntry  *{dos,-684}(dlist{1}     : DosListNodePtr;
                                    name{2}      : ARRAY OF CHAR;
                                    flags{3}     : LONGSET): DosListNodePtr;
PROCEDURE NextDosEntry  *{dos,-690}(dlist{1}     : DosListNodePtr;
                                    flags{2}     : LONGSET): DosListNodePtr;
PROCEDURE MakeDosEntry  *{dos,-696}(name{1}      : ARRAY OF CHAR;
                                    type{2}      : LONGINT): DosListNodePtr;
PROCEDURE FreeDosEntry  *{dos,-702}(dlist{1}     : DosListNodePtr);
PROCEDURE IsFileSystem  *{dos,-708}(name{1}      : ARRAY OF CHAR): BOOLEAN;
(*      Handler Interface *)
PROCEDURE Format        *{dos,-714}(filesystem{1}: ARRAY OF CHAR;
                                    volumename{2}: ARRAY OF CHAR;
                                    dostype{3}   : LONGINT): BOOLEAN;
PROCEDURE Relabel       *{dos,-720}(drive{1}     : ARRAY OF CHAR;
                                    newname{2}   : ARRAY OF CHAR): BOOLEAN;
PROCEDURE Inhibit       *{dos,-726}(name{1}      : ARRAY OF CHAR;
                                    onoff{2}     : LONGINT): BOOLEAN;
PROCEDURE AddBuffers    *{dos,-732}(name{1}      : ARRAY OF CHAR;
                                    number{2}    : LONGINT): LONGINT;
(*      Date, Time Routines *)
PROCEDURE CompareDates  *{dos,-738}(date1{1}     : Date;
                                    date2{2}     : Date): LONGINT;
PROCEDURE DateToStr     *{dos,-744}(VAR dt{1}    : DateTime): BOOLEAN;
PROCEDURE StrToDate     *{dos,-750}(VAR dt{1}    : DateTime): BOOLEAN;
(*      Image Management *)
PROCEDURE InternalLoadSeg*{dos,-756}(fh{1}       : FileHandlePtr;
                                    table{2}     : e.BPTR;
                                    funcarray{9} : e.APTR;
                                    VAR stack{10}: LONGINT): e.BPTR;
PROCEDURE InternalUnLoadSeg*{dos,-762}(seglist{1}: e.BPTR;
                                    freefunc{9}  : e.PROC): BOOLEAN;
PROCEDURE NewLoadSeg    *{dos,-768}(file{1}      : ARRAY OF CHAR;
                                    tags{2}      : ARRAY OF u.TagItem): e.BPTR;
PROCEDURE NewLoadSegTags*{dos,-768}(file{1}      : ARRAY OF CHAR;
                                    tags{2}..    : u.Tag): e.BPTR;
PROCEDURE AddSegment    *{dos,-774}(name{1}      : ARRAY OF CHAR;
                                    seg{2}       : e.BPTR;
                                    system{3}    : LONGINT): BOOLEAN;
PROCEDURE FindSegment   *{dos,-780}(name{1}      : ARRAY OF CHAR;
                                    seg{2}       : SegmentPtr;
                                    system{3}    : LONGINT): SegmentPtr;
PROCEDURE RemSegment    *{dos,-786}(seg{1}       : SegmentPtr): BOOLEAN;
(*      Command Support *)
PROCEDURE CheckSignal   *{dos,-792}(mask{1}      : LONGSET): LONGSET;
PROCEDURE OldReadArgs   *{dos,-798}(template{1}  : ARRAY OF CHAR;
                                    VAR array{2} : ARRAY OF y.BYTE;
                                    args{3}      : RDArgsPtr): RDArgsPtr;
PROCEDURE ReadArgs      *{dos,-798}(template{1}  : ARRAY OF CHAR;
                                    VAR array{2} : ArgsStruct;
                                    args{3}      : RDArgsPtr): RDArgsPtr;
PROCEDURE FindArg       *{dos,-804}(template{1}  : ARRAY OF CHAR;
                                    keyword{2}   : ARRAY OF CHAR): LONGINT;
PROCEDURE ReadItem      *{dos,-810}(VAR name{1}  : ARRAY OF CHAR;
                                    maxchars{2}  : LONGINT;
                                    cSrc{3}      : CSourcePtr): LONGINT;
PROCEDURE StrToLong     *{dos,-816}(string{1}    : ARRAY OF CHAR;
                                    VAR value{2} : LONGINT): LONGINT;
PROCEDURE MatchFirst    *{dos,-822}(pat{1}       : ARRAY OF CHAR;
                                    VAR anchor{2}: AnchorPath): LONGINT;
PROCEDURE MatchNext     *{dos,-828}(VAR anchor{1}: AnchorPath): LONGINT;
PROCEDURE MatchEnd      *{dos,-834}(VAR anchor{1}: AnchorPath);
PROCEDURE ParsePattern  *{dos,-840}(pat{1}       : ARRAY OF CHAR;
                                    VAR buf{2}   : ARRAY OF CHAR;
                                    buflen{3}    : LONGINT): INTEGER;
PROCEDURE MatchPattern  *{dos,-846}(pat{1}       : ARRAY OF CHAR;
                                    str{2}       : ARRAY OF CHAR): BOOLEAN;
PROCEDURE FreeArgs      *{dos,-858}(args{1}      : RDArgsPtr);
PROCEDURE FilePart      *{dos,-870}(path{1}      : ARRAY OF CHAR): e.LSTRPTR;
PROCEDURE PathPart      *{dos,-876}(path{1}      : ARRAY OF CHAR): e.APTR;
PROCEDURE AddPart       *{dos,-882}(VAR dir{1}   : ARRAY OF CHAR;
                                    filename{2}  : ARRAY OF CHAR;
                                    size{3}      : LONGINT): BOOLEAN;
(*      Notification *)
PROCEDURE StartNotify   *{dos,-888}(VAR notify{1}: NotifyRequest): BOOLEAN;
PROCEDURE EndNotify     *{dos,-894}(VAR nofify{1}: NotifyRequest);
(*      Environment Variable functions *)
PROCEDURE SetVar        *{dos,-900}(name{1}      : ARRAY OF CHAR;
                                    buffer{2}    : ARRAY OF CHAR;
                                    size{3}      : LONGINT;
                                    flags{4}     : LONGSET): BOOLEAN;
PROCEDURE GetVar        *{dos,-906}(name{1}      : ARRAY OF CHAR;
                                    VAR buffer{2}: ARRAY OF CHAR;
                                    size{3}      : LONGINT;
                                    flags{4}     : LONGSET): LONGINT;
PROCEDURE DeleteVar     *{dos,-912}(name{1}      : ARRAY OF CHAR;
                                    flags{2}     : LONGSET): BOOLEAN;
PROCEDURE FindVar       *{dos,-918}(name{1}      : ARRAY OF CHAR;
                                    type{2}      : LONGSET): LocalVarPtr;
PROCEDURE CliInit       *{dos,-924}(VAR dp{8}    : DosPacket): LONGINT;
PROCEDURE CliInitNewcli *{dos,-930}(VAR dp{8}    : DosPacket): LONGINT;
PROCEDURE CliInitRun    *{dos,-936}(VAR dp{8}    : DosPacket): LONGINT;
PROCEDURE WriteChars    *{dos,-942}(buf{1}       : ARRAY OF CHAR;
                                    buflen{2}    : LONGINT): LONGINT;
PROCEDURE PutStr        *{dos,-948}(str{1}       : ARRAY OF CHAR): LONGINT;
PROCEDURE VPrintf       *{dos,-954}(format{1}    : ARRAY OF CHAR;
                                    argarray{2}  : ARRAY OF y.BYTE): LONGINT;
PROCEDURE Printf        *{dos,-954}(format{1}    : ARRAY OF CHAR;
                                    arg1{2}..    : e.APTR): LONGINT;
PROCEDURE PrintF        *{dos,-954}(format{1}    : ARRAY OF CHAR;
                                    arg1{2}..    : e.APTR); (* result is ignored *)
(* these were unimplemented until dos 36.147 *)
PROCEDURE ParsePatternNoCase*{dos,-966}(pat{1}   : ARRAY OF CHAR;
                                    VAR buf{2}   : ARRAY OF CHAR;
                                    len{3}       : LONGINT): INTEGER;
PROCEDURE MatchPatternNoCase*{dos,-972}(pat{1}   : ARRAY OF CHAR;
                                    str{2}       : ARRAY OF CHAR): BOOLEAN;
(* this was added for V37 dos, returned 0 before then. *)
PROCEDURE SameDevice    *{dos,-984}(lock1{1}     : FileLockPtr;
                                    lock2{2}     : FileLockPtr): BOOLEAN;

(* NOTE: the following entries did NOT exist before ks 36.303 (2.02) *)
(* If you are going to use them, open dos.library with version 37 *)

(* These calls were added for V39 dos: *)
PROCEDURE ExAllEnd      *{dos,-3DEH}(lock{1}     : FileLockPtr;
                                    buffer{2}    : ARRAY OF y.BYTE;
                                    size{3}      : LONGINT;
                                    data{4}      : LONGINT;
                                    ctrl{5}      : ExAllControlPtr);
PROCEDURE SetOwner      *{dos,-3E4H}(name{1}     : ARRAY OF CHAR;
                                     ownerInfo{2}: OwnerInfo): BOOLEAN;


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

PROCEDURE ReadChar*(): CHAR;
VAR c: LONGINT;
BEGIN
  c := FGetC(Input()); IF (c<0) OR (c>255) THEN c := 0 END; RETURN CHR(c);
END ReadChar;


PROCEDURE WriteChar*(c{2}: CHAR): LONGINT;
BEGIN RETURN FPutC(Output(),ORD(c)) END WriteChar;


PROCEDURE UnReadChar*(c{2}: CHAR): LONGINT;
BEGIN RETURN UnGetC(Input(),ORD(c)); END UnReadChar;

(* next one is inefficient *)

PROCEDURE ReadChars*(VAR buf: ARRAY OF y.BYTE; num: LONGINT): LONGINT;
BEGIN RETURN FRead(Input(),buf,1,num); END ReadChars;

PROCEDURE ReadLn*(VAR buf: ARRAY OF CHAR; len: LONGINT): e.APTR;
BEGIN RETURN FGets(Input(),buf,len); END ReadLn;

PROCEDURE WriteStr*(s: ARRAY OF CHAR): BOOLEAN; (* $CopyArrays- *)
BEGIN RETURN FPuts(Output(),s); END WriteStr;

PROCEDURE VWritef*(format: ARRAY OF CHAR; argv: ARRAY OF y.BYTE): LONGINT;
(* $CopyArrays- *)
BEGIN RETURN VFWritef(Output(),format,argv); END VWritef;

(*
 * The following procedures are implemented for to avoid using SYSTEM within
 * Oberon programs.
 *)

(*
 * Use this to convert a ProcessId (eg. WBStartup.process) to a ProcessPtr.
 *)
PROCEDURE ProcessIdToProcess*(id{8}: ProcessId): ProcessPtr;
BEGIN RETURN y.VAL(ProcessPtr,y.VAL(LONGINT,id)-SIZE(e.Task)); END ProcessIdToProcess;

(*
 * Use this to get a Process' ProcessId, ie. a pointer to its MsgPort.
 *)
PROCEDURE ProcessToProcessId*(proc{8}: ProcessPtr): ProcessId;
BEGIN RETURN y.ADR(proc.msgPort); END ProcessToProcessId;

BEGIN
  dos :=  e.OpenLibrary(dosName,33);
  IF dos = NIL THEN HALT(fail) END;
  base := dos;

CLOSE
  IF dos#NIL THEN e.CloseLibrary(dos) END;

END Dos.

