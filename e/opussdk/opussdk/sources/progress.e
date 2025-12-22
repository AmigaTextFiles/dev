/*****************************************************************************

 Progress window

 *****************************************************************************/
OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem'

CONST PW_Screen     = TAG_USER + 0        -> Screen to open on
CONST PW_Window     = TAG_USER + 1        -> Owner window
CONST PW_Title      = TAG_USER + 2        -> Window title
CONST PW_SigTask    = TAG_USER + 3        -> Task to signal
CONST PW_SigBit     = TAG_USER + 4        -> Signal bit
CONST PW_Flags      = TAG_USER + 5        -> Flags
CONST PW_FileName   = TAG_USER + 6        -> File name
CONST PW_FileSize   = TAG_USER + 7        -> File size
CONST PW_FileDone   = TAG_USER + 8        -> File done
CONST PW_FileCount  = TAG_USER + 9        -> Number of files
CONST PW_FileNum    = TAG_USER + 10       -> Current number
CONST PW_Info       = TAG_USER + 11       -> Information line

SET PWF_FILENAME,        -> Filename display
    PWF_FILESIZE,        -> Filesize display
    PWF_INFO,            -> Information line
    PWF_GRAPH,           -> Bar graph display
    PWF_NOABORT,         -> No abort gadget
    PWF_INVISIBLE,       -> Open invisibly
    PWF_ABORT,           -> Want abort gadget
    PWF_SWAP             -> Swap bar and size displays
