#ifndef CLIB_DISPLAYMODULE_PROTOS_H
#define CLIB_DISPLAYMODULE_PROTOS_H

/*
**	$VER: displaymodule_protos.h 2.01 (9.12.98)
**
**	modules libraries common prototypes.
**
*/

#include <exec/types.h>
#include <utility/tagitem.h>

void		SetModuleTags(struct WildApp *wapp,struct TagItem *tags);
void		GetModuleTags(struct WildApp *wapp,struct TagItem *tags);
BOOL		SetupModule(struct WildApp *wapp,struct TagItem *tags);
void		CloseModule(struct WildApp *wapp);
BOOL		RefreshModule(struct WildApp *wapp);
void		DISDisplayFrame(struct WildApp *wapp);
void 		DISInitFrame(struct WildApp *wapp);

#endc