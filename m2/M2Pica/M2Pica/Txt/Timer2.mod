(*---------------------------------------------------------------------------
    :Program.    Timer2.mod
    :Author.     Bernd Preusing
    :Address.    Gerhardstr. 16  D-2200 Elmshorn
    :Phone.      04121/22486
    :Shortcut.   [bep]
    :Version.    1.0
    :Date.       21-Oct-88
    :Copyright.  PD
    :Language.   Modula-II
    :Translator. M2Amiga
    :Imports.    ---
    :UpDate.
    :Contents.   Procedures to handle time and date.
    :Remark.
---------------------------------------------------------------------------*)
IMPLEMENTATION MODULE Timer2;

FROM SYSTEM IMPORT
	ADR, ADDRESS;

FROM ExecD IMPORT
	quick, execBase;
FROM ExecL IMPORT
	FindName;

FROM Timer IMPORT
	timerName, getSysTime, TimeRequest;


CONST	(* Register *)
	A0 = 0+8;  A1 = 1+8; A6 = 6+8;

VAR
	TimerBase: ADDRESS;
	MyIO: TimeRequest;
	Time1: TimeVal;


(* Dies geht nur ohne OpenDevice, weil keine Unit benötigt wird und
   das timer.device ganz sicher offen ist und wg. Quick-IO!!!! *)

(* Hilfsprozeduren:
   Achtung: diese können niemals exportiert werden, weil sonst
   die Übergabe in A6 nicht funktioniert!
*)
PROCEDURE BeginIO(base{A6}:ADDRESS; TimeReq{A1}:ADDRESS);
CODE -30;

PROCEDURE AddT(base{A6}:ADDRESS; dest{A0},source{A1}:ADDRESS);
CODE -42;

PROCEDURE SubT(base{A6}:ADDRESS; dest{A0},source{A1}:ADDRESS);
CODE -48;

PROCEDURE CmpT(base{A6}:ADDRESS; t0{A0},t1{A1}:ADDRESS):INTEGER;
CODE -54;


PROCEDURE AddTime(VAR dest,source: TimeVal); (* dest:=dest+source *)
BEGIN
  AddT(TimerBase,ADR(dest),ADR(source))
END AddTime;

PROCEDURE SubTime(VAR dest,source: TimeVal); (* dest:=dest-source *)
BEGIN
  SubT(TimerBase,ADR(dest),ADR(source))
END SubTime;

(* ReturnChk := FALSE *)
PROCEDURE CmpTime(VAR d1,d2:TimeVal): INTEGER; (* -1: d2<d1  1: d2>d1  0: d1=d2 *)
BEGIN
  RETURN CmpT(TimerBase,ADR(d1),ADR(d2))
END CmpTime;

PROCEDURE GetSysTime(VAR t: TimeVal);
BEGIN
  BeginIO(TimerBase,ADR(MyIO));
  t:=MyIO.time
END GetSysTime;


PROCEDURE StartTime();
BEGIN
  GetSysTime(Time1)
END StartTime;

PROCEDURE StopTime(VAR t:TimeVal); (* Differenz seit StartTime *)
BEGIN
  GetSysTime(t);
  SubT(TimerBase,ADR(t),ADR(Time1));
END StopTime;

BEGIN
  TimerBase:=FindName(ADR(execBase^.deviceList),ADR(timerName));
  IF TimerBase=NIL THEN HALT END; (* unmöglich! *)
  WITH MyIO.node DO
    device:=NIL; (* vorsichtshalber *)
    unit:=NIL;
    command:=getSysTime;
    flags:=quick (* handling ohne MessagePort *)
  END;
END Timer2.mod
