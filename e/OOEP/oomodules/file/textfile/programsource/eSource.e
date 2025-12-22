/****** eSource/--background-- ******************************************

    PURPOSE
          This object gives you the means the deal with sources of the E
          language.

    CREATION
        September 26 1995 Gregor Goldbach

    HISTORY
        October 11 1995 Gregor Goldbach
          Added getMethods(). Builds elist of module name strings.
          Added end().

    NOTES
        There are two groups of procs in this module. The first runs over the
        whole file and tries to find out everything about objects, proc,
        variables and their relationship. This group is called by getInfo().

        The second group does not need the information provided by the procs
        of the first group. They search for more general aspectes of the
        source, e.g. the settings and the modules needed. These are the procs
        this group consists of:
            getModules()
            needsModule()
            testSetting()

        Note that getModules() has to be called before using needsModule().

        To get all methods working on a source call getInfo() and
        getModules() after sucking the file. To free the memory that was
        allocated by these methods call freeContents(), freeMainLists() and
        freeListModulesNeeded().

******************************************************************************

History


*/
OPT MODULE
OPT PREPROCESS

MODULE  'oomodules/file/textfile/programSource',
        'oomodules/file/textfile/programSource/sourceBlock',
        'oomodules/file/textfile/programSource/eSource/eObject',
        'oomodules/file/textfile/programSource/eSource/eProc',
        'oomodules/file/textfile/programSource/eSource/eVar',
        'oomodules/list/queuestack',

        'oomodules/sort/string',

        'dos/dos'

#define LASTCHAR(line) line[StrLen(line)-1]

->#define DEBUG

EXPORT ENUM EOBJECT=1, EMETHOD, EPROC, EVAR, EGLOBALVAR

EXPORT OBJECT eSource OF programSource
/****** eSource/--eSource-- ******************************************

    NAME
        eSource

    ATTRIBUTES
        privateObjectList:PTR TO LONG -- elist of eSourceBlocks that
            represent private objects.

        publicObjectList:PTR TO LONG -- elist of eSourceBlocks that
            represent public objects.

        privateProcList:PTR TO LONG -- elist of eSourceBlocks that
            represent private procs.

        publicProcList:PTR TO LONG -- elist of eSourceBlocks that
            represent public procs.

        privateVarList:PTR TO LONG -- elist of eSourceBlocks that
            represent private variables.

        publicVarList:PTR TO LONG -- elist of eSourceBlocks that
            represent public variables.

        modulesNeeded:PTR TO LONG -- elist of Strings that represent a
            module name. These modules are needed to run this source.

    NOTES
        Compilation and interpretation are not available

******************************************************************************

History


*/
  privateObjectList:PTR TO LONG
  publicObjectList:PTR TO LONG
  privateProcList:PTR TO LONG
  publicProcList:PTR TO LONG
  privateVarList:PTR TO LONG
  publicVarList:PTR TO LONG
  modulesNeeded:PTR TO LONG
ENDOBJECT

EXPORT OBJECT eSourceBlock OF sourceBlock
ENDOBJECT

EXPORT PROC name() OF eSourceBlock IS 'eSourceBlock'

EXPORT PROC findPrivateProc(fromLine=0) OF eSource IS self.findBlock('PROC','ENDPROC',fromLine, "FrFr")
/****** eSource/findPrivateProc *****************************************

    NAME
        findPrivateProc() -- Get next private proc definition.

    SYNOPSIS
        eSource.findPrivateProc(fromLine=0)

    FUNCTION
        Gets starting and ending line number of the next private procedure.

    INPUTS
        fromLine=0 -- In which line the search should start

    RESULT
        startLine, endLine -- Number of the lines the procstarts and ends.

    NOTES
        Does not know if somebody wrote OPT EXPORT at the start of the
        source. This may change.

    KNOWN BUGS
        Does not find the single-line procs. Easy to fix.

    SEE ALSO
        buildPrivateProcList()

******************************************************************************

History


*/

