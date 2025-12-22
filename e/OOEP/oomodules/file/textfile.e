
/****** textfile/--background-- ******************************************

    PURPOSE
        This is the first draft of a basic textfile module. This object
        provides the means to deal with text files. Everything is based
        on lines.

        The methods may change when the file object was adapted for
        Stream.

    CREATION
        September 23 1995 Gregor Goldbach

    HISTORY
        September 23 1995 Gregor Goldbach
          Took procs from tools/file and squeezed them into countlines()
          and buildLineList().

        September 25 1995 Gregor Goldbach
          Created all other procs.

        October 1 1995 Gregor Goldbach

    TODO
        Change implementation of getLine() and relying procs. The way they
        exist now is very memory consuming, maybe one short suck()ing and a
        buildLineList() would be better. The line list could be
        recalculated to contain offsets from the beginning of the file, so
        every getLine() could get that offset and read from the file...
        That could require a locking protocol so nobody can edit the file
        while we are working it (unset w protection flag).

        Add methods to process lines. These methods could also be methods of
        some String sub-object. They should work word-based:
        getNextWordAfter(a,b,c)
        Could search the next word the is after the character a and which
        has to be surrounded by b and c. getNextWordAfter(",","\a","\a")
        would find "this, 'mater'" would return mater.
******************************************************************************

History

*/

OPT MODULE

MODULE  'dos/dos',
        'oomodules/file',
        'dos/dosextens'

EXPORT OBJECT textfile OF file
/****** textfile/--textfile-- ******************************************

    NAME
        textfile of file

    FUNCTION
        The basic textfile object.

    ATTRIBUTES
        numberOfLines:LONG -- The number of lines that are in this file. Set
            by countLines()

        lineList:PTR TO LONG -- An elist with pointers to the lines as
            items. Set by buildLineList()

        lineCount:LONG
            The number of the current line, 0 means we are in the very
            first line whereas numberOfLines-1 is the last line.

    NOTES
        By now the attributes are public. This will change, so don't use
        them.

        If you get a string address (getLine() and the like), do NOT
        Dispose() it! This is done when ENDing the object. This may change
        in the future.

******************************************************************************

History


*/
  numberOfLines
  lineList:PTR TO LONG
  lineCount
ENDOBJECT

EXPORT PROC name() OF textfile IS 'Textfile'

EXPORT PROC getLine(lineNumber=0) OF textfile
/****** textfile/getLine *****************************************

    NAME
        getLine() -- Get a line from a textfile.

    SYNOPSIS
        textfile.getLine(lineNumber=0)

    FUNCTION
        Gets a line from the textfile's buffer. You have to do a suck()
        on the file before using this function or unpredictable results
        may happen.

    INPUTS
        lineNumber=0 -- The number of the line you want to get. If too
        high you get the last line of the file.

    RESULT
        PTR TO CHAR -- Pointer to the line.

    SEE ALSO
        suck()

******************************************************************************

History


*/

   RETURN self.lineList[IF lineNumber<self.numberOfLines THEN lineNumber ELSE self.numberOfLines-1]
ENDPROC

EXPORT PROC setLine(lineNumber,str) OF textfile
/****** textfile/setLine *****************************************

    NAME
        setLine() -- Set the contents of a line.

    SYNOPSIS
        textfile.setLine(lineNumber,str:PTR TO CHAR)

    FUNCTION
        Set the contents of a textfile line. The contents of the string
        are not tested in any way. Be sure not to exceed the file's maximum
        line number. Be also sure to make a suck() on the file first.

    INPUTS
        lineNumber -- The number of the line to change.

        str:PTR TO CHAR -- Pointer to the new line.

    NOTES
        In the future there may be a version that doesn't require a suck().

******************************************************************************

History


*/
   self.lineList[IF lineNumber<self.numberOfLines THEN lineNumber ELSE self.numberOfLines-1] := str
ENDPROC

EXPORT PROC getNextLine() OF textfile
/****** textfile/getNextLine *****************************************

    NAME
        getNextLine() -- Get next line from a textfile.

    SYNOPSIS
        textfile.getNextLine()

    FUNCTION
        Gets the next line of a already suck()ed textfile. If already at
        end the last line is returned.

    RESULT
        PTR TO CHAR -- Pointer to next line.

******************************************************************************

History


*/
  self.lineCount := self.lineCount+1

   IF self.lineCount = self.numberOfLines
     self.lineCount := self.lineCount-1
   ENDIF

   RETURN self.lineList[self.lineCount]
