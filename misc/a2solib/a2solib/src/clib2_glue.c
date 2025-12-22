#include <proto/exec.h>
#include <proto/utility.h>
#include <proto/dos.h>

#include <solib.h>

#define DEBUG
#include "debug.h"

extern struct Library *__UtilityBase;
extern struct UtilityIFace *__IUtility;

extern char *__program_name;
char **_dummy = &__program_name;
struct SolibContext *___solib_currentContext;

void __set_context(struct SolibContext *ctx)
{
	dprintf("Setting context to %p\n", ctx);
	___solib_currentContext = ctx;
}

void __open_libraries(struct ExecIFace *iexec)
{
	SysBase = iexec->Data.LibBase;
	IExec = iexec;
	IExec->Obtain();

	DOSBase = IExec->OpenLibrary("dos.library", 0);
	IDOS = (struct DOSIFace *)IExec->GetInterface(DOSBase, "main", 1, NULL);

	__UtilityBase = IExec->OpenLibrary("utility.library", 0);
	__IUtility = (struct UtilityIFace *)
						IExec->GetInterface(__UtilityBase, "main", 1, NULL);
}

void __close_libraries(void)
{
	if (__IUtility)
	{
		IExec->DropInterface((struct Interface *)__IUtility);
		__IUtility = 0;
	}

	if (__UtilityBase)
	{
		IExec->CloseLibrary(__UtilityBase);
		__UtilityBase = 0;
	}
	
	if (IDOS)
	{
		IExec->DropInterface((struct Interface *)IDOS);
		IDOS = 0;
	}
	
	if (DOSBase)
	{
		IExec->CloseLibrary(DOSBase);
		DOSBase = 0;
	}
	
	IExec->Release();
}
