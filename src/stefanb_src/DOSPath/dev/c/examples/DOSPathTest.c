/*
 * DOSPathTest.c  V1.0
 *
 * Example: test dospath.library
 *
 * (c) 1996 Stefan Becker
 *
 */

/* OS include files */
#include <dos/dostags.h>
#include <libraries/dospath.h>
#include <workbench/startup.h>

/* OS function prototypes */
#include <clib/dos_protos.h>
#include <clib/dospath_protos.h>

/* OS function inline calls */
#include <pragmas/dos_pragmas.h>
#include <pragmas/dospath_pragmas.h>

/* ANSI C includes */
#include <stdlib.h>
#include <stdio.h>

/* Library bases */
extern struct Library *DOSBase, *DOSPathBase;

/* Directory names arrays (NULL terminated string array) */
static const char *Empty[] = {
 NULL
};
static const char *Dir1[] = {
 "C:",
 "Work:",
 "CONSOLE:", /* Illegal name */
 "S:",
 "C:dir",    /* Illegal name, "c:dir" is a file! */
 "L:",
 NULL
};
static const char *Dir2[] = {
 "DEVS:",
 "LIBS:",
 "SYS:Tools",
 "SYS:System",
 NULL
};

/* Conversion buffer */
#define BUFLEN 256
static char Buffer[BUFLEN];

/* Print path list to stdout */
static void PrintPathList(const char *text, struct PathListEntry *ple)
{
 puts("");
 puts(text);

 /* Scan path list */
 while (ple) {

  /* Convert lock to name */
  if (NameFromLock(ple->ple_Lock, Buffer, BUFLEN)) puts(Buffer);

  /* Next path list entry */
  ple = BADDR(ple->ple_Next);
 }
}

/* Remove a directory from the path */
static struct PathListEntry *RemoveFromPath(struct PathListEntry *head,
                                            const char *name)
{
 BPTR lock;

 /* Get a shared lock on the directory */
 if (lock = Lock(name, SHARED_LOCK)) {

  /* Remove directory from path list */
  head = RemoveFromPathList(head, lock);

  /* Unlock directory */
  UnLock(lock);
 }

 /* Return pointer to head of path list */
 return(head);
}

/* CLI/WB entry point */
int main(int argc, char *argv[])
{
 /* Workbench startup? Yes, make sure that stdout is open */
 if ((argc != 0) ||
     freopen("CON:0/0/640/200/DOSPath Test/WAIT/CLOSE/AUTO", "w", stdout)) {
  struct PathListEntry *head, *new, *anchor;

  /* Initialize anchor */
  anchor = NULL;

  /* Build path from empty string array */
  head = BuildPathListTags(&anchor, DOSPath_BuildFromArray, Empty, TAG_DONE);
  PrintPathList("Empty: From head of list",  head);
  PrintPathList("Empty: Last entry in list", anchor);
  puts("");

  /* Add path from first directory string array */
  new = BuildPathListTags(&anchor, DOSPath_BuildFromArray, Dir1, TAG_DONE);
  if (head == NULL) head = new;
  PrintPathList("Dir1: From head of list",   head);
  PrintPathList("Dir1: New entries in list", new);
  PrintPathList("Dir1: Last entry in list",  anchor);
  puts("");

  /* Add a global path. Started from Workbench or CLI? */
  switch (argc) {
   case 0:  /* Started from Workbench. Add path from Workbench process */
    new = CopyWorkbenchPathList((struct WBStartup *) argv, &anchor);
    break;

   case 1:  /* Started from CLI without parameters. Add path from WB process */
    /* NOTE: See also the WARNING section in the dospath.library AutoDocs */
    new = CopyWorkbenchPathList(NULL, &anchor);
    break;

   default: /* Started from CLI with parameters. Add path from CLI process */
    new = CopyPathList((struct PathListEntry *) BADDR(Cli()->cli_CommandDir),
                       &anchor);
    break;
  }
  if (head == NULL) head = new;
  PrintPathList("Global: From head of list",   head);
  PrintPathList("Global: New entries in list", new);
  PrintPathList("Global: Last entry in list",  anchor);
  puts("");

  /* Add path from second directory string array */
  new = BuildPathListTags(&anchor, DOSPath_BuildFromArray, &Dir2);
  if (head == NULL) head = new;
  PrintPathList("Dir2: From head of list",   head);
  PrintPathList("Dir2: New entries in list", new);
  PrintPathList("Dir2: Last entry in list",  anchor);
  puts("");

  /* Remove directory from  path */
  head = RemoveFromPath(head, "C:");
  head = RemoveFromPath(head, "Work123:");
  head = RemoveFromPath(head, "Sys:Tools");
  PrintPathList("Remove: From head of list",   head);
  puts("");

  /* Now we start a shell and supply the path */
  puts("Starting new CLI process. Try to type 'path' in it!");
  if (SystemTags("NewCLI", SYS_UserShell,  TRUE,
                           NP_Path,        MKBADDR(head),
                           TAG_DONE) == -1) {

   /* Couldn't create process */
   puts("Couldn't create process!!");

   /* Free path list */
   FreePathList(head);
  }
 }

 return(0);
}

#ifdef _DCC
/* DICE WB entry point */
int wbmain(struct WBStartup *wbs)
{
 /* Just call the main entry point */
 return(main(0, (char **) wbs));
}
#endif
