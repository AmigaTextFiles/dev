-> Test for the 'extended_double.m' module by Deniil 715!

MODULE 'mathieeedoubtrans', '*extended_double'

PROC main()
 DEF x, y, double64:ieee_dbl, extended80:sane_ext, float32
 IF mathieeedoubtransbase:=OpenLibrary('mathieeedoubtrans.library',0)

  float32:=3.141596         -> just a number in 32 bit ieee, known as
                            -> 'float' in C.
  x,y:=IeeeDPFieee(float32) -> convert it to 64 bit ieee, known as
                            -> 'double' in C.
  double64.hi:=x            -> put the 2*32 values into an object
  double64.lo:=y
  double_to_extended(double64, extended80) -> convert the double to an
                            -> 80 bit sane float, known as 'extended'
                            -> or 'long double' in *some* C-compilers.

-> .... use the 80bit float, extended80, which aslo could have been
-> defined as:   DEF extended80[10]:ARRAY

  extended_to_double(extended80, double64) -> convert it back to
                                           -> double.
  float32:=IeeeDPTieee(double64.hi, double64.lo) -> convert the double
                                                 -> back to float.
  x:=!float32!              -> Make an int of the float.
  WriteF('x=\d\n',x)        -> Print the int, should show '3'.

  CloseLibrary(mathieeedoubtransbase)
 ELSE
  WriteF('Could not open mathieeedoubtrans.library v0!\n')
 ENDIF
ENDPROC
