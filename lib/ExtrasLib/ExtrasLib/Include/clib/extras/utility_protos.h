#ifndef CLIB_EXTRAS_UTILITY_PROTOS_H
#define CLIB_EXTRAS_UTILITY_PROTOS_H

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

struct  TagItem *tag_AllocTags(ULONG TagCount);
void    tag_FreeTags (struct TagItem *TL);
void    tag_ClearNumTags(struct TagItem *TL, ULONG TagCount);

BOOL    tag_AddTags(struct TagItem *TagList, ULONG Tag, ...);
BOOL    tag_AddTagList(struct TagItem *TagList, struct TagItem *NewTags);
BOOL    tag_AddTag(struct TagItem *TagList, ULONG Tag, ULONG Data);
BOOL    tag_RemTag(struct TagItem *TL, ULONG Tag);
BOOL    tag_TagMore(struct TagItem *TL, struct TagItem *More);
BOOL    tag_TagEnd(struct TagItem *TL);

ULONG   tag_CountUserTags(struct TagItem *TL);
void    tag_ClearTags(struct TagItem *TL);


#endif /* CLIB_EXTRAS_UTILITY_PROTOS_H */
