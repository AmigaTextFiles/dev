@DATABASE "gg:doc/NDK/Guide/Include/inline/amigaguide.h"
@MASTER   "gg:os-include/inline/amigaguide.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:25
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/amigaguide.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/amigaguide.h" LINK File}


@{b}#defines@{ub}

@{"AddAmigaGuideHost()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 133}       @{"AddAmigaGuideHostA()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 128}
@{"AMIGAGUIDE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 35}      @{"AmigaGuideSignal()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 68}
@{"CLIB_AMIGAGUIDE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 5}  @{"CloseAmigaGuide()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 64}
@{"ExpungeXRef()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 124}             @{"GetAmigaGuideAttr()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 116}
@{"GetAmigaGuideMsg()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 72}        @{"GetAmigaGuideString()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 146}
@{"LoadXRef()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 120}                @{"LockAmigaGuideBase()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 38}
@{"OpenAmigaGuide()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 51}          @{"OpenAmigaGuideA()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 46}
@{"OpenAmigaGuideAsync()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 60}     @{"OpenAmigaGuideAsyncA()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 55}
@{"RemoveAmigaGuideHost()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 142}    @{"RemoveAmigaGuideHostA()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 137}
@{"ReplyAmigaGuideMsg()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 76}      @{"SendAmigaGuideCmd()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 103}
@{"SendAmigaGuideCmdA()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 98}      @{"SendAmigaGuideContext()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 94}
@{"SendAmigaGuideContextA()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 89}  @{"SetAmigaGuideAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 112}
@{"SetAmigaGuideAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 107}     @{"SetAmigaGuideContext()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 85}
@{"SetAmigaGuideContextA()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 80}   @{"UnlockAmigaGuideBase()" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 42}

@ENDNODE
@NODE File "inline/amigaguide.h"
#ifndef _INLINE_AMIGAGUIDE_H
#define _INLINE_AMIGAGUIDE_H

#ifndef CLIB_AMIGAGUIDE_PROTOS_H
#define CLIB_AMIGAGUIDE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif
#ifndef  DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif
#ifndef  LIBRARIES_AMIGAGUIDE_H
#include <@{"libraries/amigaguide.h" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif
#ifndef  REXX_STORAGE_H
#include <@{"rexx/storage.h" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File"}>
#endif

#ifndef AMIGAGUIDE_BASE_NAME
#define AMIGAGUIDE_BASE_NAME AmigaGuideBase
#endif

#define @{"LockAmigaGuideBase" LINK "gg:doc/NDK/Guide/amigaguide/LockAmigaGuideBase"}(handle) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x24, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"LockAmigaGuideBase" LINK File 38}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, handle, a0, \\
        , @{"AMIGAGUIDE_BASE_NAME" LINK File 35})

#define @{"UnlockAmigaGuideBase" LINK "gg:doc/NDK/Guide/amigaguide/UnlockAmigaGuideBase"}(key) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"UnlockAmigaGuideBase" LINK File 42}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, key, d0, \\
        , @{"AMIGAGUIDE_BASE_NAME" LINK File 35})

#define @{"OpenAmigaGuideA" LINK "gg:doc/NDK/Guide/amigaguide/OpenAmigaGuideA"}(nag, tags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"OpenAmigaGuideA" LINK File 46}, @{"struct NewAmigaGuide" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 103} *, nag, a0, struct TagItem *, tags, a1, \\
        , AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"OpenAmigaGuide" LINK "gg:doc/NDK/Guide/amigaguide/OpenAmigaGuideA"}(nag, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"OpenAmigaGuideA" LINK File 46}((nag), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"OpenAmigaGuideAsyncA" LINK "gg:doc/NDK/Guide/amigaguide/OpenAmigaGuideAsyncA"}(nag, attrs) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x3c, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"OpenAmigaGuideAsyncA" LINK File 55}, @{"struct NewAmigaGuide" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 103} *, nag, a0, struct TagItem *, attrs, d0, \\
        , AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"OpenAmigaGuideAsync" LINK "gg:doc/NDK/Guide/amigaguide/OpenAmigaGuideAsyncA"}(nag, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"OpenAmigaGuideAsyncA" LINK File 55}((nag), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"CloseAmigaGuide" LINK "gg:doc/NDK/Guide/amigaguide/CloseAmigaGuide"}(cl) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x42, @{"CloseAmigaGuide" LINK File 64}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, cl, a0, \\
        , @{"AMIGAGUIDE_BASE_NAME" LINK File 35})

#define @{"AmigaGuideSignal" LINK "gg:doc/NDK/Guide/amigaguide/AmigaGuideSignal"}(cl) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x48, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"AmigaGuideSignal" LINK File 68}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, cl, a0, \\
        , @{"AMIGAGUIDE_BASE_NAME" LINK File 35})

