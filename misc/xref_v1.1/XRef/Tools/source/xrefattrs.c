;/* execute me to make with SAS 6.x
sc NOSTKCHK CSRC xrefattrs.c OPT IGNORE=73
slink lib:c.o xrefattrs.o //Goodies/extrdargs/extrdargs.o TO /c/xrefattrs SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/*
** $PROJECT: XRef-Tools
**
** $VER: xrefattrs.c 0.1 (16.07.94)
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
** 16.07.94 : 000.001 : initial
*/

#include "Def.h"

#include <libraries/xref.h>
#include <proto/xref.h>

#include <debug.h>

#include "/lib/xrefsupport.h"

#include "xrefattrs_rev.h"

/* ---------------------------- version string ---------------------------- */

static char *version = VERSTAG;
static char *prgname = "XRefAttrs";

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/XRefAttrs *************************************************

$VER: XRefAttrs.doc

NAME
    XRefAttrs - change attributes of a/some xreffile(s)

TEMPLATE
    FILES/M/A,PRI/N/K,LOCK/S,UNLOCK/S,INDEX/S,NOINDEX/S

FORMAT
    XRefAttrs [FILES] file [file1 [..]] [PRI priority] [LOCK|UNLOCK]
              [INDEX|NOINDEX]

FUNCTION
    changes a/some attribute(s) of a/some xreffile(s).

INPUTS
    FILES (STRINGS) - filenames of the xreffiles to change the attributes

    PRI (NUMBER) - new priority for the xreffile(s)

    LOCK (BOOLEAN) - lock these xreffile(s)

    UNLOCK (BOOLEAN) - unlock the xreffile(s)

    INDEX (BOOLEAN) - generate an index for these xreffile(s). The normal
        compare modes are much faster as without an index !!!

    NOINDEX (BOOLEAN) - removes all index array's of the xreffile(s)

EXAMPLE
    XRefAttrs autodoc_v40.xref PRI -1 LOCK INDEX

SEE ALSO
    LoadXRef, ExpungeXRef, ParseXRef, AGuideXRefV37, AGuideXRefV39,
    XRefConvert

COPYRIGHT
    by Stefan Ruppert (C) 1994

HISTORY
    XRefAttrs 1.1 (16.7.94) :
        - created

*****************************************************************************/
/*FE*/

/* ------------------------- template definition -------------------------- */

#define USETAG(tag,check)     ((check) ? (tag) : TAG_IGNORE)

#define template    "FILES/M/A,XREFPRI/N/K,LOCK/S,UNLOCK/S,INDEX/S,NOINDEX/S"

enum {
   ARG_FILES,
   ARG_XREFPRI,
   ARG_LOCK,
   ARG_UNLOCK,
   ARG_INDEX,
   ARG_NOINDEX,
   ARG_MAX};


/* --------------------------- main entry point --------------------------- */

int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};
   struct Library *XRefBase;

   ULONG para[ARG_MAX];
   STRPTR obj = prgname;
   LONG err;

   LONG i;

   /* clear args buffer */
   for(i = 0 ; i < ARG_MAX ; i++)
      para[i] = 0;

   eargs.erda_Template      = template;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = ARG_FILES;

   if((err = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      obj = "xref.library";
      if(XRefBase = OpenLibrary(obj,0))
      {
         struct Buffer *buf;

         if((buf = AllocMem(sizeof(struct Buffer),MEMF_ANY)))
         {
            STRPTR *files = (STRPTR *) para[ARG_FILES];
            struct XRefFileNode *xreffile;

            LONG index = -1;
            LONG lock  = -1;

            buf->b_Ptr = buf->b_Buffer;

            obj = prgname;

            if(para[ARG_LOCK])
               lock = XREF_LOCK;
            else if(para[ARG_UNLOCK])
               lock = XREF_UNLOCK;

            if(para[ARG_INDEX])
               index = TRUE;
            else if(para[ARG_NOINDEX])
               index = FALSE;

            while(*files)
            {
               if(!(xreffile = FindXRefFile(*files)))
                  mysprintf(buf,"Couldn't find %s !\n",*files);
               else
               {
                  SetXRefFileAttrs(xreffile,USETAG(XREFA_Index,(index != -1))        , index,
                                            USETAG(XREFA_Lock,(lock!=-1))            , lock,
                                            USETAG(XREFA_Priority,para[ARG_XREFPRI]) , (para[ARG_XREFPRI]) ? (*((LONG *) para[ARG_XREFPRI])) : 0,
                                            TAG_DONE);
                  {
                     BOOL index,lock;
                     BYTE pri;

                     if(GetXRefFileAttrs(xreffile,XREFA_Index    ,&index,
                                                  XREFA_Lock     ,&lock,
                                                  XREFA_Priority ,&pri,
                                                  TAG_DONE) == 3)
                     {
                        mysprintf(buf,"%s : Priority = %ld , Index = %s , Lock = %s\n",
                                      *files,pri,(index) ? "Yes" : "No",(lock) ? "Yes" : "No");
                     }
                  }
               
               }

               files++;
            }

            if(ac == 0)
            {
               struct EasyStruct es = {
                  sizeof(struct EasyStruct),
                  0,
                  NULL,
                  NULL,
                  "Ok"};

               es.es_TextFormat = buf->b_Buffer;
               es.es_Title      = prgname;

               EasyRequestArgs(NULL,&es,NULL,NULL);
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


