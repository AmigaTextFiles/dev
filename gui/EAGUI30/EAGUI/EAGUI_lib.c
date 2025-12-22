/*
 * $RCSfile: EAGUI_lib.c,v $
 *
 * $Author: marcel $
 *
 * $Revision: 3.0 $
 *
 * $Date: 1994/10/27 19:40:50 $
 *
 * $Locker: marcel $
 *
 * $State: Exp $
 */

#include "EAGUI.h"
#include "EAGUI_pragmas.h"

STATIC UBYTE rcs_id_string[] = "$Id: EAGUI_lib.c,v 3.0 1994/10/27 19:40:50 marcel Exp marcel $";

/* varargs stubs which work with SAS/C */
LONG ea_NewRelation(struct ea_Object *obj_ptr, struct Hook *relmethod_ptr, ULONG tag1, ...)
{
     return(ea_NewRelationA(obj_ptr, relmethod_ptr, (struct TagItem *)&tag1));
}

struct ea_Object *ea_NewObject(ULONG type, ULONG tag1, ...)
{
     return(ea_NewObjectA(type, (struct TagItem *)&tag1));
}

ULONG ea_GetAttrs(struct ea_Object *obj_ptr, ULONG tag1, ...)
{
     return(ea_GetAttrsA(obj_ptr, (struct TagItem *)&tag1));
}

ULONG ea_SetAttrs(struct ea_Object *obj_ptr, ULONG tag1, ...)
{
     return(ea_SetAttrsA(obj_ptr, (struct TagItem *)&tag1));
}

