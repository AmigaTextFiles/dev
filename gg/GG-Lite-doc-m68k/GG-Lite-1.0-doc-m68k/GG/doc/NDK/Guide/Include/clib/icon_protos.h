@DATABASE "gg:doc/NDK/Guide/Include/clib/icon_protos.h"
@MASTER   "gg:os-include/clib/icon_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:47
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/icon_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/icon_protos.h" LINK File}

@ENDNODE
@NODE File "clib/icon_protos.h"
#ifndef  CLIB_ICON_PROTOS_H
#define  CLIB_ICON_PROTOS_H

/*
**      $VER: icon_protos.h 44.17 (15.7.1999)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  WORKBENCH_WORKBENCH_H
#include <@{"workbench/workbench.h" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File"}>
#endif
#ifndef  DATATYPES_PICTURECLASS_H
#include <@{"datatypes/pictureclass.h" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File"}>
#endif
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeFreeList" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 23}( @{"struct FreeList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 86} *freelist );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AddFreeList" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 27}( @{"struct FreeList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 86} *freelist, CONST APTR mem, ULONG size );
@{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *GetDiskObject( CONST STRPTR name );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"PutDiskObject" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 35}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *diskobj );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeDiskObject" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 39}( @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *diskobj );
@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *@{"FindToolType" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 43}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} *toolTypeArray, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} typeName );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MatchToolValue" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 47}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} typeString, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} value );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"BumpRevision" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 51}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} newname, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} oldname );
/*--- functions in V36 or higher (Release 2.0) ---*/
@{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *GetDefDiskObject( LONG type );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"PutDefDiskObject" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 59}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *diskObject );
@{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *GetDiskObjectNew( CONST STRPTR name );
/*--- functions in V37 or higher (Release 2.04) ---*/
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DeleteDiskObject" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 67}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name );
/*--- functions in V44 or higher (Release 3.5) ---*/
@{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *DupDiskObjectA( CONST struct DiskObject *diskObject, CONST struct TagItem *tags );
@{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *DupDiskObject( CONST struct DiskObject *diskObject, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"IconControlA" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 80}( @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *icon, CONST struct TagItem *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"IconControl" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 85}( @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *icon, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DrawIconStateA" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 89}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST struct DiskObject *icon, CONST STRPTR label, LONG leftOffset, LONG topOffset, ULONG state, CONST struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DrawIconState" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 94}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST struct DiskObject *icon, CONST STRPTR label, LONG leftOffset, LONG topOffset, ULONG state, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"GetIconRectangleA" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 98}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST struct DiskObject *icon, CONST STRPTR label, struct Rectangle *rect, CONST struct TagItem *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"GetIconRectangle" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 103}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST struct DiskObject *icon, CONST STRPTR label, struct Rectangle *rect, ... );
@{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *NewDiskObject( LONG type );
@{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *GetIconTagList( CONST STRPTR name, CONST struct TagItem *tags );
@{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *GetIconTags( CONST STRPTR name, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"PutIconTagList" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 120}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *icon, CONST struct TagItem *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"PutIconTags" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 125}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *icon, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"LayoutIconA" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 129}( @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *icon, struct Screen *screen, struct TagItem *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"LayoutIcon" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 134}( @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *icon, struct Screen *screen, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ChangeToSelectedIconColor" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 138}( @{"struct ColorRegister" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 243} *cr );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_ICON_PROTOS_H */
@ENDNODE
