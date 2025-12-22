@DATABASE "gg:doc/NDK/Guide/Include/inline/resource.h"
@MASTER   "gg:os-include/inline/resource.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:41
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/resource.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/resource.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_RESOURCE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 5}  @{"RESOURCE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 29}  @{"RL_CloseResource()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 36}
@{"RL_DisposeGroup()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 62}       @{"RL_DisposeObject()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 49}  @{"RL_GetObjectArray()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 66}
@{"RL_NewGroup()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 58}           @{"RL_NewGroupA()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 53}      @{"RL_NewObject()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 45}
@{"RL_NewObjectA()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 40}         @{"RL_OpenResource()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 32}   @{"RL_SetResourceScreen()" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File" 70}

@ENDNODE
@NODE File "inline/resource.h"
#ifndef _INLINE_RESOURCE_H
#define _INLINE_RESOURCE_H

#ifndef CLIB_RESOURCE_PROTOS_H
#define CLIB_RESOURCE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  LIBRARIES_RESOURCE_H
#include <@{"libraries/resource.h" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File"}>
#endif
#ifndef  INTUITION_CLASSUSR_H
#include <@{"intuition/classusr.h" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File"}>
#endif
#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  LIBRARIES_LOCALE_H
#include <@{"libraries/locale.h" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef RESOURCE_BASE_NAME
#define RESOURCE_BASE_NAME ResourceBase
#endif

#define @{"RL_OpenResource" LINK "gg:doc/NDK/Guide/resource/RL_OpenResource"}(resource, screen, catalog) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x1e, @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17}, @{"RL_OpenResource" LINK File 32}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, resource, a0, @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *, screen, a1, struct Catalog *, catalog, a2, \\
        , RESOURCE_BASE_NAME)

#define @{"RL_CloseResource" LINK "gg:doc/NDK/Guide/resource/RL_CloseResource"}(resfile) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x24, @{"RL_CloseResource" LINK File 36}, @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17}, resfile, a0, \\
        , @{"RESOURCE_BASE_NAME" LINK File 29})

#define @{"RL_NewObjectA" LINK "gg:doc/NDK/Guide/resource/RL_NewObjectA"}(resfile, resid, tags) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x2a, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, @{"RL_NewObjectA" LINK File 40}, @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17}, resfile, a0, @{"RESOURCEID" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 18}, resid, d0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tags, a1, \\
        , RESOURCE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define RL_NewObject(resfile, resid, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"RL_NewObjectA" LINK File 40}((resfile), (resid), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"RL_DisposeObject" LINK "gg:doc/NDK/Guide/resource/RL_DisposeObject"}(resfile, obj) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x30, @{"RL_DisposeObject" LINK File 49}, @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17}, resfile, a0, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, obj, a1, \\
        , @{"RESOURCE_BASE_NAME" LINK File 29})

#define @{"RL_NewGroupA" LINK "gg:doc/NDK/Guide/resource/RL_NewGroupA"}(resfile, id, taglist) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x36, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} **, @{"RL_NewGroupA" LINK File 53}, @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17}, resfile, a0, @{"RESOURCEID" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 18}, id, d0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, taglist, a1, \\
        , RESOURCE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define RL_NewGroup(resfile, id, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"RL_NewGroupA" LINK File 53}((resfile), (id), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"RL_DisposeGroup" LINK "gg:doc/NDK/Guide/resource/RL_DisposeGroup"}(resfile, obj) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x3c, @{"RL_DisposeGroup" LINK File 62}, @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17}, resfile, a0, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} **, obj, a1, \\
        , @{"RESOURCE_BASE_NAME" LINK File 29})

#define @{"RL_GetObjectArray" LINK "gg:doc/NDK/Guide/resource/RL_GetObjectArray"}(resfile, obj, id) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x42, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} **, @{"RL_GetObjectArray" LINK File 66}, @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17}, resfile, a0, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, obj, a1, @{"RESOURCEID" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 18}, id, d0, \\
        , @{"RESOURCE_BASE_NAME" LINK File 29})

#define @{"RL_SetResourceScreen" LINK "gg:doc/NDK/Guide/resource/RL_SetResourceScreen"}(resfile, screen) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x48, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RL_SetResourceScreen" LINK File 70}, @{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17}, resfile, a0, @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *, screen, a1, \\
        , RESOURCE_BASE_NAME)

#endif /*  _INLINE_RESOURCE_H  */
@ENDNODE
