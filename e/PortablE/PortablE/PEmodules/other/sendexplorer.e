OPT MODULE

MODULE 'other/sendrexx'
MODULE 'exec', 'exec/ports'

PRIVATE
CONST MAXLINE=512
PUBLIC

PROC sendExplorer(addr,obj=NILA:ARRAY OF CHAR,repPort=NIL:PTR TO mp,message=NILA:ARRAY OF CHAR,quiet=FALSE)
  DEF s[MAXLINE]:STRING
  StringF(s, '\'DISPLAY \s$\h OBJECT "\s" MESSAGE "\s"\'',
          IF quiet THEN 'QUIET ' ELSE '', addr,
          IF obj THEN obj ELSE '', IF message THEN message ELSE '')
ENDPROC rx_SendMsg('EXPLORER',s,repPort)

PROC quitExplorer(repPort=NIL:PTR TO mp) IS rx_SendMsg('EXPLORER','\'QUIT\'',repPort)

PROC isExplorerRunning() IS FindPort('EXPLORER')<>NIL
