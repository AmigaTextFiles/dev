
#ifndef _REXXSYSLIBRARY_H
#define _REXXSYSLIBRARY_H

#include <exec/types.h>
#include <rexx/rxslib.h>
#include <rexx/rexxio.h>

class RexxSysLibrary
{
public:
	RexxSysLibrary();
	~RexxSysLibrary();

	static class RexxSysLibrary Default;

	UBYTE * CreateArgstring(CONST STRPTR string, ULONG length);
	VOID DeleteArgstring(UBYTE * argstring);
	ULONG LengthArgstring(CONST UBYTE * argstring);
	struct RexxMsg * CreateRexxMsg(CONST struct MsgPort * port, CONST_STRPTR extension, CONST_STRPTR host);
	VOID DeleteRexxMsg(struct RexxMsg * packet);
	VOID ClearRexxMsg(struct RexxMsg * msgptr, ULONG count);
	BOOL FillRexxMsg(struct RexxMsg * msgptr, ULONG count, ULONG mask);
	BOOL IsRexxMsg(CONST struct RexxMsg * msgptr);
	VOID LockRexxBase(ULONG resource);
	VOID UnlockRexxBase(ULONG resource);

private:
	struct Library *Base;
};

RexxSysLibrary RexxSysLibrary::Default;

#endif

