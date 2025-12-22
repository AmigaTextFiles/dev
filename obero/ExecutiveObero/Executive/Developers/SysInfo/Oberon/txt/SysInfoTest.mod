(*(*
 * Test-program for some SysInfo.library features
 *
 * This file is public domain.
 *
 * Author: Petri Nordlund <petrin@megabaud.fi>
 *
 * $Id: test.c 1.3 1995/10/12 16:31:32 petrin Exp petrin $
 *
 * Oberon-Version by Thomas Igracki (T.Igracki@Jana.berlinet.de)
 *
 * 20.10.96: - Recompiled for v2
 *           - Fixed a little bug: Doesn't printed pgrp/ppid unknown if unknown
 *)*)

MODULE SysInfoTest;
IMPORT
  y: SYSTEM, e: Exec, d: Dos, u: Utility, 
  si: SysInfo, rc: RealConversions;

TYPE
   LS = LONGSET;
VAR
   p,
   nice : LONGINT;
   
   not  : si.NotifyPtr;
   msg  : e.MessagePtr;
   i    : SHORTINT;
   info : si.SysInfoPtr;
   load : si.LoadAverage;
   cu   : si.CpuUsage;
   tcu  : si.TaskCpuUsage;
   
PROCEDURE WriteReal (r: REAL; v,n: INTEGER);
VAR str: ARRAY 50 OF CHAR;
BEGIN
     IF rc.RealToString (r, str, v,n, FALSE) THEN d.PrintF (str) END;
END WriteReal;

PROCEDURE PutS (str: ARRAY OF CHAR); (* $CopyArrays- *)
BEGIN     d.PrintF ("%s\n",y.ADR(str))
END PutS;

