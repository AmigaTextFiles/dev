-> utilisons une pile!

MODULE 'class/stack'

PROC main() HANDLE
  DEF s:PTR TO stack,a
  NEW s.stack()                         -> incroyaaaable! :-)
  FOR a:=1 TO 10 DO s.push(a)
  FOR a:=1 TO 11 DO WriteF('element = \d\n',s.pop())
EXCEPT DO
  END s
  IF exception="estk" THEN WriteF('vous avez sous passé la pile!\n')
ENDPROC
