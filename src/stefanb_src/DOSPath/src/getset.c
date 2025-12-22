/*
 * getset.c  V1.0
 *
 * Get/Set process path list
 *
 * (c) 1996 Stefan Becker
 */

#include "dospath.h"

/* Get CLI pointer from a process */
static struct CommandLineInterface *GetProcessCLI(struct Process *pr)
{
 return(
        /* Is the task is a AmigaDOS process? */
        (pr->pr_Task.tc_Node.ln_Type == NT_PROCESS) ?

        /* Yes, return pointer to CLI */
        (struct CommandLineInterface *) BADDR(pr->pr_CLI) :

        /* No, return NULL */
        NULL);
}

__geta4 struct PathListEntry *GetProcessPathList(__A0 struct Process *process)
{
 struct CommandLineInterface *cli;
 struct PathListEntry        *rc  = NULL;

 DEBUGLOG(kprintf("Get: Process 0x%08lx Path 0x%08lx\n", process, path);)

 /* Get CLI pointer and path list pointer */
 if (cli = GetProcessCLI(process)) rc = BADDR(cli->cli_CommandDir);

 DEBUGLOG(kprintf("Get: Result 0x%08lx\n", rc);)

 /* Return pointer to path list */
 return(rc);
}

__geta4 struct PathListEntry *SetProcessPathList(__A0 struct Process *process,
                                               __A1 struct PathListEntry *path)
{
 struct CommandLineInterface *cli;
 struct PathListEntry        *rc  = NULL;

 DEBUGLOG(kprintf("Get: Process 0x%08lx Path 0x%08lx\n", process, path);)

 /* Get CLI pointer */
 if (cli = GetProcessCLI(process)) {

  /* Get old path list pointer */
  rc = BADDR(cli->cli_CommandDir);

  /* Set new path */
  cli->cli_CommandDir = MKBADDR(path);
 }

 DEBUGLOG(kprintf("Set: Result 0x%08lx\n", rc);)

 /* Return pointer to path list */
 return(rc);
}
