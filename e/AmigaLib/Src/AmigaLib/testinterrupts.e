MODULE 'amigalib/interrupts',
       'dos/dos',
       'graphics/graphint'

DEF var

PROC main()
  DEF i:isrvstr
  var:=0
  WriteF('var = \d\n', var)
  addTOF(i, {test_int}, {var})
  WriteF('var = \d\n', var)
  Wait(SIGBREAKF_CTRL_C)
  WriteF('var = \d\n', var)
  remTOF(i)
ENDPROC

PROC test_int(addr:PTR TO LONG)
  addr[]:=addr[]+1
ENDPROC
