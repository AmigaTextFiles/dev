@DATABASE "gg:doc/NDK/Guide/Include/inline/icon.h"
@MASTER   "gg:os-include/inline/icon.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/icon.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/icon.h" LINK File}


@{b}#defines@{ub}

@{"AddFreeList()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 27}       @{"BumpRevision()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 51}       @{"ChangeToSelectedIconColor()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 138}
@{"CLIB_ICON_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 5}  @{"DeleteDiskObject()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 67}   @{"DrawIconState()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 94}
@{"DrawIconStateA()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 89}    @{"DupDiskObject()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 76}      @{"DupDiskObjectA()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 71}
@{"FindToolType()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 43}      @{"FreeDiskObject()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 39}     @{"FreeFreeList()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 23}
@{"GetDefDiskObject()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 55}  @{"GetDiskObject()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 31}      @{"GetDiskObjectNew()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 63}
@{"GetIconRectangle()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 103}  @{"GetIconRectangleA()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 98}  @{"GetIconTagList()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 111}
@{"GetIconTags()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 116}       @{"ICON_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 20}       @{"IconControl()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 85}
@{"IconControlA()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 80}      @{"LayoutIcon()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 134}         @{"LayoutIconA()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 129}
@{"MatchToolValue()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 47}    @{"NewDiskObject()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 107}      @{"PutDefDiskObject()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 59}
@{"PutDiskObject()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 35}     @{"PutIconTagList()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 120}     @{"PutIconTags()" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File" 125}

@ENDNODE
@NODE File "inline/icon.h"
#ifndef _INLINE_ICON_H
#define _INLINE_ICON_H

#ifndef CLIB_ICON_PROTOS_H
#define CLIB_ICON_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  WORKBENCH_WORKBENCH_H
#include <@{"workbench/workbench.h" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File"}>
#endif
#ifndef  DATATYPES_PICTURECLASS_H
#include <@{"datatypes/pictureclass.h" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File"}>
#endif

#ifndef ICON_BASE_NAME
#define ICON_BASE_NAME IconBase
#endif

#define @{"FreeFreeList" LINK "gg:doc/NDK/Guide/icon/FreeFreeList"}(freelist) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x36, @{"FreeFreeList" LINK File 23}, @{"struct FreeList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 86} *, freelist, a0, \\
        , ICON_BASE_NAME)

#define @{"AddFreeList" LINK "gg:doc/NDK/Guide/icon/AddFreeList"}(freelist, mem, size) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x48, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"AddFreeList" LINK File 27}, @{"struct FreeList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 86} *, freelist, a0, const APTR, mem, a1, ULONG, size, a2, \\
        , ICON_BASE_NAME)

#define @{"GetDiskObject" LINK "gg:doc/NDK/Guide/icon/GetDiskObject"}(name) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x4e, @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, GetDiskObject, const STRPTR, name, a0, \\
        , ICON_BASE_NAME)

#define @{"PutDiskObject" LINK "gg:doc/NDK/Guide/icon/PutDiskObject"}(name, diskobj) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x54, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"PutDiskObject" LINK File 35}, const @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a0, const @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, diskobj, a1, \\
        , ICON_BASE_NAME)

#define @{"FreeDiskObject" LINK "gg:doc/NDK/Guide/icon/FreeDiskObject"}(diskobj) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x5a, @{"FreeDiskObject" LINK File 39}, @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, diskobj, a0, \\
        , ICON_BASE_NAME)

#define @{"FindToolType" LINK "gg:doc/NDK/Guide/icon/FindToolType"}(toolTypeArray, typeName) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x60, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *, @{"FindToolType" LINK File 43}, const @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} *, toolTypeArray, a0, const @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, typeName, a1, \\
        , @{"ICON_BASE_NAME" LINK File 20})

#define @{"MatchToolValue" LINK "gg:doc/NDK/Guide/icon/MatchToolValue"}(typeString, value) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x66, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"MatchToolValue" LINK File 47}, const @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, typeString, a0, const @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, value, a1, \\
        , @{"ICON_BASE_NAME" LINK File 20})

#define @{"BumpRevision" LINK "gg:doc/NDK/Guide/icon/BumpRevision"}(newname, oldname) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x6c, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, @{"BumpRevision" LINK File 51}, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, newname, a0, const @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, oldname, a1, \\
        , @{"ICON_BASE_NAME" LINK File 20})

#define @{"GetDefDiskObject" LINK "gg:doc/NDK/Guide/icon/GetDefDiskObject"}(type) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x78, @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, GetDefDiskObject, LONG, type, d0, \\
        , ICON_BASE_NAME)

#define @{"PutDefDiskObject" LINK "gg:doc/NDK/Guide/icon/PutDefDiskObject"}(diskObject) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x7e, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"PutDefDiskObject" LINK File 59}, const @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, diskObject, a0, \\
        , ICON_BASE_NAME)

