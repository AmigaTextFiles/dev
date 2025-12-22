-> istr.e

->>> Header (globals)
MODULE 'utility'

ENUM ERR_NONE, ERR_LIB

RAISE ERR_LIB IF OpenLibrary()=NIL
->>>

->>> PROC main()
PROC main() HANDLE
  DEF butter, bread, ch1, ch2, result
  butter:='Bøtervløøt'
  bread:='Knåckerbrøt'

  utilitybase:=OpenLibrary('utility.library', 37)

  result:=Stricmp(butter, bread)

  WriteF('Comparing \s with \s yields \d\n', butter, bread, result)

  result:=Strnicmp(bread, butter, StrLen(bread))

  WriteF('Comparing (with length) \s with \s yields \d\n', bread, butter, result)

  ch1:=ToUpper($E6)  -> æ ASCII character 230 ae ligature
  ch2:=ToLower($D0)  -> Ð ASCII character 208 Icelandic Eth

  WriteF('Chars \c \c\n', ch1, ch2)
EXCEPT DO
  -> E-Note: C version forgets to close the library!
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_LIB;  WriteF('Error: could not open utility library\n')
  ENDSELECT
ENDPROC
->>>

