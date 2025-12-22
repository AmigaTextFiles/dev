;/* execute me to make with SAS 6.x
sc NOSTKCHK CSRC statxref.c OPT IGNORE=73
slink lib:c.o statxref.o //Goodies/extrdargs/extrdargs.o TO /c/statxref SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/* 
** $PROJECT: XRef-Tools
**
** $VER: statxref.c 1.4 (24.09.94) 
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
** 24.09.94 : 001.004 :  category output now 15 characters wide instead of 10
** 08.09.94 : 001.003 :  workbench support added
** 05.06.94 : 001.002 :  adaption to the xref.library
** 27.04.94 : 001.001 :  initial
*/

/* ------------------------------- includes ------------------------------- */

#include "Def.h"

#include <libraries/xref.h>
#include <clib/xref_protos.h>
#include <pragmas/xref_pragmas.h>

#include <debug.h>

#include "/lib/xrefsupport.h"

#include "statxref_rev.h"

/* ------------------------------- autodoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/StatXRef **************************************************

$VER: StatXRef.doc

NAME
    StatXRef - outputs information of the current settings of the xref.library

TEMPLATE
    FILES/S

FORMAT
    StatXRef [FILES]

FUNCTION
    This command outputs information about the current settings of the
    xref.library. The global path for xreffiles,the number of xref files
    in memory, the linelength and column number for the dynamic node layout.
    And optional if you specify the FILES switch, the information about the
    single xref file like the name, length , priority and the lock status.

INPUTS
    FILES (BOOLEAN) - output detail information about the xref files

SEE ALSO
    LoadXRef, ExpungeXRef, XRefAttrs

HISTORY
    StatXRef 1.5 (24.9.94) :
        - category output no 15 charaters wide , instead of 10 charaters

    StatXRef 1.4 (8.9.94) :
        - workbench support added

    StatXRef 1.3 (9.7.94) :
        - Index and Global Path output added
    
    StatXRef 1.2 (5.6.94) :
        - FILES option added

*****************************************************************************/
/*FE*/

/* ---------------------------- constant items ---------------------------- */

static char *version = VERSTAG;
static char *prgname = "StatXRef";

/* ------------------------- template definition -------------------------- */

#define template       "FILES/S"

enum {
   ARG_FILES,
   ARG_MAX};

int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};
   struct Library *XRefBase;

   ULONG para[ARG_MAX];
   STRPTR obj = prgname;
   ULONG err;

   struct List *list;
   struct Node *xrnode;

   STRPTR xrefdir   = NULL;
   UWORD linelength = 0;
   UWORD columns    = 0;
   ULONG num        = 0;
   ULONG limit      = 0;

   ULONG handle;

   LONG i;

   /* clear args buffer */
   for(i = 0 ; i < ARG_MAX ; i++)
      para[i] = 0;

   eargs.erda_Template      = template;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = -1;

   if((err = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      obj = "xref.library";
      if(XRefBase = OpenLibrary(obj,1))
      {
         struct Buffer *buf;

         handle = LockXRefBase(0);

         if(GetXRefBaseAttrs(XREFBA_List         ,&list,
                             XREFBA_LineLength   ,&linelength,
                             XREFBA_Columns      ,&columns,
                             XREFBA_DefaultLimit ,&limit,
                             XREFBA_XRefDir      ,&xrefdir,
                             TAG_DONE) == 5)
         if((buf = AllocMem(sizeof(struct Buffer),MEMF_ANY)))
         {
            buf->b_Ptr = buf->b_Buffer;

            mysprintf(buf,"xref.library v%ld.%ld\n\n",XRefBase->lib_Version,
                                                      XRefBase->lib_Revision);

            for(xrnode = list->lh_Head ;
                xrnode->ln_Succ ;
                xrnode = xrnode->ln_Succ)
               num++;

            mysprintf(buf,"XRefFile Dir        : %s\n"
                          "Number of XRefFiles : %10ld\n"
                          "Default Entry Limit : %10ld\n"
                          "DNode LineLength    : %10ld\n"
                          "DNode Columns       : %10ld\n\n",
                           xrefdir,num,limit,linelength,columns);

            if(para[ARG_FILES])
            {
               STRPTR category;
               STRPTR name;
               ULONG length;
               BOOL index;
               BOOL lock;
               BYTE pri;

               mysprintf(buf,"\n%-31s %15s %8s %8s %6s %6s\n\n","XRefFile",
                                                                "Category",
                                                                "Length",
                                                                "Priority",
                                                                "Locked",
                                                                "Index");

               for(xrnode = list->lh_Head ;
                   xrnode->ln_Succ ;
                   xrnode = xrnode->ln_Succ)
               {
                  if(GetXRefFileAttrs((struct XRefFileNode *) xrnode,
                                      XREFA_Category,&category,
                                      XREFA_Length  ,&length,
                                      XREFA_Name    ,&name,
                                      XREFA_Index   ,&index,
                                      XREFA_Lock    ,&lock,
                                      XREFA_Priority,&pri,
                                      TAG_DONE) == 6)
                  {
                     mysprintf(buf,"%-31s %15s %8ld %8ld %6s %6s\n",name,category,length,pri,
                                                                    (lock)  ? "Yes" : "No",
                                                                    (index) ? "Yes" : "No");
                  }
               }
            }

            if(ac == 0)
            {
               struct EasyStruct es = {
                  sizeof(struct EasyStruct),
                  0,
                  NULL,
                  "%s",
                  "Ok"};

               es.es_Title = prgname;

               EasyRequest(NULL,&es,NULL,buf->b_Buffer);
            } else
               PutStr(buf->b_Buffer);

            FreeMem(buf,sizeof(struct Buffer));
         }

         UnlockXRefBase(handle);

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

