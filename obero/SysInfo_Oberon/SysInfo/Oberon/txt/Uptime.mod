(*(*
 * Uptime
 *
 * This file is public domain.
 *
 * Author: Petri Nordlund <petrin@mits.mdata.fi>
 *
 * $Id: uptime.c 1.5 1995/10/05 12:31:31 petrin Exp petrin $
 *
 * Oberon-Version by Thomas Igracki
 *
 *)*)

(* OberonVersion:
 *
 * bug: InfoData auf long-aligned bringen.
 * nur wie??? Viell. statisch def. (info: d.InfoData)??
 * 
 * MultiUser-Teil NICHT GETESTET!! 
 *)

(*
 * This is a fairly complete uptime-program. The sourcecode comes from Executive
 * uptime-client, it's just modified to support SysInfo.library. This program
 * can be compiled for multiuser.library support to show the number of users
 * currently logged in. This requires multiuser.library include-files and
 * a stub-library if you are using GCC. See GCC:geninline/README.glue for
 * information about how to generate the stub-library.
 *)

MODULE Uptime;
IMPORT
  y: SYSTEM, e: Exec, d: Dos, u: Utility, 
  (* $IF UseMultiUser *) mu: MultiUser, (* $END *)
  si: SysInfo, rc: RealConversions;

VAR
  info: si.SysInfoPtr;

PROCEDURE PutS (str: ARRAY OF CHAR); (* $CopyArrays- *)
BEGIN     d.PrintF ("%s\n",y.ADR(str))
END PutS;

(*
 * Print system time
 *)
PROCEDURE GetTime();
VAR
   dtime  : d.DateTime;
   timestr: d.DatString;
BEGIN
     d.DateStamp(dtime);

     dtime.format := d.formatDos;
     dtime.flags := SHORTSET{};
     dtime.strDay := NIL;
     dtime.strDate := NIL;
     dtime.strTime := y.ADR(timestr);

     IF ~d.DateToStr(dtime) THEN END;

     d.PrintF(timestr);
END GetTime;


(*
 * Print number of users (from Multiuser if available)
 *)
PROCEDURE Users();
VAR
  nusers: LONGINT;
  (* $IF UseMultiUser *)
  numtasks: LONGINT; uids: UNTRACED POINTER TO ARRAY OF INTEGER;
  task: e.TaskPtr;
  (* $END *)
BEGIN
     nusers := 1;

(*  $IF UseMultiUser *)
     IF mu.base # NIL THEN 

        e.Forbid();

        (* Count the number of tasks currently in system *)
        numtasks := CountTasks();

        (* Allocate memory for each task *)
        uids := e.AllocVec (numtasks*SIZE(INTEGER), LONGSET{e.memClear,e.public});
        IF uids # NIL THEN

           (* Find out how many different uids there are *)

           nusers := 0;
           AddUser (mu.GetTaskOwner(e.FindTask(NIL)), uids, nusers);
           task := e.base.taskReady.head;
           LOOP
              IF task.node.succ = NIL THEN EXIT END;
              AddUser (mu.GetTaskOwner(task), uids, nusers);
              task := task.node.succ;
           END;
           task := e.base.taskWait.head;
           LOOP
              IF task.node.succ = NIL THEN EXIT END;
              AddUser (mu.GetTaskOwner(task), uids, y.ADR(nusers));
              task := task.node.succ;
           END;
           e.FreeVec(uids);
        END;
        e.Permit();
     END;
(* $END *)

     IF (nusers > 1) OR (nusers = 0) THEN
        d.PrintF("%ld users", nusers);
     ELSE
        d.PrintF("%ld user",nusers);
     END;
END Users;


(* $IF UseMultiUser *)

PROCEDURE AddUser(user: LONGINT; VAR uids: ARRAY OF INTEGER; VAR nusers: LONGINT);
VAR
   uid: LONGINT;
   found: BOOLEAN;
   i: LONGINT;
BEGIN
     IF user # 0 THEN
        uid := SHORT(user); (* ??? C: uid = user>>16; *)
        i := 0; 
        WHILE ~found & (i<nusers) DO found := (uids[i] = uid); INC(i) END;
        IF ~found THEN INC(nusers); uids[nusers] := uid END;
     END;
END AddUser;

PROCEDURE CountTasks(): LONGINT;
VAR
   i : LONGINT;
   task: e.TaskPtr;
BEGIN
     i := 1;

     task := y.VAL(e.TaskPtr, e.SysBase.taskReady.head);
     WHILE task # NIL DO task := y.VAL(e.TaskPtr, task.node.succ); INC(i); END;

     task := y.VAL(e.TaskPtr, e.SysBase.taskWait.head);
     WHILE task # NIL DO task := y.VAL(e.TaskPtr, task.node.succ); INC(i); END;

     RETURN i;
END CountTasks;
(* $END *)

(*
 * Print uptime. We use RAM:-disk creation time.
 *)
