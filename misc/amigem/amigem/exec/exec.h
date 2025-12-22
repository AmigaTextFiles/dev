#include <exec/libraries.h>
#include <exec/semaphores.h>
#include <libraries/configvars.h>
#include <signal.h>

#define LIB_NAME	"exec.library"
#define LIB_VERSION 	40
#define LIB_REVISION	1
#define	LIB_DATE	"21.1.95"

/* Note: This is a duplicate definition from expansion.h
 *
 * I don't know if it's legal to write patched system structures down in own
 * header files. Anyway - this way I use headers and don't copy them ;-).
 */
#define MountList MountList;struct ExecBase *SysBase;struct SignalSemaphore ConfigBinding
#include <libraries/expansionbase.h>
#undef MountList

#define LocalMemStart	eb_Private02
#define LocalMemSize	eb_Private03
#define LocalCurBind	eb_Private04
#define ConfigDevList	eb_Private05

#define ex_MemHandler \
ex_MemHandler;struct Interrupt *SoftDispatch;APTR functable[14]; \
WORD inttabl[NSIG];WORD sigtabl[16];sigset_t used;sigset_t currentints; \
APTR currentcontext;UBYTE *newstack
#include <exec/execbase.h>
#undef ex_MemHandler
