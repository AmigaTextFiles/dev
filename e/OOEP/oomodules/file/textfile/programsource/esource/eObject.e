OPT MODULE
OPT PREPROCESS
OPT LARGE

MODULE  'oomodules/file/textfile/programSource',
        'oomodules/file/textfile/programSource/sourceBlock',
        'oomodules/file/textfile/programSource/eSource',
        'oomodules/file/textfile/programSource/eSource/eVar',
        'oomodules/file/textfile/programSource/eSource/eComment',

        'oomodules/file/textfile/programSource/eSource/misc'

->#define SURFACE_DEBUG
->#define DEEP_DEBUG

EXPORT OBJECT eObject OF sourceBlock
/****** sourceBlock/eObject ******************************

    NAME
        eObject() of sourceBlock --

    ATTRIBUTES
        name:PTR TO CHAR -- 

        inheritsFrom:PTR TO CHAR -- 

        entryList:PTR TO LONG -- elist of attributes of this object. Contains
            pointers to eVars. May be NIL if no attributes are present.

        offsetList:PTR TO LONG -- elist of byte offsets of the attributes.
            For this object this would be [0,4,8,12,16]. Note that this list
            one item longer than the entryList for the last item contains
            the size of this object in bytes. However, this length does not
            include the function table for the methods.

    SEE ALSO
        sourceBlock

********/
  name:PTR TO CHAR
  inheritsFrom:PTR TO CHAR
  entryList:PTR TO LONG
  offsetList:PTR TO LONG
ENDOBJECT

EXPORT PROC name() OF eObject IS 'eObject'
/****** eObject/name ******************************

    NAME
        name() of eObject -- Return object identifier.

    SYNOPSIS
        eObject.name()

    FUNCTION
        Returns 'eObject'

    SEE ALSO
        eObject

********/

EXPORT PROC getName(lineNumber=0) OF eObject
/****** eObject/getName ******************************

    NAME
        getName() of eObject -- Get the name of the object from the source.

    SYNOPSIS
        eObject.getName(LONG=0)

        eObject.getName(lineNumber)

    FUNCTION
        Gets the name of this object from the source. If the name was already
        found out just the pointer to this name is returned.

    INPUTS
        lineNumber:LONG -- The number of the line the object definition
            starts, i.e. object.startLine

    RESULT
        PTR TO CHAR -- the name of the object

    SEE ALSO
        eObject

********/
DEF ofPosition,
     line,
     name:PTR TO CHAR,
     len,
     inheritsName:PTR TO CHAR,
     inheritanceLen,
     startOfObjectName

  IF self.identifier THEN RETURN self.identifier


  line := self.source.getLine(lineNumber)

  IF self.amIPublic(line) THEN startOfObjectName := 14 ELSE startOfObjectName := 7

  ofPosition := InStr(line, ' OF ')


  IF (ofPosition>-1)    -> OF is there, so it inherits

    #ifdef DEEP_DEBUG
    WriteF('Object inherits.\n')
    #endif
  
    len:= ofPosition-startOfObjectName


    inheritanceLen := StrLen(line)-(ofPosition+4)+1
    inheritsName := String(inheritanceLen)

    
     IF inheritsName
       self.inheritsFrom := inheritsName
       StrCopy(inheritsName,line+ofPosition+4, inheritanceLen)
     ENDIF


   ELSE -> no inheritance

     len := StrLen(line)-startOfObjectName

   ENDIF


  name := String(len)


  IF name THEN StrCopy(name,line+startOfObjectName,len)

  self.identifier:= name

  RETURN name

ENDPROC

PROC amIPublic(line) OF eObject IS StrCmp(line,'EXPORT ',7)
/****** eObject/amIPublic ******************************

    NAME
        amIPublic() of eObject -- Is this object visible outside the module?

    SYNOPSIS
        eObject.amIPublic(LONG)

        eObject.amIPublic(line)

    FUNCTION
        Identifies this object as public or private.

    INPUTS
        line:LONG -- Number of the proc's header line. Usually startLine.

    RESULT
        TRUE if the object is public, FALSE otherwise.

    EXAMPLE
        public := object.amIPublic(object.startLine)

    NOTES
        Does not check if the EXPORT option is set for this module.

    SEE ALSO
        eObject

********/

