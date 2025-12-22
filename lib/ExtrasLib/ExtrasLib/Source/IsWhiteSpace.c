#include <exec/types.h>

#include <clib/extras/string_protos.h>

/****** extras.lib/IsWhiteSpace ******************************************
*
*   NAME
*       IsWhiteSpace -- Is a character a "white-space"
*
*   SYNOPSIS
*       IsWhiteSpace(Char)
*
*       BOOL IsWhiteSpace(char);
*
*   FUNCTION
*       Indicate whether or not a character is a "white-space"
*
*   INPUTS
*       Char - a letter.
*
*   RESULT
*       non-0 if Char is " "(space), "\t"(tab), or "\n"(cr)
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


BOOL IsWhiteSpace(char Char)
{
  if(Char==' ' || Char=='\t' || Char=='\n')
    return(1);
  return(0);
}