ENDPROC

EXPORT PROC getPreviousLine() OF textfile
/****** textfile/getPreviousLine *****************************************

    NAME
        getPreviousLine() -- Get the previous line of a textfile.

    SYNOPSIS
        textfile.getPreviousLine()

    FUNCTION
        Gets the previous line from a textfile. If already at the beginning
        of the text file you'll get the first line.

    RESULT
        PTR TO CHAR -- Pointer to the line.

******************************************************************************

History


*/
   self.lineCount--

   IF self.lineCount = -1 THEN self.lineCount++

   RETURN self.lineList[self.lineCount]

ENDPROC

EXPORT PROC flashbackLine(number=0) OF textfile
/****** textfile/flashbackLine *****************************************

    NAME
        flashbackLine() -- Look number of lines back.

    SYNOPSIS
        textfile.flashbackLine(number=0)

    FUNCTION
        Get the line that is a couple of lines in front of the current
        one. Unlike with getPreviousLine(), the current line number is not
        changed. Use only on previously suck()ed textfile's.

    INPUTS
        number=0 -- The number of lines you want to look back. 0 gives you
            current line. If the resulting line would be somewhere 'before'
            the actual file start you get the first line.

    RESULT
        PTR TO CAHR -- Pointer to a line.

******************************************************************************

History


*/
DEF wantedLineNumber

   IF (self.lineCount-number)>-1
     wantedLineNumber := number
   ELSE
     wantedLineNumber := 0
   ENDIF

   RETURN self.getLine(wantedLineNumber)
ENDPROC

EXPORT PROC previewLine(number=0) OF textfile
/****** textfile/previewLine *****************************************

    NAME
        previewLine() -- Look some lines in the future.

    SYNOPSIS
        textfile.previewLine(number=0)

    FUNCTION
        Get pointer to a line that is (temporarily) behind the current
        line. Unlike with getNextLine() the number of the current line
        is not changed. Use only on previously suck()ed textfile's.

    INPUTS
        number=0 -- How many lines you want to look forth.

    RESULT
        PTR TO CHAR -- Pointer to the line.

******************************************************************************

History


*/
DEF wantedLineNumber

   IF (self.lineCount-number)<self.numberOfLines
     wantedLineNumber := number
   ELSE
     wantedLineNumber := self.numberOfLines-1
   ENDIF

   RETURN self.getLine(wantedLineNumber)
ENDPROC

EXPORT PROC getCurrentLineNumber() OF textfile
/****** textfile/getCurrentLineNumber *****************************************

    NAME
        getCurrentLineNumber() -- get number of current line

    SYNOPSIS
        textfile.getCurrentLineNumber()

    FUNCTION
        Returns the number of the current line. Useful if you want to set it
        for some function and have to set it back later.

    RESULT
        LONG -- The number of the current line.

******************************************************************************

History


*/
   RETURN self.lineCount
ENDPROC

EXPORT PROC setCurrentLineNumber(number) OF textfile
/****** textfile/setCurrentLineNumber *****************************************

    NAME
        setCurrentLineNumber() -- Set the current line number

    SYNOPSIS
        textfile.setCurrentLineNumber(number)

    FUNCTION
        Set the current line number which getNextLine() ant the like react
        on.

    INPUTS
        number -- New current line number. Not tested if valid.

    SEE ALSO
        getNextLine(), setNextLine(), getCurrentLineNumber()
******************************************************************************

History


*/

   self.lineCount := number

ENDPROC


EXPORT PROC suck(name=NIL) OF textfile
/****** textfile/suck *****************************************

    NAME
        suck() -- Read textfile into memory.

    SYNOPSIS
        textfile.suck(name=NIL)

    FUNCTION
        Adapted suck() of file. A text file is read into memory.
        Various methods, like getNextLine(), need this method to be
        called before.

        In addition to the simple reading of the file also the lines
        are counted and the line list is built.

    INPUTS
        name=NIL:PTR TO CHAR -- file name to suck. Passed on to file.suck(),
        see there for more information.

    SEE ALSO
        suck()
******************************************************************************

History


*/

  IF self.lineList THEN DisposeLink(self.lineList)

  SUPER self.suck(name)

  self.numberOfLines := self.countLines()
  self.lineList := self.buildLineList()

