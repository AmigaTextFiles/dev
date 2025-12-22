
#ifndef _AMIGAGUIDELIBRARY_H
#define _AMIGAGUIDELIBRARY_H

#include <exec/types.h>
#include <exec/ports.h>
#include <dos/dos.h>
#include <libraries/amigaguide.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <rexx/storage.h>

class AmigaGuideLibrary
{
public:
	AmigaGuideLibrary();
	~AmigaGuideLibrary();

	static class AmigaGuideLibrary Default;

	LONG LockAmigaGuideBase(APTR handle);
	VOID UnlockAmigaGuideBase(LONG key);
	APTR OpenAmigaGuideA(struct NewAmigaGuide * nag, struct TagItem * tag1);
	APTR OpenAmigaGuideAsyncA(struct NewAmigaGuide * nag, struct TagItem * attrs);
	VOID CloseAmigaGuide(APTR cl);
	ULONG AmigaGuideSignal(APTR cl);
	struct AmigaGuideMsg * GetAmigaGuideMsg(APTR cl);
	VOID ReplyAmigaGuideMsg(struct AmigaGuideMsg * amsg);
	LONG SetAmigaGuideContextA(APTR cl, ULONG id, struct TagItem * attrs);
	LONG SendAmigaGuideContextA(APTR cl, struct TagItem * attrs);
	LONG SendAmigaGuideCmdA(APTR cl, STRPTR cmd, struct TagItem * attrs);
	LONG SetAmigaGuideAttrsA(APTR cl, struct TagItem * attrs);
	LONG GetAmigaGuideAttr(Tag tag, APTR cl, ULONG * storage);
	LONG LoadXRef(BPTR lock, STRPTR name);
	VOID ExpungeXRef();
	APTR AddAmigaGuideHostA(struct Hook * h, STRPTR name, struct TagItem * attrs);
	LONG RemoveAmigaGuideHostA(APTR hh, struct TagItem * attrs);
	STRPTR GetAmigaGuideString(LONG id);

private:
	struct Library *Base;
};

AmigaGuideLibrary AmigaGuideLibrary::Default;

#endif

