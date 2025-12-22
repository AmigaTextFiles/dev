#include "MyLib.h"

/****** MyLib.lib/VSPrintf ***********************************************
*
*    NAME
*	VSPrintf -- format a string
*
*    SYNOPSIS
*	Length=VSPrintf(String,FormatString,...)
*
*	int VSPrintf((char *, const char *, ...);
*
*    FUNCTION
*	This function works like dos.library/VPrintf(), except that
*	"prints" to a string in memory.
*
*    INPUTS
*	String       - pointer to enough memory to receive the string.
*	               NULL if you just want to count characters.
*	FormatString - the format string, suitable for RawDoFmt()
*
*    RESULT
*	Length - the number of characters "printed", not counting the
*	         terminating '\0'.
*
*    BUGS
*	This should really be done in assembler.
*
*    SEE ALSO
*	dos.library/VPrintf(), exec.library/RawDoFmt()
*
*************************************************************************/

struct StringInfo
{
  char *String;
  int Index;
};

static void __asm __saveds __PutChProc(register __d0 char c, register __a3 struct StringInfo *StringInfo)

{
  if (StringInfo->String)
    {
      StringInfo->String[StringInfo->Index]=c;
    }
  StringInfo->Index++;
}

int VSPrintf(char *String, const char *FormatString, va_list Args)

{
  struct StringInfo StringInfo;

  StringInfo.String=String;
  StringInfo.Index=0;
  RawDoFmt((char *)FormatString,Args,__PutChProc,&StringInfo);
  return StringInfo.Index-1;
}
