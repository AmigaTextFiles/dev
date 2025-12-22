#ifndef _INLINE_DATATYPES_H
#define _INLINE_DATATYPES_H

#ifndef CLIB_DATATYPES_PROTOS_H
#define CLIB_DATATYPES_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  EXEC_LISTS_H
#include <exec/lists.h>
#endif
#ifndef  INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef  INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif
#ifndef  INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif
#ifndef  INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  DATATYPES_DATATYPESCLASS_H
#include <datatypes/datatypesclass.h>
#endif
#ifndef  DATATYPES_DATATYPES_H
#include <datatypes/datatypes.h>
#endif
#ifndef  REXX_STORAGE_H
#include <rexx/storage.h>
#endif

#ifndef DATATYPES_BASE_NAME
#define DATATYPES_BASE_NAME DataTypesBase
#endif

#define ObtainDataTypeA(type, handle, attrs) \
	LP3(0x24, struct DataType *, ObtainDataTypeA, ULONG, type, d0, APTR, handle, a0, struct TagItem *, attrs, a1, \
	, DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define ObtainDataType(type, handle, tags...) \
	({ULONG _tags[] = {tags}; ObtainDataTypeA((type), (handle), (struct TagItem *) _tags);})
#endif

#define ReleaseDataType(dt) \
	LP1NR(0x2a, ReleaseDataType, struct DataType *, dt, a0, \
	, DATATYPES_BASE_NAME)

#define NewDTObjectA(name, attrs) \
	LP2(0x30, Object *, NewDTObjectA, APTR, name, d0, struct TagItem *, attrs, a0, \
	, DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define NewDTObject(name, tags...) \
	({ULONG _tags[] = {tags}; NewDTObjectA((name), (struct TagItem *) _tags);})
#endif

#define DisposeDTObject(o) \
	LP1NR(0x36, DisposeDTObject, Object *, o, a0, \
	, DATATYPES_BASE_NAME)

#define SetDTAttrsA(o, win, req, attrs) \
	LP4(0x3c, ULONG, SetDTAttrsA, Object *, o, a0, struct Window *, win, a1, struct Requester *, req, a2, struct TagItem *, attrs, a3, \
	, DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetDTAttrs(o, win, req, tags...) \
	({ULONG _tags[] = {tags}; SetDTAttrsA((o), (win), (req), (struct TagItem *) _tags);})
#endif

#define GetDTAttrsA(o, attrs) \
	LP2(0x42, ULONG, GetDTAttrsA, Object *, o, a0, struct TagItem *, attrs, a2, \
	, DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetDTAttrs(o, tags...) \
	({ULONG _tags[] = {tags}; GetDTAttrsA((o), (struct TagItem *) _tags);})
#endif

#define AddDTObject(win, req, o, pos) \
	LP4(0x48, LONG, AddDTObject, struct Window *, win, a0, struct Requester *, req, a1, Object *, o, a2, LONG, pos, d0, \
	, DATATYPES_BASE_NAME)

#define RefreshDTObjectA(o, win, req, attrs) \
	LP4NR(0x4e, RefreshDTObjectA, Object *, o, a0, struct Window *, win, a1, struct Requester *, req, a2, struct TagItem *, attrs, a3, \
	, DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define RefreshDTObjects(o, win, req, tags...) \
	({ULONG _tags[] = {tags}; RefreshDTObjectA((o), (win), (req), (struct TagItem *) _tags);})
#endif

#ifndef NO_INLINE_STDARG
#define RefreshDTObject RefreshDTObjects
#endif

#define DoAsyncLayout(o, gpl) \
	LP2(0x54, ULONG, DoAsyncLayout, Object *, o, a0, struct gpLayout *, gpl, a1, \
	, DATATYPES_BASE_NAME)

#define DoDTMethodA(o, win, req, msg) \
	LP4(0x5a, ULONG, DoDTMethodA, Object *, o, a0, struct Window *, win, a1, struct Requester *, req, a2, Msg, msg, a3, \
	, DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define DoDTMethod(o, win, req, tags...) \
	({ULONG _tags[] = {tags}; DoDTMethodA((o), (win), (req), (Msg) _tags);})
#endif

#define RemoveDTObject(win, o) \
	LP2(0x60, LONG, RemoveDTObject, struct Window *, win, a0, Object *, o, a1, \
	, DATATYPES_BASE_NAME)

#define GetDTMethods(object) \
	LP1(0x66, ULONG *, GetDTMethods, Object *, object, a0, \
	, DATATYPES_BASE_NAME)

#define GetDTTriggerMethods(object) \
	LP1(0x6c, struct DTMethods *, GetDTTriggerMethods, Object *, object, a0, \
	, DATATYPES_BASE_NAME)

#define PrintDTObjectA(o, w, r, msg) \
	LP4(0x72, ULONG, PrintDTObjectA, Object *, o, a0, struct Window *, w, a1, struct Requester *, r, a2, struct dtPrint *, msg, a3, \
	, DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define PrintDTObject(o, w, r, tags...) \
	({ULONG _tags[] = {tags}; PrintDTObjectA((o), (w), (r), (struct dtPrint *) _tags);})
#endif

#define ObtainDTDrawInfoA(o, attrs) \
	LP2(0x78, APTR, ObtainDTDrawInfoA, Object *, o, a0, struct TagItem *, attrs, a1, \
	, DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define ObtainDTDrawInfo(o, tags...) \
	({ULONG _tags[] = {tags}; ObtainDTDrawInfoA((o), (struct TagItem *) _tags);})
#endif

#define DrawDTObjectA(rp, o, x, y, w, h, th, tv, attrs) \
	LP9(0x7e, LONG, DrawDTObjectA, struct RastPort *, rp, a0, Object *, o, a1, LONG, x, d0, LONG, y, d1, LONG, w, d2, LONG, h, d3, LONG, th, d4, LONG, tv, d5, struct TagItem *, attrs, a2, \
	, DATATYPES_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define DrawDTObject(rp, o, x, y, w, h, th, tv, tags...) \
	({ULONG _tags[] = {tags}; DrawDTObjectA((rp), (o), (x), (y), (w), (h), (th), (tv), (struct TagItem *) _tags);})
#endif

#define ReleaseDTDrawInfo(o, handle) \
	LP2NR(0x84, ReleaseDTDrawInfo, Object *, o, a0, APTR, handle, a1, \
	, DATATYPES_BASE_NAME)

#define GetDTString(id) \
	LP1(0x8a, STRPTR, GetDTString, ULONG, id, d0, \
	, DATATYPES_BASE_NAME)

#endif /*  _INLINE_DATATYPES_H  */
