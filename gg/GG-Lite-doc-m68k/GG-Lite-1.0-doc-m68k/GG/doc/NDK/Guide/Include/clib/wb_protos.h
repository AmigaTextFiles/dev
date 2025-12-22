@DATABASE "gg:doc/NDK/Guide/Include/clib/wb_protos.h"
@MASTER   "gg:os-include/clib/wb_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:03
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/wb_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/wb_protos.h" LINK File}

@ENDNODE
@NODE File "clib/wb_protos.h"
#ifndef  CLIB_WB_PROTOS_H
#define  CLIB_WB_PROTOS_H

/*
**      $VER: wb_protos.h 44.5 (21.6.1999)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/*--- functions in V36 or higher (Release 2.0) ---*/
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

@{"struct AppWindow" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 161} *AddAppWindowA( ULONG id, ULONG userdata, struct Window *window, struct MsgPort *msgport, struct TagItem *taglist );
@{"struct AppWindow" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 161} *AddAppWindow( ULONG id, ULONG userdata, struct Window *window, struct MsgPort *msgport, Tag tag1, ... );

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RemoveAppWindow" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 41}( @{"struct AppWindow" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 161} *appWindow );

@{"struct AppIcon" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 163} *AddAppIconA( ULONG id, ULONG userdata, UBYTE *text, struct MsgPort *msgport, BPTR lock, struct DiskObject *diskobj, struct TagItem *taglist );
@{"struct AppIcon" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 163} *AddAppIcon( ULONG id, ULONG userdata, UBYTE *text, struct MsgPort *msgport, BPTR lock, struct DiskObject *diskobj, Tag tag1, ... );

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RemoveAppIcon" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 54}( @{"struct AppIcon" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 163} *appIcon );

@{"struct AppMenuItem" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 164} *AddAppMenuItemA( ULONG id, ULONG userdata, UBYTE *text, struct MsgPort *msgport, struct TagItem *taglist );
@{"struct AppMenuItem" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 164} *AddAppMenuItem( ULONG id, ULONG userdata, UBYTE *text, struct MsgPort *msgport, Tag tag1, ... );

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RemoveAppMenuItem" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 67}( @{"struct AppMenuItem" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 164} *appMenuItem );

/*--- functions in V39 or higher (Release 3) ---*/


@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WBInfo" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 71}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *screen );

/*--- functions in V44 or higher (Release 3.5) ---*/
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"OpenWorkbenchObjectA" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 75}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"OpenWorkbenchObject" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 80}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CloseWorkbenchObjectA" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 84}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CloseWorkbenchObject" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 89}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"WorkbenchControlA" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 93}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"WorkbenchControl" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 98}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, ... );
@{"struct AppWindowDropZone" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 162} *AddAppWindowDropZoneA( struct AppWindow *aw, ULONG id, ULONG userdata, struct TagItem *tags );
@{"struct AppWindowDropZone" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 162} *AddAppWindowDropZone( struct AppWindow *aw, ULONG id, ULONG userdata, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RemoveAppWindowDropZone" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 111}( @{"struct AppWindow" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 161} *aw, struct AppWindowDropZone *dropZone );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ChangeWorkbenchSelectionA" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 115}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook, struct TagItem *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ChangeWorkbenchSelection" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 120}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MakeWorkbenchObjectVisibleA" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 124}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MakeWorkbenchObjectVisible" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File" 129}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, ... );


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_WB_PROTOS_H */
@ENDNODE
