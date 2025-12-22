#include <exec/types.h>
#include <clib/alib_protos.h>

/****** extras.lib/ArgYesNo ******************************************
*
*   NAME
*       ArgYesNo - Get a boolean tooltype value.
*
*   SYNOPSIS
*       yes = ArgYesNo(TTypes,Entry,DefVal)
*
*       BOOL ArgYesNo(UBYTE **, STRPTR, DefVal);
*
*   FUNCTION
*       This function returns the value of a boolean tooltype.
*
*   INPUTS
*       TTypes - a ToolTypes array returned by ArgArrayInit()
*       Entry - the entry to search for.
*       DefVal - the default boolean value.
*
*   RESULT
*       This function only considers the first letter of the
*       of the value for the tooltype.  If the first letter
*       of the value for the tooltype is 'Y' 'y' 'T' or 't'
*       then this function returns 1, if the function finds
*       'N' 'n' 'F' or 'f' then it returns 0, if this function
*       finds any other character or cannot find the tooltype,
*       then the function returns the DefVal.
*
*   NOTES
*       must link with amiga.lib
*
*   SEE ALSO
*     amiga.lib/ArgArrayInit(), amiga.lib/ArgString(),
*     amiga.lib/ArgInt(), amiga.lib/ArgArrayDone()
******************************************************************************
*
*/

BOOL ArgYesNo(UBYTE **TTypes, STRPTR Entry,BOOL DefVal)
{
  BOOL retval;
  UBYTE *s;
  UBYTE *def;
        
  retval=DefVal;
  
  if(s=ArgString(TTypes,Entry,0))
  {
    switch(*s)
    {
      case 'Y':
      case 'y':
      case 'T':
      case 't':
        retval=1;
        break;
      case 'N':
      case 'n':
      case 'F':
      case 'f':
        retval=0;
        break;
    }
  }  
  return retval;
}

