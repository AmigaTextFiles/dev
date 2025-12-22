MODULE CyberQTSync;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  cu:=CyberQTUtils,
        d:=Dos,
        e:=Exec,
        g:=CyberQTGlobals,
        m:=MathFFP,
        mu:=MathUtils,
        o:=CyberQTOpts,
        t:=Timer,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     timerPort: e.MsgPortPtr;
        timerOpen: BOOLEAN;
        timerSig - : LONGINT;
        timerIO: t.TimeRequestPtr;
        nextTime: t.EClockVal;
        frameTime: t.EClockVal;
        syncTime: t.EClockVal;
        oneSecond: t.EClockVal;
        microsPerEClock: REAL;
        start: t.EClockVal;
        stop: t.EClockVal;
        speedChanged - : BOOLEAN;
        speedFactor: REAL;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE Micros2EClocks()" ---------------------- *)
PROCEDURE Micros2EClocks(micros: LONGINT): LONGINT;
BEGIN
  RETURN mu.floor(micros/microsPerEClock);
END Micros2EClocks;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE GetPlayingTime()" ---------------------- *)
PROCEDURE GetPlayingTime(): REAL;

VAR     time: LONGINT;
        track: g.TrackPtr;

BEGIN
  time:=0;
  track:=g.animInfo.videoTracks.head;
  WHILE track.node.succ#NIL DO
    time:=mu.max(time,track.head.duration);
    track:=track.node.succ;
  END;
  RETURN mu.min(g.animInfo.mvhd.duration,time)/g.animInfo.mvhd.timeScale;
END GetPlayingTime;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE DoStats()" ------------------------- *)
PROCEDURE DoStats * (framesDone: LONGINT;
                     framesSkipped: LONGINT;
                     totalFrames: LONGINT);

VAR     fps: REAL;
        time: REAL;
        realFPS: e.STRING;
        realTime: e.STRING;
        expFPS: e.STRING;
        expTime: e.STRING;
        diff: REAL;
        diffS: e.STRING;

BEGIN
  mu.Sub64(stop,start);

  time:=((stop.hi*4294967296.0+stop.lo)*microsPerEClock)/1000000;
  fps:=framesDone/time;
  diff:=time;
  mu.real2str(time,realTime,6);
  mu.real2str(fps,realFPS,2);

  time:=GetPlayingTime();
  fps:=totalFrames/time;
  mu.real2str(time,expTime,6);
  mu.real2str(fps,expFPS,2);

  mu.real2str(diff-time,diffS,6);

  d.PrintF("\n"
           "Statistics:\n"
           "  total frames    : %4ld\n"
           "  frames processed: %4ld\n"
           "  frames displayed: %4ld\n"
           "  frames skipped  : %4ld\n"
           "  real time used  : %11s seconds (%6s fps)\n"
           "  expected time   : %11s seconds (%6s fps)\n"
           "  difference      : %11s seconds\n"
           "\n",totalFrames,
                framesDone,
                framesDone-framesSkipped,
                framesSkipped,
                y.ADR(realTime),y.ADR(realFPS),
                y.ADR(expTime),y.ADR(expFPS),
                y.ADR(diffS));
END DoStats;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE CloseTimer()" ------------------------ *)
PROCEDURE CloseTimer();
BEGIN
  IF timerOpen THEN
    IF e.CheckIO(timerIO)=NIL THEN (* es läuft noch ein Request *)
      e.AbortIO(timerIO);
      y.SETREG(0,e.WaitIO(timerIO));
    END;
    e.CloseDevice(timerIO);
  END;
  IF timerIO#NIL THEN e.DeleteIORequest(timerIO); END;
  IF timerPort#NIL THEN e.DeleteMsgPort(timerPort); END;
END CloseTimer;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE OpenTimer()" ------------------------ *)
PROCEDURE OpenTimer(): BOOLEAN;

VAR     now: t.EClockVal;

BEGIN
  timerOpen:=FALSE;
  timerIO:=NIL;
  timerPort:=e.CreateMsgPort();
  IF timerPort=NIL THEN
    d.PrintF("Can't create timer message port!\n");
    RETURN FALSE;
  END;
  timerSig:=timerPort.sigBit;
  timerIO:=e.CreateIORequest(timerPort,SIZE(timerIO^));
  IF timerIO=NIL THEN
    d.PrintF("Can't create timer iorequest!\n");
    RETURN FALSE;
  END;
  timerOpen:=(e.OpenDevice(t.timerName,t.waitEClock,timerIO,LONGSET{})=0);
  IF ~timerOpen THEN
    d.PrintF("Can't open timer.device!\n");
    RETURN FALSE;
  END;
  timerIO.node.command:=t.addRequest;
  t.base:=timerIO.node.device;
  microsPerEClock:=1000000.0/t.ReadEClock(now);
  oneSecond.hi:=0;
  oneSecond.lo:=Micros2EClocks(1000000);
  RETURN TRUE;
