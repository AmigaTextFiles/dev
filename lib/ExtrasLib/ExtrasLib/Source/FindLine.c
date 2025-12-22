#include <string.h>

#include <clib/extras_protos.h>
#include <proto/dos.h>
#include <proto/exec.h>

/****** extras.lib/FindLine ******************************************
*
*   NAME
*       FindLine - find the next matching line in a file.
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


LONG FindLine(BPTR File, STRPTR Name, STRPTR Buffer, ULONG BufferSize)
{
  while(FGets(File,Buffer,BufferSize))
  {
    Strip(Buffer);
    if(stricmp(Buffer,Name)==0)
      return(1);
  }
  return(0);
}
