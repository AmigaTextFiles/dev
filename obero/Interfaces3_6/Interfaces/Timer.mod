(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Timer.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Timer;

IMPORT e * := Exec;

CONST
(* unit defintions *)
  microHz    * = 0;
  vBlank     * = 1;
  eClock     * = 2;
  waitUntil  * = 3;
  waitEClock * = 4;

  timerName  * = "timer.device";

TYPE
  TimeValPtr * = UNTRACED POINTER TO TimeVal;
  TimeVal * = STRUCT
    secs * : LONGINT;
    micro* : LONGINT;
  END;

  EClockValPtr * = UNTRACED POINTER TO EClockVal;
  EClockVal * = STRUCT
    hi * : LONGINT;
    lo * : LONGINT;
  END;

  TimeRequestPtr * = UNTRACED POINTER TO TimeRequest;
  TimeRequest * = STRUCT (node * : e.IORequest)
    time * : TimeVal;
  END;


CONST

(* IO_COMMAND to use for adding a timer *)
  addRequest * = e.nonstd+0;
  getSysTime * = e.nonstd+1;
  setSysTime * = e.nonstd+2;

VAR

(*
 *  You have to put a pointer to the timer.device here to use the timer
 *  procedures:
 *)

  base * : e.DevicePtr;

PROCEDURE AddTime    * {base,-42}(VAR dest{8},source{9}: TimeVal);
PROCEDURE SubTime    * {base,-48}(VAR dest{8},source{9}: TimeVal);
PROCEDURE CmpTime    * {base,-54}(VAR tv1{8} ,tv2{9}   : TimeVal): INTEGER;
PROCEDURE ReadEClock * {base,-60}(VAR dest{8}: EClockVal): LONGINT;
PROCEDURE GetSysTime * {base,-66}(VAR dest{8}: TimeVal);

END Timer.

