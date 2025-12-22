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



/****** extras.lib/db_GetEntryData ******************************************
*
*   NAME
*       db_GetEntryData -- Retrieve data from an ENTRY of a database.
*
*   SYNOPSIS
*       db_GetEntryDataA(File, EntryName, Items) -- NOT implemented --
*
*       BOOL db_GetEntryDataA(BPTR, STRPTR struct EItem *);
*
*       db_GetEntryData(File, EntryName, Items, ... )
*
*       BOOL db_GetEntryData(BPTR, STRPTR, STRPTR, ... );
*
*   FUNCTION
*       Retrieve data from a simple ENTRY based database.
*
*   INPUTS
*       File - an AmigaDOS BPTR to a file.
*       Name - an array of struct Etems, the last struct EItem should have
*              it's Name field set to NULL. (see example)
*   RESULT
*       returns 0 on failure, possibly due to EOF, improper file format, or
*       lack of memory.  
*    
*       To support multiple occurances of an item Name in an Entry, this 
*       function returns NNStrings.  The strings are stored end to end in 
*       the order that they were read from the file.
*
*       On success, each EItem.ReturnString either points to an NNString,
*       or NULL if no data for that Name was found.
*
*       On failure, all EItem.ReturnStrings are NULL, and any data collected
*       is freed.
*
*   EXAMPLE
*       STRPTR title,desc;
*       BPTR File;
*
*       if(db_GetEntryData(File,"ENTRY",
*                            "TITLE"  ,&title,
*                            "DESC"   ,&desc,
*                               0))
*       {
*         if(title)
*         {
*           printf("%s - ",title);
#           FreeVec(title);
*         }
*
*         if(desc)
*         {
*           printf("%s\n");
*           FreeVec(desc);
*         }
*       }
*
*
*   NOTES
*       The database file format is an ASCII text file, and consists
*       of "ENTRY"'s, that look like this:
*
*       <ENTRYNAME>
*       {
*         <ITEMNAME> = <data>
*         <ITEMNAME> = <data>
*       }
*
*       an example file format from above might be:
*
*       ENTRY
*       {
*         TITLE=Cows 'R Us
*         DESC=All you want to know about beef.
*       }
*
*       case of <ENTRYNAME> and <ITEMNAMES> is not important.
*       the equal sign is required.
*       
*   HISTORY
*       This code probably isn't all that usefull, but it was the
*       code behind the database of now defunct Tampa Bay Amiga Group's
*       Amiga Support Directory.  Unfortunately, TBAG died before the
*       ASD could begine to grow, and I haven't used this code since.
*
*   BUGS
*       Not reentrant.
*
*   SEE ALSO
*       nns_ProcessNNStr, nns_AddNNStr(), nns_NextNNStr(), db_EntryToNN()
*
******************************************************************************
*
*/

BOOL db_GetEntryData(BPTR File, STRPTR EntryName, STRPTR Name, ... )
{
  struct nitem
  {
    STRPTR  Name,
          *Value;
  } *ni;
  
  if(!GED_Buffer)
  {
    GED_Buffer=malloc(BUFFERSIZE);
    if(!GED_Buffer)
      return(0);
  }
  
  GED_Buffer[0]=0;

  ni=(struct nitem *)&Name;
  while(ni->Name)
  {
    *ni->Value=0;
    ni++;
  }

  
  if(db_NextEntry(File,EntryName,GED_Buffer,BUFFERSIZE))
  {
    GED_Buffer[0]=0;
    while(GED_Buffer[0]!='}')
    {
      if(!FGets(File,GED_Buffer,BUFFERSIZE))
        return(0);
      
      Strip(GED_Buffer);
  
      ni=(struct nitem *)&Name;
      while(ni->Name)
      {
        LONG namelen;
        
        namelen=strlen(ni->Name);
        
        if(strnicmp(GED_Buffer,ni->Name,namelen)==0)
        {
          STRPTR value;
          
          value=GED_Buffer+namelen;
          
          while(IsWhiteSpace(*value))
          {
            value++;
          }
        
          if(*value=='=')
          {
            value++;
            Strip(value);
            if(!(*ni->Value=nns_AddNNStr(*ni->Value,value)))
            {
              while(ni->Name)
              {
                FreeVec(*ni->Value);
                *ni->Value=0;
                ni++;
              }
              return(0);
            }
          }
        }
        ni++;
      }
    }
    return(1);
  }
  return(0);
}

