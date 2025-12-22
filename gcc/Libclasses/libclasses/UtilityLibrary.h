
#ifndef _UTILITYLIBRARY_H
#define _UTILITYLIBRARY_H

#include <exec/types.h>
#include <exec/ports.h>
#include <utility/tagitem.h>
#include <utility/date.h>
#include <utility/hooks.h>
#include <utility/name.h>

class UtilityLibrary
{
public:
	UtilityLibrary();
	~UtilityLibrary();

	static class UtilityLibrary Default;

	struct TagItem * FindTagItem(Tag tagVal, CONST struct TagItem * tagList);
	ULONG GetTagData(Tag tagValue, ULONG defaultVal, CONST struct TagItem * tagList);
	ULONG PackBoolTags(ULONG initialFlags, CONST struct TagItem * tagList, CONST struct TagItem * boolMap);
	struct TagItem * NextTagItem(struct TagItem ** tagListPtr);
	VOID FilterTagChanges(struct TagItem * changeList, struct TagItem * originalList, ULONG apply);
	VOID MapTags(struct TagItem * tagList, CONST struct TagItem * mapList, ULONG mapType);
	struct TagItem * AllocateTagItems(ULONG numTags);
	struct TagItem * CloneTagItems(CONST struct TagItem * tagList);
	VOID FreeTagItems(struct TagItem * tagList);
	VOID RefreshTagItemClones(struct TagItem * clone, CONST struct TagItem * original);
	BOOL TagInArray(Tag tagValue, CONST Tag * tagArray);
	ULONG FilterTagItems(struct TagItem * tagList, CONST Tag * filterArray, ULONG logic);
	ULONG CallHookPkt(struct Hook * hook, APTR object, APTR paramPacket);
	VOID Amiga2Date(ULONG seconds, struct ClockData * result);
	ULONG Date2Amiga(CONST struct ClockData * date);
	ULONG CheckDate(CONST struct ClockData * date);
	LONG SMult32(LONG arg1, LONG arg2);
	ULONG UMult32(ULONG arg1, ULONG arg2);
	LONG SDivMod32(LONG dividend, LONG divisor);
	ULONG UDivMod32(ULONG dividend, ULONG divisor);
	LONG Stricmp(CONST_STRPTR string1, CONST_STRPTR string2);
	LONG Strnicmp(CONST_STRPTR string1, CONST_STRPTR string2, LONG length);
	UBYTE ToUpper(ULONG character);
	UBYTE ToLower(ULONG character);
	VOID ApplyTagChanges(struct TagItem * list, CONST struct TagItem * changeList);
	LONG SMult64(LONG arg1, LONG arg2);
	ULONG UMult64(ULONG arg1, ULONG arg2);
	ULONG PackStructureTags(APTR pack, CONST ULONG * packTable, CONST struct TagItem * tagList);
	ULONG UnpackStructureTags(CONST APTR pack, CONST ULONG * packTable, struct TagItem * tagList);
	BOOL AddNamedObject(struct NamedObject * nameSpace, struct NamedObject * object);
	struct NamedObject * AllocNamedObjectA(CONST_STRPTR name, CONST struct TagItem * tagList);
	LONG AttemptRemNamedObject(struct NamedObject * object);
	struct NamedObject * FindNamedObject(struct NamedObject * nameSpace, CONST_STRPTR name, struct NamedObject * lastObject);
	VOID FreeNamedObject(struct NamedObject * object);
	STRPTR NamedObjectName(struct NamedObject * object);
	VOID ReleaseNamedObject(struct NamedObject * object);
	VOID RemNamedObject(struct NamedObject * object, struct Message * message);
	ULONG GetUniqueID();

private:
	struct Library *Base;
};

UtilityLibrary UtilityLibrary::Default;

#endif