#define @{"GetAmigaGuideMsg" LINK "gg:doc/NDK/Guide/amigaguide/GetAmigaGuideMsg"}(cl) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x4e, @{"struct AmigaGuideMsg" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 89} *, GetAmigaGuideMsg, APTR, cl, a0, \\
        , AMIGAGUIDE_BASE_NAME)

#define @{"ReplyAmigaGuideMsg" LINK "gg:doc/NDK/Guide/amigaguide/ReplyAmigaGuideMsg"}(amsg) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x54, @{"ReplyAmigaGuideMsg" LINK File 76}, @{"struct AmigaGuideMsg" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 89} *, amsg, a0, \\
        , AMIGAGUIDE_BASE_NAME)

#define @{"SetAmigaGuideContextA" LINK "gg:doc/NDK/Guide/amigaguide/SetAmigaGuideContextA"}(cl, id, attrs) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x5a, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SetAmigaGuideContextA" LINK File 80}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, cl, a0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, id, d0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, attrs, d1, \\
        , AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetAmigaGuideContext" LINK "gg:doc/NDK/Guide/amigaguide/SetAmigaGuideContextA"}(cl, id, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetAmigaGuideContextA" LINK File 80}((cl), (id), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"SendAmigaGuideContextA" LINK "gg:doc/NDK/Guide/amigaguide/SendAmigaGuideContextA"}(cl, attrs) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x60, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SendAmigaGuideContextA" LINK File 89}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, cl, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, attrs, d0, \\
        , AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SendAmigaGuideContext" LINK "gg:doc/NDK/Guide/amigaguide/SendAmigaGuideContextA"}(cl, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SendAmigaGuideContextA" LINK File 89}((cl), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"SendAmigaGuideCmdA" LINK "gg:doc/NDK/Guide/amigaguide/SendAmigaGuideCmdA"}(cl, cmd, attrs) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x66, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SendAmigaGuideCmdA" LINK File 98}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, cl, a0, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, cmd, d0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, attrs, d1, \\
        , AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SendAmigaGuideCmd(cl, cmd, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SendAmigaGuideCmdA" LINK File 98}((cl), (cmd), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"SetAmigaGuideAttrsA" LINK "gg:doc/NDK/Guide/amigaguide/SetAmigaGuideAttrsA"}(cl, attrs) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x6c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SetAmigaGuideAttrsA" LINK File 107}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, cl, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, attrs, a1, \\
        , AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetAmigaGuideAttrs" LINK "gg:doc/NDK/Guide/amigaguide/SetAmigaGuideAttrsA"}(cl, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetAmigaGuideAttrsA" LINK File 107}((cl), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetAmigaGuideAttr" LINK "gg:doc/NDK/Guide/amigaguide/GetAmigaGuideAttr"}(d0arg, cl, storage) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x72, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"GetAmigaGuideAttr" LINK File 116}, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30}, d0arg, d0, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, cl, a0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *, storage, a1, \\
        , @{"AMIGAGUIDE_BASE_NAME" LINK File 35})

#define LoadXRef(lock, name) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x7e, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"LoadXRef" LINK File 120}, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}, lock, a0, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, name, a1, \\
        , @{"AMIGAGUIDE_BASE_NAME" LINK File 35})

#define ExpungeXRef() \\
        @{"LP0NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 41}(0x84, @{"ExpungeXRef" LINK File 124}, \\
        , @{"AMIGAGUIDE_BASE_NAME" LINK File 35})

#define @{"AddAmigaGuideHostA" LINK "gg:doc/NDK/Guide/amigaguide/AddAmigaGuideHostA"}(h, name, attrs) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x8a, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"AddAmigaGuideHostA" LINK File 128}, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, h, a0, STRPTR, name, d0, struct TagItem *, attrs, a1, \\
        , AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AddAmigaGuideHost(h, name, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AddAmigaGuideHostA" LINK File 128}((h), (name), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"RemoveAmigaGuideHostA" LINK "gg:doc/NDK/Guide/amigaguide/RemoveAmigaGuideHostA"}(hh, attrs) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x90, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"RemoveAmigaGuideHostA" LINK File 137}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, hh, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, attrs, a1, \\
        , AMIGAGUIDE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"RemoveAmigaGuideHost" LINK "gg:doc/NDK/Guide/amigaguide/RemoveAmigaGuideHostA"}(hh, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"RemoveAmigaGuideHostA" LINK File 137}((hh), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetAmigaGuideString" LINK "gg:doc/NDK/Guide/amigaguide/GetAmigaGuideString"}(id) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xd2, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, @{"GetAmigaGuideString" LINK File 146}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, id, d0, \\
        , @{"AMIGAGUIDE_BASE_NAME" LINK File 35})

#endif /*  _INLINE_AMIGAGUIDE_H  */
@ENDNODE
