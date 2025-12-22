/*
** $PROJECT: rexxxref.library
**
** $VER: loadxref.c 1.1 (08.01.95)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1995
** All Rights Reserved !
**
** $HISTORY:
**
** 08.01.95 : 001.001 : initial
*/

#include "rexxxref.h"

/*FS*/ /*"AutoDoc"*/
/*GB*** rexxxref.library/LoadXRef ********************************************
*
*    NAME
*        LoadXRef - loads a xreffile into memory
*
*    SYNOPSIS
*        LoadXRef(FILE/A,XREFPRI/N,LOCK/S,INDEX/S)
*
*    FUNCTION
*        This is the Rexx-Interface function to the xref.library XR_LoadXRef()
*        function.
*
*    INPUTS
*        FILE    - xreffile to load
*        XREFPRI - priority to use for this xreffile (Enqueue())
*        LOCK    - lock this xreffile
*        INDEX   - create an index for this xreffile
*
*    RESULTS
*        Set RC to RC_WARN, if the xreffile could not loaded. Otherwise
*        set to RC_OK.
*
*    SEE ALSO
*        FindXRef() ,ExpungeXRef() ,XR_LoadXRef()
*
******************************************************************************
*
*/
/*FE*/

ULONG loadxref(struct ARexxFunction *func,struct RexxMsg *rmsg,STRPTR *argstr,struct RexxXRefBase *rxb)
{
   ULONG rc  = RC_OK;

   if(!rmsg->rm_Args[LX_FILE])
      rc = RXERR_REQUIRED_ARG_MISSING;
   else
   {
      struct TagItem tags[4];
      UWORD tag = 0;

      if(rmsg->rm_Args[LX_XREFPRI])
      {
         tags[tag].ti_Tag  = XREFA_Priority;
         StrToLong(rmsg->rm_Args[LX_XREFPRI],(LONG *) &tags[tag].ti_Data);
         tag++;
      }

      if(rmsg->rm_Args[LX_INDEX])
         if(!Stricmp(rmsg->rm_Args[LX_INDEX],"INDEX"))
         {
            tags[tag].ti_Tag  = XREFA_Index;
            tags[tag].ti_Data = TRUE;
            tag++;
         }

      if(rmsg->rm_Args[LX_LOCK])
         if(!Stricmp(rmsg->rm_Args[LX_LOCK],"LOCK"))
         {
            tags[tag].ti_Tag  = XREFA_Lock;
            tags[tag].ti_Data = TRUE;
            tag++;
         }

      tags[tag].ti_Tag = TAG_END;

      if(XR_LoadXRef(rmsg->rm_Args[LX_FILE],tags))
      {
         if(!(*argstr = CreateArgstring("1",1)))
            rc = RXERR_NO_FREE_STORE;
      } else
         rc = RC_WARN;
   }
   return(rc);
}
/*FE*/

