#include <clib/extras/math_protos.h>
#include <stdio.h>

/****** extras.lib/ftos ******************************************
*
*   NAME
*       ftos - Convert a float to a string
*
*   SYNOPSIS
*
*
*
*
*
*
*   FUNCTION
*
*
*   INPUTS
*
*   RESULT
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

STRPTR ftos(float Value, STRPTR Buffer)
{
  sprintf(Buffer,"%.4f",Value);
  return(Buffer);
}
