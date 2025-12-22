MODULE  AudioSupport;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  au:=Audio,
        e:=Exec,
        es:=ExecSupport,
        g:=Graphics,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     clock: LONGINT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "CONST" -------------------------------- *)
CONST   bitLeft1 * =0;
        bitLeft2 * =3;
        bitRight1 * =1;
        bitRight2 * =2;

        chanLeft1 * =LONGSET{bitLeft1};
        chanLeft2 * =LONGSET{bitLeft2};
        chanRight1 * =LONGSET{bitRight1};
        chanRight2 * =LONGSET{bitRight2};

        leftOnly * =chanLeft1+chanLeft2;
        rightOnly * =chanRight1+chanRight2;

        channelMap * = "\x03\x05\x0A\x0C"; (* L1+R1, L1+R2, L2+R1, L2+R2 *)
        channelSize * =4;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE WriteAudio()" ------------------------ *)
PROCEDURE WriteAudio * (req: au.IOAudioPtr;
                        data: e.APTR;
                        len: LONGINT;
                        period: LONGINT;
                        volume: INTEGER);
BEGIN
  req.request.command:=e.write;
  req.request.flags:=SHORTSET{au.pervol};
  req.data:=data;
  req.length:=len;
  req.cycles:=1;
(* $RangeChk- *)
  req.period:=SHORT(clock DIV period);
(* $RangeChk= *)
  req.volume:=volume;
  es.BeginIO(req);
END WriteAudio;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE StartAudio()" ------------------------ *)
PROCEDURE StartAudio * (req: au.IOAudioPtr);
BEGIN
  req.request.command:=e.start;
  e.SendIO(req);
  e.WaitPort(req.request.message.replyPort);
END StartAudio;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE StopAudio()" ------------------------ *)
PROCEDURE StopAudio * (req: au.IOAudioPtr);
BEGIN
  req.request.command:=e.stop;
  e.SendIO(req);
  e.WaitPort(req.request.message.replyPort);
END StopAudio;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE ResetAudio()" ------------------------ *)
PROCEDURE ResetAudio * (req: au.IOAudioPtr);
BEGIN
  req.request.command:=e.reset;
  e.SendIO(req);
  e.WaitPort(req.request.message.replyPort);
END ResetAudio;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE FlushAudio()" ------------------------ *)
PROCEDURE FlushAudio * (req: au.IOAudioPtr);
BEGIN
  req.request.command:=e.flush;
  e.SendIO(req);
  e.WaitPort(req.request.message.replyPort);
END FlushAudio;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE CopyUnit()" ------------------------- *)
PROCEDURE CopyUnit * (src: au.IOAudioPtr;
                      dst: au.IOAudioPtr;
                      mask: LONGSET);
BEGIN
  dst.request.device:=src.request.device;
  dst.request.unit:=y.VAL(e.UnitPtr,y.VAL(LONGSET,src.request.unit)*mask);
  dst.allocKey:=src.allocKey;
END CopyUnit;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE SetPerVol()" ------------------------ *)
PROCEDURE SetPerVol * (req: au.IOAudioPtr;
                       period: LONGINT;
                       volume: INTEGER);
BEGIN
  req.request.command:=au.perVol;
(* $RangeChk- *)
  req.period:=SHORT(clock DIV period);
(* $RangeChk= *)
  req.volume:=volume;
  e.SendIO(req);
END SetPerVol;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  IF g.pal IN g.base.displayFlags THEN
    clock:=3546895;
  ELSE
    clock:=3579545;
  END;
END AudioSupport.
