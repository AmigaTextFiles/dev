;/* execute me to make with SAS 6.x
sc NOSTKCHK CSRC expungexref.c OPT IGNORE=73
slink lib:c.o expungexref.o //Goodies/extrdargs/extrdargs.o TO /c/expungexref SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/*
** $PROJECT: XRef-Tools
**
** $VER: expungexref.c 1.7 (24.09.94) 
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 24.09.94 : 001.007 :  locked info added
** 07.09.94 : 001.006 :  workbench support added (FinalReadArgs())
** 03.09.94 : 001.005 :  VERBOSE option added
** 06.07.94 : 001.004 :  xref.library function names changed
** 28.05.94 : 001.003 :  now use the tags function
** 18.05.94 : 001.002 :  file option and autodoc added
** 04.05.94 : 001.001 :  tags changed and force option added
** 02.05.94 : 000.001 :  initial
*/

/* ------------------------------- includes ------------------------------- */

#include "Def.h"

#include <libraries/xref.h>
#include <proto/xref.h>

#include <register.h>
#include <debug.h>

#include "/lib/xrefsupport.h"

#include "expungexref_rev.h"

struct ExpungeHookData
{
   struct Buffer *Buffer;
   ULONG Locked;
   ULONG Expunged;
   BOOL Verbose;
   struct Library *XRefBase;
};

/* ---------------------------- version string ---------------------------- */

static char *version = VERSTAG;
static char *prgname = "ExpungeXRef";

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/ExpungeXRef ***********************************************

$VER: ExpungeXRef.doc

NAME
    ExpungeXRef - expunge a given file,category or all xreffiles

TEMPLATE
    CATEGORY,FILE/K,FORCE/S,VERBOSE/S

FORMAT
    ExpungeXRef [[CATEGORY] category] [FILE xreffile] [FORCE] [VERBOSE]

FUNCTION
    this command expunges a/some xreffiles from memory.If no category or
    file is specified all xreffiles are removed. If you turn on the switch
    FORCE, xreffiles are also removed, which are locked.

INPUTS
    CATEGORY (STRING) - category of xreffiles to expunge. Can be a pattern.

    FILE (STRING) - only expunge the file given here

    FORCE (BOOLEAN) - expunge also such files, which are protected via the
        LOCK mechanism

    VERBOSE (BOOLEAN) - show each file, which is expunged !

EXAMPLE
    the following example expunges only the xreffile mytools.xref in the
    global xref drawer , even it is locked or not :

       ExpungeXRef FILE mytools.xref FORCE

SEE ALSO
    LoadXRef, xref.library/XR_ExpungeXRef(), xref.library/XR_LoadXRef()

HISTORY
    ExpungeXRef 1.7 (24.9.94) :
        - now displays xreffiles, which aren't expunged due to a lock

    ExpungeXRef 1.6 (7.9.94) :
        - workbench support added

    ExpungeXRef 1.5 (3.9.94) :
        - VERBOSE option added

    ExpungeXRef 1.4 (6.7.94) :
        - xref.library function names changed

    ExpungeXRef 1.3 (28.5.94) :
        - FILE argument added

*****************************************************************************/
/*FE*/

/* ------------------------- template definition -------------------------- */

#define USETAG(tag,check)     ((check) ? (tag) : TAG_IGNORE)

#define template "CATEGORY,FILE/K,FORCE/S,VERBOSE/S"

enum {
   ARG_CATEGORY,
   ARG_FILE,
   ARG_FORCE,
   ARG_VERBOSE,
   ARG_MAX};

/* ---------------------- expunge callback function ----------------------- */

RegCall GetA4 ULONG expungehook(REGA0 struct Hook *hook,REGA2 struct XRefFileNode *xref,REGA1 struct xrmExpunge *msg)
{
   if(msg->Msg == XRM_EXPUNGE)
   {
      struct ExpungeHookData *expdata = (struct ExpungeHookData *) hook->h_Data;
      BOOL force  = (GetTagData(XREFA_Lock,XREF_LOCK,msg->exp_Attrs) == XREF_UNLOCK);
      BOOL lock;

      #define XRefBase  expdata->XRefBase

      if(GetXRefFileAttrs(xref,XREFA_Lock,&lock,
                               TAG_DONE) == 1)
      {
         if(force || !lock)
         {
            if(expdata->Verbose)
               mysprintf(expdata->Buffer,"%s expunged !\n",xref->xrfn_Node.ln_Name);

            expdata->Expunged++;
         } else
         {
            if(expdata->Verbose)
               mysprintf(expdata->Buffer,"%s not expunged due to lock !\n",xref->xrfn_Node.ln_Name);

            expdata->Locked++;
         }
      }

      #undef XRefBase

      return(1);
   }

   return(0);
}

/* --------------------------- main entry point --------------------------- */

int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};
   struct Library *XRefBase;

   struct Hook hook = {NULL};
   ULONG para[ARG_MAX];
   LONG err;
   STRPTR obj = prgname;

   LONG i;

   hook.h_Entry = (HOOKFUNC) expungehook;

   /* clear args buffer */
   for(i = 0 ; i < ARG_MAX ; i++)
      para[i] = 0;

   eargs.erda_Template      = template;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = ARG_FILE;

   if((err = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      obj = "xref.library";
      if(XRefBase = OpenLibrary(obj,0))
      {
         struct Buffer *buf;

         if((buf = AllocMem(sizeof(struct Buffer),MEMF_ANY)))
         {
            struct ExpungeHookData expdata = {NULL};

            expdata.Buffer   = buf;
            expdata.Verbose  = para[ARG_VERBOSE];
            expdata.XRefBase = XRefBase;

            buf->b_Ptr  = buf->b_Buffer;
            hook.h_Data = &expdata;

            obj = prgname;

            XR_ExpungeXRefTags(USETAG(XREFA_Category,!para[ARG_FILE] )  , para[ARG_CATEGORY],
                               USETAG(XREFA_File    , para[ARG_FILE] )  , para[ARG_FILE],
                               USETAG(XREFA_Lock    , para[ARG_FORCE])  , XREF_UNLOCK,
                               XREFA_XRefHook                           , &hook,
                               TAG_DONE);

            if(!para[ARG_VERBOSE])
            {
               mysprintf(buf,"%ld xreffiles expunged !\n",(APTR) expdata.Expunged);

               if(expdata.Locked)
                  mysprintf(buf,"\n%ld xreffiles not expunged due to lock !\n",(APTR) expdata.Locked);
            } else if(expdata.Expunged == 0)
            {
               mysprintf(buf,"no xreffiles expunged !\n",NULL);

               if(expdata.Locked)
                  mysprintf(buf,"\n%ld xreffiles not expunged due to lock !\n",(APTR) expdata.Locked);
            }  

            if(ac == 0)
            {
               struct EasyStruct es = {
                  sizeof(struct EasyStruct),
                  0,
                  NULL,
                  NULL,
                  "Ok"};

               es.es_Title      = prgname;
               es.es_TextFormat = buf->b_Buffer;

               EasyRequest(NULL,&es,NULL,NULL);
            } else
               PutStr(buf->b_Buffer);

            FreeMem(buf,sizeof(struct Buffer));
         }
         CloseLibrary(XRefBase);
      }
   }
   ExtFreeArgs(&eargs);

   if(!err)
      err = IoErr();

   if(err)
   {
      if(ac == 0)
         showerror(prgname,obj,err);
      else
         PrintFault(err,obj);
      return(RETURN_ERROR);
   }

   return(RETURN_OK);
}


