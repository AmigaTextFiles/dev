#include <exec/types.h>
#include <string.h>

#include <clib/extras/string_protos.h>

/****** extras.lib/StrIStr ******************************************
*
*   NAME
*       StrIStr -- search for a string in another string, case 
*                  insenseitive.
*
*   SYNOPSIS
*       StrIStr(InStr,SearchStr)
*
*       STRPTR StrIStr(STRPTR InStr,STRPTR SearchStr);
*
*   FUNCTION
*       Seach for a string inside another, case insensitive.
*
*   INPUTS
*       InStr - the string to search in.
*       SearchStr - the string to search for.
*
*   RESULT
*       returns a pointer in InStr that matches SearchStr, or NULL
*       if no match was found.
*
******************************************************************************
*
*/



STRPTR StrIStr(STRPTR InStr,STRPTR SearchStr)
{
  LONG l,l2,t=0;
  
  if(InStr && SearchStr)
  {
    l2=strlen(SearchStr);
    l=strlen(InStr)-l2;
    
    while(t<=l)
    {
      if(strnicmp(&InStr[t],SearchStr,l2)==0)
        return(&InStr[t]);
      t++;
    }
  }
  return(0);
}
