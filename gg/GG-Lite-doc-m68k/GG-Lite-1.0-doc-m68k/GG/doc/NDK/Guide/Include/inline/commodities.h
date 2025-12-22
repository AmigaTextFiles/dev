@DATABASE "gg:doc/NDK/Guide/Include/inline/commodities.h"
@MASTER   "gg:os-include/inline/commodities.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:35
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/commodities.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/commodities.h" LINK File}


@{b}#defines@{ub}

@{"ActivateCxObj()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 40}    @{"AddIEvents()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 128}               @{"AttachCxObj()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 68}
@{"ClearCxObjError()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 60}  @{"CLIB_COMMODITIES_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 5}  @{"COMMODITIES_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 29}
@{"CreateCxObj()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 32}      @{"CxBroker()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 36}                 @{"CxMsgData()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 104}
@{"CxMsgID()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 108}          @{"CxMsgType()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 100}                @{"CxObjError()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 56}
@{"CxObjType()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 52}        @{"DeleteCxObj()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 44}              @{"DeleteCxObjAll()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 48}
@{"DisposeCxMsg()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 120}     @{"DivertCxMsg()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 112}              @{"EnqueueCxObj()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 72}
@{"InsertCxObj()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 76}      @{"InvertKeyMap()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 124}             @{"MatchIX()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 132}
@{"ParseIX()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 96}          @{"RemoveCxObj()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 80}              @{"RouteCxMsg()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 116}
@{"SetCxObjPri()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 64}      @{"SetFilter()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 88}                @{"SetFilterIX()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 92}
@{"SetTranslate()" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 84}     

@ENDNODE
@NODE File "inline/commodities.h"
#ifndef _INLINE_COMMODITIES_H
#define _INLINE_COMMODITIES_H

#ifndef CLIB_COMMODITIES_PROTOS_H
#define CLIB_COMMODITIES_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif
#ifndef  LIBRARIES_COMMODITIES_H
#include <@{"libraries/commodities.h" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File"}>
#endif
#ifndef  DEVICES_INPUTEVENT_H
#include <@{"devices/inputevent.h" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File"}>
#endif
#ifndef  DEVICES_KEYMAP_H
#include <@{"devices/keymap.h" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File"}>
#endif

#ifndef COMMODITIES_BASE_NAME
#define COMMODITIES_BASE_NAME CxBase
#endif

#define @{"CreateCxObj" LINK "gg:doc/NDK/Guide/commodities/CreateCxObj"}(type, arg1, arg2) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x1e, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, @{"CreateCxObj" LINK File 32}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, type, d0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, arg1, a0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, arg2, a1, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"CxBroker" LINK "gg:doc/NDK/Guide/commodities/CxBroker"}(nb, error) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x24, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, @{"CxBroker" LINK File 36}, const @{"struct NewBroker" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 40} *, nb, a0, LONG *, error, d0, \\
        , COMMODITIES_BASE_NAME)

#define @{"ActivateCxObj" LINK "gg:doc/NDK/Guide/commodities/ActivateCxObj"}(co, doIt) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x2a, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"ActivateCxObj" LINK File 40}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, doIt, d0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"DeleteCxObj" LINK "gg:doc/NDK/Guide/commodities/DeleteCxObj"}(co) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x30, @{"DeleteCxObj" LINK File 44}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"DeleteCxObjAll" LINK "gg:doc/NDK/Guide/commodities/DeleteCxObjAll"}(co) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x36, @{"DeleteCxObjAll" LINK File 48}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"CxObjType" LINK "gg:doc/NDK/Guide/commodities/CxObjType"}(co) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x3c, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"CxObjType" LINK File 52}, const @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"CxObjError" LINK "gg:doc/NDK/Guide/commodities/CxObjError"}(co) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x42, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"CxObjError" LINK File 56}, const @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"ClearCxObjError" LINK "gg:doc/NDK/Guide/commodities/ClearCxObjError"}(co) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x48, @{"ClearCxObjError" LINK File 60}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"SetCxObjPri" LINK "gg:doc/NDK/Guide/commodities/SetCxObjPri"}(co, pri) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x4e, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SetCxObjPri" LINK File 64}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, pri, d0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"AttachCxObj" LINK "gg:doc/NDK/Guide/commodities/AttachCxObj"}(headObj, co) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x54, @{"AttachCxObj" LINK File 68}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, headObj, a0, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a1, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"EnqueueCxObj" LINK "gg:doc/NDK/Guide/commodities/EnqueueCxObj"}(headObj, co) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x5a, @{"EnqueueCxObj" LINK File 72}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, headObj, a0, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a1, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"InsertCxObj" LINK "gg:doc/NDK/Guide/commodities/InsertCxObj"}(headObj, co, pred) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0x60, @{"InsertCxObj" LINK File 76}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, headObj, a0, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a1, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, pred, a2, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"RemoveCxObj" LINK "gg:doc/NDK/Guide/commodities/RemoveCxObj"}(co) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x66, @{"RemoveCxObj" LINK File 80}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"SetTranslate" LINK "gg:doc/NDK/Guide/commodities/SetTranslate"}(translator, events) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x72, @{"SetTranslate" LINK File 84}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, translator, a0, @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *, events, a1, \\
        , COMMODITIES_BASE_NAME)

#define @{"SetFilter" LINK "gg:doc/NDK/Guide/commodities/SetFilter"}(filter, text) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x78, @{"SetFilter" LINK File 88}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, filter, a0, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, text, a1, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"SetFilterIX" LINK "gg:doc/NDK/Guide/commodities/SetFilterIX"}(filter, ix) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x7e, @{"SetFilterIX" LINK File 92}, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, filter, a0, const @{"IX" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 157} *, ix, a1, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"ParseIX" LINK "gg:doc/NDK/Guide/commodities/ParseIX"}(description, ix) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x84, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"ParseIX" LINK File 96}, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, description, a0, @{"IX" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 157} *, ix, a1, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"CxMsgType" LINK "gg:doc/NDK/Guide/commodities/CxMsgType"}(cxm) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x8a, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"CxMsgType" LINK File 100}, const @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *, cxm, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"CxMsgData" LINK "gg:doc/NDK/Guide/commodities/CxMsgData"}(cxm) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x90, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"CxMsgData" LINK File 104}, const @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *, cxm, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"CxMsgID" LINK "gg:doc/NDK/Guide/commodities/CxMsgID"}(cxm) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x96, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"CxMsgID" LINK File 108}, const @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *, cxm, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"DivertCxMsg" LINK "gg:doc/NDK/Guide/commodities/DivertCxMsg"}(cxm, headObj, returnObj) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0x9c, @{"DivertCxMsg" LINK File 112}, @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *, cxm, a0, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, headObj, a1, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, returnObj, a2, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"RouteCxMsg" LINK "gg:doc/NDK/Guide/commodities/RouteCxMsg"}(cxm, co) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0xa2, @{"RouteCxMsg" LINK File 116}, @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *, cxm, a0, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *, co, a1, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"DisposeCxMsg" LINK "gg:doc/NDK/Guide/commodities/DisposeCxMsg"}(cxm) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xa8, @{"DisposeCxMsg" LINK File 120}, @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *, cxm, a0, \\
        , @{"COMMODITIES_BASE_NAME" LINK File 29})

#define @{"InvertKeyMap" LINK "gg:doc/NDK/Guide/commodities/InvertKeyMap"}(ansiCode, event, km) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xae, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"InvertKeyMap" LINK File 124}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, ansiCode, d0, @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *, event, a0, const struct KeyMap *, km, a1, \\
        , COMMODITIES_BASE_NAME)

#define @{"AddIEvents" LINK "gg:doc/NDK/Guide/commodities/AddIEvents"}(events) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xb4, @{"AddIEvents" LINK File 128}, @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *, events, a0, \\
        , COMMODITIES_BASE_NAME)

#define @{"MatchIX" LINK "gg:doc/NDK/Guide/commodities/MatchIX"}(event, ix) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xcc, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"MatchIX" LINK File 132}, const @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *, event, a0, const IX *, ix, a1, \\
        , COMMODITIES_BASE_NAME)

#endif /*  _INLINE_COMMODITIES_H  */
@ENDNODE
