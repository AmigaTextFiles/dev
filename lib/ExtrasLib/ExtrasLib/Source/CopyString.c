#include <exec/types.h>
#include <proto/exec.h>
#include <string.h>

#include <clib/extras/string_protos.h>

/****** extras.lib/CopyString ******************************************
*
*   NAME
*       CopyString -- Copy a string
*
*   SYNOPSIS
*       newstring = CopyString(Source, MemFlags)
*
*       STRPTR CopyString(STRPTR, ULONG);
*
*   FUNCTION
*       Allocates memory using AllocVec and copies a string.
*
*   INPUTS
*       Source - the source string to copy
*       MemFlags - Memory flags see exec.library/AllocVec()
*
*   RESULT
*       String pointer or NULL. 
*
*   NOTES
*       newstring must be freed with FreeVec.
*
*   SEE ALSO
*     exec.library/AllocVec(), exec.library/FreeVec()
*
******************************************************************************
*
*/


STRPTR CopyString(STRPTR Source,ULONG MemFlags)
{
  STRPTR str;
  
  str=0;
  if(Source)
  {
    if(str=AllocVec(strlen(Source)+1,MemFlags))
    {
      strcpy(str,Source);
    }
  }

  return(str);
}
