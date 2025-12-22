OPT OSVERSION=37, REG = 5

MODULE '*progresswin'

PROC main() HANDLE
DEF count,
    pw = NIL:PTR TO progresswin

  NEW pw

  pw.openprogresswin(NIL, NIL,'(pling) Elevator ready...')

  Delay(75)

  pw.drawprogresstext('Going up...')

  Delay(25)

  FOR count := 0 TO 49
    pw.drawprogressgad(count)
    Delay(1)
  ENDFOR

  pw.drawprogresstext('Stand by...')

  Delay(75)
  pw.drawprogresstext('50 to go...')

  FOR count := 50 TO 100
    pw.drawprogressgad(count)
    Delay(1)
  ENDFOR

  pw.drawprogresstext('(snap) Oops! No wire...')

  Delay(75)

  pw.drawprogresstext('Gooing doooown...')

  FOR count := 100 TO 50 STEP -1
    pw.drawprogressgad(count)
    Delay(1)
  ENDFOR

  pw.drawprogresstext('(Hick)...')

  Delay(60)

  pw.drawprogresstext('50 to go...')

  FOR count := 49 TO 0 STEP -1
    pw.drawprogressgad(count)
    Delay(1)
  ENDFOR

  pw.drawprogresstext('You can go home now...')

  Delay(150)
EXCEPT DO
  IF pw
    pw.closeprogresswin()
    END pw
  ENDIF
ENDPROC

