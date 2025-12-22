(*(*
**      $VER: SysInfo.h 1.30 (14.11.95)
**      SysInfo Release 1.30
**
**      SysInfo.library definitions
**
**      This file is public domain.
**
**      Author: Petri Nordlund <petrin@megabaud.fi>
**
**      $Id: SysInfo.h 1.3 1995/11/14 13:00:29 petrin Exp petrin $
**
**      Oberon-Interface by Thomas Igracki (T.Igracki@Bamp.berlinet.de)
**
*)*)

MODULE SysInfo;
IMPORT
   y: SYSTEM, e: Exec, I: Intuition;

CONST
  name  * = "SysInfo.library"; version * = 1;

TYPE
  SysInfoPtr          * = UNTRACED POINTER TO SysInfo;
  LoadAveragePtr      * = UNTRACED POINTER TO LoadAverage;
  NotifyPtr           * = UNTRACED POINTER TO Notify;
  CpuUsagePtr         * = UNTRACED POINTER TO CpuUsage;
  TaskCpuUsagePtr     * = UNTRACED POINTER TO TaskCpuUsage;

(*
 * This structure is returned by InitSysInfo() and it's READ-ONLY.
 *
 * NOTE!! This structure will grow in the future, so don't make any assumptions
 * about it's length.
 *
 *)

  SysInfo * = STRUCT 
     errNo -: LONGINT;        (* INT: Used to hold error values    *)
                              (* from some functions               *)
(* load average *)
     loadAvgType  -: INTEGER; (* UWORD: load average type, see below       *)
     loadAvgTime1 -: INTEGER; (* UWORD: Usually 1, 5 and 15 minutes.       *)
     loadAvgTime2 -: INTEGER; (* UWORD: These times are in seconds.        *)
     loadAvgTime3 -: INTEGER; (* UWORD: 0 = time not implemented           *)
     fScale       -: INTEGER; (* UWORD: scale value, if lavgtype = FIXED   *)

(* id *)
     pad1                : y.BYTE;  (* because BOOL = 2 Byte and BOOLEAN = 1 Byte! *)
     getPpidImplemented -: BOOLEAN; (* BOOL: TRUE if GetPpid is implemented  *)
     pad2                : y.BYTE;  (* because BOOL = 2 Byte and BOOLEAN = 1 Byte! *)
     getPgrpImplemented -: BOOLEAN; (* BOOL: TRUE if GetPgrp is implemented  *)

(* get/setnice *)
     whichImplemented -: SET; (* UWORD: Search methods for Get/SetNice   *)
     niceMin          -: INTEGER; (* WORD: Nice-value giving most cpu time   *)
     niceMax          -: INTEGER; (* WORD: Nice-value giving least cpu time  *)

(* notify *)
     pad3                  : y.BYTE;  (* because BOOL = 2 Byte and BOOLEAN = 1 Byte! *)
     notifySigImplemented -: BOOLEAN; (* BOOL: Notify by signal implemented   *)
     pad4                  : y.BYTE;  (* because BOOL = 2 Byte and BOOLEAN = 1 Byte! *)
     notifyMsgImplemented -: BOOLEAN; (* BOOL: Notify by message implemented  *)

(* cpu usage *)
     cpuUsageImplemented -: SET; (* UWORD: What cpu usage values are implemented *)

(* task cpu usage *)
     taskCpuUsageImplemented -: SET; (* UWORD: What cpu usage values are implemented *)
     reserved : ARRAY 8 OF LONGINT; (* Reserved for future use *)
  END;


(*
 * general
 *
 *)

CONST
(* errno values *)
  whichEPerm   * =  1;  (* Operation not permitted *)
  whichESrch   * =  3;  (* No such process         *)
  whichEAcces  * = 13;  (* Permission denied       *)
  whichEInval  * = 22;  (* Invalid argument        *)


(*
 * load average
 *
 *)

(* Loadaverage type *)
  loadAvgNone     * = 0;  (* load averages not implemented   *)
  loadAvgFixedPnt * = 1;  (* load * SysInfo.fscale           *)