ENDPROC

PROC countLines() OF textfile
/****** textfile/countLines *****************************************

    NAME
        countLines() -- Count number of lines in the file

    SYNOPSIS
        textfile.countLines()

    FUNCTION
        Counts the lines of the suck()ed text file.

    RESULT
        LONG -- number of lines, at least 1.

    NOTES
        This proc is taken from src/tools/file.e of the original E
        distribution.

        This proc is only callable within the textfile module since it's
        no use anywhere else for the number is stored in the textfile
        object.

    SEE ALSO
        suck().
******************************************************************************

History


*/
DEF startAddress,
     fileSize

   startAddress := self.contents
   fileSize := self.getSize()

  MOVE.L startAddress,A0
  MOVE.L A0,D1
  ADD.L  fileSize,D1
  MOVEQ  #0,D0
  MOVEQ  #10,D2
strings:
  ADDQ.L #1,D0
findstring:
  CMP.B  (A0)+,D2
  BNE.S  findstring
  CMPA.L D1,A0
  BMI.S  strings
ENDPROC D0

PROC buildLineList() OF textfile
/****** textfile/buildLineList *****************************************

    NAME
       buildLineList() -- Build list of lines.

    SYNOPSIS
        textfile.buildLineList()

    FUNCTION
        Builds an elist with pointers to the lines as items. The hunk of
        memory where the original textfile image lies is modified, every
        cr is sustituted by a 0byte so fiddling around with the line
        is save.

    RESULT
        elist -- List of line pointers.

    NOTES
        Not callable outside the module.

******************************************************************************

History


*/
DEF list,
     startAddress,
     fileSize,
     lines,
     l

   startAddress := self.contents
   fileSize := self.getSize()
   lines := self.countLines()
   list := List(lines)

  IF list=NIL THEN Raise("MEM")

  MOVE.L list,A1
  MOVE.L lines,D3
  MOVE.L startAddress,A0
  MOVE.L A0,D1
  ADD.L  fileSize,D1
  MOVEQ  #0,D0
  MOVEQ  #10,D2
stringsl:
  CMP.L  D3,D0
  BPL.S  done
  ADDQ.L #1,D0
  MOVE.L A0,(A1)+
findstringl:
  CMP.B  (A0)+,D2
  BNE.S  findstringl
  CLR.B  -1(A0)
  CMPA.L D1,A0
  BMI.S  stringsl
done:
  MOVE.L D0,l
  ->SetList(list,l)
ENDPROC list

EXPORT PROC writeTo(filename:PTR TO CHAR) OF textfile
/****** textfile/writeTo *****************************************

    NAME
        writeTo() -- Write the text to a file.

    SYNOPSIS
        textfile.writeTo(filename:PTR TO CHAR)

    FUNCTION
        Write the contents of the file to a file. The lines are
        actually appended.

    INPUTS
        filename:PTR TO CHAR -- name of the file to write to.

******************************************************************************

History


*/
DEF textfile:PTR TO textfile,
     oldLineNumber,
     line

  NEW textfile.new()

  textfile.open(filename,MODE_READWRITE)

  oldLineNumber := self.getCurrentLineNumber()

  self.setCurrentLineNumber(0)

  line := self.getLine(0)

  textfile.appendBytes(line, StrLen(line))
  textfile.appendBytes('\n', StrLen('\n'))

  WHILE self.atEnd()=FALSE
     line := self.getNextLine()

   textfile.appendBytes(line, StrLen(line))
     textfile.appendBytes('\n', StrLen('\n'))

   ENDWHILE

   textfile.close()

   END textfile

  self.setCurrentLineNumber(oldLineNumber)
ENDPROC

EXPORT PROC atEnd() OF textfile
/****** textfile/atEnd *****************************************

    NAME
        atEnd() -- Tes tif at the end of the file.

    SYNOPSIS
        textfile.atEnd()

    FUNCTION
        Tests if the current line is the last one in the file.

    RESULT
        TRUE if at the end of the file, FALSE otherwise.

******************************************************************************

History


*/
  IF self.lineCount=(self.numberOfLines-1)
    RETURN TRUE
  ELSE
    RETURN FALSE
  ENDIF
ENDPROC

