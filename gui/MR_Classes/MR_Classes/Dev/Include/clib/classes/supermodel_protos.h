#ifndef CLIB_CLASSES_SUPERMODEL_PROTOS_H
#define CLIB_CLASSES_SUPERMODEL_PROTOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif

Object *SM_NewSuperModelA(struct TagItem *TagList);
Object *SM_NewSuperModel(Tag Tags, ... );

Object *SM_NewSuperICA(struct TagItem *TagList);
Object *SM_NewSuperIC(Tag Tags, ... );

Object *SM_SICMAPA(Object *Target, struct TagItem *MapTagList);
Object *SM_SICMAP(Object *Target, Tag MapList, ...);

BOOL    SM_IsMemberOf(Object *obj, Class *class, STRPTR class_id);

ULONG   SM_SuperNotifyA(Class *CL, Object *O, struct opUpdate *M, struct TagItem *TagList);
ULONG   SM_SuperNotify(Class *CL, Object *O, struct opUpdate *M, Tag Tags, ... );

struct GadgetInfo *SM_GetGInfo(Msg Message);

ULONG   SM_SendGlueAttrsA(struct smGlueData *GD, struct TagItem *TagList);
ULONG   SM_SendGlueAttrs(struct smGlueData *GD, Tag Tags, ...);


struct  TagItem *SMTAG_AllocTags(ULONG TagCount);
void    SMTAG_FreeTags (struct TagItem *TL);
void    SMTAG_ClearNumTags(struct TagItem *TL, ULONG TagCount);

BOOL    SMTAG_AddTags(struct TagItem *TagList, ULONG Tag, ...);
BOOL    SMTAG_AddTagsA(struct TagItem *TagList, struct TagItem *NewTags);
BOOL    SMTAG_AddTag(struct TagItem *TagList, ULONG Tag, ULONG Data);
BOOL    SMTAG_RemTag(struct TagItem *TL, ULONG Tag);
BOOL    SMTAG_TagMore(struct TagItem *TL, struct TagItem *More);
BOOL    SMTAG_TagEnd(struct TagItem *TL);

void    SMTAG_ClearTags(struct TagItem *TL);

#endif /* CLIB_CLASSES_SUPERMODEL_PROTOS_H */
