MODULE 'amigalib/interrupts',
       'dos/dos',
       'graphics/graphint'

DEF var

-> This example using an interrupt to toggle which string to print.
-> Try running it in a Shell, then try redirecting output to a file.
-> Look at the difference in the number of times it prints the same
-> string (i.e., how many times it gets to complete a WriteF before
-> the interrupt occurs),
PROC main()
  DEF i:isrvstr, strs:PTR TO LONG, x, y, z
  strs:=['hello\n', 'goodbye\n']
  var:=0
  x:=0; y:=0
  WriteF('var = \d\n', var)
  addTOF(i, {test_int}, {var})
  WriteF('var = \d\n', var)
  REPEAT
    z:=var
    IF z<>y
      x:=0; y:=z
    ENDIF
    WriteF('\d \s', x++, strs[z])
  UNTIL CtrlC()
  WriteF('var = \d\n', var)
  remTOF(i)
ENDPROC

PROC test_int(addr:PTR TO LONG)
  addr[]:=1-addr[]
ENDPROC