EXPORT PROC buildPrivateProcList(fromLine=0) OF eSource IS self.buildBlockList('PROC','ENDPROC',fromLine, "FrFr",{workOnProc})
/****** eSource/buildPrivateProcList *****************************************

    NAME
        buildPrivateProcList() -- Build list of private procs.

    SYNOPSIS
        eSource.buildPrivateProcList(fromLine=0)

    FUNCTION
        Builds an elist of eSourceBlocks that define private procs.

    INPUTS
        fromLine=0 -- Where the search should start.

    RESULT
        elist of eSourceBlocks or NIL.

    NOTES
        Does not know if somebody wrote OPT EXPORT at the start of the
        source. This may change.

******************************************************************************

History


*/

EXPORT PROC findPublicProc(fromLine=0) OF eSource IS self.findBlock('EXPORT PROC','ENDPROC',fromLine, "FrFr")
/****** eSource/findPublicProc *****************************************

    NAME
        findPublicProc() -- Get next public proc definition.

    SYNOPSIS
        eSource.findPublicProc(fromLine=0)

    FUNCTION
        Gets starting and ending line number of the next public procedure.

    INPUTS
        fromLine=0 -- In which line the search should start

    RESULT
        startLine, endLine -- Number of the lines the proc starts and ends.

    SEE ALSO
        buildPublicProcList()

******************************************************************************

History


*/
EXPORT PROC buildPublicProcList(fromLine=0) OF eSource IS self.buildBlockList('EXPORT PROC','ENDPROC',fromLine, "FrFr",{workOnProc})
/****** eSource/buildPublicProcList *****************************************

    NAME
        buildPublicProcList() -- Build list of public procs.

    SYNOPSIS
        eSource.buildPublicProcList(fromLine=0)

    FUNCTION
        Builds an elist of eSourceBlocks that define public procs.

    INPUTS
        fromLine=0 -- Where the search should start.

    RESULT
        elist of eSourceBlocks or NIL.

******************************************************************************

History


*/

EXPORT PROC findPrivateObject(fromLine=0) OF eSource IS self.findBlock('OBJECT','ENDOBJECT',fromLine, "FrFr")
/****** eSource/findPrivateObject *****************************************

    NAME
        findPrivateObject() -- Get next private object definition.

    SYNOPSIS
        eSource.findPrivateObject(fromLine=0)

    FUNCTION
        Gets starting and ending line number of the next private object.

    INPUTS
        fromLine=0 -- In which line the search should start

    RESULT
        startLine, endLine -- Number of the lines the object starts and
            ends.

    NOTES
        Does not know if somebody wrote OPT EXPORT at the start of the
        source. This may change.

    SEE ALSO
        buildPrivateObjectList()

******************************************************************************

History


*/
EXPORT PROC buildPrivateObjectList(fromLine=0) OF eSource IS self.buildBlockList('OBJECT','ENDOBJECT',fromLine, "FrFr",{workOnObject})
/****** eSource/buildPrivateObjectList *****************************************

    NAME
        buildPrivateObjectList() -- Build list of private objects.

    SYNOPSIS
        eSource.buildPrivateObjectList(fromLine=0)

    FUNCTION
        Builds an elist of eSourceBlocks that define private objects.

    INPUTS
        fromLine=0 -- Where the search should start.

    RESULT
        elist of eSourceBlocks or NIL.

    NOTES
        Does not know if somebody wrote OPT EXPORT at the start of the
        source. This may change.

******************************************************************************

History


*/

EXPORT PROC findPublicObject(fromLine=0) OF eSource IS self.findBlock('EXPORT OBJECT','ENDOBJECT',fromLine, "FrFr")
/****** eSource/findPublicObject *****************************************

    NAME
        findPublicObject() -- Get next public object definition.

    SYNOPSIS
        eSource.findPublicObject(fromLine=0)

    FUNCTION
        Gets starting and ending line number of the next public object.

    INPUTS
        fromLine=0 -- In which line the search should start

    RESULT
        startLine, endLine -- Number of the lines the object starts and
            ends.

    SEE ALSO
        buildPublicObjectList()

******************************************************************************

History


*/
EXPORT PROC buildPublicObjectList(fromLine=0) OF eSource IS self.buildBlockList('EXPORT OBJECT','ENDOBJECT',fromLine, "FrFr",{workOnObject})
/****** eSource/buildPublicObjectList *****************************************

    NAME
        buildPublicObjectList() -- Build list of public objects.

    SYNOPSIS
        eSource.buildPublicObjectList(fromLine=0)

    FUNCTION
        Builds an elist of eSourceBlocks that define public objects.

    INPUTS
        fromLine=0 -- Where the search should start.

    RESULT
        elist of eSourceBlocks or NIL.

******************************************************************************

History


*/

