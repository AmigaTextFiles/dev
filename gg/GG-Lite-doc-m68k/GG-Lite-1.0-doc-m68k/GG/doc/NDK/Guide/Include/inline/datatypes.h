@DATABASE "gg:doc/NDK/Guide/Include/inline/datatypes.h"
@MASTER   "gg:os-include/inline/datatypes.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:38
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/datatypes.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/datatypes.h" LINK File}


@{b}#defines@{ub}

@{"AddDTObject()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 91}       @{"CLIB_DATATYPES_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 5}  @{"DATATYPES_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 44}
@{"DisposeDTObject()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 69}   @{"DoAsyncLayout()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 108}          @{"DoDTMethod()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 117}
@{"DoDTMethodA()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 112}       @{"DrawDTObject()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 156}           @{"DrawDTObjectA()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 151}
@{"GetDTAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 87}        @{"GetDTAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 82}            @{"GetDTMethods()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 125}
@{"GetDTString()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 164}       @{"GetDTTriggerMethods()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 129}    @{"NewDTObject()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 65}
@{"NewDTObjectA()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 60}      @{"ObtainDataType()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 52}         @{"ObtainDataTypeA()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 47}
@{"ObtainDTDrawInfo()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 147}  @{"ObtainDTDrawInfoA()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 142}      @{"PrintDTObject()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 138}
@{"PrintDTObjectA()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 133}    @{"RefreshDTObject" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 105}          @{"RefreshDTObjectA()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 95}
@{"RefreshDTObjects()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 100}  @{"ReleaseDataType()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 56}        @{"ReleaseDTDrawInfo()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 160}
@{"RemoveDTObject()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 121}    @{"SetDTAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 78}             @{"SetDTAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 73}

@ENDNODE
@NODE File "inline/datatypes.h"
#ifndef _INLINE_DATATYPES_H
#define _INLINE_DATATYPES_H

#ifndef CLIB_DATATYPES_PROTOS_H
#define CLIB_DATATYPES_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif
#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif
#ifndef  INTUITION_CLASSUSR_H
#include <@{"intuition/classusr.h" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File"}>
#endif
#ifndef  INTUITION_GADGETCLASS_H
#include <@{"intuition/gadgetclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  DATATYPES_DATATYPESCLASS_H
#include <@{"datatypes/datatypesclass.h" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File"}>
#endif
#ifndef  DATATYPES_DATATYPES_H
#include <@{"datatypes/datatypes.h" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File"}>
#endif
#ifndef  REXX_STORAGE_H
#include <@{"rexx/storage.h" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File"}>
#endif

#ifndef DATATYPES_BASE_NAME
#define DATATYPES_BASE_NAME DataTypesBase
#endif

#define @{"ObtainDataTypeA" LINK "gg:doc/NDK/Guide/datatypes/ObtainDataTypeA"}(type, handle, attrs) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x24, @{"struct DataType" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 175} *, ObtainDataTypeA, ULONG, type, d0, APTR, handle, a0, struct TagItem *, attrs, a1, \\
        , DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"ObtainDataType" LINK "gg:doc/NDK/Guide/datatypes/ObtainDataTypeA"}(type, handle, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"ObtainDataTypeA" LINK File 47}((type), (handle), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"ReleaseDataType" LINK "gg:doc/NDK/Guide/datatypes/ReleaseDataType"}(dt) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"ReleaseDataType" LINK File 56}, @{"struct DataType" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 175} *, dt, a0, \\
        , DATATYPES_BASE_NAME)

#define @{"NewDTObjectA" LINK "gg:doc/NDK/Guide/datatypes/NewDTObjectA"}(name, attrs) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x30, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, @{"NewDTObjectA" LINK File 60}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, name, d0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, attrs, a0, \\
        , DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"NewDTObject" LINK "gg:doc/NDK/Guide/datatypes/NewDTObjectA"}(name, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"NewDTObjectA" LINK File 60}((name), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"DisposeDTObject" LINK "gg:doc/NDK/Guide/datatypes/DisposeDTObject"}(o) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x36, @{"DisposeDTObject" LINK File 69}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, o, a0, \\
        , @{"DATATYPES_BASE_NAME" LINK File 44})

#define @{"SetDTAttrsA" LINK "gg:doc/NDK/Guide/datatypes/SetDTAttrsA"}(o, win, req, attrs) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x3c, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"SetDTAttrsA" LINK File 73}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, o, a0, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *, win, a1, struct Requester *, req, a2, struct TagItem *, attrs, a3, \\
        , DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetDTAttrs" LINK "gg:doc/NDK/Guide/datatypes/SetDTAttrsA"}(o, win, req, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetDTAttrsA" LINK File 73}((o), (win), (req), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"GetDTAttrsA" LINK "gg:doc/NDK/Guide/datatypes/GetDTAttrsA"}(o, attrs) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x42, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"GetDTAttrsA" LINK File 82}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, o, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, attrs, a2, \\
        , DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetDTAttrs" LINK "gg:doc/NDK/Guide/datatypes/GetDTAttrsA"}(o, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetDTAttrsA" LINK File 82}((o), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"AddDTObject" LINK "gg:doc/NDK/Guide/datatypes/AddDTObject"}(win, req, o, pos) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x48, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"AddDTObject" LINK File 91}, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *, win, a0, struct Requester *, req, a1, Object *, o, a2, LONG, pos, d0, \\
        , DATATYPES_BASE_NAME)

