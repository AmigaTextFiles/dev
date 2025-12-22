#include "MyLib.h"

/****** MyLib.lib/Seek ***************************************************
*
*    NAME
*	Seek -- bug-fixed dos.library/Seek()
*
*    SYNOPSIS
*	Position=Seek(Filehandle,Position,Mode)
*
*	LONG Seek(BPTR, LONG, LONG);
*
*    FUNCTION
*	If ROM_VERSION < 39, then calls to Seek() will be replaced by
*	calls to a library function that attempts to work around the
*	V37 ROM filesystem bug.
*
*    SEE ALSO
*	dos.library/Seek()
*
*************************************************************************/

LONG (Seek37)(BPTR Filehandle, LONG Position, LONG Mode)

{
  LONG Result;

  SetIoErr(0L);
  Result=(Seek)(Filehandle,Position,Mode);
  if (IoErr())
    {
      Result=-1L;
    }
  return Result;
}