EXPORT PROC getInfo() OF eSource
/****** eSource/getInfo *****************************************

    NAME
        getInfo() -- build main lists of eSource object.

    SYNOPSIS
        eSource.getInfo()

    FUNCTION
        Builds the main lists of the object. The procs and the objects
        are listed.

    SEE ALSO
         buildPrivateProcList() ,buildPublicProcList(),
         buildPrivateObjectList(), buildPublicObjectList()

******************************************************************************

History


*/

  #ifdef DEBUG
  WriteF('eSource.m: building list of private procs\n')
  #endif

  self.privateProcList := self.buildPrivateProcList()


  #ifdef DEBUG
  WriteF('eSource.m: building list of public procs\n')
  #endif

  self.publicProcList := self.buildPublicProcList()


  #ifdef DEBUG
  WriteF('eSource.m: building list of private objects\n')
  #endif

  self.privateObjectList := self.buildPrivateObjectList()


  #ifdef DEBUG
  WriteF('eSource.m: building list of public objects\n')
  #endif

  self.publicObjectList := self.buildPublicObjectList()


  #ifdef DEBUG
  WriteF('eSource.m: finished with building the main lists.\n')
  #endif


ENDPROC

PROC workOnObject(sourceBlock:PTR TO sourceBlock) HANDLE
/****** eSource/workOnObject *****************************************

    NAME
        workOnObject()

    SYNOPSIS
        eSource.workOnObject(sourceBlock:PTR TO sourceBlock)

    FUNCTION
        Takes a Source Block and extracts the information of it to
        create an eObject. The eObject will have a valid entryList.

    INPUTS
        sourceBlock:PTR TO sourceBlock -- Source Block that contains
            the location of an object definition in the source file.
            That information HAS to be valid, it is not tested.

    RESULT
        Pointer to eObject or to passed Source Block if an error
        occured.

    NOTES
        To test if the procedure ran successfully over the Source Block
        thou may test the type entry, it is set to EOBJECT on success.

    SEE ALSO
        sourceBlock

******************************************************************************

History


*/
DEF eObject:PTR TO eObject

  NEW eObject

  sourceBlock.copyTo(eObject)

  eObject.type := EOBJECT

  eObject.getName(eObject.startLine)
  eObject.entryList := eObject.getEntries()
  eObject.buildOffsetList()

  END sourceBlock

  RETURN eObject

EXCEPT

 /*
  * if the allocation of the eObject failed we have to make sure a valid
  * sourceBlock has to be returned
  */

  RETURN sourceBlock

ENDPROC

PROC workOnProc(sourceBlock:PTR TO sourceBlock) HANDLE
/****** eSource/workOnProc *****************************************

    NAME
        workOnProc()

    SYNOPSIS
        eSource.workOnProc(sourceBlock:PTR TO sourceBlock)

    FUNCTION
        Takes a Source Block and extracts the information of it to
        create an eProc.

    INPUTS
        sourceBlock:PTR TO sourceBlock -- Source Block that contains
            the location of a procedure definition in the source file.
            That information HAS to be valid, it is not tested.

    RESULT
        Pointer to eProc or to passed Source Block if an error
        occured.

    NOTES
        To test if the procedure ran successfully over the Source Block
        thou may test the type entry, it is set to EPROC on success.

        The failure to detect single-lined procedures has been fixed.
        The difference between start and end line is 0. Therefore, any
        documentation of that proc is *not* included.

    SEE ALSO
        sourceBlock

******************************************************************************

History


*/
DEF eProc:PTR TO eProc

  NEW eProc

  sourceBlock.copyTo(eProc)

  eProc.type := EPROC

  eProc.getName(eProc.startLine)
  eProc.getArguments()
  eProc.getLocals()

  END sourceBlock

  IF InStr(eProc.source.getLine(eProc.startLine),' IS ') <> -1

    eProc.endLine := eProc.startLine

  ENDIF

  RETURN eProc

EXCEPT

 /*
  * if the allocation of the eProc failed we have to make sure a valid
  * sourceBlock has to be returned
  */

  RETURN sourceBlock

ENDPROC

