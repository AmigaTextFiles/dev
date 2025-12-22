/*
** $PROJECT: rexxxref.library
**
** $VER: findxref.c 1.1 (08.01.95)
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
/*GB*** rexxxref.library/FindXRef ********************************************
*
*    NAME
*        FindXRef - searchs for a given pattern and returns the xref entries
*
*    SYNOPSIS
*        FindXRef(STRING/A,CATEGORY,LIMIT/N,NOPATTERN/S,NOCASE/S,STEM)
*
*    FUNCTION
*        Searchs for a given pattern or string. If one or more xref entries
*        are found, this function returns the full information about the xref
*        entry in the specified stem variable.
*
*    INPUTS
*        STRING   - string/pattern to search for
*        CATEGORY - category to search in
*        LIMIT    - maximal number of entries to return
*        NOPATTERN- string isn't a pattern
*        NOCASE   - ignore case ('A'=='a')
*        STEM     - stem variable to use, if not specified it uses the
*                   "XRef" as stem base name !
*                   The following stem field are supported :
*                   XRef.Count
*                   XRef.n.Type
*                   XRef.n.Name
*                   XRef.n.NodeName
*                   XRef.n.File
*                   XRef.n.Path
*                   XRef.n.Line
*
*    RESULTS
*        Set RC to WARN,if no entry was found. Otherwise set to RC_OK
*
*    SEE ALSO
*        LoadXRef() ,ExpungeXRef() ,ParseXRef()
*
******************************************************************************
*
*/
/*FE*/

const STRPTR xref_types[] = {
   "Generic",
   "Function",
   "Command",
   "Include",
   "Macro",
   "Structure",
   "Field",
   "Typedef",
   "Define",
   NULL};

struct FindXRefData
{
   struct RexxMsg *RMsg;
   STRPTR Stem;
   struct RexxXRefBase *LibBase;
   ULONG Number;
   UBYTE StemBuf[100];
   UBYTE Buf[20];
};

static RegCall GetA4 ULONG findxreffunc(REGA0 struct Hook *hook,REGA2 struct XRefFileNode *xref,REGA1 struct xrmXRef *msg)
{
   if(msg->Msg == XRM_XREF)
   {
      struct FindXRefData *fxd = (struct FindXRefData *) hook->h_Data;
      struct RexxXRefBase *rxb = (struct RexxXRefBase *) fxd->LibBase;
      struct TagItem *tstate = msg->xref_Attrs;
      struct TagItem *tag;
      STRPTR value;
      STRPTR field;
      ULONG len;
      BOOL noline = TRUE;

      DB(("Name : \"%s\"\n",GetTagData(ENTRYA_Name,(ULONG) "noname",tstate)));

      fxd->Number++;

      while((tag = NextTagItem(&tstate)))
      {
         value = (STRPTR) tag->ti_Data;
         field = NULL;
         len   = 0;

         switch(tag->ti_Tag)
         {
         case ENTRYA_Type:
            field = "TYPE";
            if(tag->ti_Data < XREFT_MAXTYPES)
            {
               value = (STRPTR) xref_types[tag->ti_Data];
               len = strlen(value);
            } else
               value = 0;
            break;
         case ENTRYA_File:
            field = "FILE";
            break;
         case ENTRYA_Name:
            field = "NAME";
            break;
         case ENTRYA_Line:
            noline =  FALSE;
            field = "LINE";
            value = fxd->Buf;
            sprintf(fxd->Buf,"%ld",tag->ti_Data);
            break;
         case ENTRYA_NodeName:
            field = "NODENAME";
            break;
         case XREFA_Path:
            field = "PATH";
            break;
         }

         if(field)
         {
            sprintf(fxd->StemBuf,"%s.%ld.%s",fxd->Stem,fxd->Number,field);
            DB(("try to set : \"%s\" to \"%s\"\n",fxd->StemBuf,value));

            if(value)
               SetRexxVar((struct Message *) fxd->RMsg,fxd->StemBuf,value,(len) ? len : strlen(value));
            else
               SetRexxVar((struct Message *) fxd->RMsg,fxd->StemBuf,"",0);

            DB(("after SetRexxVar()\n"));
         }
      }

      if(noline)
      {
         sprintf(fxd->StemBuf,"%s.%ld.LINE",fxd->Stem,fxd->Number);
         SetRexxVar((struct Message *) fxd->RMsg,fxd->StemBuf,"0",1);
      }
   }
   return(0);
}

ULONG findxref(struct ARexxFunction *func,struct RexxMsg *rmsg,STRPTR *argstr,struct RexxXRefBase *rxb)
{
   ULONG rc  = RC_OK;

   if(!rmsg->rm_Args[FX_STRING])
      rc = RXERR_REQUIRED_ARG_MISSING;
   else
   {
      struct FindXRefData fxd;
      struct TagItem tags[5];
      struct Hook hook;

      ULONG matching = XREFMATCH_PATTERN_CASE;
      ULONG limit    = ~0;

      BOOL nopattern = (rmsg->rm_Args[FX_NOPATTERN] && !Stricmp(rmsg->rm_Args[FX_NOPATTERN],"NOPATTERN"));
      BOOL nocase    = (rmsg->rm_Args[FX_NOCASE]    && !Stricmp(rmsg->rm_Args[FX_NOCASE],"NOCASE"));

      GetXRefBaseAttrs(XREFBA_DefaultLimit,&limit,TAG_DONE);

      fxd.RMsg    = rmsg;
      fxd.Stem    = (rmsg->rm_Args[FX_STEM]) ? rmsg->rm_Args[FX_STEM] : "XREF";
      fxd.Number  = 0;
      fxd.LibBase = rxb;

      hook.h_Data  = &fxd;
      hook.h_Entry = (HOOKFUNC) findxreffunc;

      if(nopattern)
         if(nocase)
            matching = XREFMATCH_COMPARE_NOCASE;
         else
            matching = XREFMATCH_COMPARE_CASE;
      else
         if(nocase)
            matching = XREFMATCH_PATTERN_NOCASE;

      if(rmsg->rm_Args[FX_LIMIT])
         StrToLong(rmsg->rm_Args[FX_LIMIT],(LONG *) &limit);

      tags[0].ti_Tag  = XREFA_Category;
      tags[0].ti_Data = (ULONG) rmsg->rm_Args[FX_CATEGORY];
      tags[1].ti_Tag  = XREFA_Matching;
      tags[1].ti_Data = matching;
      tags[2].ti_Tag  = XREFA_XRefHook;
      tags[2].ti_Data = (ULONG) &hook;
      tags[3].ti_Tag  = XREFA_Limit;
      tags[3].ti_Data = limit;
      tags[4].ti_Tag  = TAG_DONE;

      if(ParseXRef(rmsg->rm_Args[FX_STRING],tags))
      {
         DB(("returned from ParseXRef()\n"));
         if(fxd.Number == 0)
            rc = RC_WARN;
         else
         {
            sprintf(fxd.Buf,"%ld",fxd.Number);
            sprintf(fxd.StemBuf,"%s.COUNT",fxd.Stem);

            SetRexxVar((struct Message *) rmsg,fxd.StemBuf,fxd.Buf,strlen(fxd.Buf));

            if(!(*argstr = CreateArgstring("1",1)))
               rc = RXERR_NO_FREE_STORE;

            DB(("after set \"%s\" to \"%s\"\n",fxd.StemBuf,fxd.Buf));
         }
      } else
         rc = RC_FATAL;

   }

   DB(("now returning to ARexx\n"));

   return(rc);
}

