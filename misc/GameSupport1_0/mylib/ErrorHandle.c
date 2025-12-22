#ifndef DOS_DOSEXTENS_H
#include <dos/dosextens.h>
#endif

#include "MyLib.h"

BPTR StdErr;
int __MyLib_CloseStdErr;

/****** MyLib.lib/CloseStdErr ********************************************
*
*    NAME
*	CloseStdErr -- close the StdErr stream
*
*    SYNOPSIS
*	CloseStdErr()
*
*	void CloseStdErr(void);
*
*    FUNCTION
*	Close the StdErr stream
*
*    SEE ALSO
*	ErrorHandle(), StdErr
*
*************************************************************************/

/****** MyLib.lib/ErrorHandle ********************************************
*
*    NAME
*	ErrorHandle -- create a StdErr handle
*
*    SYNOPSIS
*	ErrorStream=ErrorHandle()
*
*	BPTR ErrorHandle(void);
*
*    FUNCTION
*	This function finds a suitable(?) error stream.
*	You can call this function as often as you want.
*
*	The stream is also stored in StdErr, so you can call ErrorHandle()
*	once and use the global StdErr variable afterwards.
*
*	Currently these steps are used to find an error stream:
*	  1) use pr_CES if != 0
*	  2) open CONSOLE:. Use it if successful
*	  3) Use Output() if it is interactive
*	  4) open CON://///AUTO/WAIT. Use it if successful
*	  5) open NIL:. Use it if successful
*	  6) use Output()
*
*    PREPROCESSOR SYMBOLS
*	MYLIB_STDERR
*
*    RESULT
*	ErrorHandle -- an error stream
*
*    SEE ALSO
*	StdErr, CloseStdErr()
*
*************************************************************************/

/****** MyLib.lib/StdErr *************************************************
*
*    NAME
*	StdErr -- the global error handle
*
*    SYNOPSIS
*	BPTR StdErr;
*
*    FUNCTION
*	After calling ErrorHandle(), you can find the error stream
*	in this variable. ErrorHandle() returns that variable, too.
*
*    SEE ALSO
*	ErrorHandle()
*
*************************************************************************/

BPTR ErrorHandle(void)

{
  if (!StdErr)
    {
      BPTR Handle;

      if (!(Handle=((struct Process *)FindTask(NULL))->pr_CES))
	{
	  if (!(Handle=Open("CONSOLE:",MODE_NEWFILE)))
	    {
	      if (!IsInteractive(Handle=Output()))
		{
		  BPTR NewHandle;

		  if ((NewHandle=Open("CON://///AUTO/WAIT",MODE_NEWFILE)) || (NewHandle=Open("NIL:",MODE_NEWFILE)))
		    {
		      Handle=NewHandle;
		      __MyLib_CloseStdErr=TRUE;
		    }
		}
	    }
	  else
	    {
	      __MyLib_CloseStdErr=TRUE;
	    }
	}
      StdErr=Handle;
    }
  return StdErr;
}
