/*
 * DOSPathWhich.c  V1.0
 *
 * Example: Implementation of the "which" program using dospath.library
 *
 * (c) 1996 Stefan Becker
 *
 */

/* OS include files */
#include <libraries/dospath.h>

/* OS function prototypes */
#include <clib/dos_protos.h>
#include <clib/dospath_protos.h>
#include <clib/exec_protos.h>

/* OS function inline calls */
#include <pragmas/dos_pragmas.h>
#include <pragmas/dospath_pragmas.h>
#include <pragmas/exec_pragmas.h>

/* ANSI C includes */
#include <stdlib.h>
#include <stdio.h>

/* Library bases */
extern struct Library *DOSBase, *DOSPathBase, *SysBase;

/* Conversion buffer */
#define BUFLEN 256
static char Buffer[BUFLEN];

/* CLI/WB entry point */
int main(int argc, char *argv[])
{
 int rc = RETURN_FAIL;

 /* Workbench startup? */
 if (argc > 0) {

  /* CLI startup, check argument count */
  if (argc > 1) {
   struct PathListEntry *path =
                         GetProcessPathList((struct Process *) FindTask(NULL));

   /* Set new error code */
   rc = RETURN_OK;

   /* For each argument on the command line */
   while (--argc) {
    char                 *file  = *++argv;
    struct PathListEntry *state = path;
    BPTR                  lock;
    BOOL                  found = FALSE;

    /* Print file name */
    printf("%s:", file);
    fflush(stdout);

    /* Scan path list */
    while (lock = FindFileInPathList(&state, file)) {

     /* File has been found */
     found = TRUE;

     /* File found, convert lock to directory name */
     if (NameFromLock(lock, Buffer, BUFLEN))

      /* Print directory */
      printf(" %s", Buffer);

     else

      /* Couldn't convert lock */
      printf(" <UNKNOWN>");
    }

    /* File found? */
    if (found)

     /* Yes, complete line */
     printf("\n");

    else {

     /* File not found */
     printf(" not in path!\n");

     /* Set return code to WARN level */
     rc = RETURN_WARN;
    }
   }

  } else
   fprintf(stderr, "Usage: %s <file> [<file> ....]\n", argv[0]);
 }

 return(rc);
}
