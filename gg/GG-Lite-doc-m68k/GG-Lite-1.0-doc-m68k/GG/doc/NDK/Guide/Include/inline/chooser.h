@DATABASE "gg:doc/NDK/Guide/Include/inline/chooser.h"
@MASTER   "gg:os-include/inline/chooser.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:33
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/chooser.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/chooser.h" LINK File}


@{b}#defines@{ub}

@{"AllocChooserNode()" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 32}      @{"AllocChooserNodeA()" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 27}     @{"CHOOSER_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 20}
@{"CHOOSER_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 23}      @{"CLIB_CHOOSER_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 5}   @{"FreeChooserNode()" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 36}
@{"GetChooserNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 54}   @{"GetChooserNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 49}  @{"SetChooserNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 45}
@{"SetChooserNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File" 40}  

@ENDNODE
@NODE File "inline/chooser.h"
#ifndef _INLINE_CHOOSER_H
#define _INLINE_CHOOSER_H

#ifndef CLIB_CHOOSER_PROTOS_H
#define CLIB_CHOOSER_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif

#ifndef CHOOSER_BASE_NAME
#define CHOOSER_BASE_NAME ChooserBase
#endif

#define @{"CHOOSER_GetClass()" LINK "gg:doc/NDK/Guide/chooser_gc/CHOOSER_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"CHOOSER_GetClass" LINK File 23}, \\
        , @{"CHOOSER_BASE_NAME" LINK File 20})

#define @{"AllocChooserNodeA" LINK "gg:doc/NDK/Guide/chooser_gc/AllocChooserNodeA"}(tags) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x24, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, AllocChooserNodeA, struct TagItem *, tags, a0, \\
        , CHOOSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AllocChooserNode" LINK "gg:doc/NDK/Guide/chooser_gc/AllocChooserNodeA"}(tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocChooserNodeA" LINK File 27}((@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"FreeChooserNode" LINK "gg:doc/NDK/Guide/chooser_gc/FreeChooserNode"}(node) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"FreeChooserNode" LINK File 36}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, \\
        , CHOOSER_BASE_NAME)

#define @{"SetChooserNodeAttrsA" LINK "gg:doc/NDK/Guide/chooser_gc/SetChooserNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x30, @{"SetChooserNodeAttrsA" LINK File 40}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , CHOOSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetChooserNodeAttrs" LINK "gg:doc/NDK/Guide/chooser_gc/SetChooserNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetChooserNodeAttrsA" LINK File 40}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetChooserNodeAttrsA" LINK "gg:doc/NDK/Guide/chooser_gc/GetChooserNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x36, @{"GetChooserNodeAttrsA" LINK File 49}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , CHOOSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetChooserNodeAttrs" LINK "gg:doc/NDK/Guide/chooser_gc/GetChooserNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetChooserNodeAttrsA" LINK File 49}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_CHOOSER_H  */
@ENDNODE
