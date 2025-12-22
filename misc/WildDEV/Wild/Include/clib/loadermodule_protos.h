#ifndef CLIB_LOADERMODULE_PROTOS_H
#define CLIB_LOADERMODULE_PROTOS_H

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
ULONG		*LOALoadObj(struct TagItem *tags);
ULONG		LOAGetObjAttr(struct WildApp *wapp,ULONG *obj,ULONG attr,ULONG def);
ULONG		*LOANextObjChild(ULONG *obj,ULONG *prec,ULONG type);
void		LOAMadeObjIs(ULONG *obj,ULONG *wildobj);
void		LOAFreeObj(ULONG *obj);

#endc