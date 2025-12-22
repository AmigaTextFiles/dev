/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_MULTIMEDIA_H
#define _PPCINLINE_MULTIMEDIA_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef MULTIMEDIA_BASE_NAME
#define MULTIMEDIA_BASE_NAME MultimediaBase
#endif /* !MULTIMEDIA_BASE_NAME */

#define MediaFreeVec(__p0) \
	(((void (*)(void *, APTR ))*(void**)((long)(MULTIMEDIA_BASE_NAME) - 70))((void*)(MULTIMEDIA_BASE_NAME), __p0))

#define MediaGetClassAttr(__p0, __p1, __p2) \
	(((BOOL (*)(void *, STRPTR , ULONG , ULONG *))*(void**)((long)(MULTIMEDIA_BASE_NAME) - 58))((void*)(MULTIMEDIA_BASE_NAME), __p0, __p1, __p2))

#ifndef __cplusplus
#define MediaLog(__p0, __p1, __p2, __p3, ...) \
	(((void (*)(void *, ULONG , STRPTR , STRPTR , STRPTR , ...))*(void**)((long)(MULTIMEDIA_BASE_NAME) - 34))((void*)(MULTIMEDIA_BASE_NAME), __p0, __p1, __p2, __p3, __VA_ARGS__))
#else
#define MediaLog(__p0, __p1, __p2, __p3...) \
	(((void (*)(void *, ULONG , STRPTR , STRPTR , STRPTR , ...))*(void**)((long)(MULTIMEDIA_BASE_NAME) - 34))((void*)(MULTIMEDIA_BASE_NAME), __p0, __p1, __p2, __p3))
#endif

#define MediaConnectTagList(__p0, __p1, __p2, __p3, __p4) \
	(((BOOL (*)(void *, Object *, ULONG , Object *, ULONG , struct TagItem *))*(void**)((long)(MULTIMEDIA_BASE_NAME) - 40))((void*)(MULTIMEDIA_BASE_NAME), __p0, __p1, __p2, __p3, __p4))

#define MediaSetLogLevel(__p0) \
	(((ULONG (*)(void *, ULONG ))*(void**)((long)(MULTIMEDIA_BASE_NAME) - 76))((void*)(MULTIMEDIA_BASE_NAME), __p0))

#define MediaNewObjectTagList(__p0) \
	(((Object *(*)(void *, struct TagItem *))*(void**)((long)(MULTIMEDIA_BASE_NAME) - 46))((void*)(MULTIMEDIA_BASE_NAME), __p0))

#define MediaAllocVec(__p0) \
	(((APTR (*)(void *, ULONG ))*(void**)((long)(MULTIMEDIA_BASE_NAME) - 64))((void*)(MULTIMEDIA_BASE_NAME), __p0))

#define MediaFindClassTagList(__p0, __p1) \
	(((STRPTR (*)(void *, APTR , struct TagItem *))*(void**)((long)(MULTIMEDIA_BASE_NAME) - 52))((void*)(MULTIMEDIA_BASE_NAME), __p0, __p1))

#ifdef USE_INLINE_STDARG

#include <stdarg.h>

#define MediaNewObjectTags(...) \
	({ULONG _tags[] = { __VA_ARGS__ }; \
	MediaNewObjectTagList((struct TagItem *)_tags);})

#define MediaFindClassTags(__p0, ...) \
	({ULONG _tags[] = { __VA_ARGS__ }; \
	MediaFindClassTagList(__p0, (struct TagItem *)_tags);})

#define MediaConnectTags(__p0, __p1, __p2, __p3, ...) \
	({ULONG _tags[] = { __VA_ARGS__ }; \
	MediaConnectTagList(__p0, __p1, __p2, __p3, (struct TagItem *)_tags);})

#endif

#endif /* !_PPCINLINE_MULTIMEDIA_H */