#define @{"RefreshDTObjectA" LINK "gg:doc/NDK/Guide/datatypes/RefreshDTObjectA"}(o, win, req, attrs) \\
        @{"LP4NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 386}(0x4e, @{"RefreshDTObjectA" LINK File 95}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, o, a0, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *, win, a1, struct Requester *, req, a2, struct TagItem *, attrs, a3, \\
        , DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define RefreshDTObjects(o, win, req, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"RefreshDTObjectA" LINK File 95}((o), (win), (req), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#ifndef NO_INLINE_STDARG
#define @{"RefreshDTObject" LINK "gg:doc/NDK/Guide/datatypes/RefreshDTObjectA"} @{"RefreshDTObjects" LINK File 100}
#endif

#define @{"DoAsyncLayout" LINK "gg:doc/NDK/Guide/datatypes/DoAsyncLayout"}(o, gpl) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x54, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"DoAsyncLayout" LINK File 108}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, o, a0, @{"struct gpLayout" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 460} *, gpl, a1, \\
        , DATATYPES_BASE_NAME)

#define @{"DoDTMethodA" LINK "gg:doc/NDK/Guide/datatypes/DoDTMethodA"}(o, win, req, msg) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x5a, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"DoDTMethodA" LINK File 112}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, o, a0, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *, win, a1, struct Requester *, req, a2, Msg, msg, a3, \\
        , DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"DoDTMethod" LINK "gg:doc/NDK/Guide/datatypes/DoDTMethodA"}(o, win, req, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"DoDTMethodA" LINK File 112}((o), (win), (req), (@{"Msg" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 29}) _tags);})
#endif

#define @{"RemoveDTObject" LINK "gg:doc/NDK/Guide/datatypes/RemoveDTObject"}(win, o) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x60, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"RemoveDTObject" LINK File 121}, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *, win, a0, Object *, o, a1, \\
        , DATATYPES_BASE_NAME)

#define @{"GetDTMethods" LINK "gg:doc/NDK/Guide/datatypes/GetDTMethods"}(object) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x66, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *, @{"GetDTMethods" LINK File 125}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, object, a0, \\
        , @{"DATATYPES_BASE_NAME" LINK File 44})

#define @{"GetDTTriggerMethods" LINK "gg:doc/NDK/Guide/datatypes/GetDTTriggerMethods"}(object) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x6c, struct DTMethods *, GetDTTriggerMethods, Object *, object, a0, \\
        , DATATYPES_BASE_NAME)

#define @{"PrintDTObjectA" LINK "gg:doc/NDK/Guide/datatypes/PrintDTObjectA"}(o, w, r, msg) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x72, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"PrintDTObjectA" LINK File 133}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, o, a0, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *, w, a1, struct Requester *, r, a2, struct dtPrint *, msg, a3, \\
        , DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"PrintDTObject" LINK "gg:doc/NDK/Guide/datatypes/PrintDTObjectA"}(o, w, r, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"PrintDTObjectA" LINK File 133}((o), (w), (r), (@{"struct dtPrint" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 421} *) _tags);})
#endif

#define @{"ObtainDTDrawInfoA" LINK "gg:doc/NDK/Guide/datatypes/ObtainDTDrawInfoA"}(o, attrs) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x78, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"ObtainDTDrawInfoA" LINK File 142}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, o, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, attrs, a1, \\
        , DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"ObtainDTDrawInfo" LINK "gg:doc/NDK/Guide/datatypes/ObtainDTDrawInfoA"}(o, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"ObtainDTDrawInfoA" LINK File 142}((o), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"DrawDTObjectA" LINK "gg:doc/NDK/Guide/datatypes/DrawDTObjectA"}(rp, o, x, y, w, h, th, tv, attrs) \\
        @{"LP9" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 755}(0x7e, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"DrawDTObjectA" LINK File 151}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, rp, a0, Object *, o, a1, LONG, x, d0, LONG, y, d1, LONG, w, d2, LONG, h, d3, LONG, th, d4, LONG, tv, d5, struct TagItem *, attrs, a2, \\
        , DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"DrawDTObject" LINK "gg:doc/NDK/Guide/datatypes/DrawDTObjectA"}(rp, o, x, y, w, h, th, tv, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"DrawDTObjectA" LINK File 151}((rp), (o), (x), (y), (w), (h), (th), (tv), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"ReleaseDTDrawInfo" LINK "gg:doc/NDK/Guide/datatypes/ReleaseDTDrawInfo"}(o, handle) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x84, @{"ReleaseDTDrawInfo" LINK File 160}, @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *, o, a0, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, handle, a1, \\
        , @{"DATATYPES_BASE_NAME" LINK File 44})

#define @{"GetDTString" LINK "gg:doc/NDK/Guide/datatypes/GetDTString"}(id) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x8a, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, @{"GetDTString" LINK File 164}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, id, d0, \\
        , @{"DATATYPES_BASE_NAME" LINK File 44})

#endif /*  _INLINE_DATATYPES_H  */
@ENDNODE
