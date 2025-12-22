#ifndef  CLIB_MUIMASTER_PROTOS_H
#define  CLIB_MUIMASTER_PROTOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif
#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifdef __cplusplus
#extern "C" {
#endif

/* functions to be used in applications */

APTR MUI_NewObjectA         (char *classname,struct TagItem *tags);
APTR MUI_NewObject          (char *classname,Tag tag1,...);
VOID MUI_DisposeObject      (APTR obj);
LONG MUI_RequestA           (APTR app,APTR win,LONGBITS flags,char *title,char *gadgets,char *format,APTR params);
LONG MUI_Request            (APTR app,APTR win,LONGBITS flags,char *title,char *gadgets,char *format,...);
LONG MUI_Error              (VOID);
APTR MUI_AllocAslRequest    (unsigned long reqType, struct TagItem *tagList);
APTR MUI_AllocAslRequestTags(unsigned long reqType, Tag Tag1, ...);
VOID MUI_FreeAslRequest     (APTR requester );
BOOL MUI_AslRequest         (APTR requester, struct TagItem *tagList);
BOOL MUI_AslRequestTags     (APTR requester, Tag Tag1, ...);


/* functions to be used with custom classes */

LONG                  MUI_SetError    (LONG num);
struct IClass *       MUI_GetClass    (char *classname);
VOID                  MUI_FreeClass   (struct IClass *classptr);
VOID                  MUI_RequestIDCMP(Object *obj,ULONG flags);
VOID                  MUI_RejectIDCMP (Object *obj,ULONG flags);
APTR                  MUI_Redraw      (Object *obj,ULONG flags);

#ifdef __cplusplus
}
#endif
#endif /* CLIB_MUIMASTER_PROTOS_H */
