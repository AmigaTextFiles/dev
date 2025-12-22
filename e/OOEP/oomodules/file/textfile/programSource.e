/****** programSource/--background-- ******************************************

    PURPOSE
        The basic object for dealing with program sources is programSource.
        You may interpret, compile and edit the file as well as anylizing
        it.

    CREATION
        September 24 1995 Gregor Goldbach

    HISTORY
        October 2 1995 Gregor Goldbach
          Moved sourceBlock to the subdirectory of this object.

******************************************************************************

History


*/
OPT MODULE

MODULE  'oomodules/file/textfile',
        'oomodules/file/textfile/programSource/sourceBlock',
        'oomodules/list/queuestack'

EXPORT OBJECT programSource OF textfile
/****** programSource/--programSource-- ******************************************

    NAME
        programSource

    ATTRIBUTES
        None at this point. May change

******************************************************************************

History


*/
PRIVATE

ENDOBJECT


EXPORT PROC interpret() OF programSource
/****** programSource/interpret *****************************************

    NAME
        interpret() -- Interpret this source.

    SYNOPSIS
        programSource.interpret()

    FUNCTION
        Runs this source in interpreter mode. Has to be extended by
        inheriting objects, by now it does nothing.

******************************************************************************

History


*/
ENDPROC

EXPORT PROC compile() OF programSource
/****** programSource/compile *****************************************

    NAME
        compile() -- Compile this source.

    SYNOPSIS
        programSource.compile()

    FUNCTION
        Runs this source in compile mode. Has to be extended by
        inheriting objects, by now it does nothing.

******************************************************************************

History


*/
ENDPROC


EXPORT PROC findBlock(head:PTR TO CHAR, tail:PTR TO CHAR, fromLine=0, mode="FrFr") OF programSource
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

PROC buildBlockList(head:PTR TO CHAR, tail:PTR TO CHAR, fromLine=0, mode="FrFr",proc=NIL) OF programSource
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
    qs:PTR TO queuestack,
    sourceBlock:PTR TO sourceBlock,
    list


  NEW qs.new()


  start,end := self.findBlock(head, tail, fromLine, mode)


  WHILE (start<>-1) AND (end<>-1)

    sourceBlock := NEW sourceBlock
    sourceBlock.startLine := start
    sourceBlock.endLine := end
    sourceBlock.source := self

    IF proc THEN sourceBlock := proc(sourceBlock) -> note that the source block address may have changed

    qs.addLast(sourceBlock)

   /*
    * make findBlock() use the endLine attribute of the resulting sourceBlock.
    * Since proc(sourceBlock) is called, that proc could have changed this
    * attribute for any reason. For example, a single-lined E procedure
    * wouldn't be found by findBlock() (the ENDPROC is missing), the proc
    * could therefore check the first line and set the new endLine attribute
    * so the search can be done from the right line.
    */

    start,end := self.findBlock(head, tail, sourceBlock.endLine+1, mode)


  ENDWHILE


  list := qs.asList()

  END qs

  RETURN list

ENDPROC

EXPORT PROC name() OF programSource IS 'Programsource'
/*EE folds
-1
27 17 30 18 33 18 
EE folds*/
