/* The Amiga environment */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#ifndef _DCC
#include <dos.h>
#else
#include <dos/dos.h>
#endif

#include <exec/types.h>
#include <exec/lists.h>
#ifndef _DCC
#include <dos/var.h>
#include <proto/exec.h>
#else
#include <dos/var.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#endif

#include "extern.h"
#include "sysintf.h"

char **environ = NULL;

__aligned struct FileInfoBlock info;

char FileName[MAX_PATH_LEN];

/* Find all environment variables from ENV: directory (not from subdirs) */
void make_env(void)
{
  int numenvs=0;
  struct Process *proc;
  struct MinNode *node;
  char *str;
#ifdef _DCC
  int argc;
  char **argv;
  BPTR lock;
#endif

#ifndef _DCC
  /* Find out the number of files */
  if (dfind(&info, "ENV:#?", 0)) {
    /* No files found! Unbelievable! */
    return;
  }
  do {
    numenvs++;
  } while (!dnext(&info));
#else
  {
    int oldargc = 2;
    char *oldargv[] = { "", "ENV:#?", NULL };

    if (expand_args(oldargc, oldargv, &argc, &argv) || argc < 2)
      return;
    /* DICE runtime will free the memory malloced here */
  }
  numenvs = argc-1;
#endif
  proc = (struct Process *)FindTask(NULL);
  if (!IsListEmpty((struct List *)&(proc->pr_LocalVars))) {
    for (node=proc->pr_LocalVars.mlh_Head; node->mln_Succ;
         node = node->mln_Succ) {
      if ((((struct LocalVar *)node)->lv_Node.ln_Type == LV_VAR) &&
          !(((struct LocalVar *)node)->lv_Flags & GVF_BINARY_VAR))
        numenvs++;
    }
  }
  if ((environ = MALLOC(numenvs+1, char *)) == NULL) {
    /* No memory */
    No_ram();
  }
  numenvs = 0;
#ifndef _DCC
  if (dfind(&info, "ENV:#?", 0)) {
    /* This shouldn't happend */
    free(environ);
    environ = NULL;
    return;
  }
#endif
#ifndef _DCC
  do {
#else
  while (--argc > 0) {
#endif
    FILE *fptr;

#ifdef _DCC
    lock = Lock(argv[argc], ACCESS_READ);
    if (Examine(lock, &info) != DOSTRUE)
      {
        UnLock(lock);
        free(environ);
        environ = NULL;
        return;
      }
    UnLock(lock);
    if (info.fib_DirEntryType >= 0) /* No file */
      continue;
#endif

    /* Space for entry name=value */
    if ((environ[numenvs] = MALLOC(strlen(info.fib_FileName)+
                                   info.fib_Size+2, char)) == NULL) {
      No_ram();
    }

    str = environ[numenvs];
    strcpy(str, info.fib_FileName);
    str += strlen(info.fib_FileName);
    *str++ = '=';
    /* Read the file */
#ifndef _DCC
    strmfn(FileName, "ENV", NULL, info.fib_FileName, NULL);
#else
    strcpy(FileName, argv[argc]);
#endif
    if ((fptr = fopen(FileName, "r")) == NULL) {
      /* Cannot read! Free memory */
      free(environ[numenvs]);
      continue;
    }
    fgets(str, info.fib_Size+1, fptr);
    fclose(fptr);
    numenvs++;
#ifndef _DCC
  } while (!dnext(&info));
#else
  } /* while() */
#endif

  if (!IsListEmpty((struct List *)&(proc->pr_LocalVars))) {
    for (node=proc->pr_LocalVars.mlh_Head; node->mln_Succ;
         node = node->mln_Succ) {
      if ((((struct LocalVar *)node)->lv_Node.ln_Type == LV_VAR) &&
          !(((struct LocalVar *)node)->lv_Flags & GVF_BINARY_VAR)) {
        if ((environ[numenvs] =
             MALLOC(strlen(((struct LocalVar *)node)->lv_Node.ln_Name)+
                    strlen(((struct LocalVar *)node)->lv_Value)+2, char))
            == NULL) {
          No_ram();
        }
        str = environ[numenvs];
        strcpy(str, ((struct LocalVar *)node)->lv_Node.ln_Name);
        str += strlen(((struct LocalVar *)node)->lv_Node.ln_Name);
        *str++ = '=';
        strcpy(str, ((struct LocalVar *)node)->lv_Value);
        numenvs++;
      }
    }
  }

  environ[numenvs] = NULL;
}

void free_env(void)
{
  int i;

  /* Free all strings */
  for (i=0; environ[i] != NULL; i++)
    free(environ[i]);

  /* Free environ itself */
  free(environ);

  environ = NULL;
}
