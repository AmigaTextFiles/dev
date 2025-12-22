(*
 *--------------------------------------------------------------
 *
 * cybergraphx/cgxmpeg.h
 *
 *      main include file for cgxmpeg.library 41.7
 *
 *      (c) 1997 by phase5 digital products
 *
 *--------------------------------------------------------------
 *
 * AmigaOberon-Interface by Thomas Igracki (T.Igracki@Jana.berlinet.de)
 * 
 * 19.04.97: Changed UBYTE* from "e.STRPTR" to "UNTRACED POINTER TO y.BYTE"
 *
 *--------------------------------------------------------------
 *)

MODULE cgxmpeg;
(* $StackChk- $RangeChk- $CaseChk- $OvflChk- $ReturnChk- $TypeChk- $NilChk- *)
IMPORT
  y: SYSTEM, e: Exec, u: Utility;

CONST
  name * = "cgxmpeg.library"; minversion * = 41;

  HANDLER         * = u.user + 0x02306000;

(*
 * I/O Handler Tags
 *)
  ioHandlerType         * = HANDLER + 0; (* see ioType* *)
  ioHandlerOpen         * = HANDLER + 1; (* Open function of I/O handler *)
  ioHandlerClose        * = HANDLER + 2; (* Close function of I/O handler *)
  ioHandlerPerform      * = HANDLER + 3; (* Perform function of I/O handler *)
  ioHandlerExtra        * = HANDLER + 4; (* Extra function (eg. Seek, Resize, Mute) *)

(*
 * CreateMPGHandle Tags
 *)
  CREATE                 * = HANDLER + 0x00001000; (* C: CGXMPEG_CREATE *)
  createRandom           * = CREATE + 0; (* Random stream access possible (boolean) *)
  createPrescan          * = CREATE + 1; (* Prescan stream and create index file (boolean) *)
  createVideoAccess      * = CREATE + 2; (* Open for video access (boolean) *)
  createAudioAccess      * = CREATE + 3; (* Open for audio access (boolean) *)
  createIgnoreErrors     * = CREATE + 4; (* Ignore errors in MPEG stream (boolean) *)
  createFrameRate        * = CREATE + 5; (* Frame rate in fps
                                          *  0 = as defined in stream
                                          * -1 = as fast as possible *)
  createLoop             * = CREATE + 6; (* Loop flag (boolean) *)
  createNoB              * = CREATE + 7; (* Show no B pictures (boolean) *)
  createNoP              * = CREATE + 8; (* Show no P pictures (boolean) *)

(*
 * I/O Handler Type
 *)
  IOTYPE                 * = 00003000H;
  ioTypeInput            * = IOTYPE + 0; (* Input eg. File, RAM *)
  ioTypeVideo            * = IOTYPE + 1; (* Video output *)
  ioTypeAudio            * = IOTYPE + 2; (* Audio output *)
  ioTypeIdct             * = IOTYPE + 3; (* IDCT input/output *)

(*
 * Action Types
 *)
  ACTION                 * = IOTYPE +  0x00001000;
  actionPlay             * = ACTION +  0; (* Play *)
  actionPause            * = ACTION +  1; (* Pause *)
  actionFFWD             * = ACTION +  2; (* Fast Forward *)
  actionREW              * = ACTION +  3; (* Rewind *)
  actionSlowFWD          * = ACTION +  4; (* Slow motion forward *)
  actionSlowREW          * = ACTION +  5; (* Slow motion rewind *)
  actionRefresh          * = ACTION + 20; (* Refresh display (causes PerformVideo call) *)
  actionNewSize          * = ACTION + 21; (* New display size (causes ExtraVideo call) *)
  actionEject            * = ACTION + 99; (* Eject *)
  actionQuit             * = actionEject; (* Quit = Eject *)

(*
 * State Types
 *)
  STATE                  * = IOTYPE + 0x00002000;
  statePlay              * = STATE +  0; (* Playing *)
  statePaus              * = STATE +  1; (* Pausing *)
  stateUndefined         * = STATE + 40; (* Undefined *)
  stateEject             * = STATE + 99; (* Ejecting *)
  stateQuit              * = stateEject; (* Quit = Eject *)

