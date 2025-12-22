/* Compile with:

  dcc -3.1 -mRR -ms -mi -o wbsparams wbsparams.c -ldebug -lamiga31s

*/
#include <dos/dosextens.h>
#include <workbench/startup.h>
#include <clib/dos_protos.h>
#include <clib/icon_protos.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <stdlib.h>

extern struct Library *DOSBase, *IconBase;

void kprintf(const char *, ...);

char buf[1000];

int main(int argc, char **argv)
{
 return(0);
}

int wbmain(struct WBStartup *wbs)
{
 struct Process *proc = (struct Process *) ((ULONG) wbs->sm_Process -
                                                     sizeof(struct Task));
 struct WBArg   *wa;
 int             i;

 /* Print process parameters */
 kprintf("Name       : %s (0x%08lx)\n"
         "SegList    : 0x%08lx\n"
         "Stack Size : %ld\n"
         "GlobVec    : 0x%08lx\n"
         "TaskNum    : %ld\n"
         "ConsoleTask: 0x%08lx\n"
         "FSTask     : 0x%08lx\n"
         "CLI        : 0x%08lx\n"
         "ReturnAddr : 0x%08lx\n"
         "PktWait    : 0x%08lx\n"
         "WindowPtr  : 0x%08lx\n"
         "Flags      : 0x%08lx\n"
         "ExitCode   : 0x%08lx\n"
         "ExitData   : 0x%08lx\n"
         "Arguments  : 0x%08lx\n"
         "ShellPriv  : 0x%08lx\n",
         proc->pr_Task.tc_Node.ln_Name, proc->pr_Task.tc_Node.ln_Name,
         proc->pr_SegList, proc->pr_StackSize, proc->pr_GlobVec,
         proc->pr_TaskNum, proc->pr_ConsoleTask, proc->pr_FileSystemTask,
         proc->pr_CLI, proc->pr_ReturnAddr, proc->pr_PktWait,
         proc->pr_WindowPtr, proc->pr_Flags, proc->pr_ExitCode,
         proc->pr_ExitData, proc->pr_Arguments, proc->pr_ShellPrivate);
 NameFromLock(proc->pr_CurrentDir, buf, 1000);
 kprintf("Current Dir: %s (0x%08lx)\n", buf, proc->pr_CurrentDir);
 NameFromLock(proc->pr_HomeDir, buf, 1000);
 kprintf("Home Dir   : %s (0x%08lx)\n", buf, proc->pr_HomeDir);
 NameFromLock(proc->pr_CIS, buf, 1000);
 kprintf("Input      : %s (0x%08lx)\n", buf, proc->pr_CIS);
 NameFromLock(proc->pr_COS, buf, 1000);
 kprintf("Ouput      : %s (0x%08lx)\n", buf, proc->pr_COS);
 NameFromLock(proc->pr_CES, buf, 1000);
 kprintf("Error      : %s (0x%08lx)\n", buf, proc->pr_CES);

 /* Print WBArgs */
 kprintf("Number of arguments: %ld\n", wbs->sm_NumArgs);

 for (i = 0, wa = wbs->sm_ArgList; i < wbs->sm_NumArgs; i++, wa++) {
  struct DiskObject *dobj;
  BPTR               oldlock;

  oldlock = CurrentDir(wa->wa_Lock);
  dobj = GetDiskObject(wa->wa_Name);
  CurrentDir(oldlock);
  NameFromLock(wa->wa_Lock, buf, 1000);
  kprintf("DirLock: %s (0x%08lx), Name: %s (0x%08lx), Icon: %s\n",
          buf, wa->wa_Lock, wa->wa_Name, wa->wa_Name,
          dobj ? "OK" : "NOT FOUND!");
  if (dobj) FreeDiskObject(dobj);
 }

 /* Try to open program icon */
 {
  struct DiskObject *dobj;
  BPTR               oldlock;

  oldlock = CurrentDir(wbs->sm_ArgList->wa_Lock);

  if (dobj = GetDiskObject(wbs->sm_ArgList->wa_Name))

    kprintf("Program icon found in wa_Lock: 0x%08lx\n", dobj);

  else {

   CurrentDir(proc->pr_HomeDir);

   if (dobj = GetDiskObject(wbs->sm_ArgList->wa_Name))

    kprintf("Program icon found in PROGDIR: 0x%08lx\n", dobj);

   else

    kprintf("Program icon NOT found!\n");
  }

  if (dobj) FreeDiskObject(dobj);

  CurrentDir(oldlock);
 }

 return(0);
}
