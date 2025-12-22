@DATABASE "gg:doc/NDK/Guide/Include/clib/datatypes_protos.h"
@MASTER   "gg:os-include/clib/datatypes_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:34
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/datatypes_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/datatypes_protos.h" LINK File}

@ENDNODE
@NODE File "clib/datatypes_protos.h"
#ifndef  CLIB_DATATYPES_PROTOS_H
#define  CLIB_DATATYPES_PROTOS_H

/*
**      $VER: datatypes_protos.h 44.2 (21.4.1999)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

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
/*--- functions in V40 or higher (Release 3.1) ---*/

/* Public entries */

@{"struct DataType" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 175} *ObtainDataTypeA( ULONG type, APTR handle, struct TagItem *attrs );
@{"struct DataType" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 175} *ObtainDataType( ULONG type, APTR handle, Tag tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleaseDataType" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 56}( @{"struct DataType" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 175} *dt );
@{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *@{"NewDTObjectA" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 60}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} name, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *attrs );
@{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *@{"NewDTObject" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 65}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} name, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisposeDTObject" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 69}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetDTAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 73}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, struct Requester *req, struct TagItem *attrs );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetDTAttrs" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 78}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, struct Requester *req, Tag tag1, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetDTAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 82}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *attrs );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetDTAttrs" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 87}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AddDTObject" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 91}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, struct Requester *req, Object *o, LONG pos );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RefreshDTObjectA" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 95}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, struct Requester *req, struct TagItem *attrs );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RefreshDTObjects" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 100}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, struct Requester *req, Tag tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RefreshDTObject" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 105}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, struct Requester *req, Tag tag1, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"DoAsyncLayout" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 108}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct gpLayout" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 460} *gpl );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"DoDTMethodA" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 112}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, struct Requester *req, Msg msg );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"DoDTMethod" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 117}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, struct Requester *req, ULONG data, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RemoveDTObject" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 121}( @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *win, Object *o );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *@{"GetDTMethods" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 125}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *object );
struct DTMethods *GetDTTriggerMethods( Object *object );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"PrintDTObjectA" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 133}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *w, struct Requester *r, struct dtPrint *msg );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"PrintDTObject" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 138}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *w, struct Requester *r, ULONG data, ... );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"ObtainDTDrawInfoA" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 142}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *attrs );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"ObtainDTDrawInfo" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 147}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DrawDTObjectA" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 151}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, Object *o, LONG x, LONG y, LONG w, LONG h, LONG th, LONG tv, struct TagItem *attrs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DrawDTObject" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 156}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, Object *o, LONG x, LONG y, LONG w, LONG h, LONG th, LONG tv, Tag tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleaseDTDrawInfo" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 160}( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} handle );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"GetDTString" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File" 164}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} id );
/* Just in case, make sure we reserve space for @{"datatypes.library" LINK "gg:doc/NDK/Guide/datatypes/MAIN"} V45 */

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_DATATYPES_PROTOS_H */
@ENDNODE
