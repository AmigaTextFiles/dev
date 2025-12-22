#include <clib/extras/nnstring_protos.h>
#include <extras/nnstring.h>
#include <exec/types.h>

/****** extras.lib/nns_NNStrLen ******************************************
*
*   NAME
*       nns_NNStrLen -- Return the length of an NNString.
*
*   SYNOPSIS
*       length=nns_NNStrLen(NNStr)
*
*       LONG nns_NNStrLen(STRPTR);
*
*   FUNCTION
*       Returns the length in bytes of an NNString, including the
*       trailing NULLs. 
*
*   INPUTS
*       NNStr - NNString pointer.
*
*   RESULT
*       Size of NNStr include NULLs.
*
*   SEE ALSO
*
******************************************************************************
*
*/

LONG nns_NNStrLen(STRPTR NNStr)
{
  LONG l=0;
  
  while(*NNStr || *(NNStr+1))
  {
    NNStr++;
    l++;
  }
  return(l+2);
}


