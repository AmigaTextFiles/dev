OPT MODULE

MODULE  'oomodules/file/textfile/programSource',
        'oomodules/file/textfile/programSource/sourceBlock',
        'oomodules/list/queuestack',

        'oomodules/sort/string'

/*
 * The different Variable Types
 */

EXPORT ENUM  VT_LONG=0, -> Variable Type Long
      VT_CHAR,
      VT_INT,
      VT_OBJECT,
      VT_PTR_TO_CHAR,
      VT_PTR_TO_INT,
      VT_PTR_TO_LONG,
      VT_PTR_TO_OBJECT,
      VT_ARRAY_OF_CHAR,
      VT_ARRAY_OF_INT,
      VT_ARRAY_OF_LONG,
      VT_ARRAY_OF_OBJECT

EXPORT OBJECT eVar OF sourceBlock
/****** eVar/eVar ******************************

    NAME
        eVar() of sourceBlock --

    ATTRIBUTES
        name:PTR TO CHAR -- The name of the variable.

        varType:LONG -- Type identifier. one of the following:
            VT_LONG,
            VT_CHAR,
            VT_INT,
            VT_OBJECT,
            VT_PTR_TO_CHAR,
            VT_PTR_TO_INT,
            VT_PTR_TO_LONG,
            VT_PTR_TO_OBJECT,
            VT_ARRAY_OF_CHAR,
            VT_ARRAY_OF_INT,
            VT_ARRAY_OF_LONG,
            VT_ARRAY_OF_OBJECT

        varTypeModifier:LONG -- points to the object name if varType equals
            VT_OBJECT, VT_PTR_TO_OBJECT or VT_ARRAY_OF_OBJECT.

        arraySize:LONG -- the size of the array in bytes if the variable is
            an array.

        value:PTR TO CHAR -- fututre use.

    SEE ALSO
        sourceBlock

********/
  name:PTR TO CHAR
  varType:LONG
  varTypeModifier
  arraySize
  value:PTR TO CHAR
ENDOBJECT

EXPORT PROC name() OF eVar IS 'eVar'
/****** eVar/name ******************************

    NAME
        name() of eVar -- Return the name of the object.

    SYNOPSIS
        eVar.name()

    FUNCTION
        Returns string that contains the name of the object.

    RESULT
        PTR TO CHAR -- Constant string that reads 'eVar'

    SEE ALSO
        eVar

********/

EXPORT PROC buildVarListFromString(originalLine:PTR TO CHAR,lineNumber)
/****** /buildVarNameListFromString ******************************

    NAME
        buildVarListFromString() -- Build list of variables.

    SYNOPSIS
        buildVarListFromString(PTR TO CHAR, LONG)

        buildVarListFromString(originalLine, lineNumber)

    FUNCTION
        Takes a string and extracts the variable names from it. The names
        are tossed in freshly created eVar objects. The type is found out,
        too.

    INPUTS
        originalLine:PTR TO CHAR -- the line to search in. It si not
            modified.

        lineNumber:LONG -- The number to set te eVar.startLine attribute to.

    RESULT
        PTR TO LONG -- Elist of eVars.

    NOTES
        The strings in the object are allocated. You have to Dispose()
        them by yourself.

********/

DEF colonPosition,
    commaPosition,
    equalPosition, -> position of =
    line,
    name:PTR TO CHAR,
    len,
    startOfVarName,
    endOfVarName,
    varQS:PTR TO queuestack,
    var:PTR TO eVar,
    list

  NEW varQS.new()


  line := TrimStr(originalLine)


  IF StrCmp(line,'EXPORT DEF ', 11)
     commaPosition := 10
  ELSEIF StrCmp(line,'DEF ', 4)
    commaPosition := 3
  ELSE
    commaPosition := -1
  ENDIF
  

 /*
  * go through the loop until the comma is the last char on the line
  */

  WHILE((commaPosition+1)<StrLen(line))

    startOfVarName := commaPosition+1


   /*
    * first, skip spaces and tab after the comma
    */

    WHILE (line[startOfVarName]=32) OR (line[startOfVarName]=9)
      startOfVarName++
    ENDWHILE


   /*
    * get the position of the next comma after the last comma
    */

    equalPosition := InStr(line, '=', commaPosition+1)
    colonPosition := InStr(line, ':', commaPosition+1)

    commaPosition := InStr(line, ',', commaPosition+1)

->    WriteF('initial:   = = \d, : = \d, , = \d.\n',equalPosition,colonPosition,commaPosition)

