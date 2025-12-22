MODULE 'icon',
       'amigalib/argarray'

ENUM ERR_NONE, ERR_LIB

RAISE ERR_LIB IF OpenLibrary()=NIL

PROC main() HANDLE
  DEF p:PTR TO LONG, i=0
  iconbase:=OpenLibrary('icon.library', 33)
  IF p:=argArrayInit()  -> Result is a NIL-terminated list of strings
    WriteF('Integer value of "ARG_ONE" is \d (default is 2)\n',
           argInt(p, 'ARG_ONE', 2))
    WriteF('String value of "OTHER" is "\s" (default is "fred")\n',
           argString(p, 'OTHER', 'fred'))
    WriteF('\nActual arguments are:\n')
    WHILE p[] DO WriteF('\d[2]: "\s"\n', i++, p[]++)
    WriteF('Total: \d arguments\n', i)
    argArrayDone()
  ENDIF
EXCEPT DO
  IF iconbase THEN CloseLibrary(iconbase)
ENDPROC