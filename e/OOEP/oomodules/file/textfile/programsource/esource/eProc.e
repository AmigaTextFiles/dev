
OPT MODULE

MODULE  'oomodules/file/textfile/programSource',
        'oomodules/file/textfile/programSource/sourceBlock',
        'oomodules/file/textfile/programSource/eSource/eVar',

        'oomodules/sort/string'

EXPORT OBJECT eProc OF sourceBlock
/****** eProc/--eProc-- ******************************************

    NAME 
        eProc -- E procedure source block.

    PURPOSE
        E procedure handling. Useful when operating with eSources.

    ATTRIBUTES
        name:PTR TO CHAR -- The name of the procedure as found out by
            the method getName().

        methodOf:PTR TO CHAR -- If non-NIL the proc is a method of the
            object of which the name can be found in this string. Set
            by getName().

        arguments -- elist as returned by the method getArguments().
            Contains pointers to eVar objects as items.

        locals -- elist as returned by the method getArguments().
            Contains pointers to eVar objects as items. These objects
            represent the local variables of ths proc.

    SEE ALSO
        eVar/--eVar--, eSource/--eSource--
******************************************************************************

History


*/
  name:PTR TO CHAR
  methodOf:PTR TO CHAR
  arguments:PTR TO LONG  -> list of eVars
  locals:PTR TO LONG -> local vars
ENDOBJECT

EXPORT PROC name() OF eProc IS 'eProc'

EXPORT PROC getName(lineNumber=0) OF eProc
/****** eProc/getName ******************************************

    NAME 
        getName() -- Get the name of the procedure.

    SYNOPSIS
        PTR TO CHAR eProc.getName(LONG)

    FUNCTION
        Gets the procedure's name right from the source or returns the
        pointer to it if it has been found out before.

    INPUTS
        lineNumber:LONG=0 -- The number of the line where the procedure
            definition starts. Equals eProc.startLine.
    RESULT
        PTR TO CHAR -- The name of the procedure or NIL if an error ocurred.

    NOTES
        Does now handle the 'full E spectrum' of procedure declarations,
        this includes one-liners and methods.

        There is no test if the line where this proc should search for name
        does actually contain the header line of the proc. Do NOT call with
        any other value than the attribute startLine.

******************************************************************************

History


*/
DEF ofPosition,
    isPosition, -> IS...
    line,
    name:PTR TO CHAR,
    len,
    objectName:PTR TO CHAR,
    objectLen,
    startOfProcName,
    leftBracket

  IF self.identifier THEN RETURN self.identifier


  line := self.source.getLine(lineNumber)

  IF self.amIPublic(line) THEN startOfProcName := 12 ELSE startOfProcName := 5

  ofPosition := InStr(line, ' OF ')
  isPosition := InStr(line, ' IS ')
  leftBracket := InStr(line, '(')


  IF ofPosition>-1    -> OF is there, so it's a method

    len:= leftBracket-startOfProcName

    IF (isPosition=-1) -> no one-liner
      objectLen := StrLen(line)-(ofPosition+4)+1
    ELSE
      objectLen := isPosition-(ofPosition+4)
    ENDIF

    objectName := String(objectLen)


    IF objectName
      self.methodOf := objectName
      StrCopy(objectName,line+ofPosition+4, objectLen)
    ENDIF


  ELSE -> not method

    len := leftBracket-startOfProcName

  ENDIF

  name := String(len)


  IF name THEN StrCopy(name,line+startOfProcName,len)

  self.identifier := name

  RETURN self.identifier

ENDPROC


PROC amIPublic(line) OF eProc IS StrCmp(line,'EXPORT ',7)

PROC getArguments() OF eProc
DEF leftBracket,
     rightBracket,
     comma,
     colon,
     line,
     str[255]:STRING


   line := self.source.getLine(self.startLine) -> get first line


   leftBracket := InStr(line, '(')
   rightBracket := InStr(line, ')', leftBracket+1)


->if the right bracket is right after the left bracket there are no arguments

  IF rightBracket = 0 THEN RETURN

 /*
  * now we have the argument string, we just have to copy it and
  * get the vars from it
  */

  StrCopy(str, line+leftBracket+1, rightBracket-leftBracket-1)

  ->WriteF('*** \s\n', str)

 /*
  * get arguments and enter -1 as line number.
  */

  self.arguments := appendVarListFromString(str,-1)

ENDPROC


