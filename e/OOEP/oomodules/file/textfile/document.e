OPT MODULE

MODULE  'oomodules/file/textfile'

EXPORT OBJECT document OF textfile
ENDOBJECT

EXPORT OBJECT textBlock
  startLine,
  endLine,
  document:PTR TO document
ENDOBJECT

EXPORT PROC display() OF document
ENDPROC

EXPORT PROC edit() OF document
ENDPROC

EXPORT PROC findBlock(head:PTR TO CHAR, tail:PTR TO CHAR, fromLine=0, mode="FrFr") OF document
/****** programSource/findBlock *****************************************

    NAME
        findBlock() -- Find a source block in the file.

    SYNOPSIS
        programSource.findBlock(head:PTR TO CHAR, tail:PTR TO CHAR,
            fromLine=0, mode="FrFr")

    FUNCTION
        Looks for a block in the source. The block starts with the head line
        and ends with the tail line.

    INPUTS
        head:PTR TO CHAR -- Pointer to the text that marks the head of the
            block

        tail:PTR TO CHAR -- Pointer to the text that marks the tail of the
            block

        fromLine=0
          Number of the line where the search should start.

        mode
          One of the following:
            "FrFr" - head is at the beginning of the line, tail too
            "FrBa" - head is at the beginning of the line, tail is
                at the end
            "BaFr" - head is at the back, tail at the front
            "BaBa" - both strings are at the end

    RESULTS
        startLine, endLine -- Numbers of the lines where the according
            part starts. Note that startLine may be 0 if you started at 0,
            else both numbers should be greater than 0.

    EXAMPLES

        source.findBlock('{','}', 0, "FrBa")

          should find this segment:

          {int n;
              n = i*3;
            return(n)}



        source.findBlock('PROC','ENDPROC', 0, "FrFr")

          should find this segment:

         PROC foo(bar=NIL)
         RETURN "did ","you ", "know"
         ENDPROC

******************************************************************************

History


*/

DEF startLine,
     endLine

 /*
  * If the head is not found we don't search for the tail, so
   * endLine stays -1. Important for the end.
   */

  endLine := -1

  SELECT mode

     CASE "FrFr"

   /*
    * Try to find the first line of the block. If we receive atEnd, then
    * the head was not found, so we don't search for the tail.
    *
    * See below, if atEnd is TRUE we didn't find the block.
    */

    startLine := self.findLine(head,fromLine)
    IF startLine>-1 THEN endLine := self.findLine(tail, startLine)

     CASE "FrBa"

    startLine := self.findLine(head,fromLine)
    IF startLine>-1 THEN endLine := self.findLineFromBack(tail, startLine)

     CASE "BaFr"

    startLine := self.findLineFromBack(head,fromLine)
    IF startLine>-1 THEN endLine := self.findLine(tail, startLine)

     CASE "BaBa"

    startLine := self.findLineFromBack(head,fromLine)
    IF startLine>-1 THEN endLine := self.findLineFromBack(tail, startLine)

   ENDSELECT

 /*
  * startLine and endLine equal -1 if the block was not found
   */

  RETURN startLine, endLine

ENDPROC

PROC buildBlockList(head:PTR TO CHAR, tail:PTR TO CHAR, fromLine=0, mode="FrFr",proc=NIL) OF document
/****** programSource/buildBlockList *****************************************

    NAME
        buildBlockList() -- Build a list of blocks in the source.

    SYNOPSIS
        programSource.buildBlockList(head:PTR TO CHAR, tail:PTR TO CHAR,
            fromLine=0, mode="FrFr",proc=NIL)

    FUNCTION
        Builds an elist with source blocks found by findBlock(). Before
        adding a found source block to the list it is passed to a function
        defined in the proc parameter.

    INPUTS
        head:PTR TO CHAR -- Pointer to the text that marks the head of the
            block

        tail:PTR TO CHAR -- Pointer to the text that marks the tail of the
            block

        fromLine=0
          Number of the line where the search should start.

        mode -- One of the following:
          "FrFr" - head is at the beginning of the line, tail too
          "FrBa" - head is at the beginning of the line, tail is
           at the end
          "BaFr" - head is at the back, tail at the front
          "BaBa" - both strings are at the end

        proc=NIL -- Pointer to a procedure which has one parameter: the
            source block which was found. This way nheriting objects can
            modify source blocks immediately when they are found.

    RESULT
        elist with source blocks found.

    SEE ALSO
        programSource/sourceBlock
******************************************************************************

History


*/
DEF start,
    end,
    textBlock:PTR TO textBlock,
    list:PTR TO LONG,
    index


  list := List(255)
  index:=0

  start,end := self.findBlock(head, tail, fromLine, mode)

  WHILE (start<>-1) AND (end<>-1)

    textBlock:=NIL
    NEW textBlock

    textBlock.startLine := start
    textBlock.endLine := end
    textBlock.document := self


    IF proc THEN textBlock := proc(textBlock) -> note that the text block address may have changed after calling this

    list[index] := textBlock
    INC index

    EXIT (index=255)

    start,end := self.findBlock(head, tail, end, mode)

  ENDWHILE

  IF index=0 THEN DisposeLink(list) ELSE SetList(list,index)

  RETURN list

ENDPROC

PROC copyTo(n:PTR TO textBlock) OF textBlock

  n.startLine := self.startLine
  n.endLine := self.endLine
  n.document := self.document

ENDPROC
/*EE folds
-1
20 110 
EE folds*/
