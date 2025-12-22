/*
** $PROJECT: FinalReadArgs() test
**
** $VER: test.c 0.1 (04.09.94)
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
** 04.09.94 : 000.001 :  initial
*/

#include "extrdargs.h"

#include <intuition/intuition.h>

#include <clib/dos_protos.h>
#include <clib/icon_protos.h>
#include <clib/intuition_protos.h>

#include <proto/dos.h>
#include <proto/icon.h>
#include <proto/intuition.h>

#include <debug.h>

#define TEMPLATE     "FILES/M/A,VERBOSE/S"

enum {
   ARG_FILES,
   ARG_VERBOSE,
   ARG_MAX};

STRPTR filetypes[] = {
   "pipe",
   "linkfile",
   "file",
   NULL,
   NULL,
   NULL,
   "root",
   "dir",
   "softlink",
   "linkdir",
   NULL};

LONG main(LONG ac,STRPTR *av)
{
   struct ExtRDArgs eargs = {NULL};
   LONG para[ARG_MAX];
   LONG error;
   LONG i;

   for(i = 0 ; i < ARG_MAX ; i++)
      para[i] = 0;

   eargs.erda_Template      = TEMPLATE;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = 0;
   eargs.erda_Window        = "CON:////Test ExtReadArgs() from Workbench/WAIT/CLOSE";

   if((error = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      struct FileInfoBlock *fib;

      D(bug("finalargs : %ld\n",eargs.erda_Flags & ERDAF_WORKBENCH));

      if((fib = AllocDosObject(DOS_FIB,NULL)))
      {
         STRPTR *files = (STRPTR *) para[ARG_FILES];
         BPTR lock;

         while(*files)
         {
            if((lock = Lock(*files,SHARED_LOCK)))
            {
               if(Examine(lock,fib))
               {
                  Printf ("%-32s ",fib->fib_FileName);

                  if(para[ARG_VERBOSE])
                     Printf ("%8ld (%s)",fib->fib_Size,filetypes[fib->fib_DirEntryType + 5]);

                  PutStr("\n");
               }
               UnLock(lock);
            }
            files++;
         }

         FreeDosObject(DOS_FIB,fib);
      }
   }
   ExtFreeArgs(&eargs);

   if(!error)
      error = IoErr();

   if(error)
      if(eargs.erda_Flags & ERDAF_WORKBENCH)
      {
         UBYTE buffer[100];
         struct EasyStruct es = {
            sizeof(struct EasyStruct),
            0,
            "Test",
            "%s",
            "End"};

         Fault(error,"Test",buffer,sizeof(buffer));

         EasyRequest(NULL,&es,NULL,buffer);
      } else
         PrintFault(error,"Test");

   return((error == 0) ? RETURN_OK : RETURN_FAIL);
}