PROC getLocals() OF eProc
/****** eProc/getLocals ******************************************

    NAME 
        getLocals() -- Get list of local variables.

    SYNOPSIS
        PTR TO LONG eProc.getLocals()

    FUNCTION
        A elist is built in which each item represents an eVar object which
        is a local variable of the procedure.

    RESULT
        PTR TO LONG -- elist as built by eVar/appendVarNameListFromString()

    SEE ALSO
        eVar/--eVar--
******************************************************************************

History


*/
DEF oldLineNumber,
    startOfDefinition,
    line:PTR TO CHAR,
    list=NIL

  oldLineNumber := self.source.getCurrentLineNumber()

  startOfDefinition := self.source.findLine('DEF', self.startLine)

  IF (startOfDefinition=-1) OR (startOfDefinition>self.endLine) THEN RETURN NIL

  self.source.setCurrentLineNumber(startOfDefinition-1)

  REPEAT
    line := self.source.getNextLine()
->    WriteF('processing line \s.\n',line)
    list := appendVarListFromString(line,self.source.getCurrentLineNumber(),list)
  UNTIL line[StrLen(line)-1]<>","

  self.source.setCurrentLineNumber(oldLineNumber)

  self.locals := list

  RETURN list
ENDPROC

PROC getAutodocString(string:PTR TO string) OF eProc
DEF argumentList:PTR TO eVar,
    eVar:PTR TO eVar,
    index,
    tempString=NIL:PTR TO string,

    buffer[255]:STRING


  NEW tempString.new()

  IF string = NIL THEN RETURN


 /*
  * END the string and new it - it's totally 'freshed'.
  */

  END string
  NEW string.new()


 /*
  * Header line
  */

  StringF(buffer, '/****** \s/\s ********\n\n', self.methodOf, self.identifier)
  string.set(buffer)


 /*
  * 'clear' the buffer
  */

  SetStr(buffer,0)

 /*
  * The name entry
  */

  string.cat('    NAME\n        ')
  string.cat(self.identifier)


  IF self.methodOf

    string.cat(' of ')
    string.cat(self.methodOf)


  ENDIF


 /*
  * The synopsis entry
  */

  string.cat('\n\n    SYNOPSIS\n        ')


  IF self.methodOf

    string.cat(self.methodOf)
    string.cat('.')


  ENDIF

  string.cat(self.identifier)
  string.cat('(')


 /*
  * object.method(var1type, var2type, var3type)
  */


  IF self.arguments

    IF ListLen(self.arguments)>1

      FOR index := 0 TO ListLen(self.arguments)-2


        eVar := ListItem(self.arguments, index)
        eVar.getTypeString(tempString)

        string.cat(tempString.write())
        string.cat(', ')

      ENDFOR

    ENDIF


    IF ListLen(self.arguments)>0

      eVar := ListItem(self.arguments, ListLen(self.arguments)-1)
      eVar.getTypeString(tempString)

      string.cat(tempString.write())

    ENDIF

    string.cat(')\n\n        ')


   /*
    * object.method(var1name, var2name, var3name)
    */

    IF self.methodOf

      string.cat(self.methodOf)
      string.cat('.')

    ENDIF

    string.cat(self.identifier)
    string.cat('(')


    IF ListLen(self.arguments)>1

      FOR index := 0 TO ListLen(self.arguments)-2


        eVar := ListItem(self.arguments, index)

        string.cat(eVar.identifier)
        string.cat(', ')

      ENDFOR

    ENDIF


    IF ListLen(self.arguments)>0

      eVar := ListItem(self.arguments, ListLen(self.arguments)-1)

      string.cat(eVar.identifier)

    ENDIF

    string.cat(')\n\n')

  ENDIF


 /*
  * The FUNCTION entry
  */

  string.cat('    FUNCTION\n\n')


 /*
  * The INPUTS entry
  */

  string.cat('    INPUTS\n')

  IF self.arguments

    FOR index := 0 TO ListLen(self.arguments)-1


      eVar := ListItem(self.arguments, index)
      eVar.getAutodocString(tempString)

      string.cat('        ')
      string.cat(tempString.write())
      string.cat(' --\n')


    ENDFOR

    string.cat('\n')

  ENDIF


 /*
  * The RESULTS entry
  */

  string.cat('    RESULTS\n\n')

 /*
  * The remaining entries
  */

  string.cat('    EXCEPTIONS\n\n    KNOWN BUGS\n\n    NOTES\n\n    SEE ALSO\n\n')
  string.cat('********/')

  END tempString


ENDPROC

PROC getAutodocProc(string:PTR TO string) OF eProc
DEF lineNumber,
    tempString:PTR TO string

  IF string=NIL THEN RETURN

  END string
  NEW string.new()

  NEW tempString.new()

  string.cat(self.source.getLine(self.startLine))
  string.cat('\n')

  self.getAutodocString(tempString)
  string.cat(tempString.write())
  string.cat('\n')


  IF (self.endLine-self.startLine)>0

    FOR lineNumber := self.startLine+1 TO self.endLine

      string.cat(self.source.getLine(lineNumber))
      string.cat('\n')

    ENDFOR

  ENDIF

  END tempString

ENDPROC
/*EE folds
-1
433 31 
EE folds*/
