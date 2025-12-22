#include <exec/types.h>

#include <clib/extras/nnstring_protos.h>

/****** extras.lib/NNString_Overview ******************************************
*
*   FUNCTION
*       An NNString is an array of strings, stored end to end, ending
*       with a double NULL.  Individual strings are seperated by NULLs.
*
*   EXAMPLE
*       An NNString representing this array of strings:
*       "Cow" "Dog" "Barn"
*       would look like this:
*       "Cow\0Dog\0Barn\0\0"
*
*   SEE ALSO
*       NextNNStr(), ProcessNNStr, GetEntryData(), AddNNStr(), 
*       NNStrLen()
*
******************************************************************************
*
*/


/****** extras.lib/NextNNStr ******************************************
*
*   NAME
*       NextNNStr -- Get the next string in a double NULL terminted
*                    string array (aka NNString).
*
*   SYNOPSIS
*       nextstring=NextNNStr(NNString)
*
*       STRPTR NextNNStr(STRPTR);
*
*   FUNCTION
*       returns a pointer to the next string contained in a 
*       double NULL teminated string array, or NULL.
*
*   INPUTS
*       NNString - A pointer to some part of a double NULL string.
*
*   RESULT
*       Pointer to the next string or NULL if there is no string.
*
*   EXAMPLE
*       ** this example steps through an NNString. **
*
*       STRPTR NNString;
*       STRPTR str;
*
*       for(str=NNString; str; str=NextNNStr(str))
*       {
*         printf("%s\n",str);
*       }
*
*       The above can be simplified by using the ProcessNNStr macro
*       defined in extras/nnstring.h
*
*       STRPTR NNString;
*       STRPTR str;
*
*       ProcessNNStr(NNString,str)
*       {
*         printf("%s\n",str);
*       }
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       NNString AddNNStr() ProcessNNStr, extras/macros.h
*
******************************************************************************
*
*/

STRPTR NextNNStr(STRPTR Str)
{
  while(*Str)
    Str++;
  Str++; 
  if(!*Str) 
    Str=0;
  return(Str);
}
