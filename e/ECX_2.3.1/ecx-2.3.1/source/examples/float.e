DEF f, i, s[20]:STRING

PROC print_float()
  WriteF('\tf is \s\n', RealF(s, !f, 6))
ENDPROC

PROC print_both()
  WriteF('\ti is \d, ', i)
  print_float()
ENDPROC

/* Square a float */
PROC square_float(f) IS !f*f

/* Square an integer */
PROC square_integer(i) IS i*i

/* Converts a float to an integer */
PROC convert_to_integer(f) IS Val(RealF(s, !f, 0))

/* Converts an integer to a float */
PROC convert_to_float(i) IS RealVal(StringF(s, '\d', i))

/* This should be the same as Ftan */
PROC my_tan(f) IS !Fsin(!f)/Fcos(!f)

/* This should show float inaccuracies */
PROC inaccurate(f) IS Fexp(Flog(!f))

/* This should show float inaccuracies 2 */
PROC inaccurate2(f) IS Fsqrt(!f*f)

PROC main()
  WriteF('Next 2 lines should be the same\n')
  f:=2.75; i:=!f!
  print_both()
  f:=2.75; i:=convert_to_integer(!f)
  print_both()

  WriteF('Next 2 lines should be the same\n')
  i:=10;  f:=i!
  print_both()
  i:=10;  f:=convert_to_float(i)
  print_both()

  WriteF('f and i should be the same\n')
  i:=square_integer(i)
  f:=square_float(f)
  print_both()

  WriteF('Next 2 lines should be the same\n')
  f:=Ftan(.8)
  print_float()
  f:=my_tan(.8)
  print_float()

  WriteF('Next 2 lines should be the same\n')
  f:=0.35
  print_float()
  f:=inaccurate(f)
  print_float()

  WriteF('Next 2 lines should be the same\n')
  f:=1.35
  print_float()
  f:=inaccurate2(f)
  print_float()
ENDPROC
