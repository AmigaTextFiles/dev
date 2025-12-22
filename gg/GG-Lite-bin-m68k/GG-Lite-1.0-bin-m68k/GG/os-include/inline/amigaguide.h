#ifndef _INLINE_AMIGAGUIDE_H
#define _INLINE_AMIGAGUIDE_H

#ifndef CLIB_AMIGAGUIDE_PROTOS_H
#define CLIB_AMIGAGUIDE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  EXEC_PORTS_H
#include <exec/ports.h>
#endif
#ifndef  DOS_DOS_H
#include <dos/dos.h>
#endif
#ifndef  LIBRARIES_AMIGAGUIDE_H
#include <libraries/amigaguide.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif
#ifndef  REXX_STORAGE_H
#include <rexx/storage.h>
#endif

#ifndef AMIGAGUIDE_BASE_NAME
#define AMIGAGUIDE_BASE_NAME AmigaGuideBase
#endif

#define LockAmigaGuideBase(handle) \
	LP1(0x24, LONG, LockAmigaGuideBase, APTR, handle, a0, \
	, AMIGAGUIDE_BASE_NAME)

#define UnlockAmigaGuideBase(key) \
	LP1NR(0x2a, UnlockAmigaGuideBase, LONG, key, d0, \
	, AMIGAGUIDE_BASE_NAME)

#define OpenAmigaGuideA(nag, tags) \
	LP2(0x36, APTR, OpenAmigaGuideA, struct NewAmigaGuide *, nag, a0, struct TagItem *, tags, a1, \
	, AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define OpenAmigaGuide(nag, tags...) \
	({ULONG _tags[] = {tags}; OpenAmigaGuideA((nag), (struct TagItem *) _tags);})
#endif

#define OpenAmigaGuideAsyncA(nag, attrs) \
	LP2(0x3c, APTR, OpenAmigaGuideAsyncA, struct NewAmigaGuide *, nag, a0, struct TagItem *, attrs, d0, \
	, AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define OpenAmigaGuideAsync(nag, tags...) \
	({ULONG _tags[] = {tags}; OpenAmigaGuideAsyncA((nag), (struct TagItem *) _tags);})
#endif

#define CloseAmigaGuide(cl) \
	LP1NR(0x42, CloseAmigaGuide, APTR, cl, a0, \
	, AMIGAGUIDE_BASE_NAME)

#define AmigaGuideSignal(cl) \
	LP1(0x48, ULONG, AmigaGuideSignal, APTR, cl, a0, \
	, AMIGAGUIDE_BASE_NAME)

#define GetAmigaGuideMsg(cl) \
	LP1(0x4e, struct AmigaGuideMsg *, GetAmigaGuideMsg, APTR, cl, a0, \
	, AMIGAGUIDE_BASE_NAME)

#define ReplyAmigaGuideMsg(amsg) \
	LP1NR(0x54, ReplyAmigaGuideMsg, struct AmigaGuideMsg *, amsg, a0, \
	, AMIGAGUIDE_BASE_NAME)

#define SetAmigaGuideContextA(cl, id, attrs) \
	LP3(0x5a, LONG, SetAmigaGuideContextA, APTR, cl, a0, ULONG, id, d0, struct TagItem *, attrs, d1, \
	, AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetAmigaGuideContext(cl, id, tags...) \
	({ULONG _tags[] = {tags}; SetAmigaGuideContextA((cl), (id), (struct TagItem *) _tags);})
#endif

#define SendAmigaGuideContextA(cl, attrs) \
	LP2(0x60, LONG, SendAmigaGuideContextA, APTR, cl, a0, struct TagItem *, attrs, d0, \
	, AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SendAmigaGuideContext(cl, tags...) \
	({ULONG _tags[] = {tags}; SendAmigaGuideContextA((cl), (struct TagItem *) _tags);})
#endif

#define SendAmigaGuideCmdA(cl, cmd, attrs) \
	LP3(0x66, LONG, SendAmigaGuideCmdA, APTR, cl, a0, STRPTR, cmd, d0, struct TagItem *, attrs, d1, \
	, AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SendAmigaGuideCmd(cl, cmd, tags...) \
	({ULONG _tags[] = {tags}; SendAmigaGuideCmdA((cl), (cmd), (struct TagItem *) _tags);})
#endif

#define SetAmigaGuideAttrsA(cl, attrs) \
	LP2(0x6c, LONG, SetAmigaGuideAttrsA, APTR, cl, a0, struct TagItem *, attrs, a1, \
	, AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetAmigaGuideAttrs(cl, tags...) \
	({ULONG _tags[] = {tags}; SetAmigaGuideAttrsA((cl), (struct TagItem *) _tags);})
#endif

#define GetAmigaGuideAttr(d0arg, cl, storage) \
	LP3(0x72, LONG, GetAmigaGuideAttr, Tag, d0arg, d0, APTR, cl, a0, ULONG *, storage, a1, \
	, AMIGAGUIDE_BASE_NAME)

#define LoadXRef(lock, name) \
	LP2(0x7e, LONG, LoadXRef, BPTR, lock, a0, STRPTR, name, a1, \
	, AMIGAGUIDE_BASE_NAME)

#define ExpungeXRef() \
	LP0NR(0x84, ExpungeXRef, \
	, AMIGAGUIDE_BASE_NAME)

#define AddAmigaGuideHostA(h, name, attrs) \
	LP3(0x8a, APTR, AddAmigaGuideHostA, struct Hook *, h, a0, STRPTR, name, d0, struct TagItem *, attrs, a1, \
	, AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AddAmigaGuideHost(h, name, tags...) \
	({ULONG _tags[] = {tags}; AddAmigaGuideHostA((h), (name), (struct TagItem *) _tags);})
#endif

#define RemoveAmigaGuideHostA(hh, attrs) \
	LP2(0x90, LONG, RemoveAmigaGuideHostA, APTR, hh, a0, struct TagItem *, attrs, a1, \
	, AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define RemoveAmigaGuideHost(hh, tags...) \
	({ULONG _tags[] = {tags}; RemoveAmigaGuideHostA((hh), (struct TagItem *) _tags);})
#endif

#define GetAmigaGuideString(id) \
	LP1(0xd2, STRPTR, GetAmigaGuideString, LONG, id, d0, \
	, AMIGAGUIDE_BASE_NAME)

#endif /*  _INLINE_AMIGAGUIDE_H  */