->  WriteF('Comma at \d\n', commaPosition)
->  WriteF('Colon at \d\n', colonPosition)

   /*
    * If the colon lies behind the comma it belongs to the next var
    */

    IF (colonPosition>commaPosition) AND (commaPosition>-1) THEN colonPosition:=-1

   /*
    * If the = lies behind the comma it belongs to the next var
    */

    IF (equalPosition>commaPosition) AND (commaPosition<>-1) THEN equalPosition:=-1

   /*
    * if no type is specified, the colon's positon is -1 (not there)
    */

    IF colonPosition = -1 -> no type specified

     /*
      * if no comma is there, the last char of the var's name is the last char
      * of the line, otherwise it's the char before the comma (since no colon is
      * there)
      */

      endOfVarName := IF commaPosition = -1 THEN StrLen(line)-1 ELSE commaPosition-1

    ELSE

     /*
      * we have a colon, so the var name ends one char before it
      */

      endOfVarName := colonPosition-1

    ENDIF


    -> re-set the end of var name marker. If the = was found and valid it is
    -> the end marker

    IF equalPosition<>-1 THEN endOfVarName := equalPosition-1

->    WriteF('after processing: = = \d, : = \d, , = \d.\n',equalPosition,colonPosition,commaPosition)

    len := endOfVarName-startOfVarName+1
    name := String(len)

    IF name

->     WriteF('About to copy a string of len \d.\n',len)
      AstrCopy(name,line+startOfVarName,len+1)

->      WriteF('Copied \s.\n', name)
    ENDIF

    NEW var
    var.identifier := name

    var.getType(line, colonPosition)

    var.value := getValue(line, equalPosition)
    var.startLine := lineNumber

    varQS.addLast(var)


->    WriteF('Here I am.\n')
    EXIT (commaPosition = -1)

  ENDWHILE


  list := varQS.asList()

  END varQS

  RETURN list

ENDPROC



PROC getType(line:PTR TO CHAR, colonPosition) OF eVar
/****** eVar/getType ******************************

    NAME
        getType() of eVar -- Get the var's type.

    SYNOPSIS
        eVar.getType(PTR TO CHAR, LONG)

        eVar.getType(line, colonPosition)

    FUNCTION
        Takes a string that contains a variable definition and extracts the type
        from it. Does not check if the line really contains a variable
        definition. The according attributes of the eVar are set.

        The type is put in the varType attribute and can be of the follwing
        values:

          VT_LONG
          VT_CHAR,
          VT_INT,
          VT_OBJECT,
          VT_PTR_TO_CHAR,
          VT_PTR_TO_INT,
          VT_PTR_TO_LONG,
          VT_PTR_TO_OBJECT,
          VT_ARRAY_OF_CHAR,
          VT_ARRAY_OF_INT,
          VT_ARRAY_OF_LONG,
          VT_ARRAY_OF_OBJECT

    INPUTS
        line:PTR TO CHAR --  the line to search in.

        colonPosition:LONG -- where in the line the colon is.

    SEE ALSO
        eVar

********/
DEF varType:PTR TO CHAR,
    len,
    commaPosition,
    index,
    bracketPosition -> position of '[' in array declaration

  IF colonPosition = -1

     RETURN NIL

   ELSE

     commaPosition := InStr(line, ',',colonPosition)


    IF commaPosition = -1 -> we have no more vars in this line

      len := StrLen(line)-colonPosition-1   -> from colon to the end

    ELSE

      len := commaPosition-colonPosition-1

    ENDIF


   /*
    * Remove any trailing spaces
    */

    index:=len-1

    WHILE (line[colonPosition+index] = " ")
      line[colonPosition+index] := 0
      index--
    ENDWHILE

    len := index+1

  ENDIF -> delete this line if the old block in the following comment sgould be used again
/*
    varType := String(len)

    IF varType

      StrCopy(varType,line+colonPosition+1, len)

     ENDIF

  ENDIF

  RETURN varType
*/

