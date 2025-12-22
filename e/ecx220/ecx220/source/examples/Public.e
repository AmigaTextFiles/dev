-> Opening our public screen with a shell on it ... [nothing fancy]

OPT OSVERSION=37

MODULE 'intuition/screens'

ENUM OKAY,NOSCREEN,NOSIG

PROC main() HANDLE
  DEF s=NIL,sig=-1,name
  IF (s:=OpenScreenTagList(0,          /* get ourselves a public screen */
         [SA_DEPTH,4,
          SA_DISPLAYID,$8000,
          SA_PUBNAME,name:='PublicShell',
          SA_TITLE,name,
          SA_PUBSIG,IF (sig:=AllocSignal(-1))=NIL THEN Raise(NOSIG) ELSE sig,
          SA_PUBTASK,NIL,
          0,0]))=NIL THEN Raise(NOSCREEN)
  PubScreenStatus(s,0)                 /* make it available */
  SetDefaultPubScreen(name)
  SetPubScreenModes(SHANGHAI)
  Execute('NewShell WINDOW CON:10/20/400/100/bla',NIL,NIL)
    /* other applications can use our screen also.
       if we just want our shell on it, turn it private again */
  Wait(Shl(1,sig))            /* wait until all windows closed */
  SetDefaultPubScreen(NIL)    /* workbench is default again */
EXCEPT DO
  IF s THEN CloseS(s)
  IF sig>=0 THEN FreeSignal(sig)
  IF exception=NOSCREEN
    WriteF('Could not open screen!\n')
  ELSEIF exception=NOSIG
    WriteF('No signal available!\n')
  ENDIF
ENDPROC
