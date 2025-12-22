#include <clib/timer_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

#include <pragmas/timer_pragmas.h>
#include <pragmas/exec_sysbase_pragmas.h>
#include <pragmas/dos_pragmas.h>

#include <exec/tasks.h>
#include <exec/execbase.h>
#include <dos/dosextens.h>

extern int main(int argc,char **argv);
struct ExecBase *SysBase;
struct Library *DOSBase;
struct Library *UtilityBase;


int __saveds _main(void)
{
struct Process *proc;
LONG rc = 25;

        SysBase = *(struct ExecBase **)(4L);

        proc = SysBase->ThisTask;

        if (proc->pr_CLI == NULL) {
                WaitPort(&(proc->pr_MsgPort));
                Forbid();
                ReplyMsg(GetMsg(&(proc->pr_MsgPort)));
                return 0;
        }

        if (DOSBase = OpenLibrary("dos.library",37L)) {
                if (UtilityBase = OpenLibrary("utility.library",37L)) {
                        rc = main(1,NULL);
                        CloseLibrary(UtilityBase);
                }
                CloseLibrary(DOSBase);
        }

        return rc;
}


