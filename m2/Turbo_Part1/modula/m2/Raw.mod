IMPLEMENTATION MODULE Raw ;

FROM SYSTEM IMPORT ADR ;
IMPORT Exec, Dos ;

VAR
  conFH : Dos.FileHandlePtr ;

PROCEDURE SetConsoleMode( mode : LONGINT ) ;
VAR
  replyPort : Exec.MsgPortPtr ;
  packet    : Dos.StandardPacketPtr ;
BEGIN
  replyPort := Exec.CreatePort( NIL, 0 ) ;
  IF replyPort = NIL THEN done := FALSE ; RETURN END ;
  packet := Exec.AllocMem( SIZE( Dos.StandardPacket ),
  			   Exec.MEMF_PUBLIC+Exec.MEMF_CLEAR ) ;
  IF packet = NIL THEN
    Exec.DeletePort( replyPort ) ;
    done := FALSE ;
  ELSE
    packet^.sp_Msg.mn_Node.ln_Name := ADR( packet^.sp_Pkt ) ;
    packet^.sp_Pkt.dp_Link := ADR( packet^.sp_Msg ) ;
    packet^.sp_Pkt.dp_Port := replyPort ;
    packet^.sp_Pkt.dp_Type := Dos.ACTION_SCREEN_MODE ;
    packet^.sp_Pkt.dp_Arg1 := mode ;
    Exec.PutMsg( conFH^.fh_Type, ADR( packet^.sp_Msg ) ) ;
    Exec.WaitPort( replyPort ) ;
    Exec.GetMsg( replyPort ) ;
    done := packet^.sp_Pkt.dp_Res1 # 0 ;
    Exec.FreeMem( packet, SIZE( Dos.StandardPacket ) ) ;
    Exec.DeletePort( replyPort )
  END
END SetConsoleMode ;

PROCEDURE SetConsoleRaw( ) ;
BEGIN IF conFH = NIL THEN done := FALSE ELSE SetConsoleMode( -1 ) END
END SetConsoleRaw ;

PROCEDURE SetConsoleCooked( ) ;
BEGIN IF conFH = NIL THEN done := FALSE ELSE SetConsoleMode( 0 ) END
END SetConsoleCooked ;

BEGIN
  conFH := Dos.Open( "*", Dos.MODE_OLDFILE ) ;
  IF conFH # NIL THEN
    IF Dos.IsInteractive( conFH ) = 0 THEN conFH := NIL END
  END
CLOSE
  IF conFH # NIL THEN SetConsoleMode( 0 ) ; Dos.Close( conFH ) END
END Raw.
