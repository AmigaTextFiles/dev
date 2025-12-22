#ifndef _UTILITY_PROTOS_H_
#define _UTILITY_PROTOS_H_ 1

/* UtiltiyProto.h
 *
 * The prototypes of the functions in the utiltiy.library.
 */

/* --- Amiga part ----------------------------------------------------------- */

#ifdef _AMIGA

#ifndef PROTO_UTILITY_H
#include <proto/utility.h>
#endif

#else				/* _AMIGA */

/* --- Windoof part --------------------------------------------------------- */

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

EXPORT struct TagItem *AllocateTagItems(ULONG numTags);
EXPORT void ApplyTagChanges (struct TagItem *list, struct TagItem *changeList);
EXPORT struct TagItem *CloneTagItems (struct TagItem *original);
EXPORT void FilterTagChanges (struct TagItem *changeList,
										struct TagItem *originalList, ULONG apply);
EXPORT ULONG FilterTagItems (struct TagItem *tagList, Tag *FilterArray, ULONG logic);
EXPORT struct TagItem *FindTagItem (Tag tagValue, struct TagItem *tagList);
EXPORT void FreeTagItems (struct TagItem *tagList);
EXPORT ULONG GetTagData (Tag tagValue, ULONG defaultVal, struct TagItem *tagList);
EXPORT void MapTags (struct TagItem *tagList, struct TagItem *mapList, ULONG mapType);
EXPORT struct TagItem *NextTagItem (struct TagItem **tagItemPtr);
EXPORT ULONG PackBoolTags (ULONG initialFlags, struct TagItem *tagList,
																struct TagItem *boolMap);
EXPORT ULONG PackStructureTags (APTR pack, ULONG *packTable,
											struct TagItem *tagList);
EXPORT void RefreshTagItemClones (struct TagItem *clone, struct TagItem *original);
EXPORT BOOL TagInArray (Tag tagValue, Tag *tagArray);
EXPORT ULONG UnpackStructureTags (APTR pack, ULONG *packTable,
											struct TagItem *tagList);

#endif			/* _AMIGA */

#endif			/* _UTILITY_PROTOS_H_ */