PROC getEntries() OF eObject
/****** eObject/getAttributeOffset ******************************

    NAME
        getEntries() of eObject -- Get list of attributes.

    SYNOPSIS
        eObject.getEntries()

    FUNCTION
        Builds an elist of attributes this object posesses. The entries 
        of this list are initialized eVar objects.

    RESULT
        PTR TO LONG -- elist of eVars which represent the attributes of this
            object. A value of NIL represents no attributes.

    SEE ALSO
        eObject, eVar/eVar

********/
DEF lineNumber,
    entryList=NIL,
    startOfComment,kindOfComment,
    line, trimmedLine,
    oldLineNumber,
    multiLineCommentStart,

    originalLine,
    copiedLine

 /*
  * Return instantly if the object has no entries at all
  */

  IF self.endLine = (self.startLine+1) THEN RETURN NIL


 /*
  * Search for entries in these bounds
  */


  FOR lineNumber := self.startLine+1 TO self.endLine-1

   /*
    * is the line commented?
    */

    originalLine := self.source.getLine(lineNumber)

    copiedLine := originalLine

->    WriteF('line in (about to strip PRIVATE) -- \s\n', originalLine)
    copiedLine := copyLineAndStripWord(originalLine,'PRIVATE')
->    WriteF('line out -- \s(len=\d)\n', copiedLine,StrLen(copiedLine))

    IF copiedLine AND (StrLen(copiedLine)>0) THEN copiedLine := copyLineAndStripWord(copiedLine,'PUBLIC')
->    WriteF('line out(priv): \s (len=\d)\n', copiedLine, StrLen(copiedLine))
    IF copiedLine AND (StrLen(copiedLine)>0)

->      WriteF('entered iner loop\n')
  ->  WriteF('line out(pub): \s(len=\d)\n', copiedLine,StrLen(copiedLine))

      startOfComment,kindOfComment := isCommented(copiedLine)

      IF kindOfComment <> "none"


       /*
        * We need this later
        */

        multiLineCommentStart := isMultiLineCommentStart(copiedLine)

       /*
        * If comment is present, strip it
        */

        line := stripCommentFromLine(copiedLine)

      ELSE

        line := copiedLine

      ENDIF


     /*
      * If the line exists, trim it, then try to get the entries from it  
      */  

      IF line

        trimmedLine := TrimStr(line)

        IF StrLen(trimmedLine) THEN entryList := appendVarListFromString( trimmedLine,  lineNumber, entryList)

       /*
        * If there was a comment, we passed the line to stripCommentFromLine()
        * That proc returns a newly created 'pure' line, so we have to dispose it.
        */

        IF kindOfComment<>"none" THEN Dispose(line)

      ENDIF


     /*
      * If we have a multiple line comment we skip the lines between this and the last
      * last line.
      */


      IF (kindOfComment = "mult") AND (multiLineCommentStart<>-1)

        oldLineNumber := self.source.getCurrentLineNumber()
        self.source.setCurrentLineNumber(lineNumber)

        goToEndOfMultiLineComment(self.source,0) 

        lineNumber := self.source.getCurrentLineNumber() -> the proc call above set the number right
        self.source.setCurrentLineNumber(oldLineNumber)

        lineNumber := lineNumber-1
  
      ENDIF

      DisposeLink(copiedLine)

    ENDIF

  ENDFOR

 /*
  * Provide an emtpy list if the procs called above didn't create an attribute
  * list. A length of 0 means there are no attributes, NIL for the list value
  * says that there was an error.
  *
  * Temporary workaround, has to be rethought.
  */

  IF entryList=NIL THEN entryList := List(0)

->  WriteF('\nAbout to return list of attributes at address \d (len \d).\n\n', entryList, ListLen(entryList))
  RETURN entryList

ENDPROC

PROC buildOffsetList() OF eObject
/****** eObject/buildOffsetList ******************************

    NAME
        buildOffsetList() of eObject -- Build list of attribute offsets.

    SYNOPSIS
        eObject.buildOffsetList()

    FUNCTION
        Build an elist which contains the byte offets of the attributes.
        Sets the according attribute to this list.

    SEE ALSO
        eObject

********/
DEF index,
    actualOffset,
    var:PTR TO eVar,
    varsize,
    parentObject:PTR TO eObject,
    parentObjectSize,
    offsetListLen,
    offsetList,
    inheritedSize

