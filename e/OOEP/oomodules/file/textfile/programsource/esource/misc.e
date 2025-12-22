OPT MODULE
OPT PREPROCESS

->#define DEBUG

EXPORT PROC copyLineAndStripWord(line:PTR TO CHAR,word=NIL:PTR TO CHAR)
/****** /copyLineAndStripWord ******************************

    NAME
        copyLineAndStripWord() -- Copy a string and extract a part of it.

    SYNOPSIS
        copyLineAndStripWord(PTR TO CHAR, PTR TO CHAR=NIL:PTR TO CHAR)

        copyLineAndStripWord(line, word)

    FUNCTION
        Copies a line. If the word parameter is specified the first occurence
        of that string will be stripped for the copy.

    INPUTS
        line:PTR TO CHAR -- Normal string.

        word:PTR TO CHAR -- Word to extract.

    RESULT
        PTR TO CHAR -- The copied line. May be NIL. It's length is 0 if
        the original line contained only the word to strip.

    EXAMPLE
        linePtr := copyLineAndStripWord('Remove the PRIVATE keyword',
                      'PRIVATE)

       /*
        * linePtr now points to 'Remove the  keyword'
        */

        DisposeLink(linePtr)

        linePtr := copyLineAndStripWord('PRIVATE',
                      'PRIVATE)

       /*
        * linePtr now points to ''
        */

        DisposeLink(linePtr)

    NOTES
        Debug information will be printed to stdout if recompiled with
        #define DEBUG
********/
DEF copyOfLine:PTR TO CHAR,
     wordPosition

  #ifdef DEBUG
   WriteF('\nentered misc.m/copyLineAndStripWord()\n')
  #endif

  copyOfLine := String(StrLen(line))

  IF copyOfLine = NIL THEN RETURN NIL

  IF word

     wordPosition := InStr(line, word)

     IF (wordPosition>-1)

    #ifdef DEBUG
    WriteF('Found word to replace at position \d.\n',wordPosition)
    WriteF('Length of word to replace is \d.\n', StrLen(word))
    #endif

       StrCopy(copyOfLine, line, wordPosition)
       StrAdd(copyOfLine,line+wordPosition+StrLen(word))

    ELSE

     StrCopy(copyOfLine, line)

     ENDIF

   ELSE

     StrCopy(copyOfLine, line)

   ENDIF

  #ifdef DEBUG
   WriteF('Line to return is :\s:\n',copyOfLine)
  #endif

   RETURN copyOfLine

ENDPROC


