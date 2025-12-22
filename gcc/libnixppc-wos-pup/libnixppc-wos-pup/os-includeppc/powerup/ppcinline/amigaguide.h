/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_AMIGAGUIDE_H
#define _PPCINLINE_AMIGAGUIDE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef AMIGAGUIDE_BASE_NAME
#define AMIGAGUIDE_BASE_NAME AmigaGuideBase
#endif /* !AMIGAGUIDE_BASE_NAME */

#define AddAmigaGuideHostA(h, name, attrs) \
	LP3(0x8a, APTR, AddAmigaGuideHostA, struct Hook *, h, a0, STRPTR, name, d0, struct TagItem *, attrs, a1, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AddAmigaGuideHost(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; AddAmigaGuideHostA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AmigaGuideSignal(cl) \
	LP1(0x48, ULONG, AmigaGuideSignal, APTR, cl, a0, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CloseAmigaGuide(cl) \
	LP1NR(0x42, CloseAmigaGuide, APTR, cl, a0, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ExpungeXRef() \
	LP0NR(0x84, ExpungeXRef, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetAmigaGuideAttr(tag, cl, storage) \
	LP3(0x72, LONG, GetAmigaGuideAttr, Tag, tag, d0, APTR, cl, a0, ULONG *, storage, a1, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetAmigaGuideMsg(cl) \
	LP1(0x4e, struct AmigaGuideMsg *, GetAmigaGuideMsg, APTR, cl, a0, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetAmigaGuideString(id) \
	LP1(0xd2, STRPTR, GetAmigaGuideString, LONG, id, d0, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define LoadXRef(lock, name) \
	LP2(0x7e, LONG, LoadXRef, BPTR, lock, a0, STRPTR, name, a1, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define LockAmigaGuideBase(handle) \
	LP1(0x24, LONG, LockAmigaGuideBase, APTR, handle, a0, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OpenAmigaGuideA(nag, *_) \
	LP2(0x36, APTR, OpenAmigaGuideA, struct NewAmigaGuide *, nag, a0, struct TagItem *, *_, a1, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define OpenAmigaGuide(a0, tags...) \
	({ULONG _tags[] = { tags }; OpenAmigaGuideA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define OpenAmigaGuideAsyncA(nag, attrs) \
	LP2(0x3c, APTR, OpenAmigaGuideAsyncA, struct NewAmigaGuide *, nag, a0, struct TagItem *, attrs, d0, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define OpenAmigaGuideAsync(a0, tags...) \
	({ULONG _tags[] = { tags }; OpenAmigaGuideAsyncA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define RemoveAmigaGuideHostA(hh, attrs) \
	LP2(0x90, LONG, RemoveAmigaGuideHostA, APTR, hh, a0, struct TagItem *, attrs, a1, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define RemoveAmigaGuideHost(a0, tags...) \
	({ULONG _tags[] = { tags }; RemoveAmigaGuideHostA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define ReplyAmigaGuideMsg(amsg) \
	LP1NR(0x54, ReplyAmigaGuideMsg, struct AmigaGuideMsg *, amsg, a0, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SendAmigaGuideCmdA(cl, cmd, attrs) \
	LP3(0x66, LONG, SendAmigaGuideCmdA, APTR, cl, a0, STRPTR, cmd, d0, struct TagItem *, attrs, d1, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SendAmigaGuideCmd(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; SendAmigaGuideCmdA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SendAmigaGuideContextA(cl, attrs) \
	LP2(0x60, LONG, SendAmigaGuideContextA, APTR, cl, a0, struct TagItem *, attrs, d0, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SendAmigaGuideContext(a0, tags...) \
	({ULONG _tags[] = { tags }; SendAmigaGuideContextA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetAmigaGuideAttrsA(cl, attrs) \
	LP2(0x6c, LONG, SetAmigaGuideAttrsA, APTR, cl, a0, struct TagItem *, attrs, a1, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetAmigaGuideAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetAmigaGuideAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetAmigaGuideContextA(cl, id, attrs) \
	LP3(0x5a, LONG, SetAmigaGuideContextA, APTR, cl, a0, ULONG, id, d0, struct TagItem *, attrs, d1, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetAmigaGuideContext(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; SetAmigaGuideContextA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define UnlockAmigaGuideBase(key) \
	LP1NR(0x2a, UnlockAmigaGuideBase, LONG, key, d0, \
	, AMIGAGUIDE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_AMIGAGUIDE_H */
