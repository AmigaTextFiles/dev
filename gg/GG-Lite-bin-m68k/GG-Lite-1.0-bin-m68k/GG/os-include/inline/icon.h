#ifndef _INLINE_ICON_H
#define _INLINE_ICON_H

#ifndef CLIB_ICON_PROTOS_H
#define CLIB_ICON_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  WORKBENCH_WORKBENCH_H
#include <workbench/workbench.h>
#endif
#ifndef  DATATYPES_PICTURECLASS_H
#include <datatypes/pictureclass.h>
#endif

#ifndef ICON_BASE_NAME
#define ICON_BASE_NAME IconBase
#endif

#define FreeFreeList(freelist) \
	LP1NR(0x36, FreeFreeList, struct FreeList *, freelist, a0, \
	, ICON_BASE_NAME)

#define AddFreeList(freelist, mem, size) \
	LP3(0x48, BOOL, AddFreeList, struct FreeList *, freelist, a0, const APTR, mem, a1, ULONG, size, a2, \
	, ICON_BASE_NAME)

#define GetDiskObject(name) \
	LP1(0x4e, struct DiskObject *, GetDiskObject, const STRPTR, name, a0, \
	, ICON_BASE_NAME)

#define PutDiskObject(name, diskobj) \
	LP2(0x54, BOOL, PutDiskObject, const STRPTR, name, a0, const struct DiskObject *, diskobj, a1, \
	, ICON_BASE_NAME)

#define FreeDiskObject(diskobj) \
	LP1NR(0x5a, FreeDiskObject, struct DiskObject *, diskobj, a0, \
	, ICON_BASE_NAME)

#define FindToolType(toolTypeArray, typeName) \
	LP2(0x60, UBYTE *, FindToolType, const STRPTR *, toolTypeArray, a0, const STRPTR, typeName, a1, \
	, ICON_BASE_NAME)

#define MatchToolValue(typeString, value) \
	LP2(0x66, BOOL, MatchToolValue, const STRPTR, typeString, a0, const STRPTR, value, a1, \
	, ICON_BASE_NAME)

#define BumpRevision(newname, oldname) \
	LP2(0x6c, STRPTR, BumpRevision, STRPTR, newname, a0, const STRPTR, oldname, a1, \
	, ICON_BASE_NAME)

#define GetDefDiskObject(type) \
	LP1(0x78, struct DiskObject *, GetDefDiskObject, LONG, type, d0, \
	, ICON_BASE_NAME)

#define PutDefDiskObject(diskObject) \
	LP1(0x7e, BOOL, PutDefDiskObject, const struct DiskObject *, diskObject, a0, \
	, ICON_BASE_NAME)

#define GetDiskObjectNew(name) \
	LP1(0x84, struct DiskObject *, GetDiskObjectNew, const STRPTR, name, a0, \
	, ICON_BASE_NAME)

#define DeleteDiskObject(name) \
	LP1(0x8a, BOOL, DeleteDiskObject, const STRPTR, name, a0, \
	, ICON_BASE_NAME)

#define DupDiskObjectA(diskObject, tags) \
	LP2(0x96, struct DiskObject *, DupDiskObjectA, const struct DiskObject *, diskObject, a0, const struct TagItem *, tags, a1, \
	, ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define DupDiskObject(diskObject, tags...) \
	({ULONG _tags[] = {tags}; DupDiskObjectA((diskObject), (const struct TagItem *) _tags);})
#endif

#define IconControlA(icon, tags) \
	LP2(0x9c, ULONG, IconControlA, struct DiskObject *, icon, a0, const struct TagItem *, tags, a1, \
	, ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define IconControl(icon, tags...) \
	({ULONG _tags[] = {tags}; IconControlA((icon), (const struct TagItem *) _tags);})
#endif

#define DrawIconStateA(rp, icon, label, leftOffset, topOffset, state, tags) \
	LP7NR(0xa2, DrawIconStateA, struct RastPort *, rp, a0, const struct DiskObject *, icon, a1, const STRPTR, label, a2, LONG, leftOffset, d0, LONG, topOffset, d1, ULONG, state, d2, const struct TagItem *, tags, a3, \
	, ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define DrawIconState(rp, icon, label, leftOffset, topOffset, state, tags...) \
	({ULONG _tags[] = {tags}; DrawIconStateA((rp), (icon), (label), (leftOffset), (topOffset), (state), (const struct TagItem *) _tags);})
#endif

#define GetIconRectangleA(rp, icon, label, rect, tags) \
	LP5A4(0xa8, BOOL, GetIconRectangleA, struct RastPort *, rp, a0, const struct DiskObject *, icon, a1, const STRPTR, label, a2, struct Rectangle *, rect, a3, const struct TagItem *, tags, d7, \
	, ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetIconRectangle(rp, icon, label, rect, tags...) \
	({ULONG _tags[] = {tags}; GetIconRectangleA((rp), (icon), (label), (rect), (const struct TagItem *) _tags);})
#endif

#define NewDiskObject(type) \
	LP1(0xae, struct DiskObject *, NewDiskObject, LONG, type, d0, \
	, ICON_BASE_NAME)

#define GetIconTagList(name, tags) \
	LP2(0xb4, struct DiskObject *, GetIconTagList, const STRPTR, name, a0, const struct TagItem *, tags, a1, \
	, ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetIconTags(name, tags...) \
	({ULONG _tags[] = {tags}; GetIconTagList((name), (const struct TagItem *) _tags);})
#endif

#define PutIconTagList(name, icon, tags) \
	LP3(0xba, BOOL, PutIconTagList, const STRPTR, name, a0, const struct DiskObject *, icon, a1, const struct TagItem *, tags, a2, \
	, ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define PutIconTags(name, icon, tags...) \
	({ULONG _tags[] = {tags}; PutIconTagList((name), (icon), (const struct TagItem *) _tags);})
#endif

#define LayoutIconA(icon, screen, tags) \
	LP3(0xc0, BOOL, LayoutIconA, struct DiskObject *, icon, a0, struct Screen *, screen, a1, struct TagItem *, tags, a2, \
	, ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define LayoutIcon(icon, screen, tags...) \
	({ULONG _tags[] = {tags}; LayoutIconA((icon), (screen), (struct TagItem *) _tags);})
#endif

#define ChangeToSelectedIconColor(cr) \
	LP1NR(0xc6, ChangeToSelectedIconColor, struct ColorRegister *, cr, a0, \
	, ICON_BASE_NAME)

#endif /*  _INLINE_ICON_H  */