#define @{"GetDiskObjectNew" LINK "gg:doc/NDK/Guide/icon/GetDiskObjectNew"}(name) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x84, @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, GetDiskObjectNew, const STRPTR, name, a0, \\
        , ICON_BASE_NAME)

#define @{"DeleteDiskObject" LINK "gg:doc/NDK/Guide/icon/DeleteDiskObject"}(name) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x8a, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"DeleteDiskObject" LINK File 67}, const @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a0, \\
        , @{"ICON_BASE_NAME" LINK File 20})

#define @{"DupDiskObjectA" LINK "gg:doc/NDK/Guide/icon/DupDiskObjectA"}(diskObject, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x96, @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, DupDiskObjectA, const struct DiskObject *, diskObject, a0, const struct TagItem *, tags, a1, \\
        , ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"DupDiskObject" LINK "gg:doc/NDK/Guide/icon/DupDiskObjectA"}(diskObject, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"DupDiskObjectA" LINK File 71}((diskObject), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"IconControlA" LINK "gg:doc/NDK/Guide/icon/IconControlA"}(icon, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x9c, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"IconControlA" LINK File 80}, @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, icon, a0, const struct TagItem *, tags, a1, \\
        , ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"IconControl" LINK "gg:doc/NDK/Guide/icon/IconControlA"}(icon, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"IconControlA" LINK File 80}((icon), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"DrawIconStateA" LINK "gg:doc/NDK/Guide/icon/DrawIconStateA"}(rp, icon, label, leftOffset, topOffset, state, tags) \\
        @{"LP7NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 626}(0xa2, @{"DrawIconStateA" LINK File 89}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, rp, a0, const struct DiskObject *, icon, a1, const STRPTR, label, a2, LONG, leftOffset, d0, LONG, topOffset, d1, ULONG, state, d2, const struct TagItem *, tags, a3, \\
        , ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"DrawIconState" LINK "gg:doc/NDK/Guide/icon/DrawIconStateA"}(rp, icon, label, leftOffset, topOffset, state, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"DrawIconStateA" LINK File 89}((rp), (icon), (label), (leftOffset), (topOffset), (state), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetIconRectangleA" LINK "gg:doc/NDK/Guide/icon/GetIconRectangleA"}(rp, icon, label, rect, tags) \\
        @{"LP5A4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 515}(0xa8, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"GetIconRectangleA" LINK File 98}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, rp, a0, const struct DiskObject *, icon, a1, const STRPTR, label, a2, struct Rectangle *, rect, a3, const struct TagItem *, tags, d7, \\
        , ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetIconRectangle" LINK "gg:doc/NDK/Guide/icon/GetIconRectangleA"}(rp, icon, label, rect, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetIconRectangleA" LINK File 98}((rp), (icon), (label), (rect), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"NewDiskObject" LINK "gg:doc/NDK/Guide/icon/NewDiskObject"}(type) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xae, @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, NewDiskObject, LONG, type, d0, \\
        , ICON_BASE_NAME)

#define @{"GetIconTagList" LINK "gg:doc/NDK/Guide/icon/GetIconTagList"}(name, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xb4, @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, GetIconTagList, const STRPTR, name, a0, const struct TagItem *, tags, a1, \\
        , ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetIconTags" LINK "gg:doc/NDK/Guide/icon/GetIconTagList"}(name, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetIconTagList" LINK File 111}((name), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"PutIconTagList" LINK "gg:doc/NDK/Guide/icon/PutIconTagList"}(name, icon, tags) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xba, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"PutIconTagList" LINK File 120}, const @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a0, const @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, icon, a1, const struct TagItem *, tags, a2, \\
        , ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"PutIconTags" LINK "gg:doc/NDK/Guide/icon/PutIconTagList"}(name, icon, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"PutIconTagList" LINK File 120}((name), (icon), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"LayoutIconA" LINK "gg:doc/NDK/Guide/icon/LayoutIconA"}(icon, screen, tags) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xc0, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"LayoutIconA" LINK File 129}, @{"struct DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65} *, icon, a0, struct Screen *, screen, a1, struct TagItem *, tags, a2, \\
        , ICON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"LayoutIcon" LINK "gg:doc/NDK/Guide/icon/LayoutIconA"}(icon, screen, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"LayoutIconA" LINK File 129}((icon), (screen), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"ChangeToSelectedIconColor" LINK "gg:doc/NDK/Guide/icon/ChangeToSelectedIconColor"}(cr) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xc6, @{"ChangeToSelectedIconColor" LINK File 138}, @{"struct ColorRegister" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 243} *, cr, a0, \\
        , ICON_BASE_NAME)

#endif /*  _INLINE_ICON_H  */
@ENDNODE
