#include <interfaces/exec.h>
#include <solib.h>

struct SolibContext ___solib_ctx;
/* The "current context" is always 0 for programs, and non-0 for shared
 * libraries
 */
struct SolibContext *___solib_currentContext = 0; 

void __ctx_construct(void) __attribute__((constructor));

void __ctx_construct(void)
{
	struct ExecIFace *IExec = (struct ExecIFace *)((*(struct ExecBase **)4)
													->MainInterface);
	IExec->NewList(&___solib_ctx.Interfaces);
	IExec->InitSemaphore(&___solib_ctx.Lock);
}