EXPORT PROC atBeginning() OF textfile IS self.lineCount=0
/****** textfile/atBeginning *****************************************

    NAME
        atBeginning() -- test if at the beginning of a textfile.

    SYNOPSIS
        textfile.atBeginning()

    FUNCTION
        Tests if the current line is the first one in the file.

    RESULT
        TRUE if in the first line of the file, FALSE otherwise.

******************************************************************************

History


*/

PROC select(opts,i) OF textfile
/****** textfile/select *****************************************

    NAME
        select() -- action on textfile via taglist

    SYNOPSIS
        textfile.select(opts,i)

    FUNCTION
        Performs an action that is defined via in item i of the
        optionlist. See Object's new() doc for more info.

        The following actions are defined:
          "open" -- Take next item as file name. Open that file.

          "suck" -- Take next item as file name. Perform a
           suck() on it.

    INPUTS
        opts -- elist with tags

        i -- index of optionlist

******************************************************************************

History


*/
DEF item

   item:=ListItem(opts,i)


   SELECT item

     CASE "open"

    INC i
    self.open(ListItem(opts,i))

   CASE "suck"

    INC i
    self.suck(ListItem(opts,i))

   ENDSELECT

ENDPROC i

EXPORT PROC findLine(str,fromLine=0) OF textfile
/****** textfile/findLine *****************************************

    NAME
        findLine() -- Find a line that begins with string.

    SYNOPSIS
        textfile.findLine(str,fromLine=0)

    FUNCTION
        Searches for a line that starts with the string provided in str.

    INPUTS
        str:PTR TO CHAR -- string to search for.

        fromLine=0 -- number of line to start with hte search.

    RESULT
        LONG -- Number of the line the string was found in or -1 if not
            found.

******************************************************************************

History

  October 11 1995 Gregor Goldbach
    Fixed a tiny bug which made the proc don't find the string in the very
    first line.

*/
DEF oldLineNumber,
     found=-1,
     len,
     atEnd

  oldLineNumber := self.getCurrentLineNumber()

  self.setCurrentLineNumber(fromLine-1)

  len := StrLen(str)

  REPEAT

    IF StrCmp(TrimStr(self.getNextLine()),str,len) THEN found := self.getCurrentLineNumber()
->    WriteF('found is \d.\n', found)

  UNTIL self.atEnd() OR (found<>-1)

  atEnd := self.atEnd()

  self.setCurrentLineNumber(oldLineNumber)

-> return -1 if nothing was found

   RETURN found
ENDPROC

EXPORT PROC findLineFromBack(str,fromLine=0) OF textfile
/****** textfile/findLineFromBack *****************************************

    NAME
        findLineFromBack()

    SYNOPSIS
        textfile.findLineFromBack(str,fromLine=0)

    FUNCTION
        Searches for a line that ends with the string provided in str.

    INPUTS
        str:PTR TO CHAR -- string to search for.

        fromLine=0 -- number of line to start with hte search.

    RESULT
        LONG -- Number of the line the string was found in or -1 if not
            found.
******************************************************************************

History


*/

/*  INPUTS

  RESULTS

     -1 when the end was reached, the line number otherwise
  EXCEPTIONS

  NOTE
*/
DEF oldLineNumber,
     found=0,
     len,
     line,
     lineStart,
     atEnd

  oldLineNumber := self.getCurrentLineNumber()

  self.setCurrentLineNumber(fromLine-1)

   len := StrLen(str)

  REPEAT
     line := self.getNextLine()
     lineStart := line+StrLen(line)-len

     IF StrCmp(lineStart,str) THEN found := self.getCurrentLineNumber()
  UNTIL self.atEnd() OR (found)

   atEnd := self.atEnd()

  self.setCurrentLineNumber(oldLineNumber)

-> return -1 if nothing was found

  IF (found=0) AND atEnd
     RETURN -1
   ELSE
     RETURN found
   ENDIF

ENDPROC

EXPORT PROC end() OF textfile

  IF self.isOpen() THEN self.close()
  IF self.contents THEN self.freeContents()
  IF self.lineList THEN DisposeLink(self.lineList)

  -> SUPER self.end() doesn't work ! :(
ENDPROC
/*EE folds
-1
52 37 56 31 59 28 62 28 65 27 68 36 71 34 74 22 77 26 81 36 84 48 87 60 90 51 93 25 96 70 99 54 102 67 105 6 
EE folds*/
