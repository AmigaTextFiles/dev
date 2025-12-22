#ifndef	WILD_LOADER_H
#define WILD_LOADER_H

#include <wild/wild.h>
#include <wild/objects.h>

#define LOADER_TAGBASE		WILD_OTHERSTD+200

#define	LOAD_ObjectType		LOADER_TAGBASE+0
#define LOAD_FileName		WILO_FileName
#define	LOAD_FileHandle		WILO_FileHandle
#define	LOAD_ReadHook		WILO_ReadHook

#define SPECIAL_LOADER_MADE	ATTR_BASE+0x5000

#endif