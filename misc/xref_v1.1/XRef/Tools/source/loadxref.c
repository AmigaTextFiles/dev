;/* execute me to make with SAS 6.x
sc NOSTKCHK CSRC loadxref.c OPT IGNORE=73
slink lib:c.o loadxref.o //Goodies/extrdargs/extrdargs.o TO /c/loadxref SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/*
** $PROJECT: XRef-Tools
**
** $VER: loadxref.c 1.5 (04.09.94) 
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
** 04.09.94 : 001.005 :  added workbench support FinalReadArgs()
** 06.07.94 : 001.004 :  index argument added
** 05.06.94 : 001.003 :  priority tag ignored if not specified
** 28.05.94 : 001.002 :  now uses the tags function
** 20.05.94 : 001.001 :  AutoDoc added
** 02.05.94 : 000.001 :  initial
*/

/* ------------------------------ includes -------------------------------- */

#include "Def.h"

#include "/lib/xrefsupport.h"

#include "loadxref_rev.h"

/* ---------------------------- version string ---------------------------- */

static char *version = VERSTAG;
static char *prgname = "LoadXRef";

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/LoadXRef **************************************************

$VER: LoadXRef.doc

NAME
    LoadXRef - load a/some xreffiles for the xref.library into the memory

TEMPLATE
    FILES/M/A,PRI/N/K,LOCK/S,INDEX/S

FORMAT
    LoadXRef [FILES] file [file2 ..] [PRI priority] [LOCK] [INDEX]

FUNCTION
    loads the given xreffiles into the memory. The priority is used to sort
    the list of xreffiles.With the LOCK switch you can protect all xreffile 
    from removing from memory during a memory flush.

INPUTS
    FILES (STRINGS) - file(s) to be loaded into the memory

    PRI (NUMBER) - priority to be inserted in the list. Thus a high priority
        inserts a xreffile before others and therefor is parsed before others
        with lower priority

    LOCK (BOOLEAN) - if set, it locks all given xreffiles. Thus such files
        are not expunged during a system memory flush.

    INDEX (BOOLEAN) - if set, the xref.library creates a index array for all
        entries and uses for normal strcmp() , strncmp() a binary search
        algorithm !

SEE ALSO
    ExpungeXRef, ParseXRef, AGuideXRefV37, AGuideXRefV39, MakeXRef, XRefAttrs

COPYRIGHT
    by Stefan Ruppert (C) 1994

HISTORY
    LoadXRef 1.6 (22.9.94) :
        - CATEGORY option removed , use this in MakeXRef

    LoadXRef 1.5 (4.9.94) :
        - added workbench support FinalReadArgs() function

    LoadXRef 1.4 (6.7.94) :
        - Index argument added UNLOCK option removed

    LoadXRef 1.3 (5.6.94) :
        - now ignores priority if not specified

    LoadXRef 1.2 (28.5.94) :
        - LOCK and UNLOCK options added

    LoadXRef 1.1 (20.5.94) :
        - first beta release

*****************************************************************************/
/*FE*/

/* ------------------------- template definition -------------------------- */

#define USETAG(tag,check)     ((check) ? (tag) : TAG_IGNORE)

#define template "FILES/M/A,XREFPRI/N/K,LOCK/S,INDEX/S"

enum {
   ARG_FILES,
   ARG_XREFPRI,
   ARG_LOCK,
   ARG_INDEX,
   ARG_MAX};

/* --------------------------- main entry point --------------------------- */

int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};

   struct Library *XRefBase;
   ULONG para[ARG_MAX];
   LONG err;
   STRPTR obj = prgname;

   LONG lock = -1;
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
         STRPTR *files = (STRPTR *) para[ARG_FILES];

         obj = prgname;

         if(para[ARG_LOCK])
            lock = XREF_LOCK;

         while(*files)
         {
            if(!XR_LoadXRefTags(*files,XREFA_Index                              ,para[ARG_INDEX],
                                       USETAG(XREFA_Lock,(lock!=-1))            , lock,
                                       USETAG(XREFA_Priority,para[ARG_XREFPRI]) ,(para[ARG_XREFPRI]) ? (*((LONG *) para[ARG_XREFPRI])) : 0,
                                       TAG_DONE))
               break;

            files++;
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