EXPORT PROC testSetting(string:PTR TO CHAR) OF eSource
/****** eSource/getSettings ******************************************

    NAME
        testSetting() -- Determine if a specific setting is done for this
            source.

    SYNOPSIS
        BOOL eSource.testSetting(PTR TO CHAR)

    FUNCTION
        This function determines if a certain compiler setting is found
        after an OPT keyword. All ocurrences of OPT are used. However,
        the proc returns immediately after the setting was found.

    INPUTS
        string:PTR TO CHAR -- The setting to look for. Refer to the
            reference for all available settings, some of them are:
                EXPORT, MODULE, ASM, DIR, STACK, LARGE

    NOTES
        Needs none of the internal lists. It searches directly for the OPP
        keyword.
******************************************************************************

History


*/
DEF lineNumber=-1,
    line:PTR TO CHAR

  REPEAT
    lineNumber := self.findLine('OPT',lineNumber+1)

    REPEAT
      line := self.getLine(lineNumber)

      IF InStr(line,string)<>-1 THEN RETURN TRUE

      IF line[StrLen(line)-1]="," THEN lineNumber := lineNumber+1

    UNTIL (line[StrLen(line)-1]<>",") OR CtrlC()

  UNTIL (lineNumber=-1) OR CtrlC()

ENDPROC

EXPORT PROC getModules() OF eSource HANDLE
/****** eSource/getModules ******************************************

    NAME
        getModules() -- Determine what modules are included in this source.

    SYNOPSIS
        eSource.getModules()

    FUNCTION
        Determines what modules are needed to interpret/compile this source.
        This is done by checking what strings are behind the MODULE keyword.

    NOTES
        Needs none of the internal lists. It searches directly for the module
        keyword.
******************************************************************************

History


*/
DEF qs:PTR TO queuestack,
    list,
    lineNumber,
    commaPosition,
    startOfName,
    line:PTR TO CHAR,
    len, -> length of the string
    str, -> string to add
    oldLineNumber,
    noMoreModulesThisLine=FALSE,
    endOfDeclaration=FALSE

  NEW qs.new()


 -> search for the keyword

  lineNumber := self.findLine('MODULE')


  -> if not found, return immediately
  IF lineNumber = -1

    END qs
    RETURN

  ENDIF


  oldLineNumber := self.getCurrentLineNumber()

 /*
  * Set the line counter to one line _in front of_ the actual MODULE
  * line for the loop does a getNextLine()
  */

  self.setCurrentLineNumber(lineNumber-1)
  startOfName := 8 -> after 'MODULE ''


  REPEAT

    line := self.getNextLine()

    commaPosition := 0


    IF InStr(line, ',')=-1
      noMoreModulesThisLine := TRUE
      endOfDeclaration := TRUE
    ELSE
      noMoreModulesThisLine:=FALSE
    ENDIF


    REPEAT

      startOfName := InStr(line+commaPosition,'\a')
      -> correct startOfName, it's relative
      startOfName := startOfName+commaPosition+1

      len := InStr(line+startOfName,'\a')


      IF (len<>-1)
        str := String(len)
        StrCopy(str, line+startOfName, len)


        #ifdef DEBUG
        WriteF('eSource.m: source needs module \s\n', str)
        #endif

        qs.addLast(str)


        IF (startOfName+len)=StrLen(line)
          commaPosition := -1
        ELSE
          commaPosition := InStr(line+startOfName+len+1, ',') -> search comma after the name
        ENDIF

       /*
        * set commaPsotion to the right value since it's now relative to the start
        * of the name.
        */

        IF commaPosition <> -1 THEN commaPosition := commaPosition+startOfName+len+1

      ELSE

        commaPosition:=-1

      ENDIF


      IF CtrlC()
      /* set exit conditions... */
        self.setCurrentLineNumber(self.numberOfLines-1)
        commaPosition:=-1
      ENDIF

    UNTIL (commaPosition=-1) OR (LASTCHAR(line)='\a')-> until no comma is there or the ' is at the end

  UNTIL self.atEnd() OR (endOfDeclaration)


  list := qs.asList()

  self.modulesNeeded := list

  END qs

  self.setCurrentLineNumber(oldLineNumber)

EXCEPT
-> queuestack NEWing could have failed.


ENDPROC

