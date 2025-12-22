#include <proto/exec.h>
#include <interfaces/solib.h>
#include <dlfcn.h>
#include <solib.h>

char const *lasterror;

extern struct SolibContext ___solib_ctx;
extern struct SolibContext *___solib_currentContext; 


struct Handle
{
	struct Library *Lib;
	struct SolibMainIFace *ISolibMain;
	struct SolibSymIFace *ISolibSym;
};

void *dlopen (const char *filename, int flag)
{
	struct ExecIFace *IExec = (struct ExecIFace *)((*(struct ExecBase **)4)->MainInterface);
	struct Handle *handle;
	struct SolibContext *ctx;
	
	if (!filename)
	{
		lasterror = "dlopen: No filename";
		return NULL;
	}
	
	handle = (struct Handle *)IExec->AllocVec(sizeof(struct Handle), MEMF_CLEAR);
	if (!handle)
	{
		lasterror = "dlopen: Out of memory";
		return NULL;
	}
	
	handle->Lib = IExec->OpenLibrary((char *)filename, 0);
	if (!handle->Lib)
	{
		lasterror = "dlopen: File not found";
		goto error;
	}
	
	handle->ISolibMain = (struct SolibMainIFace *)IExec->GetInterface(handle->Lib,
		"main", 1, NULL);
	if (!handle->ISolibMain)
	{
		lasterror = "dlopen: Not a shared library";
		goto error;
	}
	
	if (___solib_currentContext == 0)
		ctx = &___solib_ctx;
	else
		ctx = ___solib_currentContext;
	
	handle->ISolibSym = (struct SolibSymIFace *)handle->ISolibMain->GetInterface(ctx);
	if (!handle->ISolibSym)
	{
		lasterror = "dlopen: No symbols in file";
		goto error;
	}
	
	return (void *)handle;
	
error:
	if (handle && handle->ISolibSym)
		handle->ISolibMain->DropInterface(handle->ISolibSym);
	
	if (handle && handle->ISolibMain)
		IExec->DropInterface((struct Interface *)handle->ISolibMain);
		
	if (handle && handle->Lib)
		IExec->CloseLibrary(handle->Lib);
	
	if (handle)
		IExec->FreeVec(handle);
		
	return NULL;
}

int dlclose (void *_handle)
{
	struct ExecIFace *IExec = (struct ExecIFace *)((*(struct ExecBase **)4)->MainInterface);
	struct Handle *handle = (struct Handle *)_handle;
	
	if (!handle)
	{
		lasterror = "dlclose: Handle does not refer to an open object";
		return 1;
	}
	
	if (handle->ISolibSym)
		handle->ISolibMain->DropInterface(handle->ISolibSym);

	if (handle->ISolibMain)
		IExec->DropInterface((struct Interface *)handle->ISolibMain);
		
	if (handle->Lib)
		IExec->CloseLibrary(handle->Lib);
		
	IExec->FreeVec(handle);
	
	return 0;
}

void *dlsym(void *_handle, char *symbol)
{
	void *ressym;
	struct Handle *handle = (struct Handle *)_handle;
	
	if (!handle || (handle->ISolibSym == 0))
	{
		lasterror = "dlsym: Handle does not refer to an open object";
		return NULL;
	}
	
	ressym = handle->ISolibSym->GetSymbol(symbol, 0);
	if (!ressym)
	{
		lasterror = "dlysm: Symbol not found";
		return NULL;
	}
	
	return ressym;
}
	
const char *dlerror(void)
{
	char const *error = lasterror;
	
	lasterror = NULL;
	return error;
}
