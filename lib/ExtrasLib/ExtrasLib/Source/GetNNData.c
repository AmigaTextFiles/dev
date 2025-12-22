#include <stdlib.h>
#include <string.h>

#include <clib/extras/db_protos.h>
#include <clib/extras/nnstring_protos.h>
#include <clib/extras_protos.h>
#include <extras/macros.h>
#include "entries.h"

#include <exec/types.h>

/****** extras.lib/nns_GetNNData ******************************************
*
*   NAME
*       nns_GetNNData -- Find data in a NNString
*
*   SYNOPSIS
*       STRPTR GetNNData(STRPTR NNStr, STRPTR Name, STRPTR DefVal);
*
*   FUNCTION
*       Retrieves data from a NNString.
*
*       nnstr="TITLE=Joe\0COLOR=Green\0TITLE=Test\0\0"
*
*       t=GetNNData(nnstr,"TITLE","None");
*
*       t will equal "Joe\0Test\0\0"
*
*   SEE ALSO
*
******************************************************************************
*
*/


STRPTR nns_GetNNData(STRPTR NNStr, STRPTR Name, STRPTR DefVal)
{
  STRPTR s,rv=0;
  LONG namelen;

  if(!GED_Buffer)
  {
    GED_Buffer=malloc(BUFFERSIZE);
    if(!GED_Buffer)
      return(0);
  }
  
  GED_Buffer[0]=0;

  if(NNStr && Name)
  {
    namelen=strlen(Name);
    nns_ProcessNNStr(NNStr,s)
    {
      if(strnicmp(s,Name,namelen)==0)
      {
        STRPTR value;
          
        value=s+namelen;
        
        while(IsWhiteSpace(*value))
        {
          value++;
        }
        
        if(*value=='=')
        {
          value++;
          strncpy(GED_Buffer,value,BUFFERSIZE);
          GED_Buffer[BUFFERSIZE]=0;
          value=GED_Buffer;
          Strip(value);
          if(!(rv=nns_AddNNStr(rv,value)))
          {
            return(0);
          }
        }
      }
    }
    if(!rv)
      rv=nns_AddNNStr(0,DefVal);
  }
  return(rv);
}
