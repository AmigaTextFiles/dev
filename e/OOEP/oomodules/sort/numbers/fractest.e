MODULE 'oomodules/sort/numbers/fraction'

PROC main()
DEF bruch_1:PTR TO fraction,
    bruch_2:PTR TO fraction, zkette[80]:STRING

  NEW bruch_1.new(["set",2,3])
  NEW bruch_2.new(["copy",bruch_1])

  WriteF('\s\n', bruch_1.write())
  WriteF('+\n\s\n', bruch_2.write())

  bruch_1.add( bruch_2 )

  WriteF('=\n\s\n', bruch_1.write())

  bruch_1.substract( bruch_2 )

  WriteF('-\n\s\n', bruch_2.write())

  WriteF('=\n\s\n', bruch_1.write())



  WriteF('now multiply...\n\n')

  bruch_1.opts(["set",2,3])

  WriteF('\s\n', bruch_1.write())

  bruch_2.opts(["set",2,4])

  WriteF('*\n\s\n', bruch_2.write())

  bruch_1.multiply( bruch_2 )

  WriteF('=\n\s\n', bruch_1.write())



  WriteF('now divide...\n\n')

  bruch_1.opts(["set",2,3])

  WriteF('\s\n', bruch_1.write())

  bruch_2.opts(["set",2,5])

  WriteF('/\n\s\n', bruch_2.write())

  bruch_1.divide( bruch_2 )

  WriteF('=\n\s\n', bruch_1.write())

  -> now just copy

  bruch_1.opts(["set", 3,7])
  bruch_1.copy( bruch_2 )

  WriteF('\s\n', bruch_1.write())
  WriteF('\s\n', bruch_2.write())

  bruch_1.flt2fraction(2.25)
  WriteF('\s\n', bruch_1.write())
  bruch_1.flt2fraction(7.9675)
  WriteF('\s\n', bruch_1.write())
  bruch_1.flt2fraction(3.1415926)
  WriteF('\s\n', bruch_1.write())

  RealF(zkette,bruch_1.fraction2flt(),5)
  WriteF('\s\n', zkette)
ENDPROC