PROCEDURE Uptime();
VAR
   boottime   : LONGINT;
   currenttime: LONGINT;
   dtime      : d.DateTime;
   lock       : d.FileLockPtr;
   infodata   : d.InfoDataPtr;
   ramdevice  : d.DeviceListPtr;
   days, hrs, mins, hrsTmp: LONGINT;
BEGIN
(*
 * InfoData-structure must be long word aligned. By allocating it this way,
 * we can make sure it is aligned properly. GCC has a bug in it's aligned-
 * attribute <sigh> so it's not possible to just use: struct InfoData infodata.
 *)

     infodata := e.AllocMem (SIZE(d.InfoData), e.any);
     IF infodata = NIL THEN RETURN END;

     lock := d.Lock ("RAM:", d.sharedLock);
     IF lock # NIL THEN
             
         IF d.Info(lock, infodata^) THEN
             ramdevice := infodata.volumeNode;

             boottime :=  u.SMult32(ramdevice.volumeDate.days, 86400) +
                          u.SMult32(ramdevice.volumeDate.minute, 60) +
                          u.SDivMod32(ramdevice.volumeDate.tick, d.ticksPerSecond);

             d.DateStamp(dtime);

             currenttime :=  u.SMult32(dtime.stamp.days, 86400) +
                             u.SMult32(dtime.stamp.minute, 60) +
                             u.SDivMod32(dtime.stamp.tick, d.ticksPerSecond);

             DEC(currenttime, boottime);

             IF currenttime > 0 THEN

                (* Calculate days, hours and minutes *)
                days := currenttime DIV 86400;
                hrs := currenttime MOD 86400; hrsTmp := hrs;
                hrs := hrs DIV 3600;
                mins := (hrsTmp MOD 3600) DIV  60;

                IF (days > 0) OR (hrs > 0) OR (mins > 0) THEN d.PrintF("up ") END;

                IF (days > 0) THEN
                   IF (days > 1) THEN
                      d.PrintF("%ld days ", days);
                   ELSE
                      d.PrintF("%ld day ", days);
                   END;
                END; (* IF days > 0 *)
                IF (hrs > 0) THEN
                   d.PrintF("%ld:%02ld", hrs, mins);
                ELSE
                   IF (mins > 1) OR (mins = 0) THEN
                      d.PrintF("%ld mins", mins);
                   ELSE
                      d.PrintF("%ld min", mins);
                   END
                END; (* IF hrs > 0 *)
             END; (* IF currenttime > 0 *)
         END; (* IF d.Info() *)
         d.UnLock(lock);
     END; (* IF lock # NIL *);

     e.FreeMem(infodata, SIZE(d.InfoData));
END Uptime;

PROCEDURE WriteReal (r: REAL; v,n: INTEGER);
VAR str: ARRAY 50 OF CHAR;
BEGIN
     IF rc.RealToString (r, str, v,n, FALSE) THEN d.PrintF (str) END;
END WriteReal;

(*
 * Print load averages
 *)
PROCEDURE LoadAverages();
VAR
   loadAvg: si.LoadAverage; (* This will be filled by GetLoadAverage() *)
BEGIN
     si.GetLoadAverage (info, loadAvg);
     d.PrintF("load: ");

     IF info.loadAvgType = si.loadAvgFixedPnt THEN
         si.GetLoadAverage(info, loadAvg);     (* Ask SysInfo.library for current load averages *)
         (* Convert fixed point values to floating point values *)
         IF info.loadAvgTime1 # 0 THEN
            WriteReal (loadAvg.load1 / info.fScale, 1, 2)
         ELSE
            d.PrintF(" N/A");
         END;
         IF info.loadAvgTime2 # 0 THEN
            WriteReal (loadAvg.load2 / info.fScale, 1, 2)
         ELSE
            d.PrintF(" N/A");
         END;
         IF info.loadAvgTime3 # 0 THEN
            WriteReal (loadAvg.load3 / info.fScale, 1, 2)
         ELSE
            d.PrintF(" N/A");
         END;
     ELSE
        (* Load average is not supported *)
        d.PrintF("-");
     END
END LoadAverages;

BEGIN
     IF si.base = NIL THEN d.PrintF ("Failed to open %s v%ld!\n",y.ADR(si.name),si.version); HALT(d.warn) END;

     (* Initialize SysInfo.library, this will make the connection to the
      * server-process and allocate the SysInfo-structure. *)
 
     info := si.InitSysInfo();
     IF info = NIL THEN PutS("Couldn't initialize SysInfo."); HALT(d.fail) END;

     GetTime();
     d.PrintF(", ");
     Uptime();
     d.PrintF(", ");
     Users();
     d.PrintF(", ");
     LoadAverages();
     d.PrintF("\n");

     HALT(d.ok);
CLOSE
     (* Exit. Free everything. *)
     IF info # NIL THEN si.FreeSysInfo(info) END;
END Uptime.
