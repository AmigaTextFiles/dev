/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_BULLET_H
#define _PPCINLINE_BULLET_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef BULLET_BASE_NAME
#define BULLET_BASE_NAME BulletBase
#endif /* !BULLET_BASE_NAME */

#define CloseEngine(glyphEngine) \
	LP1NR(0x24, CloseEngine, struct GlyphEngine *, glyphEngine, a0, \
	, BULLET_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ObtainInfoA(glyphEngine, tagList) \
	LP2(0x30, ULONG, ObtainInfoA, struct GlyphEngine *, glyphEngine, a0, struct TagItem *, tagList, a1, \
	, BULLET_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define ObtainInfo(a0, tags...) \
	({ULONG _tags[] = { tags }; ObtainInfoA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define OpenEngine() \
	LP0(0x1e, struct GlyphEngine *, OpenEngine, \
	, BULLET_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReleaseInfoA(glyphEngine, tagList) \
	LP2(0x36, ULONG, ReleaseInfoA, struct GlyphEngine *, glyphEngine, a0, struct TagItem *, tagList, a1, \
	, BULLET_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define ReleaseInfo(a0, tags...) \
	({ULONG _tags[] = { tags }; ReleaseInfoA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetInfoA(glyphEngine, tagList) \
	LP2(0x2a, ULONG, SetInfoA, struct GlyphEngine *, glyphEngine, a0, struct TagItem *, tagList, a1, \
	, BULLET_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetInfo(a0, tags...) \
	({ULONG _tags[] = { tags }; SetInfoA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#endif /* !_PPCINLINE_BULLET_H */
