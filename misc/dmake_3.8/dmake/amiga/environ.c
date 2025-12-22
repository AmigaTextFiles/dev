/* The Amiga environment */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <dos.h>

#include <exec/types.h>
#include <exec/lists.h>
#include <dos/var.h>
#include <proto/exec.h>

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

  /* Find out the number of files */
  if (dfind(&info, "ENV:#?", 0)) {
    /* No files found! Unbelievable! */
    return;
  }
  do {
    numenvs++;
  } while (!dnext(&info));
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
  if (dfind(&info, "ENV:#?", 0)) {
    /* This shouldn't happend */
    free(environ);
    environ = NULL;
    return;
  }
  do {
    FILE *fptr;

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
    strmfn(FileName, "ENV", NULL, info.fib_FileName, NULL);
    if ((fptr = fopen(FileName, "r")) == NULL) {
      /* Cannot read! Free memory */
      free(environ[numenvs]);
      continue;
    }
    fgets(str, info.fib_Size+1, fptr);
    fclose(fptr);

    numenvs++;
  } while (!dnext(&info));

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
