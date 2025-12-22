/****** sourceBlock/--background-- ******************************************

    PURPOSE
        Simple object for keeping track of things when navigating through
        source files. This object is to be extended by other objects for
        specific language reasons. Mainly this object is meant to be used
        for building lists of functions, object definitions, whateveryouwant
        when processing any kind of language.

    CREATION
        September 24 1995 Gregor Goldbach

******************************************************************************

History


*/
OPT MODULE

MODULE  'oomodules/file/textfile/programSource',
        'oomodules/object'

EXPORT OBJECT sourceBlock OF object
/****** sourceBlock/--sourceBlock-- ******************************************

    NAME
        sourceBlock

    ATTRIBUTES
        source:PTR TO programSource -- The source this block is defined in.

        identifier:PTR TO CHAR -- The name of this block. If it's a PROC,
            this would be the proc's name.

        startLine -- Number of the line it starts in.

        endLine -- Number of the line it ends in.

        type -- the type of the block, e.g. comment, function etc. Set it
            as you like.

******************************************************************************

History


*/
  source:PTR TO programSource
  identifier:PTR TO CHAR
  startLine
  endLine
  type -> any type you want
ENDOBJECT

EXPORT PROC init() OF sourceBlock IS EMPTY
EXPORT PROC end() OF sourceBlock IS EMPTY
EXPORT PROC name() OF sourceBlock IS 'SourceBlock'

EXPORT PROC copyTo(sourceBlock:PTR TO sourceBlock) OF sourceBlock
/****** sourceBlock/copyTo *****************************************

    NAME
        copyTo() -- Copy itself to another sourceBlock

    SYNOPSIS
        sourceblock.copyTo(sourceBlock:PTR TO sourceBlock)

    FUNCTION
        Copies attributes to another sourceBlock.

    INPUTS
        sourceBlock:PTR TO sourceBlock -- Destination source block.

******************************************************************************

History


*/

  sourceBlock.startLine := self.startLine
  sourceBlock.endLine := self.endLine
  sourceBlock.source := self.source
  sourceBlock.type := self.type
ENDPROC

/*
EXPORT PROC inRange(lineNumber) OF sourceBlock IS ((self.startLine<=lineNumber) AND (self.endLine>=lineNumber))
/****** sourceBlock/inRange ******************************************

    NAME 
        inRange() -- Is a line included in the Source Block?

    SYNOPSIS
        BOOL sourceBlock.inRange(LONG)

    FUNCTION
        Determines if a line lies between the boundaries of a Source Block.

    INPUTS
        lineNumber:LONG -- Number of the line to test. Note that only this
            number is tested, NOT the actual contents of the line.

    RESULT
        BOOL -- TRUE if the line is included, FALSE otherwise.

******************************************************************************

History


*/
*/