->  WriteF('building offset list for obhect \a\s\a.\n\n', self.name)

  IF self.entryList=NIL THEN RETURN

  IF ListLen(self.entryList)=0 THEN RETURN

  
  offsetListLen := ListLen(self.entryList)+1
-> doesn't work somehow:  self.offsetList := List(ListLen(self.entryList)+1)

  self.offsetList := List(offsetListLen)
  IF self.offsetList = NIL THEN RETURN


->  WriteF('\nOffset list for object \s: \t\d\n', self.identifier,self.offsetList)
  offsetList := self.offsetList


  actualOffset := 0

  IF offsetList
    FOR index := 0 TO ListLen(self.entryList)-1

      var := ListItem(self.entryList, index)
      varsize := IF var THEN var.sizeOfVar() ELSE 0

      actualOffset := actualOffset+varsize


     /*
      * If there is a var size that's even and the offset is odd
      * we have to make the offset even (add 1). This is for the mc68000
      * can address words and lognwords only even addresses.
      */

      IF (Mod(varsize,2)=0) AND (Mod(actualOffset,2)=1)
        INC actualOffset
        self.offsetList[index] := self.offsetList[index]+1
      ENDIF

      self.offsetList[index+1] := actualOffset

      #ifdef SURFACE_DEBUG
      WriteF('( \d )\n', actualOffset)
      #endif

    ENDFOR


  #ifdef DEEP_DEBUG
  WriteF('begin of buildOffsetList(): Object \s: size is \d.\n',self.identifier, actualOffset)
  #endif

 /*
  * now rebuild the offsets with the size if necessary
  */

  IF offsetList AND self.inheritsFrom

    inheritedSize := self.getInheritedSize()

->    WriteF('The inherited size is \d.\n', inheritedSize)

->    WriteF('\nOffset list for object \s: \t\d\n', self.identifier,offsetList)

    FOR index := 0 TO ListLen(self.entryList)

->      WriteF('Before: \d\n',ListItem(offsetList,index))
      actualOffset := ListItem(offsetList, index)
      actualOffset := actualOffset+inheritedSize
      self.offsetList[index] := actualOffset
->      WriteF('After:  \d\n',ListItem(offsetList,index))
      #ifdef SURFACE_DEBUG
      WriteF('( \d )\n', actualOffset)
      #endif

    ENDFOR

    #ifdef SURFACE_DEBUG
    WriteF('Offset list rebuilt. Ending parent object (\d) .\n', parentObject)
    WriteF('The new obhect size for object \s in now \d.\n', self.identifier,self.offsetList[offsetListLen-1])
    #endif



  ENDIF
/*
  parentObject := self.getParentObject()

  #ifdef DEEP_DEBUG
  WriteF('Tried to get parent object.\n')
  #endif

  IF parentObject

    #ifdef DEEP_DEBUG
    WriteF('buildOffsetList(): Got parent object. Trying to get the size of it.\n')
    #endif

->    #ifdef DEBUG
->    WriteF('buildOffsetList(): parent object\as name is \s.\n',parentObject.identifier)
->    #endif

    parentObjectSize := parentObject.getSize()


    #ifdef SURFACE_DEBUG
    WriteF('buildOffsetList(): Got parent object\as size, it\as \d. Rebuilding offset list now\n', parentObjectSize)
    #endif

  #ifdef DEEP_DEBUG
  WriteF('\nOffset list for object \s: \t\d\n', self.identifier,offsetList)
  #endif

    FOR index := 0 TO ListLen(self.entryList)

      #ifdef DEEP_DEBUG
      WriteF('Before: \d\n',ListItem(offsetList,index))
      #endif

      actualOffset := ListItem(offsetList, index)

      actualOffset := actualOffset+parentObjectSize

      self.offsetList[index] := actualOffset

      #ifdef DEEP_DEBUG
      WriteF('After:  \d\n',ListItem(offsetList,index))

      WriteF('( \d )\n', actualOffset)
      #endif

    ENDFOR

    #ifdef DEEP_DEBUG
    WriteF('Offset list rebuilt. Ending parent object (\d) .\n', parentObject)
    WriteF('The new obhect size for object \s in now \d.\n', self.identifier,self.offsetList[offsetListLen-1])
    #endif

    END parentObject
*/

  ELSE

    #ifdef SURFACE_DEBUG
    WriteF('buildOffsetList(): No parent object found.\n')
    #endif

  ENDIF

  
 
