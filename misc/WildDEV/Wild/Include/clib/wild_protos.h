#ifndef CLIB_WILD_PROTOS_H
#define CLIB_WILD_PROTOS_H

/*
**	$VER: wild_protos.h 2.00 (13.10.98)
**
**	Wild.library prototypes.
**
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#include <wild/wild.h>

struct 	WildApp 	*AddWildApp(struct MSGPort *wildport,struct TagItem *tags);
void			RemWildApp(struct WildApp *wildapp);
struct	WildModule	*LoadModule(char *type,char *name);
void			KillModule(struct WildModule *module);
BOOL			SetWildAppTags(struct WildApp *wildapp,struct TagItem *tags);
void			GetWildAppTags(struct WildApp *wildapp,struct TagItem *tags);
struct 	WildThread	*AddWildThread(struct WildApp *wildapp,struct TagItem *tags);
void			RemWildThread(struct WildThread *thread);
ULONG			*AllocVecPooled(ULONG size,ULONG *pool);
void			FreeVecPooled(ULONG *mem);
void			RealyzeFrame(struct WildApp *wildapp);
void			InitFrame(struct WildApp *wildapp);
void			DisplayFrame(struct WildApp *wildapp);
struct	WildTable	*LoadTable(ULONG ID,char *name);
void			KillTable(struct WildTable *table);
ULONG			LoadFile(ULONG offs,char *name,ULONG *pool);
struct 	WildExtension	*LoadExtension(char *libname,ULONG version);
void			KillExtension(struct WildExtension *extension);
struct	WildApp		*FindWildApp(struct TagItem *tags);
ULONG			*BuildWildObject(struct TagItem *tags);
void			FreeWildObject(ULONG *object);
ULONG			*LoadWildObject(struct WildApp *wapp,struct TagItem *tags);
ULONG			*GetWildObjectChild(ULONG *object,ULONG childtype,ULONG number);
ULONG			*SaveWildObject(struct WildApp *wapp,struct TagItem *tags);
struct	WildDoing	*DoAction(struct WildApp *wapp,struct TagItem *tags);
void			WildAnimate(struct WildApp *wapp,struct TagItem *tags);
void			AbortAction(struct WildDoing *doing);
#endif
