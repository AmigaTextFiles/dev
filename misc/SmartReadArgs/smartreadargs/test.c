/*
 * test.c -- Test SmartReadArgs()
 *
 * $VER: test.c 1.1 (1.9.98)
 *
 * Copyright 1998 by Thomas Aglassinger <agi@sbox.tu-graz.ac.at>
 *
 * Based on ExtReadArgs Copyright 1994,1995 by Stefan Ruppert
 */

#include "debug.h"
#include "SmartReadArgs.h"

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <utility/tagitem.h>
#include <dos/exall.h>
#include <intuition/intuition.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/icon.h>
#include <proto/intuition.h>

#include <clib/alib_stdio_protos.h>

/* ReadArgs()-template and indices to address parameter array */
#define TEMPLATE     "FILES/M/A,VERBOSE/S"

enum
{
   ARG_FILES,
   ARG_VERBOSE,
   ARG_MAX
};

/* Description of filetypes */
STRPTR filetypes[] =
{
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

#ifdef __GNUC__
/* Contains WBStartup message if gcc/libnix is used */
extern struct WBStartup *_WBenchMsg;

/* Libnix output window */
char __stdiowin[] = "con:///200/libnix stdio/AUTO/CLOSE/WAIT";
#endif

/*
 * Main function
 */
int main(int argc, STRPTR argv[])
{
   int return_code = RETURN_ERROR;

   struct WBStartup *wbstart = NULL;
   struct SmartArgs smart_args =
   {NULL};
   LONG argument[ARG_MAX] =
   {NULL};

   LONG error;

   D(bug("argc = %d\n", argc));

   /* Get WBStartup message */
#ifdef __GNUC__
   wbstart = _WBenchMsg;
#else
   if (argc == 0)
   {
      wbstart = (struct WBStartup *) argv;
   }
#endif

   /* Prepare SmartArgs structure */
   smart_args.sa_Template = TEMPLATE;
   smart_args.sa_Parameter = argument;
   smart_args.sa_FileParameter = ARG_FILES;
   smart_args.sa_Window = "CON://500/200/Test SmartReadArgs from Workbench/AUTO/WAIT/CLOSE";

   /* Attempt to parse arguments */
   error = SmartReadArgs(wbstart, &smart_args);

   /* If parsing was successful, display information about all files passed */
   if (error == 0)
   {
      struct FileInfoBlock *fib = AllocDosObject(DOS_FIB, NULL);

      D(bug("started from workbench : %ld\n",
            smart_args.sa_Flags & SAF_WORKBENCH));

      if (fib != NULL)
      {
         STRPTR *files = (STRPTR *) argument[ARG_FILES];
         BPTR lock;

         while (*files)
         {
            D(bug("examine \"%s\"\n", *files));
            if ((lock = Lock(*files, SHARED_LOCK)))
            {
               if (Examine(lock, fib))
               {
                  printf("%-32s ", fib->fib_FileName);

                  if (argument[ARG_VERBOSE])
                     printf("%8ld (%s)", fib->fib_Size, filetypes[fib->fib_DirEntryType + 5]);

                  puts("");
               }
               UnLock(lock);
            }
            files++;
         }

         FreeDosObject(DOS_FIB, fib);
      }

      error = IoErr();
   }

   /* Free resources allocated by SmartReadArgs(), even in case of error
    * during parsing */
   SmartFreeArgs(&smart_args);

   /* Do the error handling */
   if (error)
   {
      if (smart_args.sa_Flags & SAF_WORKBENCH)
      {
         /* Display error in requester if started from Workbench */
         UBYTE buffer[100];
         struct EasyStruct es =
         {
            sizeof(struct EasyStruct),
            0,
            "Test",
            "%s",
            "Cancel"
         };

         Fault(error, "Error", buffer, sizeof(buffer));

         EasyRequest(NULL, &es, NULL, buffer);
      }
      else
      {
         /* Display error in console if started from CLI */
         PrintFault(error, "Test");
      }
   }

   /* Update the return code */
   if (error == 0)
   {
      return_code = RETURN_OK;
   }

   return return_code;
}
