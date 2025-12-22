#ifndef _INLINE_BULLET_H
#define _INLINE_BULLET_H

#ifndef CLIB_BULLET_PROTOS_H
#define CLIB_BULLET_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  DISKFONT_GLYPH_H
#include <diskfont/glyph.h>
#endif

#ifndef BULLET_BASE_NAME
#define BULLET_BASE_NAME BulletBase
#endif

#define OpenEngine() \
	LP0(0x1e, struct GlyphEngine *, OpenEngine, \
	, BULLET_BASE_NAME)

#define CloseEngine(glyphEngine) \
	LP1NR(0x24, CloseEngine, struct GlyphEngine *, glyphEngine, a0, \
	, BULLET_BASE_NAME)

#define SetInfoA(glyphEngine, tagList) \
	LP2(0x2a, ULONG, SetInfoA, struct GlyphEngine *, glyphEngine, a0, struct TagItem *, tagList, a1, \
	, BULLET_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetInfo(glyphEngine, tags...) \
	({ULONG _tags[] = {tags}; SetInfoA((glyphEngine), (struct TagItem *) _tags);})
#endif

#define ObtainInfoA(glyphEngine, tagList) \
	LP2(0x30, ULONG, ObtainInfoA, struct GlyphEngine *, glyphEngine, a0, struct TagItem *, tagList, a1, \
	, BULLET_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define ObtainInfo(glyphEngine, tags...) \
	({ULONG _tags[] = {tags}; ObtainInfoA((glyphEngine), (struct TagItem *) _tags);})
#endif

#define ReleaseInfoA(glyphEngine, tagList) \
	LP2(0x36, ULONG, ReleaseInfoA, struct GlyphEngine *, glyphEngine, a0, struct TagItem *, tagList, a1, \
	, BULLET_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define ReleaseInfo(glyphEngine, tags...) \
	({ULONG _tags[] = {tags}; ReleaseInfoA((glyphEngine), (struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_BULLET_H  */
