MODULE '*set'

PROC main() HANDLE
  DEF s=NIL:PTR TO set
  NEW s.create(20)
  s.add(1)
  s.add(-13)
  s.add(91)
  s.add(42)
  s.add(-76)
  IF s.member(1) THEN WriteF('1 è un member\n')
  IF s.member(11) THEN WriteF('11 è un member\n')
  WriteF('s = ')
  s.print()
  WriteF('\n')
EXCEPT DO
  END s
  SELECT exception
  CASE "NEW"
    WriteF('Fuori memoria\n')
  CASE "full"
    WriteF('Set è pieno\n')
  ENDSELECT
ENDPROC