PROC freeObjectList(list)
DEF index,
    str,
    eObject:PTR TO eObject


  IF list=NIL THEN RETURN
  IF ListLen(list)=0 THEN RETURN

  FOR index:=0 TO ListLen(list)-1
    eObject := ListItem(list,index)
    END eObject
  ENDFOR

  DisposeLink(list)


ENDPROC

PROC freeProcList(list)
DEF index,
    eProc:PTR TO eProc


  IF list=NIL THEN RETURN
  IF ListLen(list)=0 THEN RETURN

  FOR index:=0 TO ListLen(list)-1
    eProc := ListItem(list,index)
    END eProc
  ENDFOR

  DisposeLink(list)

ENDPROC

PROC freeVarList(list)
DEF index,
    eVar:PTR TO eVar

  IF list=NIL THEN RETURN
  IF ListLen(list)=0 THEN RETURN

  FOR index:=0 TO ListLen(list)-1
    eVar := ListItem(list,index)
    END eVar
  ENDFOR

  DisposeLink(list)

ENDPROC

EXPORT PROC freeMainLists() OF eSource
/****** eSource/freeMainLists ******************************************

    NAME
        freeMainLists() -- Destructor for the main lists.

    SYNOPSIS
        eSource.freeMainLists()

    FUNCTION
        Frees allocated resources this object uses. This can be quite
        an amount of bytes for the strings used. Every list is disposed.

    SEE ALSO
        freeListModulesNeeded()
******************************************************************************

History


*/
DEF str,
    list,
    index

  freeObjectList(self.privateObjectList)
  freeObjectList(self.publicObjectList)
  freeProcList(self.privateProcList)
  freeProcList(self.publicProcList)
  freeVarList(self.privateVarList)
  freeVarList(self.publicVarList)

  self.privateObjectList := NIL
  self.publicObjectList := NIL
  self.privateProcList := NIL
  self.publicProcList := NIL
  self.privateVarList := NIL
  self.publicVarList := NIL

ENDPROC

EXPORT PROC hasModuleSetting() OF eSource IS self.testSetting('MODULE')
EXPORT PROC hasAsmSetting() OF eSource IS self.testSetting('ASM')
EXPORT PROC hasLargeSetting() OF eSource IS self.testSetting('LARGE')
EXPORT PROC hasStackSetting() OF eSource IS self.testSetting('STACK')
EXPORT PROC hasDirSetting() OF eSource IS self.testSetting('DIR')
EXPORT PROC hasRegSetting() OF eSource IS self.testSetting('REG')

EXPORT PROC needsModule(name:PTR TO CHAR) OF eSource
/****** eSource/needsModule ******************************************

    NAME
        needsModule() -- Test if the source needs a specific module to run.

    SYNOPSIS
        BOOL eSource.needsModule(PTR TO CHAR)

    FUNCTION
        Tests if the module specified by the name is needed by the source
        to be run.

    INPUTS
        name:PTR TO CHAR -- Name of the module. This name is searched for
            in the source's module list which may be NIL.

    RESULT
        BOOL -- TRUE if a module of that name is needed, FALSE otherwise.

    NOTES
        Doesn't care about the OPT DIR setting. EMODULES: is hard coded
        by now. This will change.

        Needs the list of modules needed to run the source. If not already
        present it calls getModules().

******************************************************************************

History


*/
DEF index

  IF self.modulesNeeded=NIL THEN self.getModules()

  IF self.modulesNeeded = NIL THEN RETURN FALSE

  FOR index := 0 TO ListLen(self.modulesNeeded)-1
    IF StrCmp(name, ListItem(self.modulesNeeded,index)) THEN RETURN TRUE
  ENDFOR
ENDPROC

EXPORT PROC freeListModulesNeeded() OF eSource
DEF index

  IF self.modulesNeeded = NIL THEN RETURN

  FOR index := 0 TO ListLen(self.modulesNeeded)-1
    DisposeLink(ListItem(self.modulesNeeded,index))
  ENDFOR

  DisposeLink(self.modulesNeeded)
  self.modulesNeeded := NIL

ENDPROC

EXPORT PROC end() OF eSource

  self.freeContents()
  self.freeMainLists()
  self.freeListModulesNeeded()

  SUPER self.end()
ENDPROC