ENDPROC


/*
EXPORT PROC getAttributeOffset(number:LONG) OF eObject
/****** eObject/getAttributeOffset ******************************

    NAME
        getAttributeOffset() of eObject --

    SYNOPSIS
        eObject.getAttributeOffset(LONG)

        eObject.getAttributeOffset(number)

    FUNCTION

    INPUTS
        number:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        eObject

********/
DEF eVar:PTR TO eVar

  IF self.entryList=NIL THEN RETURN

  IF ListLen(self.entryList)=0 THEN RETURN

  IF number > ListLen(self.entryList) THEN RETURN

  eVar := ListItem(self.entryList,number-1)

  IF eVar THEN RETURN eVar.getVarSize()

ENDPROC

*/

EXPORT PROC getParentObject() OF eObject HANDLE
/****** eObject/getParentObject ******************************

    NAME
        getParentObject() of eObject HANDLE -- Get object I'm inheriting
        from.

    SYNOPSIS
        eObject.getParentObject()

    FUNCTION
        Tries to get the pointer to the object the current one inherits
        from. The result is an initialized eObject. Note that the source
        attribute is valid, this means you have to END the source. Keep
        in mind that when you end the source attribute of an object frees
        the object itself, see eSource/end() for more details.

    RESULT
        PTR TO eObject -- The parent object or NIL if I have no parent.

    EXAMPLE

       /*
        * Get the parent object.
        */

        parent := object.getParentObject()


       /*
        * Work with it as you like. All attributes are valid.
        * Here we just dump the attributes.
        */

        dumpObjectAttributes(parent.entryList)

       /*
        * Before we end the object we end the source
        */

        END object.source

    NOTES
        Doesn't get the parent object if it's definition is in the same
        module.

    SEE ALSO
        eObject

********/
/*

NEVER call getInfo() on the source I'm defined in for this would lock
the program - infinite loop...

Does not get the parent object if it is defined in the same module.

Returns a full initialized eObject (getInfo() done on the source)
*/

DEF eSource:PTR TO eSource,
    object=NIL,
    moduleList,
    index,
    filename=NIL:PTR TO CHAR,
    src:PTR TO eSource

 /*
  * Exit if there is no parent object
  */

  IF self.inheritsFrom=NIL THEN RETURN 0,0

  #ifdef DEEP_DEBUG
  WriteF('object \s/getParentObject(): searching for parent object.\n',self.identifier)
  #endif

  NEW eSource.new()

  filename := String(255)

->  WriteF('eObject.m: newed source.\n')

 /*
  * Exit if no source is specified or there are no modules
  * to search in.
  */

  IF self.source=NIL

    END eSource
    DisposeLink(filename)
    RETURN 0,0

  ENDIF


  src := self.source

  IF src.modulesNeeded=NIL

 /*
  * If there is no list of the modules needed we try to build this list.
  */

    src.getModules()

    IF src.modulesNeeded=NIL
    
   /*
    * If the list still is empty we end since there is no file we can
    * search in.
    */

      END eSource
      RETURN 0,0
    
    ENDIF

  ENDIF


  moduleList := self.source::eSource.modulesNeeded

->  WriteF('eObject.m: got module list.\n')

 /*
  * Search in each module.
  */

  FOR index := 0 TO ListLen(moduleList)-1

    StringF(filename, 'EMODULES:\s.e',ListItem(moduleList,index))

    #ifdef DEEP_DEBUG
    WriteF('eObject.m: searching for parent object in file \s.\n', filename)
    #endif 

   /*
    * Suck the file and build the main lists. This is required for
    * getObject().
    */

->    WriteF('eObject.m: sucking file \s.\n', filename)
    eSource.suck(filename)
->    WriteF('(\s)\n',eSource.getLine(0))
->    WriteF('eObject.m: getting info on objects and procs.\n')

    eSource.getInfo()

->    WriteF('eObject.m: try to find object.\n')

    IF self.inheritsFrom

      object := eSource.getObject(self.inheritsFrom)

    ELSE

      object := NIL

    ENDIF


   /*
    * Free the lists and the sucked contents.
    */

->    WriteF('eObject.m: freeing contents.\n')

->    eSource.freeContents()
->    WriteF('eObject.m: freeing lists.\n')
  ->  eSource.freeMainLists()

    EXIT object -> exit loop if object found

