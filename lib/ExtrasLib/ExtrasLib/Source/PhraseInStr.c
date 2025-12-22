#include <exec/types.h>
#include <string.h>
#include <ctype.h>

#include <clib/extras/string_protos.h>

/****** extras.lib/PhraseInStr ******************************************
*
*   NAME
*       PhraseInStr -- Find a phrase or word in a string.
*
*   SYNOPSIS
*       str = PhraseInStr(InStr, Phrase)
*
*       STRPTR PhraseInStr(STRPTR , Phrase)
*
*   FUNCTION
*       Locates a phrase or word in a string.
*
*   INPUTS
*       InStr - String to search in.
*       Phrase to search for.
*
*   RESULT
*       returns pointer to phrase in InStr or NULL.
*
*   EXAMPLE
*
*   NOTES
*       case insensitive.
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/

STRPTR PhraseInStr(STRPTR InStr,STRPTR Phrase)
{
  LONG l,l2,t=0;
  
  if(InStr && Phrase)
  {
    l2=strlen(Phrase);
    l=strlen(InStr)-l2;
    
    while(!isalnum(InStr[t]))
      t++;
    
    while(t<=l)
    {
      if(strnicmp(&InStr[t],Phrase,l2)==0)
      {
        if(!isalnum(InStr[t+l2]))
          return(&InStr[t]);
      }
      t++;
      while(isalnum(InStr[t]))
        t++;
      while(!isalnum(InStr[t]))
        t++;
    }
  }
  return(0);
}

