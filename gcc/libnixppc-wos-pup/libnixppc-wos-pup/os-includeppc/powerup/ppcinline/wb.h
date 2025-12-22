/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_WB_H
#define _PPCINLINE_WB_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef WB_BASE_NAME
#define WB_BASE_NAME WorkbenchBase
#endif /* !WB_BASE_NAME */

#define AddAppIconA(id, userdata, text, msgport, lock, diskobj, taglist) \
	LP7A4(0x3c, struct AppIcon *, AddAppIconA, ULONG, id, d0, ULONG, userdata, d1, UBYTE *, text, a0, struct MsgPort *, msgport, a1, struct FileLock *, lock, a2, struct DiskObject *, diskobj, a3, struct TagItem *, taglist, d7, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AddAppIcon(a0, a1, a2, a3, a4, a5, tags...) \
	({ULONG _tags[] = { tags }; AddAppIconA((a0), (a1), (a2), (a3), (a4), (a5), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AddAppMenuItemA(id, userdata, text, msgport, taglist) \
	LP5(0x48, struct AppMenuItem *, AddAppMenuItemA, ULONG, id, d0, ULONG, userdata, d1, UBYTE *, text, a0, struct MsgPort *, msgport, a1, struct TagItem *, taglist, a2, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AddAppMenuItem(a0, a1, a2, a3, tags...) \
	({ULONG _tags[] = { tags }; AddAppMenuItemA((a0), (a1), (a2), (a3), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AddAppWindowA(id, userdata, window, msgport, taglist) \
	LP5(0x30, struct AppWindow *, AddAppWindowA, ULONG, id, d0, ULONG, userdata, d1, struct Window *, window, a0, struct MsgPort *, msgport, a1, struct TagItem *, taglist, a2, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AddAppWindow(a0, a1, a2, a3, tags...) \
	({ULONG _tags[] = { tags }; AddAppWindowA((a0), (a1), (a2), (a3), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AddAppWindowDropZoneA(aw, id, userdata, tags) \
	LP4(0x72, struct AppWindowDropZone *, AddAppWindowDropZoneA, struct AppWindow *, aw, a0, ULONG, id, d0, ULONG, userdata, d1, struct TagItem *, tags, a1, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AddAppWindowDropZone(a0, a1, a2, tags...) \
	({ULONG _tags[] = { tags }; AddAppWindowDropZoneA((a0), (a1), (a2), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define ChangeWorkbenchSelectionA(name, hook, tags) \
	LP3(0x7e, BOOL, ChangeWorkbenchSelectionA, STRPTR, name, a0, struct Hook *, hook, a1, struct TagItem *, tags, a2, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define ChangeWorkbenchSelection(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; ChangeWorkbenchSelectionA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define CloseWorkbenchObjectA(name, tags) \
	LP2(0x66, BOOL, CloseWorkbenchObjectA, STRPTR, name, a0, struct TagItem *, tags, a1, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define CloseWorkbenchObject(a0, tags...) \
	({ULONG _tags[] = { tags }; CloseWorkbenchObjectA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define MakeWorkbenchObjectVisibleA(name, tags) \
	LP2(0x84, BOOL, MakeWorkbenchObjectVisibleA, STRPTR, name, a0, struct TagItem *, tags, a1, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define MakeWorkbenchObjectVisible(a0, tags...) \
	({ULONG _tags[] = { tags }; MakeWorkbenchObjectVisibleA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define OpenWorkbenchObjectA(name, tags) \
	LP2(0x60, BOOL, OpenWorkbenchObjectA, STRPTR, name, a0, struct TagItem *, tags, a1, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define OpenWorkbenchObject(a0, tags...) \
	({ULONG _tags[] = { tags }; OpenWorkbenchObjectA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define RemoveAppIcon(appIcon) \
	LP1(0x42, BOOL, RemoveAppIcon, struct AppIcon *, appIcon, a0, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemoveAppMenuItem(appMenuItem) \
	LP1(0x4e, BOOL, RemoveAppMenuItem, struct AppMenuItem *, appMenuItem, a0, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemoveAppWindow(appWindow) \
	LP1(0x36, BOOL, RemoveAppWindow, struct AppWindow *, appWindow, a0, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemoveAppWindowDropZone(aw, dropZone) \
	LP2(0x78, BOOL, RemoveAppWindowDropZone, struct AppWindow *, aw, a0, struct AppWindowDropZone *, dropZone, a1, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WBInfo(lock, name, screen) \
	LP3NR(0x5a, WBInfo, BPTR, lock, a0, STRPTR, name, a1, struct Screen *, screen, a2, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WorkbenchControlA(name, tags) \
	LP2(0x6c, BOOL, WorkbenchControlA, STRPTR, name, a0, struct TagItem *, tags, a1, \
	, WB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define WorkbenchControl(a0, tags...) \
	({ULONG _tags[] = { tags }; WorkbenchControlA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#endif /* !_PPCINLINE_WB_H */
