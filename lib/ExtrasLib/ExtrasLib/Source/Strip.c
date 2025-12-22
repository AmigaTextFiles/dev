#include <exec/types.h>

#include <clib/extras/string_protos.h>

/****** extras.lib/str_Strip ******************************************
*
*   NAME
*       str_Strip - Remove leading and trailing white spaces.
*
*   SYNOPSIS
*       str_Strip(Str)       
*
*       void Strip(STRPTR);
*
*   FUNCTION
*       This function removes leading and trailing whites-paces
*       from a string.  White-spaces are determined by the 
*       IsWhiteSpace() function.
*
*   INPUTS
*       Str - a null terminated string pointer.
*
*   RESULT
*       none.
*
*   EXAMPLE
*
*   NOTES
*       Modifies existing string memory.
*
*   BUGS
*       Will not work on NNStr used by other some functions in 
*       the extras.lib.
*
*   SEE ALSO
*       IsWhiteSpace().
*
******************************************************************************
*
*/


void str_Strip(STRPTR Str)
{
  STRPTR  s1,s2;
  
  s1=s2=Str;
  
  while(IsWhiteSpace(*s2))
    s2++;
  
  while(*s2)
  {
    *s1=*s2;
    s1++;
    s2++;
  }
  
  *s1=0;
  
  while(s1>Str)
  {
    s1--;
    if(IsWhiteSpace(*s1))
      *s1=0;
    else
      return;
  }
}

