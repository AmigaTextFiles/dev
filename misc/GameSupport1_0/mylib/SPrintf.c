#include "MyLib.h"

/****** MyLib.lib/SPrintf ************************************************
*
*    NAME
*	SPrintf -- format a string
*
*    SYNOPSIS
*	Length=SPrintf(String,FormatString,...)
*
*	int SPrintf(char *, const char *, ...);
*
*    FUNCTION
*	This function works like dos.library/Printf(), except that
*	"prints" to a string in memory.
*
*    INPUTS
*	String       - pointer to enough memory to receive the string,
*	               or NULL if you just want to count characters.
*	FormatString - the format string, suitable for RawDoFmt()
*
*    RESULT
*	Length - the number of characters "printed", not counting the
*	         terminating '\0'.
*
*    SEE ALSO
*	dos.library/Printf(), exec.library/RawDoFmt()
*
*************************************************************************/

int SPrintf(char *String, const char *FormatString, ...)

{
  int Result;
  va_list Params;

  va_start(Params,FormatString);
  Result=VSPrintf(String,FormatString,Params);
  va_end(Params);
  return Result;
}
