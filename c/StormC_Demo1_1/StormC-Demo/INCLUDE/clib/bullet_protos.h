#ifndef  CLIB_BULLET_PROTOS_H
#define  CLIB_BULLET_PROTOS_H

/*
**	$VER: bullet_protos.h 38.0 (19.6.92)
**	Includes Release 40.15
**
**	C prototypes. For use with 32 bit integers only.
**
**	(C) Copyright 1990-1993 Commodore-Amiga, Inc.
**	    All Rights Reserved
*/

#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  DISKFONT_GLYPH_H
#include <diskfont/glyph.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

struct GlyphEngine *OpenEngine( void );
void CloseEngine( struct GlyphEngine *glyphEngine );
ULONG SetInfoA( struct GlyphEngine *glyphEngine, struct TagItem *tagList );
ULONG SetInfo( struct GlyphEngine *glyphEngine, Tag tag1, ... );
ULONG ObtainInfoA( struct GlyphEngine *glyphEngine, struct TagItem *tagList );
ULONG ObtainInfo( struct GlyphEngine *glyphEngine, Tag tag1, ... );
ULONG ReleaseInfoA( struct GlyphEngine *glyphEngine,
	struct TagItem *tagList );
ULONG ReleaseInfo( struct GlyphEngine *glyphEngine, Tag tag1, ... );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_BULLET_LIB_H
#include <pragma/bullet_lib.h>
#endif
#endif

#endif	 /* CLIB_BULLET_PROTOS_H */