EXPORT PROC getObject(name:PTR TO CHAR) OF eSource
-> name has to be all lowercase!
DEF index,
    list,
    eObject:PTR TO eObject,
    lowerObjectName[255]:STRING

  IF self.publicObjectList THEN list := self.publicObjectList

  IF list
    IF ListLen(list)>0
      FOR index := 0 TO ListLen(list)-1
        eObject := ListItem(list,index)
->        WriteF('#\s# - #\s#\n', eObject.identifier,name)
->        WriteF('...\s\n', eObject.identifier)
        StrCopy(lowerObjectName, eObject.identifier)
        LowerStr(lowerObjectName)
->        WriteF('#\s# - #\s#\n', lowerObjectName, name)
        IF StrCmp(lowerObjectName,name,StrLen(lowerObjectName)) THEN RETURN eObject
->        IF StrCmp(eObject.identifier,name,StrLen(eObject.identifier)) THEN RETURN eObject
      ENDFOR
    ENDIF
  ENDIF


  IF self.privateObjectList THEN list := self.privateObjectList

  IF list
    IF ListLen(list)>0
      FOR index := 0 TO ListLen(list)-1
        eObject := ListItem(list,index)
->        WriteF('...\s\n', eObject.identifier)
        StrCopy(lowerObjectName, eObject.identifier)
        LowerStr(lowerObjectName)
->        WriteF('#\s# - #\s#\n', lowerObjectName, name)
        IF StrCmp(lowerObjectName,name,StrLen(lowerObjectName)) THEN RETURN eObject
      ENDFOR
    ENDIF
  ENDIF

ENDPROC

PROC name() OF eSource IS 'eSource'

PROC getAutodocString(string:PTR TO string) OF eSource
DEF eObject:PTR TO eObject,
    eProc:PTR TO eProc,
    previousProc=NIL:PTR TO eProc,
    index,
    lineNumber,
    handle,

    tempString:PTR TO string


  IF string = NIL THEN RETURN

  NEW tempString.new()

 /*
  * 'clear' it
  */

  END string
  NEW string.new()


 /*
  * Work on the public proc list
  */

  IF self.publicProcList<>NIL

   /*
    * For every proc in the list we have to get the autodoc string
    */

    FOR index := 0 TO ListLen(self.publicProcList)-1

     /*
      * safe: is the item of the list valid, i.e. non-NIL?
      */

      IF (eProc := ListItem(self.publicProcList,index))

        WriteF('\d\n', index)
        WriteF('It is \d bytes long.\n', string.length())
        Delay(25)

       /*
        * If the end line of the previous proc and the start line of the
        * current one are more than one line apart from each other we have
        * to dump those lines, too. Note that this isn't valid in the current
        * eSource file - e.g. you can't put a line that says
        * identifier: CHAR 'blablabla',0
        * between to procs. This is just to be safe. Furthermore, one could
        * actually put comments between two procs...
        */

        IF previousProc

        IF (eProc.startLine-previousProc.endLine)>1

          FOR lineNumber := previousProc.endLine+1 TO eProc.startLine-1

            string.cat(eProc.source.getLine(lineNumber))
            string.cat('\n')

          ENDFOR

        ENDIF

        ENDIF

        eProc.getAutodocProc(tempString)

        string.cat(tempString.write())
        string.cat('\n')

      ENDIF

      previousProc := eProc

    ENDFOR

    handle := Open('ram:bla', MODE_NEWFILE)
    Write(handle, string.write(), string.length())
    Close(handle)

  ENDIF

/*

  IF self.publicProcList<>NIL

->    handle := Open('ram:bla', MODE_OLDFILE)

    FOR index := 0 TO ListLen(self.publicProcList)-1

      WriteF('\d\n', index)
      Delay(50)

      eProc := ListItem(self.publicProcList,index)
      IF eProc THEN eProc.getAutodocProc(tempString)
      string.cat(tempString.write())
      string.cat('\n')

      WriteF('It is \d bytes long.\n', string.length())

->      Write(handle, tempString.write(), tempString.length())
->      Write(handle,'\n', StrLen('\n'))

    ENDFOR

    handle := Open('ram:bla', MODE_NEWFILE)
    Write(handle, string.write(), string.length())
    Close(handle)

  ENDIF
*/



  END tempString

ENDPROC
/*EE folds
-1
342 56 345 59 420 45 423 140 426 16 429 14 432 13 435 38 445 41 448 11 451 6 454 39 459 120 
EE folds*/
