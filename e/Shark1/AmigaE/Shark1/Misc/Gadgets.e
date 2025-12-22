MODULE 'intuition/intuition'

CONST BUFSIZE=GADGETSIZE * 3, IFLAGS=IDCMP_CLOSEWINDOW+IDCMP_GADGETUP

DEF buf[BUFSIZE]:ARRAY,next,w,gad:PTR TO gadget
PROC main()

next:=Gadget(buf,NIL,1,0,20,20,100,'Quit')
next:=Gadget(next,buf,2,1,20,35,100,'Gadget1')
next:=Gadget(next,buf,3,2,20,50,100,'Gadget2')

IF w:=OpenW(20,11,200,100,IFLAGS,$F,'Gadget',NIL,1,buf)
 WHILE WaitIMessage(w)<>IDCMP_CLOSEWINDOW
      gad:=MsgIaddr()
      TextF(20,80,'Gadget pick nr: \d',gad.userdata)
 ENDWHILE
CloseW(w)
ENDIF

ENDPROC
