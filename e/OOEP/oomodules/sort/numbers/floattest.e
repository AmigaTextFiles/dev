MODULE 'oomodules/sort/numbers/float'

PROC main()
DEF flt:PTR TO float,
    fl2:PTR TO float

  NEW flt.new()
  NEW fl2.new()

  flt.set(3.5)
  fl2.set(2.0)

  WriteF('a=\s\n', flt.write())

  flt.add(fl2)

  WriteF('+b=\s\n', flt.write())

  flt.substract(fl2)

  WriteF('-b=\s\n', flt.write())

  flt.neg()

  WriteF('-a=\s\n', flt.write())

  flt.divide(fl2)

  WriteF('a/-b=\s\n', flt.write())
ENDPROC
