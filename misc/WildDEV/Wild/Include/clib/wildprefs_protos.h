#ifndef CLIB_WILDPREFS_PROTOS_H
#define CLIB_WILDPREFS_PROTOS_H

/*
**	$VER: wildprefs_protos.h 2.00 (8.10.98)
**
**	WildPrefs.library prototypes.
**
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef  WILDPREFS_H
#include <libraries/wildprefs.h>
#endif

struct MinList 		*wpGetHandledList();
struct AppPrefs 	*wpFindNamedApp(char *name);
BOOL			wpLoadPrefs(struct AppPrefs *app,struct TagItem *tags);
BOOL			wpSetPrefs(struct AppPrefs *app,struct TagItem *tags);
BOOL			wpTestPrefs(struct AppPrefs *app);
BOOL			wpUsePrefs(struct AppPrefs *app);
BOOL			wpSavePrefs(struct AppPrefs *app);
BOOL			wpFreePrefs(struct AppPrefs *app);
ULONG			wpGetAppTag(struct AppPrefs *app,ULONG tagdata,ULONG def);

#endif