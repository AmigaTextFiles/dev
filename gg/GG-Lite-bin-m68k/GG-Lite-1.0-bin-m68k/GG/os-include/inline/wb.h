#ifndef _INLINE_WB_H
#define _INLINE_WB_H

#ifndef CLIB_WB_PROTOS_H
#define CLIB_WB_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  DOS_DOS_H
#include <dos/dos.h>
#endif
#ifndef  WORKBENCH_WORKBENCH_H
#include <workbench/workbench.h>
#endif
#ifndef  INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef WB_BASE_NAME
#define WB_BASE_NAME WorkbenchBase
#endif

#define AddAppWindowA(id, userdata, window, msgport, taglist) \
	LP5(0x30, struct AppWindow *, AddAppWindowA, ULONG, id, d0, ULONG, userdata, d1, struct Window *, window, a0, struct MsgPort *, msgport, a1, struct TagItem *, taglist, a2, \
	, WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AddAppWindow(id, userdata, window, msgport, tags...) \
	({ULONG _tags[] = {tags}; AddAppWindowA((id), (userdata), (window), (msgport), (struct TagItem *) _tags);})
#endif

#define RemoveAppWindow(appWindow) \
	LP1(0x36, BOOL, RemoveAppWindow, struct AppWindow *, appWindow, a0, \
	, WB_BASE_NAME)

#define AddAppIconA(id, userdata, text, msgport, lock, diskobj, taglist) \
	LP7A4(0x3c, struct AppIcon *, AddAppIconA, ULONG, id, d0, ULONG, userdata, d1, UBYTE *, text, a0, struct MsgPort *, msgport, a1, BPTR, lock, a2, struct DiskObject *, diskobj, a3, struct TagItem *, taglist, d7, \
	, WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AddAppIcon(id, userdata, text, msgport, lock, diskobj, tags...) \
	({ULONG _tags[] = {tags}; AddAppIconA((id), (userdata), (text), (msgport), (lock), (diskobj), (struct TagItem *) _tags);})
#endif

#define RemoveAppIcon(appIcon) \
	LP1(0x42, BOOL, RemoveAppIcon, struct AppIcon *, appIcon, a0, \
	, WB_BASE_NAME)

#define AddAppMenuItemA(id, userdata, text, msgport, taglist) \
	LP5(0x48, struct AppMenuItem *, AddAppMenuItemA, ULONG, id, d0, ULONG, userdata, d1, UBYTE *, text, a0, struct MsgPort *, msgport, a1, struct TagItem *, taglist, a2, \
	, WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AddAppMenuItem(id, userdata, text, msgport, tags...) \
	({ULONG _tags[] = {tags}; AddAppMenuItemA((id), (userdata), (text), (msgport), (struct TagItem *) _tags);})
#endif

#define RemoveAppMenuItem(appMenuItem) \
	LP1(0x4e, BOOL, RemoveAppMenuItem, struct AppMenuItem *, appMenuItem, a0, \
	, WB_BASE_NAME)

#define WBInfo(lock, name, screen) \
	LP3NR(0x5a, WBInfo, BPTR, lock, a0, STRPTR, name, a1, struct Screen *, screen, a2, \
	, WB_BASE_NAME)

#define OpenWorkbenchObjectA(name, tags) \
	LP2(0x60, BOOL, OpenWorkbenchObjectA, STRPTR, name, a0, struct TagItem *, tags, a1, \
	, WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define OpenWorkbenchObject(name, tags...) \
	({ULONG _tags[] = {tags}; OpenWorkbenchObjectA((name), (struct TagItem *) _tags);})
#endif

#define CloseWorkbenchObjectA(name, tags) \
	LP2(0x66, BOOL, CloseWorkbenchObjectA, STRPTR, name, a0, struct TagItem *, tags, a1, \
	, WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CloseWorkbenchObject(name, tags...) \
	({ULONG _tags[] = {tags}; CloseWorkbenchObjectA((name), (struct TagItem *) _tags);})
#endif

#define WorkbenchControlA(name, tags) \
	LP2(0x6c, BOOL, WorkbenchControlA, STRPTR, name, a0, struct TagItem *, tags, a1, \
	, WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WorkbenchControl(name, tags...) \
	({ULONG _tags[] = {tags}; WorkbenchControlA((name), (struct TagItem *) _tags);})
#endif

#define AddAppWindowDropZoneA(aw, id, userdata, tags) \
	LP4(0x72, struct AppWindowDropZone *, AddAppWindowDropZoneA, struct AppWindow *, aw, a0, ULONG, id, d0, ULONG, userdata, d1, struct TagItem *, tags, a1, \
	, WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AddAppWindowDropZone(aw, id, userdata, tags...) \
	({ULONG _tags[] = {tags}; AddAppWindowDropZoneA((aw), (id), (userdata), (struct TagItem *) _tags);})
#endif

#define RemoveAppWindowDropZone(aw, dropZone) \
	LP2(0x78, BOOL, RemoveAppWindowDropZone, struct AppWindow *, aw, a0, struct AppWindowDropZone *, dropZone, a1, \
	, WB_BASE_NAME)

#define ChangeWorkbenchSelectionA(name, hook, tags) \
	LP3(0x7e, BOOL, ChangeWorkbenchSelectionA, STRPTR, name, a0, struct Hook *, hook, a1, struct TagItem *, tags, a2, \
	, WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define ChangeWorkbenchSelection(name, hook, tags...) \
	({ULONG _tags[] = {tags}; ChangeWorkbenchSelectionA((name), (hook), (struct TagItem *) _tags);})
#endif

#define MakeWorkbenchObjectVisibleA(name, tags) \
	LP2(0x84, BOOL, MakeWorkbenchObjectVisibleA, STRPTR, name, a0, struct TagItem *, tags, a1, \
	, WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define MakeWorkbenchObjectVisible(name, tags...) \
	({ULONG _tags[] = {tags}; MakeWorkbenchObjectVisibleA((name), (struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_WB_H  */
