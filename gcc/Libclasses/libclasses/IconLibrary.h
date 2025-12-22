
#ifndef _ICONLIBRARY_H
#define _ICONLIBRARY_H

#include <workbench/workbench.h>
#include <datatypes/pictureclass.h>

class IconLibrary
{
public:
	IconLibrary();
	~IconLibrary();

	static class IconLibrary Default;

	VOID FreeFreeList(struct FreeList * freelist);
	BOOL AddFreeList(struct FreeList * freelist, CONST APTR mem, ULONG size);
	struct DiskObject * GetDiskObject(CONST_STRPTR name);
	BOOL PutDiskObject(CONST_STRPTR name, CONST struct DiskObject * diskobj);
	VOID FreeDiskObject(struct DiskObject * diskobj);
	UBYTE * FindToolType(CONST_STRPTR * toolTypeArray, CONST_STRPTR typeName);
	BOOL MatchToolValue(CONST_STRPTR typeString, CONST_STRPTR value);
	STRPTR BumpRevision(STRPTR newname, CONST_STRPTR oldname);
	struct DiskObject * GetDefDiskObject(LONG type);
	BOOL PutDefDiskObject(CONST struct DiskObject * diskObject);
	struct DiskObject * GetDiskObjectNew(CONST_STRPTR name);
	BOOL DeleteDiskObject(CONST_STRPTR name);
	struct DiskObject * DupDiskObjectA(CONST struct DiskObject * diskObject, CONST struct TagItem * tags);
	ULONG IconControlA(struct DiskObject * icon, CONST struct TagItem * tags);
	VOID DrawIconStateA(struct RastPort * rp, CONST struct DiskObject * icon, CONST_STRPTR label, LONG leftOffset, LONG topOffset, ULONG state, CONST struct TagItem * tags);
	BOOL GetIconRectangleA(struct RastPort * rp, CONST struct DiskObject * icon, CONST_STRPTR label, struct Rectangle * rect, CONST struct TagItem * tags);
	struct DiskObject * NewDiskObject(LONG type);
	struct DiskObject * GetIconTagList(CONST_STRPTR name, CONST struct TagItem * tags);
	BOOL PutIconTagList(CONST_STRPTR name, CONST struct DiskObject * icon, CONST struct TagItem * tags);
	BOOL LayoutIconA(struct DiskObject * icon, struct Screen * screen, struct TagItem * tags);
	VOID ChangeToSelectedIconColor(struct ColorRegister * cr);

private:
	struct Library *Base;
};

IconLibrary IconLibrary::Default;

#endif

