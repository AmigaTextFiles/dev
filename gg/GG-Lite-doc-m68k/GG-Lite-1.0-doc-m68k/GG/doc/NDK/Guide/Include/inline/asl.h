@DATABASE "gg:doc/NDK/Guide/Include/inline/asl.h"
@MASTER   "gg:os-include/inline/asl.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:29
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/asl.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/asl.h" LINK File}


@{b}#defines@{ub}

@{"AbortAslRequest()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 60}      @{"ActivateAslRequest()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 64}  @{"AllocAslRequest()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 38}
@{"AllocAslRequestTags()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 43}  @{"AllocFileRequest()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 26}    @{"ASL_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 23}
@{"AslRequest()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 51}           @{"AslRequestTags()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 56}      @{"CLIB_ASL_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 5}
@{"FreeAslRequest()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 47}       @{"FreeFileRequest()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 30}     @{"RequestFile()" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 34}

@ENDNODE
@NODE File "inline/asl.h"
#ifndef _INLINE_ASL_H
#define _INLINE_ASL_H

#ifndef CLIB_ASL_PROTOS_H
#define CLIB_ASL_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  LIBRARIES_ASL_H
#include <@{"libraries/asl.h" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File"}>
#endif

#ifndef ASL_BASE_NAME
#define ASL_BASE_NAME AslBase
#endif

#define @{"AllocFileRequest()" LINK "gg:doc/NDK/Guide/asl/AllocFileRequest"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"struct FileRequester" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File" 71} *, AllocFileRequest, \\
        , ASL_BASE_NAME)

#define @{"FreeFileRequest" LINK "gg:doc/NDK/Guide/asl/FreeFileRequest"}(fileReq) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x24, @{"FreeFileRequest" LINK File 30}, @{"struct FileRequester" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File" 71} *, fileReq, a0, \\
        , ASL_BASE_NAME)

#define @{"RequestFile" LINK "gg:doc/NDK/Guide/asl/RequestFile"}(fileReq) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x2a, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RequestFile" LINK File 34}, @{"struct FileRequester" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File" 71} *, fileReq, a0, \\
        , ASL_BASE_NAME)

#define @{"AllocAslRequest" LINK "gg:doc/NDK/Guide/asl/AllocAslRequest"}(reqType, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x30, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"AllocAslRequest" LINK File 38}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, reqType, d0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a0, \\
        , ASL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AllocAslRequestTags" LINK "gg:doc/NDK/Guide/asl/AllocAslRequest"}(reqType, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocAslRequest" LINK File 38}((reqType), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"FreeAslRequest" LINK "gg:doc/NDK/Guide/asl/FreeAslRequest"}(requester) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x36, @{"FreeAslRequest" LINK File 47}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, requester, a0, \\
        , @{"ASL_BASE_NAME" LINK File 23})

#define @{"AslRequest" LINK "gg:doc/NDK/Guide/asl/AslRequest"}(requester, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x3c, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"AslRequest" LINK File 51}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, requester, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a1, \\
        , ASL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AslRequestTags" LINK "gg:doc/NDK/Guide/asl/AslRequest"}(requester, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AslRequest" LINK File 51}((requester), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"AbortAslRequest" LINK "gg:doc/NDK/Guide/asl/AbortAslRequest"}(requester) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x4e, @{"AbortAslRequest" LINK File 60}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, requester, a0, \\
        , @{"ASL_BASE_NAME" LINK File 23})

#define @{"ActivateAslRequest" LINK "gg:doc/NDK/Guide/asl/ActivateAslRequest"}(requester) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x54, @{"ActivateAslRequest" LINK File 64}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, requester, a0, \\
        , @{"ASL_BASE_NAME" LINK File 23})

#endif /*  _INLINE_ASL_H  */
@ENDNODE
