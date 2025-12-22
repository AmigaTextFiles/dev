
MODULE   'oomodules/file/textfile/programSource/eSource',
         'oomodules/file/textfile/programSource/eSource/eObject',
         'oomodules/file/textfile/programSource/eSource/eProc',
         'oomodules/file/textfile/programSource/eSource/eVar',
         'oomodules/list/queuestack'

PROC main()
DEF source:PTR TO eSource

  NEW source.new(["suck", 'ram:textfile'])

  source.getInfo()
  source.getModules()

  IF source.hasModuleSetting() THEN WriteF('This is a module.\n')
  IF source.hasAsmSetting() THEN WriteF('Running in asm mode.\n')
  IF source.hasDirSetting() THEN WriteF('Default module directory changed.\n')
  IF source.hasRegSetting() THEN WriteF('Use register variables.\n')
  IF source.hasLargeSetting() THEN WriteF('LARGE model.\n')
  IF source.hasStackSetting() THEN WriteF('Stack changed.\n')

  printModulesNeeded(source)

  printInfo('Private Objects:', source.privateObjectList, source)
  WriteF('\n\n')

   printInfo('Public Objects:', source.publicObjectList, source)
   WriteF('\n\n')

   printInfo('Private Procs:', source.privateProcList, source)
   WriteF('\n\n')

   printInfo('Public Procs:', source.publicProcList, source)
   WriteF('\n\n')

ENDPROC

/*
PROC printSourcePart(source:PTR TO eSource,fromLine,toLine)
DEF oldLineNumber

  oldLineNumber := source.getCurrentLineNumber()

   source.setCurrentLineNumber(fromLine-1)

  REPEAT
    WriteF('\s\n', source.getNextLine())
  UNTIL source.getCurrentLineNumber()=toLine

   source.setCurrentLineNumber(oldLineNumber)
ENDPROC
*/
PROC printInfo(headerText:PTR TO CHAR,list:PTR TO LONG, source:PTR TO eSource)
DEF  index, 
     sourceBlock:PTR TO eSourceBlock

  WriteF('\s\n', headerText)

  WriteF('There are \d items in the list.\n', ListLen(list))

  FOR index := 1 TO ListLen(list)
    WriteF('\n')
    sourceBlock := ListItem(list,index-1)

->     WriteF(' line \d to \d\n',  sourceBlock.startLine,
->                                 sourceBlock.endLine)


      IF sourceBlock.type = EOBJECT
        printObjectInfo(sourceBlock)

     ELSEIF sourceBlock.type = EPROC
        printProcInfo(sourceBlock)

     ELSE

       WriteF('    \s\n', source.getLine(sourceBlock.startLine))
     ENDIF

   ENDFOR
ENDPROC

PROC printObjectInfo(eObject:PTR TO eObject)
DEF index

  WriteF('Object name: \a\s\a, size: \d\n', eObject.identifier, eObject.getSize())

  IF eObject.inheritsFrom THEN WriteF('Inherits from object \a\s\a.\n', eObject.inheritsFrom)

  IF eObject.entryList

    WriteF('Entries:\n')

    printVarList(eObject.entryList, eObject.offsetList)

    WriteF('\nThe object is \d bytes big.\n\n', ListItem(eObject.offsetList, ListLen(eObject.entryList)))
    WriteF('\nThe object is \d bytes big.\n\n', eObject.getSize())

  ENDIF  

 
ENDPROC

PROC printVarList(list,offsetList=NIL)
DEF index,
    eVar:PTR TO eVar,
    typeIdent

  FOR index := 0 TO ListLen(list)-1

    eVar := ListItem(list,index)

    IF offsetList
      WriteF('(\d) -- \s is', ListItem(offsetList,index),eVar.identifier)
    ELSE
      WriteF('\s is',eVar.identifier)
    ENDIF

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

    IF eVar.value THEN WriteF('Default value is \s.\n',eVar.value)

  ENDFOR

  WriteF('\n')
ENDPROC

PROC printProcInfo(eProc:PTR TO eProc)

  WriteF('Proc name: \a\s\a\n', eProc.identifier)

  IF eProc.methodOf THEN WriteF('This proc is a method of object: \s\n', eProc.methodOf)

  IF eProc.arguments
    WriteF('Arguments:\n')
    printVarList(eProc.arguments)
  ENDIF

  IF eProc.locals
    WriteF('Local variables:\n')
    printVarList(eProc.locals)
  ENDIF

ENDPROC

PROC printModulesNeeded(source:PTR TO eSource)
DEF index

  WriteF('\n These modules are required to run this source:\n')
  IF source.modulesNeeded
    FOR index:=0 TO ListLen(source.modulesNeeded)-1
      WriteF('  - \s\n', ListItem(source.modulesNeeded,index))
    ENDFOR
  ENDIF
ENDPROC
/*EE folds
-1
8 28 12 11 66 49 69 15 72 8 
EE folds*/
