(* This is a program that I hacked up when I discoverd my A1200 did not      *)
(*  come with a real time clock.This makes it difficult to use MAKE like     *)
(* programs (eg M2B) which rely on file timestamps.			     *)
(* I once read in amiga publication that on failing to detect a RTC the      *)
(* amiga should set the current date to the most recent file created on SYS: *)
(* However on booting my amiga always gave the same time.		     *)
(* What this program does is write out the time every 10 minutes to file     *)
(* devs:time. On bootup the time is set to 11 minutes past the last time     *)
(* written.This means the most recently created file will always have a      *)
(* larger time/datestamp than any existing ones, as required by M2B,MAKE etc *)

(* This program is only worth using if you have a hard-disk.		     *)
(* It should be called from within s:user-startup/s:startup-sequence	     *)

MODULE IncTime ;
(* Safe to call even if no devs:time file exists, in which case time=0 *)

FROM SYSTEM IMPORT ADR ;

IMPORT Dos, Timer, Exec ;

VAR
  time  : LONGINT ;
  timer : Timer.TimeRequestPtr ;

PROCEDURE SetTime( i : LONGINT ) ;
BEGIN
  timer^.tr_time.tv_secs := i ;
  timer^.tr_node.io_Command := Timer.TR_SETSYSTIME ;
  Exec.DoIO( timer ) ;
END SetTime ;

PROCEDURE GetTime( ) : LONGINT ;
BEGIN
  timer^.tr_node.io_Command := Timer.TR_GETSYSTIME ;
  Exec.DoIO( timer ) ;
  RETURN timer^.tr_time.tv_secs ;
END GetTime ;

VAR
  port : Exec.MsgPortPtr ;
  num  : LONGINT ;
  file : Dos.FileHandlePtr ;

BEGIN
  port := Exec.CreatePort( NIL, NIL ) ;
  IF port = NIL THEN HALT END ;
  timer := Exec.CreateExtIO( port, SIZE( timer^ ) ) ;
  IF timer = NIL THEN HALT END ;
  Exec.OpenDevice( "timer.device", Timer.UNIT_VBLANK, timer, { } ) ;
  file := Dos.Open("devs:time", Dos.MODE_READWRITE ) ;
  IF file = NIL THEN HALT END ;
  num := Dos.Read( file, ADR( time ), SIZE( time ) ) ;
  num := Dos.Seek( file, 0, Dos.OFFSET_BEGINNING ) ;
  INC( time , 11*60 ) ; (* Set time to 11 minutes past last written value *)
  SetTime( time ) ;
  LOOP
    num := Dos.Write( file, ADR( time ), SIZE( time ) ) ;
    num := Dos.Seek( file, 0, Dos.OFFSET_BEGINNING ) ;
    Dos.Close( file ) ;
    Dos.Delay( 60*10*Dos.TICKS_PER_SECOND ) ; (* Sleep for 10 minutes *)
    time := GetTime( ) ;
    file := Dos.Open("devs:time", Dos.MODE_READWRITE ) ;
    IF file = NIL THEN EXIT END
  END
END IncTime.