(* GetLoadAverage *)

(* This is needed when calling GetLoadAverage() *)

TYPE
  LoadAverage * = STRUCT
     load1  -: LONGINT; (* ULONG *)
     load2  -: LONGINT; (* ULONG *)
     load3  -: LONGINT; (* ULONG *)
     reserved: ARRAY 3 OF LONGINT; (* ULONG: Reserved for future use *)
  END;

(*
 * get/setnice
 *
 *)

CONST
(* Possible search methods for Get/SetNice and are used in 'whichImplemented'-field *)
  whichPrioProcess  * = 0;
  whichPrioPgrp     * = 1;
  whichPrioUser     * = 2;
  whichPrioTask     * = 3;

(*
 * notify
 *
 *)

TYPE
(* This is needed when adding a notify-request. This may grow in future *)
  Notify * = STRUCT 
     port   -: e.MsgPortPtr;       (* struct MsgPort*: message port for notify-messages  *)
     signal -: INTEGER;            (* WORD: signal NUMBER if you use signals  *)
     reserved: ARRAY 2 OF LONGINT; (* LONG[2]: Reserved for future use *)
  END;

(* Flags for AddNotify () *)
CONST
  anUseMessages * = 0;

(*
 * cpu usage
 *
 *)
TYPE
(* This is needed when querying cpu usage *)
  CpuUsage * = STRUCT 
     totalUsedCpuTime -: LONGINT; (* ULONG: Total used cputime in seconds      *)
     totalElapsedTime -: LONGINT; (* ULONG: Total used+idle cputime in seconds *)

     usedCpuTimeLastsec   -: LONGINT; (* ULONG: Used cputime during last second   *)
     usedCpuTimeLastsecHz -: LONGINT; (* ULONG: 100 * lastsec / lastsecHz = CPU % *)

     recentUsedCpuTime   -: LONGINT; (* ULONG: Recently used cputime             *)
     recentUsedCpuTimeHz -: LONGINT; (* ULONG: 100 * recent / hz = RECENT CPU %  *)
     recentSeconds       -: INTEGER; (* UWORD: "recent" means this many seconds  *)

     involuntaryCSw -: LONGINT; (* ULONG: Involuntary context switches *)
     voluntaryCSw   -: LONGINT; (* ULONG: Voluntary context switches   *)
     totalCSw       -: LONGINT; (* ULONG: Total # of context switches  *)

     involuntaryCSwLastsec -: LONGINT; (* ULONG: Involuntary csws during last second *)
     voluntaryCSwLastsec   -: LONGINT; (* ULONG: Voluntary csws during last second   *)
     totalCSwLastsec       -: LONGINT; (* ULONG: Total # of csws during last second  *)

     reserved : ARRAY 12 OF LONGINT; (* ULONG: Reserved for future use    *)
  END;

CONST
(* These bits are used in cpuUsageImplemented-field *)
  cpuUsageTotalImplemented           * = 0;
  cpuUsageLastsecImplemented         * = 1;
  cpuUsageRecentImplemented          * = 2;
  cpuUsageIvvoCSwImplemented         * = 3;
  cpuUsageTotalCSwImplemented        * = 4;
  cpuUsageIvvoCSwLastsecImplemented  * = 5;
  cpuUsageTotalCSwLastsecImplemented * = 6;

(*
 * task cpu usage
 *
 *)

TYPE
(* This is needed when querying cpu usage of a task *)
  TaskCpuUsage * = STRUCT 
     totalUsedCpuTime -: LONGINT; (* ULONG: Total used cputime                 *)
     totalUsedTimeHz  -: LONGINT; (* ULONG: usedCputime / hz = cputime in secs *)
     totalElapsedTime -: LONGINT; (* ULONG: Total used+idle cputime in seconds *)

     usedCpuTimeLastsec   -: LONGINT; (* ULONG: Used cputime during last second    *)
     usedCpuTimeLastsecHz -: LONGINT; (* ULONG: 100 * lastsec / lastsec_hz = CPU % *)

     recentUsedCpuTime   -: LONGINT; (* ULONG: Recently used cputime             *)
     recentUsedCpuTimeHz -: LONGINT; (* ULONG: 100 * recent / hz = RECENT CPU %  *)
     recentSeconds       -: INTEGER; (* UWORD: "recent" means this many seconds  *)

     involuntaryCSw -: LONGINT; (* ULONG: Involuntary context switches *)
     voluntaryCSw   -: LONGINT; (* ULONG: Voluntary context switches   *)
     totalCSw       -: LONGINT; (* ULONG: Total # of context switches  *)

     involuntaryCSwLastsec -: LONGINT; (* ULONG: Involuntary csws during last second *)
     voluntaryCSwLastsec   -: LONGINT; (* ULONG: Voluntary csws during last second   *)
     totalCSwLastsec       -: LONGINT; (* ULONG: Total # of csws during last second  *)

     reserved : ARRAY 8 OF LONGINT; (* ULONG: Reserved for future use    *)
  END;

CONST
(* These bits are used in cpu_usage_implemented-field *)
  taskCpuUsageTotalImplemented           * = 0;
  taskCpuUsageLastsecImplemented         * = 1;
  taskCpuUsageRecentImplemented          * = 2;
  taskCpuUsageIvvoCSwImplemented         * = 3;
  taskCpuUsageTotalCSwImplemented        * = 4;
  taskCpuUsageIvvoCSwLastsecImplemented  * = 5;
  taskCpuUsageTotalCSwLastsecImplemented * = 6;

VAR
  base * : e.LibraryPtr;

(* -----init----- *)
PROCEDURE InitSysInfo     * {base, -30} (): SysInfoPtr;
PROCEDURE FreeSysInfo     * {base, -36} (si{8}: SysInfoPtr);

(* -----load average----- *)
PROCEDURE GetLoadAverage  * {base, -42} (    si{8}: SysInfoPtr;
                                         VAR la{9}: LoadAverage);

(* -----id----- *)
PROCEDURE GetPid          * {base, -48} (si{8}: SysInfoPtr): LONGINT;
PROCEDURE GetPpid         * {base, -54} (si{8}: SysInfoPtr): LONGINT;
PROCEDURE GetPgrp         * {base, -60} (si{8}: SysInfoPtr): LONGINT;

(* -----nice----- *)
PROCEDURE GetNice         * {base, -66} (si   {8}: SysInfoPtr;
                                         which{0}: LONGINT;
                                         who  {1}: LONGINT): LONGINT;
PROCEDURE SetNice         * {base, -72} (si   {8}: SysInfoPtr;
                                         which{0}: LONGSET;
                                         who  {1}: LONGINT;
                                         nice {2}: LONGINT): LONGINT;

(* -----notify----- *)
PROCEDURE AddNotify       * {base, -78} (si         {8}: SysInfoPtr;
                                         flags      {0}: SET;
                                         safetyLimit{1}: LONGINT): NotifyPtr;
PROCEDURE RemoveNotify    * {base, -84} (si    {8}: SysInfoPtr;
                                         notify{9}: NotifyPtr);

(* -----cpu usage----- *)
PROCEDURE GetCpuUsage     * {base, -90} (    si   {8}: SysInfoPtr;
                                         VAR usage{9}: CpuUsage);
PROCEDURE GetTaskCpuUsage * {base, -96} (    si   {8}: SysInfoPtr;
                                         VAR usage{9}: TaskCpuUsage;
                                             task{10}: e.TaskPtr): LONGINT;

BEGIN
     base := e.OpenLibrary (name, version);
(*
     IF base = NIL THEN
        IF I.DisplayAlert (I.recoveryAlert, "\x00\x64\x14missing SysInfo.library\o\o", 50) THEN END;
        HALT (20)
     END; (* IF *)
*)
CLOSE
     IF base # NIL THEN e.CloseLibrary (base); base := NIL END (* IF *)
END SysInfo.
