OPT MODULE

MODULE  'oomodules/file/textfile/programSource',
        'oomodules/file/textfile/programSource/sourceBlock',
         'oomodules/list/queuestack'

OBJECT eComment OF sourceBlock
  startIsLonely
/* is true if nothing of value, say, a variable definition or the like, is on
   the same line. i.d., *in front of* the / *
*/

  endIsLonely -> the * / is all alone in the line
/* is true if nothing of value, say, a variable definition or the like, is on
   the same line. i.d., *behind* the * /
*/
ENDOBJECT

->EXPORT PROC buildCommentList(fromLine=0) OF eSource IS self.buildBlockList('/*','*/',fromLine, "FrBa")

EXPORT PROC isAutoDocLike() OF eComment
/****** eComment/isAutoDocLike ******************************************

    NAME 
        isAutoDocLike() -- Determine if a comment is autodoc.

    SYNOPSIS
        BOOL eComment.isAutoDocLike()

    FUNCTION
        Determines if an e comment is of autodoc style. An autodoc starts with
        the following characters: the first character of the line is /, ; or
        *. Then there are four asterisks, one of *, i or h followed by another
        char and a space. An autodoc comment end with at least three asterisks
        at the start of a line.

    RESULT
        TRUE if the comment block is autodoc, FALSE otherwise.

    EXAMPLE
        /****** bla/blur ******
        rubbish
        ******/

        would return TRUE.

    NOTES
        Refers to the 'autodoc.style' document for more information on
        autodocs.

******************************************************************************

History


*/


DEF line

   IF (StrCmp(line+1, '****')<>-1) AND (StrCmp(line+6, '* ')<>-1) AND (StrCmp(self.source.getLine(self.endLine)+1, '***')<>-1) THEN RETURN TRUE

ENDPROC

EXPORT PROC isOneLineComment(line)

  RETURN InStr(line,'->')

ENDPROC

EXPORT PROC isMultiLineCommentEnd(line)
/*
  NAME

    isMultiLineCommentEnd()

  FUNCTION

    Tests if a line contains the end of a comment that runs over multiple lines.

  INPUTS

    line:PTR TO CHAR

      String that contains the line to search in

  RESULTS

    The position of the literal * /. -1 if not present.

*/

  RETURN InStr(line, '*/')

ENDPROC

EXPORT PROC isMultiLineCommentStart(line)
/*
  NAME

    isMultiLineCommentStart()

  FUNCTION

    Tests if a line contains the start of a comment that runs over multiple lines.

  INPUTS

    line:PTR TO CHAR

      String that contains the line to search in

  RESULTS

    The position of the literal / *. -1 if not present

*/

  RETURN InStr(line,'/*')

ENDPROC

EXPORT PROC isCommented(line)
DEF position

  position := isOneLineComment(line)

  IF position <> -1 THEN RETURN position, "sing"


  position := isMultiLineCommentStart(line)

  IF position <> -1 THEN RETURN position, "mult"


  position := isMultiLineCommentEnd(line)

  IF position <> -1 THEN RETURN position, "mult"


  RETURN FALSE, "none"

ENDPROC

/*
EXPORT PROC skipComment(source:PTR TO programSource)
DEF line,
    lineNumber,
    position,
    commentKind,
    leave=FALSE -> the loop

  line := source.getNextLine()
  position,commentKind := isComment(line)

  IF position<>-1

    IF commentKind = "mult"

      REPEAT

        source.getNextLine()


      UNTIL isMultiLineCommentEnd(line) OR source.atEnd()

ENDPROC

*/


EXPORT PROC stripCommentFromLine(line:PTR TO CHAR)
/*
  NAME

    stripCommentFromLine()

  FUNCTION

    Strips E comments from a line. Thefollowing is stripped:

    - everything between each /+ +/
    - everything in front of a single +/
    - everything after a single /+
    - everything after - >

  INPUTS

    line:PTR TO CHAR

      The line to work with, left unchanged.

  RESULTS

    PTR TO CHAR

      New 'pure' line.

  HISTORY

    September 28 1995 Gregor Goldbach

      Creation
*/

DEF multStart,
    multEnd,
    singStart,
    stringBuffer,
    temp_stringBuffer,
    len


  len := StrLen(line)

  stringBuffer := String(len)
  temp_stringBuffer := String(len)

  StrCopy(stringBuffer,line)

  singStart := isOneLineComment(stringBuffer)

-> first, set the length according to the - >

  IF singStart <> -1 THEN SetStr(stringBuffer,singStart)


/*
 * Now remove the /+ +/ parts. That is, copy the string up to /+ and
 * after +/ . Do this until there is no more /+ or +/ or +/ preceeds /+
 */


 -> get the current positions

  multStart := isMultiLineCommentStart(stringBuffer)
  multEnd := isMultiLineCommentEnd(stringBuffer+multStart) + multStart


  REPEAT


    IF ((multStart<>-1) AND (multEnd<>-1) AND (multStart<multEnd))

      StrCopy(temp_stringBuffer,stringBuffer,multStart)
      StrAdd(temp_stringBuffer,stringBuffer+multEnd+2,StrLen(stringBuffer)-multEnd-1)

      StrCopy(stringBuffer,temp_stringBuffer)

    ENDIF


    multStart := isMultiLineCommentStart(stringBuffer)
    multEnd := isMultiLineCommentEnd(stringBuffer+multStart)


  UNTIL (multStart=-1) OR (multEnd=-1) OR (multStart>multEnd)





-> now check if the / * is alone or if it's behind the * /

  IF ((multStart<>-1) AND (multEnd=-1)) OR ((multStart<>-1) AND (multEnd<multStart))

    SetStr(stringBuffer,multStart)

  ENDIF


  multStart := isMultiLineCommentStart(stringBuffer)
  multEnd := isMultiLineCommentEnd(stringBuffer)


-> now check if the * / is alone or if it's in front of the / *

  IF ((multEnd<>-1) AND (multStart=-1)) OR ((multEnd<>-1) AND (multStart<multEnd))

    StrCopy(temp_stringBuffer,stringBuffer+multEnd+2, StrLen(stringBuffer)-multEnd)
    StrCopy(stringBuffer,temp_stringBuffer)

  ENDIF


  SetStr(temp_stringBuffer,len) ->set to original length
  Dispose(temp_stringBuffer)

  temp_stringBuffer := String(StrLen(stringBuffer)) -> only that much we need
  StrCopy(temp_stringBuffer, stringBuffer)
  SetStr(stringBuffer, len) ->set to original length
  Dispose(stringBuffer)

  RETURN temp_stringBuffer

ENDPROC

EXPORT PROC goToEndOfMultiLineComment(source:PTR TO programSource, fromLine)
/*
  NAME

    goToEndOfMultiLineComment()

  FUNCTION

    Goes to the the line that contains the * / of a multi line
    comment.

  INPUTS

    PTR TO programSource

      The source file to search in.

    fromLine

      The line number to start the search.

  RETURNS

    The line the * / is in.

  NOTE

    Nested comments are NOT supported yet.

  HISTORY

    September 28 1995 Gregor Goldbach

      Creation

*/

DEF line

  REPEAT

    line := source.getNextLine()

  UNTIL (isMultiLineCommentEnd(line) <> -1) OR (source.atEnd()) OR (CtrlC())

  RETURN line

ENDPROC
/*EE folds
-1
7 10 11 41 14 3 17 23 20 23 23 19 27 20 33 123 36 46 
EE folds*/
