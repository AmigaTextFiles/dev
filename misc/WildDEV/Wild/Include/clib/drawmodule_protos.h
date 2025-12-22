#ifndef CLIB_DRAWMODULE_PROTOS_H
#define CLIB_DRAWMODULE_PROTOS_H

/*
**	$VER: drawmodule_protos.h 2.01 (9.12.98)
**
**	modules libraries common prototypes.
**
*/

#include <exec/types.h>
#include <utility/tagitem.h>
#include <wild/tdcore.h>

void		SetModuleTags(struct WildApp *wapp,struct TagItem *tags);
void		GetModuleTags(struct WildApp *wapp,struct TagItem *tags);
BOOL		SetupModule(struct WildApp *wapp,struct TagItem *tags);
void		CloseModule(struct WildApp *wapp);
BOOL		RefreshModule(struct WildApp *wapp);
void		DRWPaintArray(struct WildApp *wapp,ULONG *PaintArray);
void 		DRWInitFrame(struct WildApp *wapp);
BOOL		DRWInitTexture(struct WildApp *wapp,struct WildTexture *tex);

#endc