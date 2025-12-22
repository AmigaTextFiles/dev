
MODULE 'thread',
       'libraries/thread'

MODULE 'intuition/screens',
       'intuition/intuition'


DEF subthread
DEF a : LONG
DEF win0, win1



PROC main ()
  IF threadbase := OpenLibrary( 'thread.library', 0 )
    IF win0 := OpenWindowTagList(NIL,[WA_FLAGS,$E,WA_WIDTH,400,WA_HEIGHT,80,WA_TITLE,'Root Process',0])
      subthread := TlCreate( {thread}, TL_AMIGAE )
      Delay( 100 )
      -> wait the sub-thread end...
      a := TlJoin( subthread )
      PrintF( 'return value = \d\n', a )
      Delay( 50 )
      IF win1 THEN CloseW( win1 )
      CloseW( win0 )
    ENDIF
    CloseLibrary( threadbase )
  ENDIF
ENDPROC



PROC thread ()
  IF win1 := OpenWindowTagList(NIL,[WA_FLAGS,$E,WA_IDCMP,IDCMP_CLOSEWINDOW,WA_WIDTH,300,WA_HEIGHT,60,WA_TITLE,'Thread window',0])
    WaitIMessage( win1 )
  ENDIF
  TlExit( 10 )
ENDPROC

