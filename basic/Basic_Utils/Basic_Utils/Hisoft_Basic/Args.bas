DIM Arg$(127)

FUNCTION NumArgs&
  SHARED Arg$()
  FOR t& = 1 TO 127
    arg$(t&)=""
  NEXT t&
  dummy&=0
  quote%=0
  arg$=" "+COMMAND$
  FOR t&=2 TO LEN(arg$)
    a$=MID$(arg$,t&,1)
    IF a$=CHR$(34)
      IF (quote%=0)
        quote%=-1
        dummy&=dummy&+1
      ELSE
        quote%=0
      END IF
    ELSE
      IF ((a$=" ") AND (quote%=0)) THEN a$=""
      IF ((MID$(arg$,t&-1,1)=" ") AND (quote%=0)) THEN dummy&=dummy&+1
      IF a$<>CHR$(34) THEN arg$(dummy&)=arg$(dummy&)+a$
    END IF
  NEXT t&
  NumArgs&=dummy&
END FUNCTION

*** Test *******************************************************************

'This piece of code provides access to the command line arguments in a very
'easy way: the array Arg$() contains the argument strings after calling
'the function NumArgs&. NumArgs& returns the number of argument strings.
'Note: Dimension the array Arg$() before using the function!

PRINT numargs&
FOR i = 1 TO NumArgs&
  PRINT arg$(i)
NEXT i
REM ************************************************************************
