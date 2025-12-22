#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <clib/extras_protos.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include <extras/entry.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <extras/macros.h>
#include "entries.h"

/****** extras.lib/db_EntryToNN ******************************************
*
*   NAME
*       db_EntryToNN -- Retrieve data from an ENTRY of a database.
*
*   SYNOPSIS
*       STRPTR db_EntryToNN(BPTR File, STRPTR EntryName)
*
*   FUNCTION
*       Get data from a Database, see db_GetEntryData().
*       All the data in the entry is put into an NNString.
*       The data can then be parsed with nns_GetNNData()
*
******************************************************************************
*
*/


STRPTR db_EntryToNN(BPTR File, STRPTR EntryName)
{
  STRPTR str=0;
  
  if(!GED_Buffer)
  {
    GED_Buffer=malloc(BUFFERSIZE);
    if(!GED_Buffer)
      return(0);
  }
  
  GED_Buffer[0]=0;

  if(db_NextEntry(File,EntryName,GED_Buffer,BUFFERSIZE))
  {
    if(!FGets(File,GED_Buffer,BUFFERSIZE))
    {
      return(0);
    }
    
    while(GED_Buffer[0]!='}')
    {
      
      Strip(GED_Buffer);
      
      if(!(str=nns_AddNNStr(str,GED_Buffer)))
        return(0);
        
      if(!FGets(File,GED_Buffer,BUFFERSIZE))
      {
        FreeVec(str);
        return(0);
      }
    }
  }
  return(str);
}

