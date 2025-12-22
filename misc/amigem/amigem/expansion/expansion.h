#include <exec/semaphores.h>

#define LOCAL_MEM_SIZE	1048576

#define LIB_NAME	"expansion.library"
#define LIB_VERSION 	40
#define LIB_REVISION	1
#define LIB_DATE	"21.01.95"

/* Note: There's a duplicate definition of this in exec.h
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
