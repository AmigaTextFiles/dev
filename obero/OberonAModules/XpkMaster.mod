(*************************************************************************

:Program.    XpkMaster.mod
:Contents.   Interface-Module for xpkmaster.library
:Author.     Hartmut Goebel [hG]
:Copyright.  Copyright © 1991 by Hartmut Goebel
:Copyright.  May be free dirstibuted with the Xpk-Package
:Copyright.  permission is given to be inlcuded with AmigaOberon
:Language.   Oberon
:Translator. Amiga Oberon V2.14
:History.    V0.9, 08 Jan 1992 Hartmut Goebel [hG]
:History.    V1.0, 04 Jun 1992 [hG]
:History.    V1.1, 06 Jul 1992 [hG] remove "Xpk" from procname, because
:History.          in Oberon you U must import qualified, so this is useless
:History.    V1.1b 27 Jul 1992 [hG] XpkMasterNA build in
:History.    V2.0  04 Aug 1992 [hG] adapted to Xpk 2.0
:Date.       04 Aug 1992 01:25:20

:Remark.     compile with "set NoAssert" to generate XpkMasterNA, which
:Remark.     does not asure the lib is opened successfull (you must check
:Remark.     this by yourself then!)


Changed by Morten Bjergstrøm to work with Oberon-A (It didn't before)
Now your program won't quit if xpkmaster.library isn't available therefore
you have to check xpk.base before you use any xpk functions!
EMail: mbjergstroem@hotmail.com
*************************************************************************)


<*STANDARD-*>
MODULE [2] XpkMaster;


IMPORT
  e := Exec,
  I := Intuition,
  s := SYSTEM,
  u := Utility,
  Kernel;

CONST

  XpkName = "xpkmaster.library";

(*****************************************************************************
 *
 *
 *      The packing/unpacking tags
 *
 *)

(* Tags we support *)
  tagBase       * = u.user + ORD("X")*256 + ORD("P");

(* Caller must supply ONE of these to tell Xpk#?ackFile where to get data from *)
  inName        * = tagBase+01H; (* Process an entire named file *)
  inFH          * = tagBase+02H; (* File handle - start from current position *)
                                 (* If packing partial file, must also supply InLen *)
  inBuf         * = tagBase+03H; (* Single unblocked memory buffer *)
                                 (* Must also supply InLen *)
  inHook        * = tagBase+04H; (* Call custom Hook to read data *)
                                 (* If packing, must also supply InLen *)
                                 (* If unpacking, InLen required only for PPDecrunch *)

(* Caller must supply ONE of these to tell Xpk#?ackFile where to send data to *)
  outName       * = tagBase+10H; (* Write (or overwrite) this data file *)
  outFH         * = tagBase+11H; (* File handle - write from current position on *)
  outBuf        * = tagBase+12H; (* Unblocked buffer - must also supply OutBufLen *)
  getOutBuf     * = tagBase+13H; (* Master allocates OutBuf - ti_Data points to buf ptr *)
  outHook       * = tagBase+14H; (* Callback Hook to get output buffers *)

(* Other tags for Pack/Unpack *)
  inLen         * = tagBase+20H; (* Length of data in input buffer *)
  outBufLen     * = tagBase+21H; (* Length of output buffer *)
  getOutLen     * = tagBase+22H; (* ti_Data points to long to receive OutLen *)
  getOutBufLen  * = tagBase+23H; (* ti_Data points to long to receive OutBufLen *)
  password      * = tagBase+24H; (* Password for de/encoding *)
  getError      * = tagBase+25H; (* ti_Data points to buffer for error message *)
  outMemType    * = tagBase+26H; (* Memory type for output buffer *)
  passThru      * = tagBase+27H; (* Bool: Pass through unrecognized formats on unpack *)
  stepDown      * = tagBase+28H; (* Bool: Step down pack method if necessary *)
  chunkHook     * = tagBase+29H; (* Call this Hook between chunks *)
  packMethod    * = tagBase+2AH; (* Do a FindMethod before packing *)
  chunkSize     * = tagBase+2BH; (* Chunk size to try to pack with *)
  packMode      * = tagBase+2CH; (* Packing mode for sublib to use *)
  noClobber     * = tagBase+2DH; (* Don't overwrite existing files  *)
  ignore        * = tagBase+2EH; (* Skip this tag                   *)
  taskPri       * = tagBase+2FH; (* Change priority for (un)packing *)
  fileName      * = tagBase+30H; (* File name for progress report   *)
  shortError    * = tagBase+31H; (* Output short error messages     *)
  packersQuery  * = tagBase+32H; (* Query available packers         *)
  packerQuery   * = tagBase+33H; (* Query properties of a packer    *)
  modeQuery     * = tagBase+34H; (* Query properties of packmode    *)
  lossyOK       * = tagBase+35H; (* Lossy packing permitted? def.=no*)

  findMethod    * = packMethod;  (* Compatibility *)

  margin        * = 256;         (* Safety margin for output buffer      *)


TYPE
(*****************************************************************************
 *
 *
 *     The hook function interface
 *
 *)

(* Message passed to InHook and OutHook as the ParamPacket *)
  XpkIOMsgPtr * = POINTER TO XpkIOMsg;
  XpkIOMsg * = RECORD
    type     * : LONGINT;   (* Read/Write/Alloc/Free/Abort        *)
    ptr      * : e.APTR;    (* The mem area to read from/write to *)
    size     * : LONGINT;   (* The size of the read/write         *)
    ioError  * : LONGINT;   (* The IoErr() that occurred          *)
    reserved * : e.ADDRESS; (* Reserved for future use            *)
    private1 * : e.ADDRESS; (* Hook specific, will be set to 0 by *)
    private2 * : e.ADDRESS; (* master library before first use    *)
    private3 * : e.ADDRESS;
    private4 * : e.ADDRESS;
  END;

CONST
(* The values for XpkIoMsg.type *)
  ioRead    * = 1;
  ioWrite   * = 2;
  ioFree    * = 3;
  ioAbort   * = 4;
  ioGetBuf  * = 5;
  ioSeek    * = 6;
  ioTotSize * = 7;


(*****************************************************************************
 *
 *
 *      The progress report interface
 *
 *)

TYPE
(* Passed to ChunkHook as the ParamPacket *)
  XpkProgressPtr * = POINTER TO XpkProgress;
  XpkProgress * = RECORD
    type           * : LONGINT;  (* Type of report: start/cont/end/abort       *)
    packerName     * : e.STRPTR; (* Brief name of packer being used            *)
    packerLongName * : e.STRPTR; (* Descriptive name of packer being used      *)
    activity * : e.STRPTR;       (* Packing/unpacking message                  *)
    fileName * : e.STRPTR;       (* Name of file being processed, if available *)
    cCur  * : LONGINT;           (* Amount of packed data already processed    *)
    uCur  * : LONGINT;           (* Amount of unpacked data already processed  *)
    uLen  * : LONGINT;           (* Amount of unpacked data already processed  *)
    cf    * : LONGINT;           (* Compression factor so far                  *)
    done  * : LONGINT;           (* Percentage done already                    *)
    speed * : LONGINT;           (* Bytes per second, from beginning of stream *)
    reserved * : ARRAY 8 OF e.ADDRESS; (* For future use               *)
  END;

CONST
(* The values for XpkProgress.type *)
  progStart * = 1;
  progMid   * = 2;
  progEnd   * = 3;

(*****************************************************************************
 *
 *
 *       The file info block
 *
 *)

TYPE
  XpkFibPtr * = POINTER TO XpkFib;
  XpkFib * = RECORD
    type * : LONGINT                 ; (* Unpacked, packed, archive?   *)
    uLen * : LONGINT                 ; (* Uncompressed length          *)
    cLen * : LONGINT                 ; (* Compressed length            *)
    nLen * : LONGINT                 ; (* Next chunk len               *)
    uCur * : LONGINT                 ; (* Uncompressed bytes so far    *)
    cCur * : LONGINT                 ; (* Compressed bytes so far      *)
    id     * : ARRAY 4 OF s.BYTE       ; (* 4 letter ID of packer        *)
    packer * : ARRAY 6 OF s.BYTE       ; (* 4 letter name of packer      *)
    subVersion * : INTEGER           ; (* Required sublib version      *)
    masVersion * : INTEGER           ; (* Required masterlib version   *)
    flags * : SET                ; (* Password?                    *)
    head * : ARRAY 16 OF s.BYTE        ; (* First 16 bytes of orig. file *)
    ratio * : LONGINT                ; (* Compression ratio            *)
    reserved * : ARRAY 8 OF e.ADDRESS; (* For future use               *)
  END;

  XpkFH * = POINTER TO RECORD
    fib*: XpkFib
    (* private data follows *)
  END;

CONST
(* Defines for XpkFib.type *)
  typeUnpacked * = 0;        (* Not packed                   *)
  typePacked   * = 1;        (* Packed file                  *)
  typeArchive  * = 2;        (* Archive                      *)

(* Defines for XpkFib.flags *)
  flagsPassword * = 0;       (* Password needed              *)
  flagsNoSeek   * = 1;       (* Chunks are dependent         *)
  flagsNonStd   * = 2;       (* Nonstandard file format      *)


CONST
(*****************************************************************************
 *
 *
 *       The error messages
 *
 *)

  errOk         * =  0;
  errNoFunc     * = -1;   (* This function not implemented         *)
  errNoFiles    * = -2;   (* No files allowed for this function    *)
  errIOErrIn    * = -3;   (* Input error happened, look at Result2 *)
  errIOErrOut   * = -4;   (* Output error happened,look at Result2 *)
  errCheckSum   * = -5;   (* Check sum test failed                 *)
  errVersion    * = -6;   (* Packed file's version newer than lib  *)
  errNoMem      * = -7;   (* Out of memory                         *)
  errLibInUse   * = -8;   (* For not-reentrant libraries           *)
  errWrongForm  * = -9;   (* Was not packed with this library      *)
  errSmallBuf   * = -10;  (* Output buffer too small               *)
  errLargeBuf   * = -11;  (* Input buffer too large                *)
  errWrongMode  * = -12;  (* This packing mode not supported       *)
  errNeedPasswd * = -13;  (* Password needed for decoding          *)
  errCorruptPkd * = -14;  (* Packed file is corrupt                *)
  errMissingLib * = -15;  (* Required library is missing           *)
  errBadParams  * = -16;  (* Caller's TagList was screwed up       *)
  errExpansion  * = -17;  (* Would have caused data expansion      *)
  errNoMethod   * = -18;  (* Can't find requested method           *)
  errAborted    * = -19;  (* Operation aborted by user             *)
  errTruncated  * = -20;  (* Input file is truncated               *)
  errWrongCPU   * = -21;  (* Better CPU required for this library  *)
  errPacked     * = -22;  (* Data are already XPacked              *)
  errNotPacked  * = -23;  (* Data not packed                       *)
  errFileExists * = -24;  (* File already exists                   *)
  errOldMastLib * = -25;  (* Master library too old                *)
  errOldSubLib  * = -26;  (* Sub library too old                   *)
  errNoCrypt    * = -27;  (* Cannot encrypt                        *)
  errNoInfo     * = -28;  (* Can't get info on that packer         *)
  errLossy      * = -29;  (* This compression method is lossy      *)
  errNoHardware * = -30;  (* Compression hardware required         *)
  errBadHardware* = -31;  (* Compression hardware failed           *)
  errWrongPW    * = -32;  (* Password was wrong                    *)

  errMsgSize    * =  80;  (* Maximum size of an error message      *)

(*****************************************************************************
 *
 *
 *     The XpkQuery() call
 *
 *)

TYPE
  XpkPackerInfoPtr * = POINTER TO XpkPackerInfo;
  XpkPackerInfo * = RECORD
    name * : ARRAY 24 OF CHAR;        (* Brief name of the packer          *)
    longName * : ARRAY 32 OF CHAR;    (* Full name of the packer           *)
    description * : ARRAY 80 OF CHAR; (* One line description of packer    *)
    flags    * : SET;             (* Defined below                     *)
    maxChunk * : LONGINT;             (* Max input chunk size for packing  *)
    defChunk * : LONGINT;             (* Default packing chunk size        *)
    defMode  * : INTEGER;             (* Default mode on 0..100 scale      *)
  END;

CONST
  (* Defines for XpkPackerInfo.Flags *)
  pkChunk    * = 0;   (* Library supplies chunk packing       *)
  pkStream   * = 1;   (* Library supplies stream packing      *)
  pkArchive  * = 2;   (* Library supplies archive packing     *)
  upChunk    * = 3;   (* Library supplies chunk unpacking     *)
  upStream   * = 4;   (* Library supplies stream unpacking    *)
  upArchive  * = 5;   (* Library supplies archive unpacking   *)
  hookIO     * = 7;   (* Uses full Hook I/O                   *)
  checking   * = 10;  (* Does its own data checking           *)
  preReadHdr * = 11;  (* Unpacker pre-reads the next chunkhdr *)
  encryption * = 13;  (* Sub library supports encryption      *)
  needPasswd * = 14;  (* Sub library requires encryption      *)
  modes      * = 15;  (* Sub library has different modes      *)
  lossy      * = 16;  (* Sub library does lossy compression   *)

TYPE
  XpkModePtr * = POINTER TO XpkMode;
  XpkMode * = RECORD
    next * : XpkModePtr;      (* Chain to next descriptor for ModeDesc list*)
    upto * : LONGINT;         (* Maximum efficiency handled by this mode   *)
    flags * : SET;        (* Defined below                             *)
    packMemory   * : LONGINT; (* Extra memory required during packing      *)
    unpackMemory * : LONGINT; (* Extra memory during unpacking             *)
    packSpeed    * : LONGINT; (* Approx packing speed in K per second      *)
    unpackSpeed  * : LONGINT; (* Approx unpacking speed in K per second    *)
    ratio    * : INTEGER;     (* CF in 0.1% for AmigaVision executable     *)
    chunkSize * : INTEGER;    (* Desired chunk size in K (!!) for this mode*)
    description * : ARRAY 10 OF CHAR; (* 7 character mode description      *)
  END;

(* Defines for XpkMode.Flags *)
CONST
  mfA3000Speed * = 0;     (* Timings on A3000/25               *)
  mfPkNoCPU    * = 1;     (* Packing not heavily CPU dependent *)
  mfUpNoCPU    * = 2;     (* Unpacking... (i.e. hardware modes)*)

CONST
  maxPackers * = 100;

TYPE
  XpkPackerListPtr = POINTER TO XpkPackerList;
  XpkPackerList = RECORD
    numPackers: LONGINT;
    Packer: ARRAY maxPackers,6 OF s.BYTE;
  END;

(*****************************************************************************
 *
 *
 *     The XpkOpen() type calls
 *
 *)

CONST
  lenOneChunk * = 7FFFFFFFH;


(*****************************************************************************
 *
 *
 *      The library vectors
 *
 *)

VAR
  base - : e.LibraryPtr;

(**
 ** Remember: when compiled witch 'SET NoAssert' you must check
 ** if base#NIL before using one of the following functions
 **)

PROCEDURE Examine* [base,-36]
  (VAR fib[8]: XpkFib;
   tagList[9]: ARRAY OF u.TagItem)
  : LONGINT;
PROCEDURE Pack    * [base,-42](tagList[8]: ARRAY OF u.TagItem): LONGINT;
PROCEDURE Unpack  * [base,-48](tagList[8]: ARRAY OF u.TagItem): LONGINT;
PROCEDURE Open    * [base,-54](VAR xfh[8]: XpkFH;
                               tagList[9]: ARRAY OF u.TagItem): LONGINT;
PROCEDURE Read    * [base,-60](xfh[8]: XpkFH;
                               buf[9]: ARRAY OF s.BYTE;
                               len[0]: LONGINT): LONGINT;
PROCEDURE Write   * [base,-66](xfh[8]: XpkFH;
                               buf[9]: ARRAY OF s.BYTE;
                               ulen[0]:LONGINT): LONGINT;
PROCEDURE Seek    * [base,-72](xfh[8]: XpkFH;
                               dist[0]: LONGINT;
                               mode[1]: LONGINT): LONGINT;
PROCEDURE Close   * [base,-78](xfh[8]: XpkFH): LONGINT;
PROCEDURE Query   * [base,-84](tagList[8]: ARRAY OF u.TagItem): LONGINT;

PROCEDURE ExamineTags * [base,-36](VAR fib[8]: XpkFib; tag1[9]..: u.Tag): LONGINT;
PROCEDURE PackTags    * [base,-42](tag1[8]..: u.Tag): LONGINT;
PROCEDURE UnpackTags  * [base,-48](tag1[8]..: u.Tag): LONGINT;
PROCEDURE OpenTags    * [base,-54](VAR xfh[8]: XpkFH; tag1[9]..: u.Tag): LONGINT;
PROCEDURE QueryTags   * [base,-84](tag1[8]..: u.Tag): LONGINT;





<*$LongVars-*>

PROCEDURE* [0] CloseIt (VAR rc : LONGINT);

BEGIN (* CloseIt *)
  IF base # NIL THEN e.CloseLibrary (base) END
END CloseIt;

<*$ < OvflChk- *>
<*$ < RangeChk- *>
<*$ < StackChk- *>
<*$ < NilChk- *>
<*$ < ReturnChk- *>
<*$ < CaseChk- *>

BEGIN (*Library*)

  base := e.OpenLibrary(XpkName,1);

  IF base # NIL THEN Kernel.SetCleanup(CloseIt) END;

END XpkMaster.
