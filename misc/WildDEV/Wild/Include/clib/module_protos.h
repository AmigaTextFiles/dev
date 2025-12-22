#ifndef CLIB_MODULE_PROTOS_H
#define CLIB_MODULE_PROTOS_H

/*
**	$VER: module_protos.h 2.00 (3.12.98)
**
**	modules libraries common prototypes.
**
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef  WILDPREFS_H
#include <wild/wild.h>
#endif

#include <utility/tagitem.h>

void		SetModuleTags(struct WildApp *wapp,struct TagItem *tags);
void		GetModuleTags(struct WildApp *wapp,struct TagItem *tags);
BOOL		SetupModule(struct WildApp *wapp,struct TagItem *tags);
void		CloseModule(struct WildApp *wapp);
BOOL		RefreshModule(struct WildApp *wapp);

#endc