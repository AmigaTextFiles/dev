OPT MODULE

MODULE 'graphics/graphint',
       'hardware/intbits'

EXPORT PROC addTOF(i:PTR TO isrvstr, p, a)
  i.code:={ttskasm}
  i.iptr:=i
  i.ccode:=p
  i.carg:=a
  AddIntServer(INTB_VERTB, i)
ENDPROC

EXPORT PROC remTOF(i:PTR TO isrvstr)
  RemIntServer(INTB_VERTB, i)
ENDPROC

EXPORT PROC waitbeam(pos)
  WHILE pos>VbeamPos() DO NOP
ENDPROC

ttskasm:
  MOVE.L $1A(A1), -(A7)
  MOVEA.L $16(A1), A0
  JSR (A0)
  ADDQ.L #4, A7
  MOVEQ.L #0, D0
  RTS