/*
 * The len contains the length of the type string, i.e. 4 for LONG.
 * If it's less than 6 it can't be a pointer to an object.
 */

  IF len < 6
    IF StrCmp(line+colonPosition+1, 'CHAR',len)
      self.varType := VT_CHAR
      RETURN
    ENDIF

    IF StrCmp(line+colonPosition+1, 'INT',len)
      self.varType := VT_INT
      RETURN
    ENDIF

    IF StrCmp(line+colonPosition+1, 'LONG',len)
      self.varType := VT_LONG
      RETURN
    ENDIF

    IF StrCmp(line+colonPosition+1, 'ARRAY',len)
      self.varType := VT_ARRAY_OF_CHAR

      bracketPosition := InStr(self.identifier,'[')
      self.arraySize := Val(self.identifier+bracketPosition+1)

      self.identifier[bracketPosition] := 0

      RETURN
    ENDIF

   /*
    * If the proc didn't return at this point we have an object.
    * So return VT_OBJECT and set the type modifier to the name of the object.
    */

    varType := String(len)
    StrCopy(varType,line+colonPosition+1, len)

    self.varType := VT_OBJECT
    self.varTypeModifier := varType

    RETURN VT_OBJECT, varType

  ELSEIF InStr(line+colonPosition+1,'PTR TO')>-1

   /*
    * Here we check for the different PTR TO types.
    */

    IF StrCmp(line+colonPosition+1, 'PTR TO LONG',len)
      self.varType := VT_PTR_TO_LONG
      RETURN
    ENDIF

    IF StrCmp(line+colonPosition+1, 'PTR TO INT',len)
      self.varType := VT_PTR_TO_INT
      RETURN
    ENDIF

    IF StrCmp(line+colonPosition+1, 'PTR TO CHAR',len)
      self.varType := VT_PTR_TO_CHAR
      RETURN
    ENDIF

   /*
    * If the proc didn't return at this point we have an object.
    * So return VT_PTR_TO_OBJECT and set the type modifier to the name of the object.
    */

    varType := String(len-7)
    StrCopy(varType,line+colonPosition+1+7, len) -> 7 is the len of 'PTR TO '

    self.varType := VT_PTR_TO_OBJECT
    self.varTypeModifier := varType

    RETURN

  ELSEIF InStr(line+colonPosition+1,'ARRAY')>-1

   /*
    * Here we check for the different ARRAYs
    */

    IF StrCmp(line+colonPosition+1, 'ARRAY OF LONG',len)
      self.varType := VT_ARRAY_OF_LONG

      bracketPosition := InStr(self.identifier,'[')
      self.arraySize := Val(self.identifier+bracketPosition+1)

      self.identifier[bracketPosition] := 0

      RETURN
    ENDIF

    IF StrCmp(line+colonPosition+1, 'ARRAY OF INT',len)
      self.varType := VT_ARRAY_OF_INT

      bracketPosition := InStr(self.identifier,'[')
      self.arraySize := Val(self.identifier+bracketPosition+1)

      self.identifier[bracketPosition] := 0

      RETURN
    ENDIF

    IF StrCmp(line+colonPosition+1, 'ARRAY OF CHAR',len)
      self.varType := VT_ARRAY_OF_CHAR

      bracketPosition := InStr(self.identifier,'[')
      self.arraySize := Val(self.identifier+bracketPosition+1)

      self.identifier[bracketPosition] := 0

      RETURN
    ENDIF

   /*
    * If the proc didn't return at this point we have an object.
    * So return VT_ARRAY_OF_OBJECT and set the type modifier to the name of the object.
    */

    varType := String(len)
    StrCopy(varType,line+colonPosition+1+9, len) -> 9 is the len of 'ARRAY OF '

    self.varType := VT_ARRAY_OF_OBJECT
    self.varTypeModifier := varType

    bracketPosition := InStr(self.identifier,'[')
    self.arraySize := Val(self.identifier+bracketPosition+1)

    self.identifier[bracketPosition] := 0

    RETURN

  ENDIF

ENDPROC



EXPORT PROC appendVarListFromString(originalLine:PTR TO CHAR,lineNumber, list=NIL)
/****** /appendVarNameListFromString ******************************

    NAME
        appendVarNameListFromString() --

    SYNOPSIS
        appendVarNameListFromString(PTR TO CHAR, LONG, LONG=NIL)

        appendVarNameListFromString(originalLine, lineNumber, list)

    FUNCTION
        Takes a string that contains variable definitions and extracts the vars
        from it. Does not check if the line really contains variable definitions.

        The variables are put in a list which is appended to the one provided by
        the third parameter.

    INPUTS
        originalLine:PTR TO CHAR -- The line to search in.

        lineNumber:LONG -- A number that the startLine attribute of each variable
            will be set to.

        list:LONG -- Pointer to an elist that already contains other variable
            definitions. The list generated by this proc will be appended to
            it. If NIL just the new list is returned. Note that this pointer
            isn't valid after this proc, use the returned pointer.

    RESULT
        PTR TO LONG -- Pointer to new elist that contains initialized eVar
            objects.

********/
DEF nulist,
     qs:PTR TO queuestack

  NEW qs.new()

  IF list THEN qs.asQueueStack(list)
   qs.asQueueStack(buildVarListFromString(originalLine,lineNumber))

   Dispose(list)

  nulist := qs.asList()

   END qs

   RETURN nulist