(*
 * Error Codes
 *)
  ERROR                  * = D0570000H;
  errOK                  * = 0; (* Everything okay *)

  errEOF                 * = ERROR + 1; (* End of file *)
  errOPEN                * = ERROR + 2; (* Error while opening file *)
  errNOMPEG              * = ERROR + 3; (* Not an MPEG file *)

  VIDEOERROR             * = ERROR + 0x00001000;
  errVIDMEM              * = VIDEOERROR + 0; (* No memory for video *)
  errVIDOPEN             * = VIDEOERROR + 1; (* Could not open video display *)
  errVIDPERFORM          * = VIDEOERROR + 2; (* Could not perform video display *)

  AUDIOERROR             * = ERROR + 0x00002000;
  errAUDMEM              * = VIDEOERROR + 0; (* No memory for audio *)

TYPE
(*
 * MPGTimeStamp
 *)
  TimeStamp * = STRUCT 
     hours    *: LONGINT; (* ULONG: Hours [0-23] *)
     minutes  *: LONGINT; (* ULONG: Minutes [0-59] *)
     seconds  *: LONGINT; (* ULONG: Seconds [0-59] *)
     pictures *: LONGINT; (* ULONG: Pictures [0-59] *)
  END;

(*
 * MPGVideoFrame
 *)
  VideoFrame * = STRUCT 
     width  *: LONGINT;   (* ULONG: Frame width *)
     height *: LONGINT;   (* ULONG: Frame height *)
     yData  *: UNTRACED POINTER TO y.BYTE; (* UBYTE*: Y data *)
     uData  *: UNTRACED POINTER TO y.BYTE; (* UBYTE*: U data *)
     vData  *: UNTRACED POINTER TO y.BYTE; (* UBYTE*: V data *)
     number *: LONGINT;   (* ULONG: Current frame number *)
     time   *: TimeStamp; (* struct TimeStamp: Timestamp *)
  END;

(*
 * MPGAudioFrame
 *)
  AudioFrame * = STRUCT 
     frequency *: LONGINT;                     (* ULONG: Frequency in Hertz (Hz) *)
     size      *: LONGINT;                     (* ULONG: Frame size in bytes *)
     data      *: UNTRACED POINTER TO INTEGER; (* UWORD*: 16bit audio data *)
     time      *: TimeStamp;                   (* struct TimeStamp: Timestamp *)
  END;

  IOHandlerPtr * = UNTRACED POINTER TO e.APTR; (* don't know where this struct is defined;-( [tig] *)
  MPGHandlePtr * = UNTRACED POINTER TO e.APTR; (* don't know where this struct is defined;-( [tig] *)

VAR
  base -: e.LibraryPtr;

PROCEDURE AddIOHandlerTags        * {base, -30} (MPGHandle{8}: MPGHandlePtr; Tags{9}..: u.Tag             ): IOHandlerPtr;
PROCEDURE AddIOHandlerTagsList    * {base, -30} (MPGHandle{8}: MPGHandlePtr; Tags{9}  : ARRAY OF u.TagItem): IOHandlerPtr;

PROCEDURE RemoveIOHandler         * {base, -36} (MPGIOHandler{8}: IOHandlerPtr);

PROCEDURE CreateMPGHandleTags     * {base, -42} (Tags{8}..: u.Tag             ): MPGHandlePtr;
PROCEDURE CreateMPGHandleTagsList * {base, -42} (Tags{8}  : ARRAY OF u.TagItem): MPGHandlePtr;

PROCEDURE DeleteMPGHandle         * {base, -48} (MPGHandle{8}: MPGHandlePtr);

PROCEDURE DecodeFrame             * {base, -54} (MPGHandle{8}: MPGHandlePtr): LONGINT;

PROCEDURE Interact                * {base, -60} (MPGHandle{8}: MPGHandlePtr; action{0}: LONGINT): LONGINT;

PROCEDURE GetState                * {base, -66} (MPGHandle{8}: MPGHandlePtr): LONGINT;

BEGIN
     base := e.OpenLibrary (name, minversion);
(*
     IF base = NIL THEN
        IF I.DisplayAlert (I.recoveryAlert, "\x00\x64\x14missing cgxmpeg.library\o\o", 50) THEN END;
        HALT (20)
     END; (* IF *)
*)
CLOSE
     IF base # NIL THEN e.CloseLibrary (base); base := NIL END (* IF *)
END cgxmpeg.
