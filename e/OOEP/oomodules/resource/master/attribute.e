OPT MODULE
OPT LARGE

MODULE  'oomodules/file/textfile/programsource/esource',
        'oomodules/file/textfile/programsource/esource/eObject',
        'oomodules/file/textfile/programsource/esource/eVar',
        'oomodules/resource',
        'oomodules/object',
        'oomodules/list/queuestack',
        'oomodules/library/reqtools'

EXPORT DEF  requester:PTR TO reqtools,
            tempList


EXPORT PROC getAttributeList(name:PTR TO CHAR,filename=NIL:PTR TO CHAR)
-> returns elist of attribute names (copied!) and PTR TO eObject

-> gets object of the name from file filename. returns attribute list
-> and pointer to object

DEF file[255]:STRING,
    eObject:PTR TO eObject,
    parentObject:PTR TO eObject,
    eVar:PTR TO eVar,
    varList,
    nuList,
    index,
    objectName[255]:STRING,
    source:PTR TO eSource,
    str:PTR TO CHAR,
    inFile

  IF name=NIL THEN RETURN
  IF StrLen(name)=0 THEN RETURN

  StrCopy(objectName,name)
  LowerStr(objectName)

  IF filename=NIL
    requester.file('Where is the object defined?')

    StrCopy(file,requester.dirbuf)
    AddPart(file,requester.filebuf,255)
  ELSE
    StrCopy(file,filename)
  ENDIF

  IF file[0]=0 THEN RETURN

  NEW source.new(["suck",file])

  source.getInfo()
  source.getModules()

  eObject := source.getObject(objectName)

  IF eObject = NIL
    END source
    RETURN
  ENDIF


  IF (eObject.entryList=NIL)
    END source
    RETURN
  ENDIF


/*

  a length of 0 is valid

  IF ListLen(eObject.entryList)=0
    END source
    RETURN
  ENDIF
*/

  varList := List(ListLen(eObject.entryList))

  IF varList = NIL
    END source
    RETURN
  ENDIF


  FOR index := 0 TO ListLen(eObject.entryList)-1

/*
    eVar := ListItem(eObject.entryList, index)
    str := String(StrLen(eVar.identifier))
    StrCopy(str,eVar.identifier)
    ListAdd(varList,[str],1)
->    WriteF('__ attribute \s\n', str)
*/

    eVar := ListItem(eObject.entryList, index)
    ListAdd(varList,[eVar],1)

  ENDFOR

  parentObject,inFile := eObject.getParentObject()

  IF parentObject

->    WriteF('got parent object \s (at address \d) in file \s.\n', parentObject.identifier,parentObject,inFile)
  

   /*
    * Get the attribute list. Do not take the second return value since
    * that is the pointer to the parent object (which is already in
    * parentObject -- eObject is the pointer to the current object)
    */

    tempList := getAttributeList(parentObject.identifier,inFile)

->    WriteF('got object \s.attribute lst is \d.\n',eObject.identifier,tempList)

    END parentObject.source

    DisposeLink(inFile)

  
    IF tempList
    
      nuList := List(ListLen(varList)+ListLen(tempList))

    ELSE

      nuList := List(ListLen(varList))

    ENDIF

    IF nuList

      IF tempList

        FOR index := 0 TO ListLen(tempList)-1

          ListAdd(nuList, [ListItem(tempList,index)], 1)

        ENDFOR

      ENDIF

      FOR index := 0 TO ListLen(varList)-1

        ListAdd(nuList, [ListItem(varList,index)], 1)

      ENDFOR

      Dispose(varList)
      varList := nuList

    ENDIF

    IF tempList THEN DisposeLink(tempList)

  ENDIF



  END source

->  FOR index:=0 TO ListLen(varList)-1 DO WriteF('\s\n', ListItem(varList,index))

  RETURN varList, eObject

ENDPROC

EXPORT PROC getAttributeValueString(attribute:PTR TO eVar, eObject:PTR TO eObject, offset)
DEF type,
    str,
    eVar:PTR TO eVar,
    formatString:PTR TO CHAR,
    stringLen


 /*
  * search for the attribute in the attribute list


  FOR index := 0 TO ListLen(eObject.entryList)-1

    eVar := ListItem(eObject.entryList, index)
    EXIT StrCmp(eVar.identifier, attributeName)

  ENDFOR
*/


  type := attribute.varType

  SELECT type

    CASE VT_LONG
      stringLen := 16
      formatString := '\ld'

    CASE VT_CHAR
      stringLen := 8
      formatString := '\c (\d)'

    CASE VT_INT
      stringLen := 8
      formatString := '\d'

    CASE VT_OBJECT
      stringLen := 16
      formatString := '\ld'

    CASE VT_PTR_TO_CHAR
      stringLen := 16
      formatString := '\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c...'

    CASE VT_PTR_TO_INT
      stringLen := 16
      formatString := '\ld'

    CASE VT_PTR_TO_LONG
      stringLen := 16
      formatString := '\ld'

    CASE VT_PTR_TO_OBJECT
      stringLen := 16
      formatString := '\ld'

    CASE VT_ARRAY_OF_CHAR
      stringLen := eVar.arraySize*3 -> text should be '\c, ' for each char
      formatString := '\c'

    CASE VT_ARRAY_OF_INT
      stringLen := eVar.arraySize*5 -> '255, '
      formatString := '\d'

    CASE VT_ARRAY_OF_LONG
      stringLen := eVar.arraySize*12 -> '42341278, '
      formatString := '\ld'

    CASE VT_ARRAY_OF_OBJECT
      stringLen := 16
      formatString := 'array of object'

    ENDSELECT


  str := String(stringLen)

  IF str

    StringF(str,formatString,eObject+offset) -> put value in string

    RETURN str

  ELSE

    RETURN NIL

  ENDIF

ENDPROC

PROC filterAttributeList(attributes:PTR TO LONG)
-> just remove PRIVATE and PUBLIC
ENDPROC