ENDPROC



PROC amIPublic(line:PTR TO CHAR) OF eVar IS EMPTY
/****** eVar/amIPublic ******************************

    NAME
        amIPublic() of eVar -- Is the var public or not?

    SYNOPSIS
        eVar.amIPublic(PTR TO CHAR)

        eVar.amIPublic(line)

    FUNCTION
        Finds out if the variable is public, i.e. if it can be accessed from
        other modules as well.

    INPUTS
        line:PTR TO CHAR -- String that contains the variables definition.
            Usually the line that is referred to by the startLine attribute.

    RESULT
        TRUE if the variable is public, FALSE otherwise.

    EXAMPLE
        IF eVar.amIPublic(eVar.startLine)

          WriteF('Access me from other modules!')

        ENDIF

    NOTES
        The line argument may be a default argument in the future.

        Non functional now.

    SEE ALSO
        eVar

********/

PROC getValue(line:PTR TO CHAR, equalPosition)
/*
   NAME

       getValue() -- Get value of variable.

   FUNCTION

     Takes a string that contains variable definitions and extracts the value
     from it. Does not check if the line really contains variable definitions.

   INPUTS

     line:PTR TO CHAR

       The line to search in. It is not modified in any way.

     equalPosition

       The offset in the string where the next = is found. May be -1,
       NIL is returned in that case.

    RESULTS

      PTR TO CHAR or NIL

        Contains the type

    KNOWN BUGS

      If the string just contains one var definition eith an initial value
      (like 'anyvar=INITIAL_VALUE:LONG') the value attribute is set to
      the string after '=' (here: INITIAL_VALUE:LONG). The varType attribute
      is, however, set to the value you would expect.

*/
DEF varValue:PTR TO CHAR,
    len,
    commaPosition,
    colonPosition,
    endOfThisVar

  IF equalPosition = -1

     RETURN NIL

  ELSE

    commaPosition := InStr(line, ',',equalPosition)
    colonPosition := InStr(line, ':',equalPosition)

   -> if this is true the = belongs to the next var
    IF (commaPosition<>-1) AND (equalPosition>commaPosition) THEN RETURN NIL


   /*
    * We have to copy either
    * - from the = position to the end of the line (colon=-1, comma=-1)
    * - from the = position to the next colon (colon=x, comma<>-1 and comma>colon)
    * - from the = position to the next comma (colon=-1, comma=x)
    */

   /*
    * The end of the name declaration (including =) is
    * - at the end of the line if there's no comma
    * - in front of : if , is behind :
    */

    endOfThisVar := StrLen(line)
    IF commaPosition<>-1 THEN endOfThisVar := commaPosition-1
    IF (colonPosition <> -1) AND (commaPosition>colonPosition) THEN endOfThisVar := colonPosition-1


    len := endOfThisVar-equalPosition

->    WriteF('** = found at \d, len of default value is \d.\n', equalPosition, len)

    varValue := String(len)

    IF varValue

      StrCopy(varValue,line+equalPosition+1, len)

    ENDIF

   ENDIF

   RETURN varValue

ENDPROC




PROC sizeOfVar() OF eVar
/****** eVar/sizeOfVar ******************************

    NAME
        sizeOfVar() of eVar -- Get the size of the var.

    SYNOPSIS
        eVar.sizeOfVar()

    FUNCTION
        Find out the size of the var in bytes.

    RESULT
        Size of the variable or -1 if the variable is either an object or an
        array of an object.

    TODO
        Implement the calculation for objects.

    SEE ALSO
        eVar

********/
DEF type

  IF self.identifier = NIL THEN RETURN

  type := self.varType

  SELECT type

    CASE VT_LONG
      RETURN 4

    CASE VT_CHAR
      RETURN 1

    CASE VT_INT
      RETURN 2

    CASE VT_OBJECT
      RETURN -1

    CASE VT_PTR_TO_CHAR
      RETURN 4

    CASE VT_PTR_TO_INT
      RETURN 4

    CASE VT_PTR_TO_LONG
      RETURN 4

    CASE VT_PTR_TO_OBJECT
      RETURN 4

    CASE VT_ARRAY_OF_CHAR
      RETURN self.arraySize

    CASE VT_ARRAY_OF_INT
      RETURN  self.arraySize*SIZEOF INT

    CASE VT_ARRAY_OF_LONG
      RETURN  self.arraySize * SIZEOF LONG

    CASE VT_ARRAY_OF_OBJECT
      RETURN -1

    ENDSELECT


