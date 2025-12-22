DEF f, i, s[20]:STRING

PROC print_float()
  WriteF('\tf è \s\n', RealF(s, !f, 8))
ENDPROC

PROC print_both()
  WriteF('\ti è \d, ', i)
  print_float()
ENDPROC

/* Square a float */
PROC square_float(f) IS !f*f

/* Un intero al quadrato */
PROC square_integer(i) IS i*i

/* Converte un float in un intero */
PROC convert_to_integer(f) IS Val(RealF(s, !f, 0))

/* Converte un intero in un float */
PROC convert_to_float(i) IS RealVal(StringF(s, '\d', i))

/* Questa dovrebbe essere uguale a Ftan */
PROC my_tan(f) IS !Fsin(!f)/Fcos(!f)

/* Questa dovrebbe mostrare le inesattezze float */
PROC inaccurate(f) IS Fexp(Flog(!f))

PROC main()
  WriteF('Le prossime 2 linee dovrebbero essere uguali\n')
  f:=2.75; i:=!f!
  print_both()
  f:=2.75; i:=convert_to_integer(!f)
  print_both()

  WriteF('Le prossime 2 linee dovrebbero essere uguali\n')
  i:=10;  f:=i!
  print_both()
  i:=10;  f:=convert_to_float(i)
  print_both()

  WriteF('f ed i dovrebbero essere uguali\n')
  i:=square_integer(i)
  f:=square_float(f)
  print_both()

  WriteF('Le prossime due linee dovrebbero essere uguali\n')
  f:=Ftan(.8)
  print_float()
  f:=my_tan(.8)
  print_float()

  WriteF('Le prossime 2 linee dovrebbero essere uguali\n')
  f:=.35
  print_float()
  f:=inaccurate(f)
  print_float()
ENDPROC
