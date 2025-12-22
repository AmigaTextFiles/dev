/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_DILPLUGIN_H
#define _PPCINLINE_DILPLUGIN_H

#ifndef CLIB_DILPLUGIN_PROTOS_H
#define CLIB_DILPLUGIN_PROTOS_H
#endif

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  DEVICES_DIL_H
#include <devices/dil.h>
#endif
#ifndef  LIBRARIES_DILPLUGIN_H
#include <libraries/dilplugin.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef DILPLUGIN_BASE_NAME
#define DILPLUGIN_BASE_NAME DILPluginBase
#endif

#define dilGetInfo() \
	LP0(0x1e, struct TagItem *, dilGetInfo, \
	, DILPLUGIN_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define dilSetup(p) \
	LP1(0x24, BOOL, dilSetup, struct DILParams *, p, a0, \
	, DILPLUGIN_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define dilCleanup(p) \
	LP1NR(0x2a, dilCleanup, struct DILParams *, p, a0, \
	, DILPLUGIN_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define dilProcess(c) \
	LP1(0x30, BOOL, dilProcess, struct DILPlugin *, c, a0, \
	, DILPLUGIN_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /*  _PPCINLINE_DILPLUGIN_H  */
