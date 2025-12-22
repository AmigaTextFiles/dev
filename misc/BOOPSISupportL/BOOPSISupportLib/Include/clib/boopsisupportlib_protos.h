#ifndef	CLIB_BOOPSISUPPORTLIB_PROTOS_H
#define	CLIB_BOOPSISUPPORTLIB_PROTOS_H
/*
 * $VER: boopsisupportlib_protos.c 11.0 (29.07.01) ® 2001 R.E.D.Group by Przemyslaw 'SENSEI' Gruchala
 */

#ifndef	EXEC_TYPES_H
#include	<exec/types.h>
#endif	/* EXEC_TYPES_H */

#ifndef	INTUITION_CGHOOKS_H
#include	<intuition/cghooks.h>
#endif	/* INTUITION_CGHOOKS_H */

#ifndef	INTUITION_CLASSES_H
#include	<intuition/classes.h>
#endif	/* INTUITION_CLASSES_H */

#ifndef	INTUITION_CLASSUSR_H
#include	<intuition/classusr.h>
#endif	/* INTUITION_CLASSUSR_H */

#ifndef	UTILITY_TAGITEM_H
#include	<utility/tagitem.h>
#endif	/* UTILITY_TAGITEM_H */

ULONG	CoerceSetAttrsA			( struct IClass *, Object *, struct TagItem * );
ULONG	CoerceSetAttrs				( struct IClass *, Object *, Tag, ... );
ULONG	CoerceSetGadgetAttrsA	( struct IClass *, Object *, struct GadgetInfo *, struct TagItem * );
ULONG	CoerceSetGadgetAttrs		( struct IClass *, Object *, struct GadgetInfo *, Tag, ... );
ULONG	DoSuperNewA					( struct IClass *, Object *, struct TagItem * );
ULONG	DoSuperNew					( struct IClass *, Object *, Tag, ... );

ULONG	xget( Object *, ULONG );

struct TagItem	*FilterTagItem	( ULONG, struct TagItem * );

STRPTR	allocstring	( ULONG );
STRPTR	clonestring	( STRPTR );
VOID		freestring	( STRPTR );

#endif	/* CLIB_BOOPSISUPPORTLIB_PROTOS_H */
