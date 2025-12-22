@DATABASE "gg:doc/NDK/Guide/Include/inline/dospath.h"
@MASTER   "gg:os-include/inline/dospath.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:46
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/dospath.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/dospath.h" LINK File}


@{b}#defines@{ub}

@{"BuildPathListTagList()" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 14}   @{"BuildPathListTags()" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 19}   @{"CopyPathList()" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 23}
@{"CopyWorkbenchPathList()" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 27}  @{"DOSPATH_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 11}     @{"FindFileInPathList()" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 31}
@{"FreePathList()" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 35}           @{"GetProcessPathList()" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 39}  @{"RemoveFromPathList()" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 43}
@{"SetProcessPathList()" LINK "gg:doc/NDK/Guide/Include/inline/dospath.h/File" 47}     

@ENDNODE
@NODE File "inline/dospath.h"
/* Automatically generated header! Do not edit! */

#ifndef _INLINE_DOSPATH_H
#define _INLINE_DOSPATH_H

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif /* !__INLINE_MACROS_H */

#ifndef DOSPATH_BASE_NAME
#define DOSPATH_BASE_NAME DOSPathBase
#endif /* !DOSPATH_BASE_NAME */

#define BuildPathListTagList(anchor, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x30, struct PathListEntry *, BuildPathListTagList, struct PathListEntry **, anchor, a0, struct TagItem *, tags, a1, \\
        , DOSPATH_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define BuildPathListTags(a0, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = { tags }; @{"BuildPathListTagList" LINK File 14}((a0), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *)_tags);})
#endif /* !NO_INLINE_STDARG */

#define CopyPathList(orig, anchor) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x2a, struct PathListEntry *, CopyPathList, struct PathListEntry *, orig, a0, struct PathListEntry **, anchor, a1, \\
        , DOSPATH_BASE_NAME)

#define CopyWorkbenchPathList(startup, anchor) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x4e, struct PathListEntry *, CopyWorkbenchPathList, struct WBStartup *, startup, a0, struct PathListEntry **, anchor, a1, \\
        , DOSPATH_BASE_NAME)

#define FindFileInPathList(state, file) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}, @{"FindFileInPathList" LINK File 31}, struct PathListEntry **, state, a0, const char *, file, a1, \\
        , DOSPATH_BASE_NAME)

#define FreePathList(list) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x24, @{"FreePathList" LINK File 35}, struct PathListEntry *, list, a0, \\
        , DOSPATH_BASE_NAME)

#define GetProcessPathList(process) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x42, struct PathListEntry *, GetProcessPathList, struct Process *, process, a0, \\
        , DOSPATH_BASE_NAME)

#define RemoveFromPathList(path, lock) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x3c, struct PathListEntry *, RemoveFromPathList, struct PathListEntry *, path, a0, BPTR, lock, a1, \\
        , DOSPATH_BASE_NAME)

#define SetProcessPathList(process, path) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x48, struct PathListEntry *, SetProcessPathList, struct Process *, process, a0, struct PathListEntry *, path, a1, \\
        , DOSPATH_BASE_NAME)

#endif /* !_INLINE_DOSPATH_H */
@ENDNODE
