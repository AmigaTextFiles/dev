/*
$VER: multimedia_protos.h 52.1
*/

#ifndef CLIB_MULTIMEDIA_PROTOS_H
#define CLIB_MULTIMEDIA_PROTOS_H


#ifndef INTUITION_INTUITION_H
# include <intuition/intuition.h>
#endif

#ifndef INTUITION_CLASSES_H
# include <intuition/classes.h>
#endif

#ifndef UTILITY_TAGITEM_H
# include <utility/tagitem.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

void MediaLog(ULONG, STRPTR, STRPTR, STRPTR, ...);
BOOL MediaConnectTagList(Object*, ULONG, Object*, ULONG, struct TagItem*);
Object *MediaNewObjectTagList(struct TagItem*);
STRPTR MediaFindClassTagList(APTR, struct TagItem*);
BOOL MediaGetClassAttr(STRPTR, ULONG, ULONG*);
APTR MediaAllocVec(ULONG);
void MediaFreeVec(APTR);
ULONG MediaSetLogLevel(ULONG);

#ifndef USE_INLINE_STDARG

BOOL MediaConnectTags(Object*, ULONG, Object*, ULONG, Tag tag1, ...);
Object *MediaNewObjectTags(Tag tag1, ...);
STRPTR MediaFindClassTags(APTR, Tag tag1, ...);

#endif

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* CLIB_MULTIMEDIA_PROTOS_H */
