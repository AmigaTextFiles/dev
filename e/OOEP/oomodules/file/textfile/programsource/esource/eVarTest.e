MODULE  'oomodules/file/textfile/programSource/eSource/eVar',

        'oomodules/sort/string'

DEF string:PTR TO string

PROC main()
DEF list=NIL


   WriteF('This is a test of the buildVarListFromString() proc.\n')

  list := testline('test:LONG',1,list)
  list := testline('DEF test:LONG,dummy=\atestbl\a,  howdy:PTR TO CHAR',2,list)
  list := testline('EXPORT DEF test:LONG,dummy',3,list)
  list := testline('aVariable=42',4,list)
  list := testline('aVariable:fu,    bVar:object',5,list)
  list := testline('bVar=objekt:PTR TO object,tüdelüüüt',6,list)

  list := testline('bVar[23]:ARRAY OF object',7,list)
  list := testline('bVar[1]:ARRAY OF LONG',8,list)
  list := testline('bVar[4]:ARRAY OF INT,bluub[40]:ARRAY OF CHAR',9,list)
  list := testline('bluub[40]:ARRAY OF CHAR',10,list)
  list := testline('bloooob[40]:ARRAY',11,list)

  printList(list)

ENDPROC

PROC testline(line:PTR TO CHAR,lineNumber,list)
DEF  index,
     eVar:PTR TO eVar

  WriteF('Line to process is: \a\s\a.\n',line)

  RETURN appendVarListFromString(line,lineNumber,list)

ENDPROC

PROC printList(list)
DEF index,
    eVar:PTR TO eVar,
    typeIdent

  FOR index := 0 TO ListLen(list)-1
    eVar := ListItem(list,index)

    WriteF('Line number \d:  \s is',eVar.startLine, eVar.identifier)

    typeIdent := eVar.varType


    SELECT typeIdent
      CASE VT_LONG
        WriteF(' a longword.\n')
      CASE VT_CHAR
        WriteF(' a character.\n')
      CASE VT_INT
        WriteF(' an integer.\n')
      CASE VT_OBJECT
        WriteF(' the object \s.\n', eVar.varTypeModifier)
      CASE VT_PTR_TO_CHAR
        WriteF(' a pointer to a character.\n')
      CASE VT_PTR_TO_INT
        WriteF(' a pointer to an integer.\n')
      CASE VT_PTR_TO_LONG
        WriteF(' a pointer to a longword.\n')
      CASE VT_PTR_TO_OBJECT
        WriteF(' a pointer to the object \s.\n', eVar.varTypeModifier)
      CASE VT_ARRAY_OF_CHAR
        WriteF(' an array of \d characters.\n', eVar.arraySize)
      CASE VT_ARRAY_OF_INT
        WriteF(' an array of \d integers.\n', eVar.arraySize)
      CASE VT_ARRAY_OF_LONG
        WriteF(' an array of \d longwords.\n', eVar.arraySize)
      CASE VT_ARRAY_OF_OBJECT
        WriteF(' an array of \d \s objects.\n', eVar.arraySize, eVar.varTypeModifier)

    ENDSELECT

    NEW string.new()

    eVar.getAutodocString(string)
    WriteF('Autodoc line: \s\n', string.write())

    END string

    Dispose(eVar.identifier)
    IF eVar.varType THEN Dispose(eVar.varType)

    END eVar
  ENDFOR

  Dispose(list)
ENDPROC
