
#ifndef _NVLIBRARY_H
#define _NVLIBRARY_H

#include <exec/types.h>
#include <exec/lists.h>
#include <libraries/nonvolatile.h>

class NVLibrary
{
public:
	NVLibrary();
	~NVLibrary();

	static class NVLibrary Default;

	APTR GetCopyNV(CONST_STRPTR appName, CONST_STRPTR itemName, LONG killRequesters);
	VOID FreeNVData(APTR data);
	UWORD StoreNV(CONST_STRPTR appName, CONST_STRPTR itemName, CONST APTR data, ULONG length, LONG killRequesters);
	BOOL DeleteNV(CONST_STRPTR appName, CONST_STRPTR itemName, LONG killRequesters);
	struct NVInfo * GetNVInfo(LONG killRequesters);
	struct MinList * GetNVList(CONST_STRPTR appName, LONG killRequesters);
	BOOL SetNVProtection(CONST_STRPTR appName, CONST_STRPTR itemName, LONG mask, LONG killRequesters);

private:
	struct Library *Base;
};

NVLibrary NVLibrary::Default;

#endif