END OpenTimer;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Wait()" --------------------------- *)
PROCEDURE Wait * (secs: LONGINT);

VAR     now: t.EClockVal;
        until: t.EClockVal;

BEGIN
  until.hi:=0;
  until.lo:=Micros2EClocks(secs*1000000);
  y.SETREG(0,t.ReadEClock(now));
  mu.Add64(until,now);
  timerIO.time:=y.VAL(t.TimeVal,until);
  y.SETREG(0,e.DoIO(timerIO));
END Wait;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE StartTimer()" ------------------------ *)
PROCEDURE StartTimer * ();
BEGIN
  IF o.maxFPS THEN
    speedChanged:=TRUE;
    speedFactor:=0.0;
  ELSE
    speedChanged:=FALSE;
    speedFactor:=1.0;
  END;
  frameTime:=t.EClockVal(0,0);
  y.SETREG(0,t.ReadEClock(start));
  nextTime:=start;
  syncTime:=start;
  mu.Add64(syncTime,oneSecond);
  timerIO.time:=y.VAL(t.TimeVal,nextTime);
  e.SendIO(timerIO);
END StartTimer;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE StopTimer()" ------------------------ *)
PROCEDURE StopTimer();
BEGIN
  y.SETREG(0,t.ReadEClock(stop));
END StopTimer;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE PauseTimer()" ------------------------ *)
PROCEDURE PauseTimer * (pause: BOOLEAN);

VAR     temp: t.EClockVal;
        now: t.EClockVal;

BEGIN
  IF pause THEN
    temp:=nextTime;
    y.SETREG(0,t.ReadEClock(now));
    mu.Sub64(temp,now);
    frameTime:=temp;
    nextTime:=now;
    WHILE e.CheckIO(timerIO)=NIL DO
      e.AbortIO(timerIO);
      y.SETREG(0,e.WaitIO(timerIO));
    END;
  ELSE
    y.SETREG(0,t.ReadEClock(nextTime));
(*
    mu.Add64(nextTime,frameTime);
*)
    syncTime:=nextTime;
    frameTime.hi:=0;
    timerIO.time:=y.VAL(t.TimeVal,nextTime);
    e.SendIO(timerIO);
  END;
END PauseTimer;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE SetSpeedFactor()" ---------------------- *)
PROCEDURE SetSpeedFactor * (factor: REAL);
BEGIN
  IF e.CheckIO(timerIO)=NIL THEN
    e.AbortIO(timerIO);
    y.SETREG(0,e.WaitIO(timerIO));
  END;
  y.SETREG(0,t.ReadEClock(nextTime));
  speedFactor:=factor;
  speedChanged:=(speedFactor#1.0);
END SetSpeedFactor;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DoFrameDelay()" ----------------------- *)
PROCEDURE DoFrameDelay * (time: REAL;
                          skipping: BOOLEAN);
BEGIN
  frameTime.lo:=mu.floor((time*1000000*speedFactor)/microsPerEClock);
  mu.Add64(nextTime,frameTime);
  IF ~skipping THEN timerIO.time:=y.VAL(t.TimeVal,nextTime); END;
  e.SendIO(timerIO);
END DoFrameDelay;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE IsSync()" -------------------------- *)
PROCEDURE IsSync * (): BOOLEAN;

VAR     now: t.EClockVal;
        ret: BOOLEAN;

BEGIN
  IF speedChanged THEN
    ret:=TRUE; (* falls Geschwindigkeit geändert, dann immer synchron *)
  ELSE
    y.SETREG(0,t.ReadEClock(now));
    mu.Sub64(now,frameTime); (* synctime>=now-frametime? *)
    ret:=(mu.Cmp64(syncTime,now)<=0); (* syncTime ist noch später als now => synchron *)
  END;
  IF mu.Cmp64(syncTime,nextTime)>=0 THEN mu.Add64(syncTime,oneSecond); END; (* eine Sekunde ist vorbei, syncTime aktualisieren *)
  RETURN ret;
END IsSync;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE Wait4LastFrame()" ---------------------- *)
PROCEDURE Wait4LastFrame * ();
BEGIN
  IF e.CheckIO(timerIO)=NIL THEN
    y.SETREG(0,e.Wait(LONGSET{timerSig})); (* auf Timer warten, sonst wird der letzte Frame zu kurz dargestellt *)
  END;
  StopTimer();
END Wait4LastFrame;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  IF ~OpenTimer() THEN
    d.PrintF("Can't open timer!\n");
    HALT(0);
  END;
CLOSE
  CloseTimer();
END CyberQTSync.