BEGIN
     IF si.base = NIL THEN d.PrintF ("Failed to open %s v%ld!\n",y.ADR(si.name),si.version); HALT(d.warn) END;

     (* Initialize SysInfo.library, this will make the connection to the
      * server-process and allocate the SysInfo-structure. *)
 
     info := si.InitSysInfo();
     IF info = NIL THEN PutS("Couldn't initialize SysInfo."); HALT(d.fail) END;

     (* print our pid, ppid and pgrp *)
     d.PrintF("pid:  %ld\n", si.GetPid(info));
     IF info.getPpidImplemented THEN
        p := si.GetPpid(info);
        IF (p # -1) THEN d.PrintF("ppid: %ld\n",p)
                    ELSE d.PrintF("ppid: unknown\n") END;
     END;
     IF info.getPgrpImplemented THEN
        p := si.GetPgrp(info);
        IF (p # -1) THEN d.PrintF("pgrp: %ld\n",p)
                    ELSE d.PrintF("pgrp: unknown\n") END;
     END;

     (* If info.whichImplemented is 0, then GetNice() and SetNice() are not available *)
     (* We'll also make sure that the search methods we need have been implemented    *)
     IF ({si.whichPrioTask,si.whichPrioProcess} * info.whichImplemented # {}) THEN
        (* display the nice-value for this task *)
        nice := si.GetNice (info, si.whichPrioTask, 0);
        IF (nice = -1) THEN
           IF (info.errNo # 0) THEN
              d.PrintF("GetNice() failed, errno: %ld\n",info.errNo);
           ELSE
              d.PrintF("nice: %ld\n",nice);
           END;
        ELSE
           d.PrintF("nice: %ld\n",nice);

           (* set our nice-value to +5 *)
           IF si.SetNice (info, LS{si.whichPrioProcess},si.GetPid(info),5) # 0 THEN
              d.PrintF("SetNice() failed, errno: %ld\n",info.errNo);
           END
        END;
     END;


     (* Ask for notify and output load averages every second for 10 seconds. *)

     IF (info.loadAvgType # si.loadAvgNone) THEN
        IF info.notifyMsgImplemented THEN not := si.AddNotify(info,{si.anUseMessages},10) END;
        IF not.port.sigBit < 0 THEN d.PrintF ("Notify.port.sigBit is < 0!\n") END;
        IF (not # NIL) & (not.port.sigBit >= 0) THEN
           d.PrintF("load averages (%ld.%02ld, %ld.%02ld, %ld.%02ld minutes):\n",
                    info.loadAvgTime1 DIV 60, info.loadAvgTime1 MOD 60,
                    info.loadAvgTime2 DIV 60, info.loadAvgTime2 MOD 60,
                    info.loadAvgTime3 DIV 60, info.loadAvgTime3 MOD 60);

           FOR i := 0 TO 9 DO
               (* We'll get a message every second. There may be more than
                * one message in the port at once. *)

               IF e.Wait(LONGSET{not.port.sigBit}) = LONGSET{} THEN END;
               LOOP
                  msg := e.GetMsg(not.port); IF msg = NIL THEN EXIT END;

                  e.ReplyMsg(msg);

                  si.GetLoadAverage(info, load);      (* Ask SysInfo.library for current load averages *)

                  d.PrintF("load average:");

                  IF info.loadAvgType = si.loadAvgFixedPnt THEN
                     (* Convert fixed point values to floating point values *)
                     IF info.loadAvgTime1 # 0 THEN WriteReal (load.fixed.load1 / info.fScale, 1, 2) ELSE d.PrintF(" N/A") END;
                     IF info.loadAvgTime2 # 0 THEN WriteReal (load.fixed.load2 / info.fScale, 1, 2) ELSE d.PrintF(" N/A") END;
                     IF info.loadAvgTime3 # 0 THEN WriteReal (load.fixed.load3 / info.fScale, 1, 2) ELSE d.PrintF(" N/A") END;
                     d.PrintF("\n");
                  END;
               END; (* LOOP *)
           END; (* FOR *)
           si.RemoveNotify(info,not);
        ELSE
            d.PrintF("Can't use notification.\n");
        END;
     ELSE
        d.PrintF("Load averages are not supported.\n");
     END;

     (* output cpu usage values *)

     si.GetCpuUsage(info,cu);

     d.PrintF("cpu time:                 ");
     IF (si.cpuUsageTotalImplemented IN info.cpuUsageImplemented) THEN
        d.PrintF("%ld seconds used, %ld seconds idle\n",cu.totalUsedCpuTime, cu.totalElapsedTime - cu.totalUsedCpuTime);
     ELSE
        d.PrintF("N/A\n");
     END;

     d.PrintF("cpu usage:                ");
     IF (si.cpuUsageTotalImplemented IN info.cpuUsageImplemented) THEN
        WriteReal ((cu.totalUsedCpuTime * 100) / cu.totalElapsedTime, 2,2);
        d.PrintF ("%%\n");
     ELSE
        d.PrintF("N/A\n");
     END;

     d.PrintF("current cpu usage:        ");
     IF (si.cpuUsageLastsecImplemented IN info.cpuUsageImplemented) THEN
        WriteReal ((cu.usedCpuTimeLastsec * 100) / cu.usedCpuTimeLastsecHz, 2,2);
        d.PrintF ("%%\n");
     ELSE
        d.PrintF("N/A\n");
     END;

     d.PrintF("recent cpu usage:         ");
     IF (si.cpuUsageRecentImplemented IN info.cpuUsageImplemented) THEN
        WriteReal ((cu.recentUsedCpuTime * 100) / cu.recentUsedCpuTimeHz, 2,2);
        d.PrintF ("% (%ld seconds)\n", cu.recentSeconds);
     ELSE
        d.PrintF("N/A\n");
     END;

     d.PrintF("context switches:         ");
     IF (si.cpuUsageIvvoCSwImplemented IN info.cpuUsageImplemented) THEN
        d.PrintF("%ld involuntary, %ld voluntary\n", cu.involuntaryCSw, cu.voluntaryCSw);
     ELSE
        d.PrintF("N/A\n");
     END;

     d.PrintF("total context switches:   ");
     IF (si.cpuUsageTotalCSwImplemented IN info.cpuUsageImplemented) THEN
        d.PrintF("%ld\n", cu.totalCSw);
     ELSE
        d.PrintF("N/A\n");
     END;

     d.PrintF("current context switches: ");
     IF (si.cpuUsageIvvoCSwLastsecImplemented IN info.cpuUsageImplemented) THEN
        d.PrintF("%ld involuntary, %ld voluntary\n", cu.involuntaryCSwLastsec, cu.voluntaryCSwLastsec);
     ELSE
        d.PrintF("N/A\n");
     END;

     d.PrintF("current total csws:       ");
     IF (si.cpuUsageTotalCSwLastsecImplemented IN info.cpuUsageImplemented) THEN
        d.PrintF("%ld\n", cu.totalCSwLastsec);
     ELSE
        d.PrintF("N/A\n");
     END;


     (* output cpu usage values for this task *)

     IF si.GetTaskCpuUsage(info,tcu,NIL) = 0 THEN
        d.PrintF("This task:\n");

        d.PrintF("cpu time:                   ");
        IF (si.taskCpuUsageTotalImplemented IN info.taskCpuUsageImplemented) THEN
           d.PrintF("%ld.%ld seconds\n",tcu.totalUsedCpuTime DIV tcu.totalUsedTimeHz, tcu.totalUsedCpuTime MOD tcu.totalUsedTimeHz);
        ELSE
           d.PrintF("N/A\n");
        END;

        d.PrintF("cpu usage:                  ");
        IF (si.taskCpuUsageTotalImplemented IN info.taskCpuUsageImplemented) THEN
           WriteReal ((tcu.totalUsedCpuTime / tcu.totalUsedTimeHz * 100) / tcu.totalElapsedTime, 2,2);
           d.PrintF("%%\n");
        ELSE
           d.PrintF("N/A\n");
        END;

        d.PrintF("current cpu usage:          ");
        IF (si.taskCpuUsageLastsecImplemented IN info.taskCpuUsageImplemented) THEN
           WriteReal ((tcu.usedCpuTimeLastsec * 100) / tcu.usedCpuTimeLastsecHz, 2,2);
           d.PrintF("%%\n");
        ELSE
           d.PrintF("N/A\n");
        END;

        d.PrintF("recent cpu usage:           ");
        IF (si.taskCpuUsageRecentImplemented IN info.taskCpuUsageImplemented) THEN
           WriteReal ((tcu.recentUsedCpuTime * 100) / tcu.recentUsedCpuTimeHz, 2,2);
           d.PrintF ("%% (%ld seconds)\n", tcu.recentSeconds);
        ELSE
           d.PrintF("N/A\n");
        END;

        d.PrintF("context switches:           ");
        IF (si.taskCpuUsageIvvoCSwImplemented IN info.taskCpuUsageImplemented) THEN
           d.PrintF("%ld involuntary, %ld voluntary\n", tcu.involuntaryCSw, tcu.voluntaryCSw);
        ELSE
           d.PrintF("N/A\n");
        END;

        d.PrintF("total context switches:     ");
        IF (si.taskCpuUsageTotalCSwImplemented IN info.taskCpuUsageImplemented) THEN
           d.PrintF("%ld\n", tcu.totalCSw);
        ELSE
           d.PrintF("N/A\n");
        END;

        d.PrintF("context switches (ps):      ");
        IF (si.taskCpuUsageIvvoCSwLastsecImplemented IN info.taskCpuUsageImplemented) THEN
           d.PrintF("%ld involuntary, %ld voluntary\n", tcu.involuntaryCSwLastsec, tcu.voluntaryCSwLastsec);
        ELSE
           d.PrintF("N/A\n");
        END;

        d.PrintF("total context switches (ps):");
        IF (si.taskCpuUsageTotalCSwLastsecImplemented IN info.taskCpuUsageImplemented) THEN
           d.PrintF("%ld\n", tcu.totalCSwLastsec);
        ELSE
           d.PrintF("N/A\n");
        END;
     ELSE
         d.PrintF("Can't get CPU usage for this task.\n");
     END;

CLOSE
     IF info # NIL THEN si.FreeSysInfo(info) END;
END SysInfoTest.