ENDPROC


/*
PROC getValueString(value) OF eVar
/****** eVar/getValueString ******************************

    NAME
        getValueString() of eVar --

    SYNOPSIS
        eVar.getValueString(LONG)

        eVar.getValueString(value)

    FUNCTION

    INPUTS
        value:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        eVar

********/
DEF str

  str := String(255)

  IF StrCmp(eVar.


ENDPROC

PROC getVarString() OF eVar
/****** eVar/getVarString ******************************

    NAME
        getVarString() of eVar --

    SYNOPSIS
        eVar.getVarString()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        eVar

********/

  IF
ENDPROC

*/


PROC getTypeString(string:PTR TO string) OF eVar
/****** eVar/getTypeString ******************************

    NAME
        getTypeString() of eVar -- Get the type as a string.

    SYNOPSIS
        eVar.getTypeString(PTR TO string)

        eVar.getTypeString(string)

    FUNCTION

    INPUTS
        string:PTR TO string -- Container object for the type. Will be
            automatically cleared. If NIL the proc returns immediately.

    RESULT
        LONG -- the size of the array if the eVar is an array, NIL otherwise

    NOTES
        Due to some crashes the string object will be ended and newed so
        don't rely on the address of it.

    SEE ALSO
        eVar, string/string

********/
DEF buffer[255]:STRING,
    typeIdent

  IF string = NIL THEN RETURN

 /*
  * 'clear' the string
  */

  END string
  NEW string.new()


  typeIdent := self.varType

  SELECT typeIdent

    CASE VT_LONG
      string.set('LONG')

      CASE VT_CHAR
        string.set('CHAR')

      CASE VT_INT
        string.set('INT')

      CASE VT_OBJECT
        string.set(self.varTypeModifier)

      CASE VT_PTR_TO_CHAR
        string.set('PTR TO CHAR')

      CASE VT_PTR_TO_INT
        string.set('PTR TO INT')

      CASE VT_PTR_TO_LONG
        string.set('PTR TO LONG')

      CASE VT_PTR_TO_OBJECT
        StringF(buffer, 'PTR TO \s',self.varTypeModifier)
        string.set(buffer)

      CASE VT_ARRAY_OF_CHAR
        string.set('ARRAY OF CHAR')
        RETURN self.arraySize

      CASE VT_ARRAY_OF_INT
        string.set('ARRAY OF INT')
        RETURN self.arraySize

      CASE VT_ARRAY_OF_LONG
        string.set('ARRAY OF LONG')
        RETURN self.arraySize

      CASE VT_ARRAY_OF_OBJECT
        StringF(buffer, 'ARRAY OF \s', self.varTypeModifier)
        string.set(buffer)
        RETURN self.arraySize

    ENDSELECT
ENDPROC

PROC getAutodocString(string:PTR TO string) OF eVar
/****** eVar/getAutodocString ******************************

    NAME
        getAutodocString() of eVar -- Get string to use in autodoc.

    SYNOPSIS
        eVar.getAutodocString(PTR TO string)

        eVar.getAutodocString(string)

    FUNCTION
        Creates an autodoc entry for that variable. This equals the string of
        characters that can be found at the INPUTS entry. The information
        for the creation are taken from the lists built when sucking the file
        and *not* directly from disk.

    INPUTS
        string:PTR TO string -- Container object for the resulting string of
            characters. If NIL the proc returns immediately.

    NOTES
        Due to some crashes the string object will be ended and newed so
        don't rely on the address of it.

    SEE ALSO
        eVar, string/string

********/
DEF buffer[255]:STRING,
    tempString:PTR TO string,
    arraySize

  NEW tempString.new()

 /*
  * 'clear' the string with brute force
  */

  END string
  NEW string.new()


  arraySize := self.getTypeString(tempString)


  IF arraySize

    StringF(buffer,'\s[\d]', self.identifier,arraySize)

  ELSE

    StringF(buffer,'\s', self.identifier)

  ENDIF

  string.set(buffer)

->  WriteF('\ntemp -- \s\n', string.write())

  SetStr(buffer, 0)


  IF self.value

    string.cat('=')
    string.cat(self.value)

  ENDIF

->  WriteF('temp -- \s\n', string.write())

  string.cat(':')
-> tempstring contains the type (see above)
  string.cat(tempString.write())


  END tempString

->  WriteF('temp -- \s\n\n', string.write())

ENDPROC

/*EE folds
-1
26 40 28 187 33 232 38 49 82 88 88 69 93 36 96 26 102 87 105 80 
EE folds*/
