(*(*
**      $VER: SysInfo.h 2.00 (20.10.96)
**      SysInfo Release 2.00
**
**      SysInfo.library definitions
**
**      This file is public domain.
**
**      Author: Petri Nordlund <petrin@megabaud.fi>
**
**      $Id: SysInfo.h 1.5 1996/10/01 23:03:07 petrin Exp petrin $
**
**      Oberon-Interface by Thomas Igracki (T.Igracki@Jana.berlinet.de)
**
**      20.10.96: Updated for v2
**
**      Oberon-A 1.6 Interface by Morten Bjergstrøm (mbjergstroem@hotmail.com)
**
**      15.4.98
*)*)

<*STANDARD-*>
MODULE [2] SysInfo;
(* $StackChk- $RangeChk- $CaseChk- $OvflChk- $ReturnChk- $TypeChk- $NilChk- *)
IMPORT
   y:=SYSTEM, e:=Exec, I:=Intuition, Sets, Kernel;

CONST
  name  * = "SysInfo.library"; minversion * = 1; version * = 2;

TYPE
  SysInfoPtr          * = POINTER [2] TO SysInfo;
  LoadAveragePtr      * = POINTER [2] TO LoadAverage;
  NotifyPtr           * = POINTER [2] TO Notify;
  CpuUsagePtr         * = POINTER [2] TO CpuUsage;
  TaskCpuUsagePtr     * = POINTER [2] TO TaskCpuUsage;

(*
 * This structure is returned by InitSysInfo() and it's READ-ONLY.
 *
 * NOTE!! This structure will grow in the future, so don't make any assumptions
 * about it's length.
 *
 *)

  SysInfo = RECORD 
(* general *)
     errNo -: LONGINT;        (* LONG: Used to hold error values   *)
                              (*       from some functions         *)
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
     whichImplemented -: SET;     (* UWORD: Search methods for Get/SetNice   *)
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
     reserved : ARRAY 8 OF LONGINT;  (* Reserved for future use *)
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

TYPE
(* GetLoadAverage *)
  LoadAverageFixed * = RECORD 
     load1 -: LONGINT; (* ULONG: *)
     load2 -: LONGINT; (* ULONG: *)
     load3 -: LONGINT; (* ULONG: *)
  END;

(* This is needed when calling GetLoadAverage() *)
  LoadAverage * = RECORD
     fixed - : LoadAverageFixed;
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
  Notify * = RECORD 
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
  CpuUsage * = RECORD 
     totalUsedCpuTime      -: LONGINT; (* ULONG: Total used cputime in seconds      *)
     totalElapsedTime      -: LONGINT; (* ULONG: Total used+idle cputime in seconds *)

     usedCpuTimeLastsec    -: LONGINT; (* ULONG: Used cputime during last second   *)
     usedCpuTimeLastsecHz  -: LONGINT; (* ULONG: 100 * lastsec / lastsecHz = CPU % *)

     recentUsedCpuTime     -: LONGINT; (* ULONG: Recently used cputime             *)
     recentUsedCpuTimeHz   -: LONGINT; (* ULONG: 100 * recent / hz = RECENT CPU %  *)
     recentSeconds         -: INTEGER; (* UWORD: "recent" means this many seconds  *)

     involuntaryCSw        -: LONGINT; (* ULONG: Involuntary context switches *)
     voluntaryCSw          -: LONGINT; (* ULONG: Voluntary context switches   *)
     totalCSw              -: LONGINT; (* ULONG: Total # of context switches  *)

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
  TaskCpuUsage * = RECORD 
     totalUsedCpuTime      -: LONGINT; (* ULONG: Total used cputime                 *)
     totalUsedTimeHz       -: LONGINT; (* ULONG: usedCputime / hz = cputime in secs *)
     totalElapsedTime      -: LONGINT; (* ULONG: Total used+idle cputime in seconds *)

     usedCpuTimeLastsec    -: LONGINT; (* ULONG: Used cputime during last second    *)
     usedCpuTimeLastsecHz  -: LONGINT; (* ULONG: 100 * lastsec / lastsec_hz = CPU % *)

     recentUsedCpuTime     -: LONGINT; (* ULONG: Recently used cputime             *)
     recentUsedCpuTimeHz   -: LONGINT; (* ULONG: 100 * recent / hz = RECENT CPU %  *)
     recentSeconds         -: INTEGER; (* UWORD: "recent" means this many seconds  *)

     involuntaryCSw        -: LONGINT; (* ULONG: Involuntary context switches *)
     voluntaryCSw          -: LONGINT; (* ULONG: Voluntary context switches   *)
     totalCSw              -: LONGINT; (* ULONG: Total # of context switches  *)

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
  base - : e.LibraryPtr;

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
                                         which{0}: Sets.SET32;
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

PROCEDURE* [0] CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)
  IF base # NIL THEN e.CloseLibrary (base) END
END CloseLib;

BEGIN

  base := e.OpenLibrary (name, minversion);
  IF base # NIL THEN Kernel.SetCleanup (CloseLib) END;

END SysInfo.
