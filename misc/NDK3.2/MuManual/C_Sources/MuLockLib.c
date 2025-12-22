/*************************************************
 ** MuLockLib                                   **
 **                                             **
 ** Load the mmu.library and lock it in memory  **
 **                                             **
 ** Release 40.3, © 1999 THOR Software          **
 ** Gunther Nikl, Thomas Richter, 7.8.1999      **
 *************************************************/

/// Include
#include <exec/types.h>
#include <exec/ports.h>
#include <exec/memory.h>

#include <dos/dosextens.h>
#include <dos/dostags.h>

#include <proto/exec.h>
#include <proto/dos.h>

#include <strings.h>
///
/// Defines
#define STACKSIZ 512
#define TASKNAME "« MuLockLib »"
///
/// Structures
struct StartupMsg {
  APTR        su_SysBase;
  struct Task su_Task;
  char        su_TaskName[16];
  char        su_LibName[16];
  ULONG       su_Code[1];
};
//
//
#if defined(__GNUC__)
int Start(void) { return Main(); }
#endif
///
/// statics
const char version[] = "$VER: MuLockLib 40.3 (7.8.99) © Gunther Nikl, THOR";
///
/// Protos
static struct StartupMsg *BuildStartup(APTR SysBase);
static void __stdargs RunBack(struct StartupMsg *su);
static void EndTag(void);
int __saveds Main(void);
///
/// main
int __saveds Main(void)
{
struct ExecBase *SysBase;
struct DosLibrary *DOSBase;
struct Process *proc;
struct Message *msg;
struct Task *lt;
int rc = 20;

        SysBase = *((struct ExecBase **)(4L));
        proc = (struct Process *)FindTask(NULL);
        msg = NULL;

        if (proc->pr_CLI==NULL) {
                WaitPort(&proc->pr_MsgPort);
                msg=GetMsg(&proc->pr_MsgPort);
        }

        if (DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",37L)) {
                Forbid();
                if (lt=FindTask(TASKNAME))
                        Signal(lt,SIGBREAKF_CTRL_C);
                Permit();

                if (lt) {
                        if (!msg) Printf("MuLockLib removed.\n");
                        rc = 0;
                } else if (!BuildStartup(SysBase)) {
                        if (!msg) Printf("MuLockLib: Failed to launch the background process.\n");
                } else rc = 0;

                CloseLibrary((struct Library *)DOSBase);
        }

        if (msg) {
                Forbid();
                ReplyMsg(msg);
        }

        return rc;
}
///
/// BuildStartup

struct newMemList {
  struct Node     nml_Node;
  UWORD           nml_NumEntries;
  struct MemEntry nml_ME[2];
};

static struct StartupMsg *BuildStartup(APTR SysBase)
{
struct StartupMsg *su;
struct newMemList nml;
struct MemList *ml;
ULONG codesize;
char *p;

        codesize                = (ULONG)(EndTag)-(ULONG)(RunBack);
        nml.nml_NumEntries      = 2;
        nml.nml_ME[0].me_Reqs   = MEMF_PUBLIC|MEMF_CLEAR;
        nml.nml_ME[0].me_Length = sizeof(struct StartupMsg)+codesize;
        nml.nml_ME[1].me_Reqs   = MEMF_PUBLIC;
        nml.nml_ME[1].me_Length = STACKSIZ;

        ml = AllocEntry((struct MemList *)&nml);

        if (!((unsigned int)ml&(1<<31))) {
                su = ml->ml_ME[0].me_Addr;
                p  = (char *)ml->ml_ME[1].me_Addr;

                su->su_SysBase = SysBase;
                su->su_Task.tc_Node.ln_Type = NT_TASK;
                su->su_Task.tc_Node.ln_Pri  = -1;
                su->su_Task.tc_Node.ln_Name = su->su_TaskName;
                su->su_Task.tc_SPLower      = p;
                su->su_Task.tc_SPReg        = (p+=STACKSIZ-4);
                ((APTR *)p)[0] = su;        /* push the function argument already to the stack */
                su->su_Task.tc_SPUpper      = (p+=sizeof(APTR));
                NewList(&su->su_Task.tc_MemEntry);
                AddHead(&su->su_Task.tc_MemEntry,&ml->ml_Node);
                strcpy(su->su_TaskName,TASKNAME);
                strcpy(su->su_LibName,"mmu.library");
                CopyMem((ULONG *)(RunBack),su->su_Code,codesize);
                CacheClearU();
                if (!AddTask(&su->su_Task,su->su_Code,0)) {
                        FreeEntry(ml);
                        su = NULL;
                }
        } else su = NULL;

  return su;
}

///
/// RunBack
static void __stdargs RunBack(struct StartupMsg *su)
{
APTR SysBase = su->su_SysBase;
struct Library *mulib;

        if (mulib=OpenLibrary(su->su_LibName,0)) {
                Wait(SIGBREAKF_CTRL_C);
                CloseLibrary(mulib);
        }
}

static void EndTag(void)
{
}

///
