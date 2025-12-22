#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <clib/extras_protos.h>
#include <proto/dos.h>
#include <proto/exec.h>

/****** extras.lib/db_NextEntry ******************************************
*
*   NAME
*       db_NextEntry - Find the next entry in a database file.
*
*   SYNOPSIS
*       error = db_NextEntry(File, EntryName, Buffer, BufferSize)
*       
*       LONG db_NextEntry(BPTR, STRPTR, STRPTR, ULONG);
*
*   FUNCTION
*       Seeks for the next entry in a database file.
*
*   INPUTS
*       File - AmigaDos file handle.
*       EntryName - the name of the entry, usually "ENTRY".
*              case is insignificant.
*       Buffer - a buffer for reading data from a file.
*       BufferSize - the size of the buffer.
*
*   RESULT
*       returns 0 on failure.  on success the file is positioned
*       inside the entry.
*
*   EXAMPLE
*
*   NOTES
*       This function is mainly used for other lib functions
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


LONG db_NextEntry(BPTR File, STRPTR EntryName, STRPTR Buffer, ULONG BufferSize)
{
  while(FGets(File,Buffer,BufferSize))
  {
    Strip(Buffer);
    if(stricmp(Buffer,EntryName)==0)
    { /* found "ENTRY" */
      if(FGets(File,Buffer,BufferSize))
      { /* Now confirm that next line is "{" */
        Strip(Buffer);
        if(strcmp(Buffer,(STRPTR)"{")==0)
        { /* next line is "{" */
          return(1);
        }
      }
      /* else format error */
      return(0);
    }
    else
    {
      if(strcmp(Buffer,(STRPTR)"{")==0)
      {
        if(!FindLine(File,(STRPTR)"}",Buffer,BufferSize))
        { /* format error, "{" missing matching "}"*/
          return(0);
        }
      }
    }  
  } /* EOF or other error */
  return(0);
}

