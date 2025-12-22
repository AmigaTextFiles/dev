/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_ICON_H
#define _PPCINLINE_ICON_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef ICON_BASE_NAME
#define ICON_BASE_NAME IconBase
#endif /* !ICON_BASE_NAME */

#define AddFreeList(freelist, mem, size) \
	LP3(0x48, BOOL, AddFreeList, struct FreeList *, freelist, a0, CONST APTR, mem, a1, ULONG, size, a2, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define BumpRevision(newname, oldname) \
	LP2(0x6c, STRPTR, BumpRevision, STRPTR, newname, a0, CONST_STRPTR, oldname, a1, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ChangeToSelectedIconColor(cr) \
	LP1NR(0xc6, ChangeToSelectedIconColor, struct ColorRegister *, cr, a0, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DeleteDiskObject(name) \
	LP1(0x8a, BOOL, DeleteDiskObject, CONST_STRPTR, name, a0, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DrawIconStateA(rp, icon, label, leftOffset, topOffset, state, tags) \
	LP7NR(0xa2, DrawIconStateA, struct RastPort *, rp, a0, CONST struct DiskObject *, icon, a1, CONST_STRPTR, label, a2, LONG, leftOffset, d0, LONG, topOffset, d1, ULONG, state, d2, CONST struct TagItem *, tags, a3, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DupDiskObjectA(diskObject, tags) \
	LP2(0x96, struct DiskObject *, DupDiskObjectA, CONST struct DiskObject *, diskObject, a0, CONST struct TagItem *, tags, a1, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindToolType(toolTypeArray, typeName) \
	LP2(0x60, UBYTE *, FindToolType, CONST_STRPTR *, toolTypeArray, a0, CONST_STRPTR, typeName, a1, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeDiskObject(diskobj) \
	LP1NR(0x5a, FreeDiskObject, struct DiskObject *, diskobj, a0, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeFreeList(freelist) \
	LP1NR(0x36, FreeFreeList, struct FreeList *, freelist, a0, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetDefDiskObject(type) \
	LP1(0x78, struct DiskObject *, GetDefDiskObject, LONG, type, d0, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetDiskObject(name) \
	LP1(0x4e, struct DiskObject *, GetDiskObject, CONST_STRPTR, name, a0, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetDiskObjectNew(name) \
	LP1(0x84, struct DiskObject *, GetDiskObjectNew, CONST_STRPTR, name, a0, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetIconRectangleA(rp, icon, label, rect, tags) \
	LP5A4(0xa8, BOOL, GetIconRectangleA, struct RastPort *, rp, a0, CONST struct DiskObject *, icon, a1, CONST_STRPTR, label, a2, struct Rectangle *, rect, a3, CONST struct TagItem *, tags, d7, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetIconTagList(name, tags) \
	LP2(0xb4, struct DiskObject *, GetIconTagList, CONST_STRPTR, name, a0, CONST struct TagItem *, tags, a1, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define IconControlA(icon, tags) \
	LP2(0x9c, ULONG, IconControlA, struct DiskObject *, icon, a0, CONST struct TagItem *, tags, a1, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define LayoutIconA(icon, screen, tags) \
	LP3(0xc0, BOOL, LayoutIconA, struct DiskObject *, icon, a0, struct Screen *, screen, a1, struct TagItem *, tags, a2, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define LayoutIcon(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; LayoutIconA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define MatchToolValue(typeString, value) \
	LP2(0x66, BOOL, MatchToolValue, CONST_STRPTR, typeString, a0, CONST_STRPTR, value, a1, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define NewDiskObject(type) \
	LP1(0xae, struct DiskObject *, NewDiskObject, LONG, type, d0, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PutDefDiskObject(diskObject) \
	LP1(0x7e, BOOL, PutDefDiskObject, CONST struct DiskObject *, diskObject, a0, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PutDiskObject(name, diskobj) \
	LP2(0x54, BOOL, PutDiskObject, CONST_STRPTR, name, a0, CONST struct DiskObject *, diskobj, a1, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PutIconTagList(name, icon, tags) \
	LP3(0xba, BOOL, PutIconTagList, CONST_STRPTR, name, a0, CONST struct DiskObject *, icon, a1, CONST struct TagItem *, tags, a2, \
	, ICON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_ICON_H */