->    WriteF('eObject.m: next file.\n')

  ENDFOR


 /*
  * End the file only if the object was not found. If it was found the file
  * has to be intact to work with it, so one has to END the file by hisherself
  * when finished ( END object.source )
  */

  IF object=NIL

    END eSource
    DisposeLink(filename)

  #ifdef SURFACE_DEBUG
  ELSE

    WriteF('object \s/getParentObject(): found parent object in file \s.\n', self.identifier,filename)
  #endif

  ENDIF

  RETURN object,filename

EXCEPT

 /*
  * NEW could raise exception
  */


ENDPROC

EXPORT PROC getSize() OF eObject
/****** eObject/getSize ******************************

    NAME
        getSize() of eObject -- Gets size of object in bytes.

    SYNOPSIS
        eObject.getSize()

    FUNCTION
        Returns the object's size.

    RESULT
        LONG -- object size. 0 if object has no attributes.

    SEE ALSO
        eObject

********/
DEF size,
    index

  #ifdef DEBUG_DEBUG
  WriteF('\neObject.m/getSize()\nCurrent object is \s(\d).\n',self.identifier,self)

  WriteF('inherits from \s.\n\n', self.inheritsFrom)

  WriteF('offsetList: \d, len: \d\n\n', self.offsetList, ListLen(self.entryList)+1)
  #endif

  IF self.offsetList

    size := ListItem(self.offsetList, ListLen(self.entryList))

    #ifdef DEEP_DEBUG
    WriteF('Got the size of object \s, it\as \d.\n\n',self.identifier,size) 
    #endif

    RETURN size

  ENDIF

ENDPROC

PROC getInheritedSize() OF eObject
/****** eObject/getInheritedSize ******************************

    NAME
        getInheritedSize() of eObject -- Get the 'inherited' size.

    SYNOPSIS
        eObject.getInheritedSize()

    FUNCTION
        Returns the 'inherited' size, i.e. the size of all parent objects.
        Be object a 6 and object b 14 bytes big. Object c which inherits
        from object b would have an inherited size of 20.

    RESULT
        LONG -- the sum of all parental object sizes.

    SEE ALSO
        eObject

********/
DEF parentObject:PTR TO eObject,
    parentObjectSize=0,
    inSize:LONG,
    object:PTR TO eObject,
    src:PTR TO eSource

->  WriteF('\n\n')

  inSize := 42
  addValue({inSize},-42)

 /* 
  * I have to do it this way. inSize simply can't be initialized with
  * 0. At least here on my machine this ain't possible.
  */

  IF self.inheritsFrom = NIL THEN RETURN

  object := self
  parentObject := object.getParentObject()

  WHILE parentObject<>NIL

->    WriteF('getInheritedSize(): Working on object \s.\n', parentObject.identifier)

    parentObjectSize := parentObject.getSize()

->    WriteF('getInheritedSize(): It\as size is \d.\n', parentObjectSize)

->    WriteF('total size so far: \d\n', inSize)  

      inSize := inSize + parentObjectSize

->    WriteF('total size after adding: \d\n', inSize)  
->    WriteF('total size resukts in: \d\n', inSize)  
->    WriteF('\ninherited size is \d.\n', inSize)

    object := parentObject
    parentObject := object.getParentObject()

   /*
    * End the inheriting object's source. Note the position: this way we
    * don't end the source of ourself.
    *
    * nota bene: ending the source ends all objects, too. So don't end
    * object here.
    */

    src := object.source
    END src

  ENDWHILE

->  WriteF('\nThe total inherited size is \d.\n\n', inSize)

  RETURN inSize

ENDPROC

PROC addValue(var,value)
/****** private/addValue ******************************

    NAME
        addValue() -- Add value to long variable.

    SYNOPSIS
        addValue(LONG, LONG)

        addValue(var, value)

    FUNCTION
        Adds value to var.

    INPUTS
        var:LONG -- Address of var.

        value:LONG -- Value to add.

    EXAMPLE
        addValue({longvar},42)

    NOTES
        It here for a compiler bug (I suppose) - in getInheritedSize()
        it is not possible to initialize a var which should contain
        the sum of all parental object's sizes. The var would contain
        such a nice value like 4237458 and the like. ECv3.2e

    SEE ALSO
        getInheritedSize()

********/
  ^var := ^var + value
ENDPROC
