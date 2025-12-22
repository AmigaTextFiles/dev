MODULE 'intuition/intuition'
MODULE 'intuition/intuitionbase'
MODULE 'intuition/screens'

PROC main()

DEF ib:intuitionbase

ib:=intuitionbase

LOOP

WriteF('ActiveWindow  : \s\n',ib.activewindow.title)
WriteF('ActiveScreen  : \s\n',ib.activescreen.title)
WriteF('X Coordinates : \d\n',ib.mousex)
WriteF('Y Coordinates : \d\n',ib.mousey)

IF Mouse()=1 THEN JUMP ext

WriteF('\b \b \b \b')

ENDLOOP

ext:

ENDPROC
