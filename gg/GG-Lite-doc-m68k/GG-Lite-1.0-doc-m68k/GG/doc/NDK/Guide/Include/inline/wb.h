@DATABASE "gg:doc/NDK/Guide/Include/inline/wb.h"
@MASTER   "gg:os-include/inline/wb.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:49
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/wb.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/wb.h" LINK File}


@{b}#defines@{ub}

@{"AddAppIcon()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 50}                   @{"AddAppIconA()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 45}
@{"AddAppMenuItem()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 63}               @{"AddAppMenuItemA()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 58}
@{"AddAppWindow()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 37}                 @{"AddAppWindowA()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 32}
@{"AddAppWindowDropZone()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 107}         @{"AddAppWindowDropZoneA()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 102}
@{"ChangeWorkbenchSelection()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 120}     @{"ChangeWorkbenchSelectionA()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 115}
@{"CLIB_WB_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 5}               @{"CloseWorkbenchObject()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 89}
@{"CloseWorkbenchObjectA()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 84}        @{"MakeWorkbenchObjectVisible()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 129}
@{"MakeWorkbenchObjectVisibleA()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 124}  @{"OpenWorkbenchObject()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 80}
@{"OpenWorkbenchObjectA()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 75}         @{"RemoveAppIcon()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 54}
@{"RemoveAppMenuItem()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 67}            @{"RemoveAppWindow()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 41}
@{"RemoveAppWindowDropZone()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 111}      @{"WB_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 29}
@{"WBInfo()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 71}                       @{"WorkbenchControl()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 98}
@{"WorkbenchControlA()" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 93}            

@ENDNODE
@NODE File "inline/wb.h"
#ifndef _INLINE_WB_H
#define _INLINE_WB_H

#ifndef CLIB_WB_PROTOS_H
#define CLIB_WB_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif
#ifndef  WORKBENCH_WORKBENCH_H
#include <@{"workbench/workbench.h" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File"}>
#endif
#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef WB_BASE_NAME
#define WB_BASE_NAME WorkbenchBase
#endif

#define @{"AddAppWindowA" LINK "gg:doc/NDK/Guide/wb/AddAppWindowA"}(id, userdata, window, msgport, taglist) \\
        @{"LP5" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}(0x30, @{"struct AppWindow" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 161} *, AddAppWindowA, ULONG, id, d0, ULONG, userdata, d1, struct Window *, window, a0, struct MsgPort *, msgport, a1, struct TagItem *, taglist, a2, \\
        , WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AddAppWindow" LINK "gg:doc/NDK/Guide/wb/AddAppWindowA"}(id, userdata, window, msgport, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AddAppWindowA" LINK File 32}((id), (userdata), (window), (msgport), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"RemoveAppWindow" LINK "gg:doc/NDK/Guide/wb/RemoveAppWindow"}(appWindow) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x36, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RemoveAppWindow" LINK File 41}, @{"struct AppWindow" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 161} *, appWindow, a0, \\
        , WB_BASE_NAME)

#define @{"AddAppIconA" LINK "gg:doc/NDK/Guide/wb/AddAppIconA"}(id, userdata, text, msgport, lock, diskobj, taglist) \\
        @{"LP7A4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 656}(0x3c, @{"struct AppIcon" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 163} *, AddAppIconA, ULONG, id, d0, ULONG, userdata, d1, UBYTE *, text, a0, struct MsgPort *, msgport, a1, BPTR, lock, a2, struct DiskObject *, diskobj, a3, struct TagItem *, taglist, d7, \\
        , WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AddAppIcon" LINK "gg:doc/NDK/Guide/wb/AddAppIconA"}(id, userdata, text, msgport, lock, diskobj, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AddAppIconA" LINK File 45}((id), (userdata), (text), (msgport), (lock), (diskobj), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"RemoveAppIcon" LINK "gg:doc/NDK/Guide/wb/RemoveAppIcon"}(appIcon) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x42, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RemoveAppIcon" LINK File 54}, @{"struct AppIcon" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 163} *, appIcon, a0, \\
        , WB_BASE_NAME)

