#ifndef CLIB_SAVERMODULE_PROTOS_H
#define CLIB_SAVERMODULE_PROTOS_H

/*
**	$VER: drawmodule_protos.h 2.01 (9.12.98)
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
ULONG		*SAVNewObj(ULONG type,void *prec,void *parent,void *wildobj);
void		SAVSetObjAttr(struct WildApp *wapp,ULONG *obj,ULONG attr,ULONG value);
void		SAVSaveObj(struct TagItem *tags);
void		SAVFreeObj(void *obj);

#endc