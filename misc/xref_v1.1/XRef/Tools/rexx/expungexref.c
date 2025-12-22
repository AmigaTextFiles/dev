/*
** $PROJECT: rexxxref.library
**
** $VER: expungexref.c 1.1 (08.01.95)
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
/*GB*** rexxxref.library/ExpungeXRef *****************************************
*
*    NAME
*        ExpungeXRef - expunge a/some xreffiles from memory
*
*    SYNOPSIS
*        ExpungeXRef(CATEGORY,FILE,FORCE/S)
*
*    FUNCTION
*        This is the Rexx-Function-Interface to the XR_ExpungeXRef() function
*        of the xref.library.
*
*    INPUTS
*        CATEGORY - category of xreffiles to expunge
*        FILE     - expunge only the given file
*        FORCE    - expunge also xreffiles, which are locked
*
*    RESULTS
*        Set RC to RC_WARN, if no xreffiles was expunged. Otherwise
*        set to RC_OK.
*
*    SEE ALSO
*        LoadXRef() ,FindXRef() ,XR_ExpungeXRef()
*
******************************************************************************
*
*/
/*FE*/

struct ExpungeXRefData
{
   struct RexxXRefBase *LibBase;
   UBYTE Buffer[100];
};

static RegCall ULONG expungexreffunc(REGA0 struct Hook *hook,REGA2 struct XRefFileNode *xref,REGA1 struct xrmExpunge *msg)
{
   if(msg->Msg = XRM_EXPUNGE)
   {
      struct ExpungeXRefData *exd = (struct ExpungeXRefData *) hook->h_Data;
      struct RexxXRefBase *rxb = exd->LibBase;

      BOOL force  = (GetTagData(XREFA_Lock,XREF_LOCK,msg->exp_Attrs) == XREF_UNLOCK);
      STRPTR name;
      BOOL lock;

      if(GetXRefFileAttrs(xref,XREFA_Name,&name,
                               XREFA_Lock,&lock,
                               TAG_DONE) == 2 && !lock && force)
      {
         strncat(exd->Buffer,name,sizeof(exd->Buffer));
         strncat(exd->Buffer," ",sizeof(exd->Buffer));
      }
      return(1);
   }
   return(0);
}

ULONG expungexref(struct ARexxFunction *func,struct RexxMsg *rmsg,STRPTR *argstr,struct RexxXRefBase *rxb)
{
   ULONG rc  = RC_OK;

   if(!rmsg->rm_Args[LX_FILE])
      rc = RXERR_REQUIRED_ARG_MISSING;
   else
   {
      struct Hook hook = {NULL};
      struct ExpungeXRefData exd;
      struct TagItem tags[4];
      UWORD tag = 2;

      exd.LibBase   = rxb;
      exd.Buffer[0] = '\0';

      hook.h_Data  = &exd;
      hook.h_Entry = (HOOKFUNC) expungexreffunc;

      tags[0].ti_Tag  = XREFA_XRefHook;
      tags[0].ti_Data = (ULONG) &hook;

      if(rmsg->rm_Args[EX_FILE])
      {
         tags[1].ti_Tag  = XREFA_File;
         tags[1].ti_Data = (ULONG) rmsg->rm_Args[EX_FILE];
      } else
      {
         tags[1].ti_Tag  = XREFA_Category;
         tags[1].ti_Data = (ULONG) rmsg->rm_Args[EX_CATEGORY];
      }

      if(rmsg->rm_Args[EX_FORCE] && !Stricmp(rmsg->rm_Args[EX_FORCE],"FORCE"))
      {
         tags[tag].ti_Tag  = XREFA_Lock;
         tags[tag].ti_Data = XREF_UNLOCK;
         tag++;
      }

      tags[tag].ti_Tag = TAG_END;

      if(XR_ExpungeXRef(tags))
      {
         if(!(*argstr = CreateArgstring(exd.Buffer,strlen(exd.Buffer))))
            rc = RXERR_NO_FREE_STORE;
      } else
         rc = RC_WARN;
   }
   return(rc);
}

