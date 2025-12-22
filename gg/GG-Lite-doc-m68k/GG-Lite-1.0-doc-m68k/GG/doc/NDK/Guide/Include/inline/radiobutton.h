@DATABASE "gg:doc/NDK/Guide/Include/inline/radiobutton.h"
@MASTER   "gg:os-include/inline/radiobutton.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/radiobutton.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/radiobutton.h" LINK File}


@{b}#defines@{ub}

@{"AllocRadioButtonNode()" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 32}     @{"AllocRadioButtonNodeA()" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 27}
@{"CLIB_RADIOBUTTON_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 5}  @{"FreeRadioButtonNode()" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 36}
@{"GetRadioButtonNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 54}  @{"GetRadioButtonNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 49}
@{"RADIOBUTTON_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 20}      @{"RADIOBUTTON_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 23}
@{"SetRadioButtonNodeAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 45}  @{"SetRadioButtonNodeAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/radiobutton.h/File" 40}

@ENDNODE
@NODE File "inline/radiobutton.h"
#ifndef _INLINE_RADIOBUTTON_H
#define _INLINE_RADIOBUTTON_H

#ifndef CLIB_RADIOBUTTON_PROTOS_H
#define CLIB_RADIOBUTTON_PROTOS_H
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

#ifndef RADIOBUTTON_BASE_NAME
#define RADIOBUTTON_BASE_NAME RadioButtonBase
#endif

#define @{"RADIOBUTTON_GetClass()" LINK "gg:doc/NDK/Guide/radiobutton_gc/RADIOBUTTON_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"RADIOBUTTON_GetClass" LINK File 23}, \\
        , @{"RADIOBUTTON_BASE_NAME" LINK File 20})

#define @{"AllocRadioButtonNodeA" LINK "gg:doc/NDK/Guide/radiobutton_gc/AllocRadioButtonNodeA"}(columns, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x24, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, AllocRadioButtonNodeA, ULONG, columns, d0, struct TagItem *, tags, a0, \\
        , RADIOBUTTON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AllocRadioButtonNode" LINK "gg:doc/NDK/Guide/radiobutton_gc/AllocRadioButtonNodeA"}(columns, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocRadioButtonNodeA" LINK File 27}((columns), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"FreeRadioButtonNode" LINK "gg:doc/NDK/Guide/radiobutton_gc/FreeRadioButtonNode"}(node) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"FreeRadioButtonNode" LINK File 36}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, \\
        , RADIOBUTTON_BASE_NAME)

#define @{"SetRadioButtonNodeAttrsA" LINK "gg:doc/NDK/Guide/radiobutton_gc/SetRadioButtonNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x30, @{"SetRadioButtonNodeAttrsA" LINK File 40}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , RADIOBUTTON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetRadioButtonNodeAttrs" LINK "gg:doc/NDK/Guide/radiobutton_gc/SetRadioButtonNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetRadioButtonNodeAttrsA" LINK File 40}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetRadioButtonNodeAttrsA" LINK "gg:doc/NDK/Guide/radiobutton_gc/GetRadioButtonNodeAttrsA"}(node, tags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x36, @{"GetRadioButtonNodeAttrsA" LINK File 49}, @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *, node, a0, struct TagItem *, tags, a1, \\
        , RADIOBUTTON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetRadioButtonNodeAttrs" LINK "gg:doc/NDK/Guide/radiobutton_gc/GetRadioButtonNodeAttrsA"}(node, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetRadioButtonNodeAttrsA" LINK File 49}((node), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_RADIOBUTTON_H  */
@ENDNODE
