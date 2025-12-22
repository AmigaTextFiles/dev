#include "MyLib.h"

/****** MyLib.lib/PError *************************************************
*
*    NAME
*	PError -- output a dos error message
*
*    SYNOPSIS
*	PError(ErrorCode, Header)
*
*	void PError(LONG, const char *);
*
*    FUNCTION
*	This function works like dos.library/PrintFault(), except that
*	it outputs to StdErr.
*
*    INPUTS
*	ErrorCode - the error code representing the error.
*	            0 will cause IoErr() to be used instead.
*	Header    - an optional header
*
*    NOTE
*	This function calls ErrorHandle(), which means you will have
*	an initialized StdErr stream afterwards.
*
*    SEE ALSO
*	dos.library/PrintFault(), ErrorHandle()
*
*************************************************************************/

void PError(LONG ErrorCode, const char *String)

{
  BPTR OldOutput;

  if (!ErrorCode)
    {
      ErrorCode=IoErr();
    }
  OldOutput=SelectOutput(ErrorHandle());
  Flush(OldOutput);
  PrintFault(ErrorCode,(char *)String);
  SelectOutput(OldOutput);
}
