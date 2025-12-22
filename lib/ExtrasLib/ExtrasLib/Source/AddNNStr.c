#include <clib/extras/nnstring_protos.h>
#include <string.h>
#include <proto/exec.h>

/****** extras.lib/nns_AddNNStr ******************************************
*
*   NAME
*       nns_AddNNStr -- append a normal string to a NNString.
*
*   SYNOPSIS
*       NewNNStr=nns_AddNNStr(NNStr,New)
*
*       STRPTR nns_AddNNStr(STRPTR, STRPTR);
*
*   FUNCTION
*       
*
*   INPUTS
*       NNStr - an existing NNString or NULL, if NULL
*           the function converts str into an NNString.
*       New - a regular NULL terminated string.
*
*   RESULT
*       A new NNString or NULL, NNStr *WILL* be freed
*       regardless of result.  if New is NULL, NNStr will
*       be returned.
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


STRPTR nns_AddNNStr(STRPTR NNStr, STRPTR New)
{
  STRPTR rv;
  LONG nnlen, newlen;


  if(New)
  {
    newlen  =strlen(New)+1;
  
    if(NNStr)
    {
      nnlen=nns_NNStrLen(NNStr);
         
      if(rv=AllocVec(nnlen+newlen+1,0))
      {
        CopyMem(NNStr ,rv        ,nnlen);
        CopyMem(New   ,rv+nnlen-1  ,newlen);
        rv[nnlen+newlen-1]=0; 
      }
      FreeVec(NNStr);
    }
    else
    {
      if(rv=AllocVec(newlen+1,0))
      {
        CopyMem(New   ,rv  ,newlen);
        rv[newlen]=0; 
      }
    }
  }
  else
    rv=NNStr;
    
  return(rv);
}


/****** Macro/nns_ProcessNNStr ******************************************
*
*   NAME
*       nns_ProcessNNStr(NNStr, Str)
*
*   SYNOPSIS
*       nns_ProcessNNStr(NNStr, Str)
*
*   FUNCTION
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*       STRPTR NNStr, str;
*       
*       ProcessNNStr(NNStr,str)
*       {
*         printf("%s\n",str);
*       }
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/
