#ifndef  CLIB_DILPLUGIN_PROTOS_H
#define  CLIB_DILPLUGIN_PROTOS_H 1

/*
**
**	$VER: dilplugin_protos.h 1.0 (01.08.2008)
**
**	DIL plugin protos
**
**	©2004-2009 Rupert Hausberger
**	All Rights Reserved
**
*/

#ifndef EXEC_TYPES_H
	#include <exec/types.h>
#endif /* EXEC_TYPES_H */

#ifndef DEVICES_DIL_H
	#include <devices/dil.h>
#endif /* DEVICES_DIL_H */

#ifndef LIBRARIES_DILPLUGIN_H
	#include <libraries/dilplugin.h>
#endif /* LIBRARIES_DILPLUGIN_H */

#ifndef UTILITY_TAGITEM_H
	#include <utility/tagitem.h>
#endif /* UTILITY_TAGITEM_H */

struct TagItem *dilGetInfo(void);

BOOL dilSetup(struct DILParams *params);
void dilCleanup(struct DILParams *params);

BOOL dilProcess(struct DILPlugin *plugin);

#endif /* CLIB_DILPLUGIN_PROTOS_H */