#define @{"AddAppMenuItemA" LINK "gg:doc/NDK/Guide/wb/AddAppMenuItemA"}(id, userdata, text, msgport, taglist) \\
        @{"LP5" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}(0x48, @{"struct AppMenuItem" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 164} *, AddAppMenuItemA, ULONG, id, d0, ULONG, userdata, d1, UBYTE *, text, a0, struct MsgPort *, msgport, a1, struct TagItem *, taglist, a2, \\
        , WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AddAppMenuItem" LINK "gg:doc/NDK/Guide/wb/AddAppMenuItemA"}(id, userdata, text, msgport, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AddAppMenuItemA" LINK File 58}((id), (userdata), (text), (msgport), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"RemoveAppMenuItem" LINK "gg:doc/NDK/Guide/wb/RemoveAppMenuItem"}(appMenuItem) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x4e, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RemoveAppMenuItem" LINK File 67}, @{"struct AppMenuItem" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 164} *, appMenuItem, a0, \\
        , WB_BASE_NAME)

#define @{"WBInfo" LINK "gg:doc/NDK/Guide/wb/WBInfo"}(lock, name, screen) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0x5a, @{"WBInfo" LINK File 71}, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}, lock, a0, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a1, @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *, screen, a2, \\
        , WB_BASE_NAME)

#define @{"OpenWorkbenchObjectA" LINK "gg:doc/NDK/Guide/wb/OpenWorkbenchObjectA"}(name, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x60, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"OpenWorkbenchObjectA" LINK File 75}, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tags, a1, \\
        , WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"OpenWorkbenchObject" LINK "gg:doc/NDK/Guide/wb/OpenWorkbenchObjectA"}(name, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"OpenWorkbenchObjectA" LINK File 75}((name), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"CloseWorkbenchObjectA" LINK "gg:doc/NDK/Guide/wb/CloseWorkbenchObjectA"}(name, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x66, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"CloseWorkbenchObjectA" LINK File 84}, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tags, a1, \\
        , WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"CloseWorkbenchObject" LINK "gg:doc/NDK/Guide/wb/CloseWorkbenchObjectA"}(name, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"CloseWorkbenchObjectA" LINK File 84}((name), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"WorkbenchControlA" LINK "gg:doc/NDK/Guide/wb/WorkbenchControlA"}(name, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x6c, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"WorkbenchControlA" LINK File 93}, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tags, a1, \\
        , WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"WorkbenchControl" LINK "gg:doc/NDK/Guide/wb/WorkbenchControlA"}(name, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"WorkbenchControlA" LINK File 93}((name), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"AddAppWindowDropZoneA" LINK "gg:doc/NDK/Guide/wb/AddAppWindowDropZoneA"}(aw, id, userdata, tags) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x72, @{"struct AppWindowDropZone" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 162} *, AddAppWindowDropZoneA, struct AppWindow *, aw, a0, ULONG, id, d0, ULONG, userdata, d1, struct TagItem *, tags, a1, \\
        , WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AddAppWindowDropZone" LINK "gg:doc/NDK/Guide/wb/AddAppWindowDropZoneA"}(aw, id, userdata, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AddAppWindowDropZoneA" LINK File 102}((aw), (id), (userdata), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"RemoveAppWindowDropZone" LINK "gg:doc/NDK/Guide/wb/RemoveAppWindowDropZone"}(aw, dropZone) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x78, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RemoveAppWindowDropZone" LINK File 111}, @{"struct AppWindow" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 161} *, aw, a0, struct AppWindowDropZone *, dropZone, a1, \\
        , WB_BASE_NAME)

#define @{"ChangeWorkbenchSelectionA" LINK "gg:doc/NDK/Guide/wb/ChangeWorkbenchSelectionA"}(name, hook, tags) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x7e, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"ChangeWorkbenchSelectionA" LINK File 115}, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a0, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, hook, a1, struct TagItem *, tags, a2, \\
        , WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"ChangeWorkbenchSelection" LINK "gg:doc/NDK/Guide/wb/ChangeWorkbenchSelectionA"}(name, hook, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"ChangeWorkbenchSelectionA" LINK File 115}((name), (hook), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"MakeWorkbenchObjectVisibleA" LINK "gg:doc/NDK/Guide/wb/MakeWorkbenchObjectVisibleA"}(name, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x84, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"MakeWorkbenchObjectVisibleA" LINK File 124}, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tags, a1, \\
        , WB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"MakeWorkbenchObjectVisible" LINK "gg:doc/NDK/Guide/wb/MakeWorkbenchObjectVisibleA"}(name, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"MakeWorkbenchObjectVisibleA" LINK File 124}((name), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_WB_H  */
@ENDNODE
