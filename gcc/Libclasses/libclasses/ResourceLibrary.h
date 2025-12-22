
#ifndef _RESOURCELIBRARY_H
#define _RESOURCELIBRARY_H

#include <libraries/resource.h>
#include <intuition/classusr.h>
#include <utility/tagitem.h>
#include <pragma/resource_lib.h>

class ResourceLibrary
{
public:
	ResourceLibrary();
	~ResourceLibrary();

	static class ResourceLibrary Default;

	RESOURCEFILE RL_OpenResource(void * resource, struct Screen * screen, struct Catalog * catalog);
	void RL_CloseResource(RESOURCEFILE resfile);
	Object * RL_NewObjectA(RESOURCEFILE resfile, RESOURCEID resourceid, struct TagItem * taglist);
	void RL_DisposeObject(RESOURCEFILE resfile, Object * object);
	Object ** RL_NewGroupA(RESOURCEFILE resfile, RESOURCEID resourceid, struct TagItem * taglist);
	void RL_DisposeGroup(RESOURCEFILE resfile, Object ** objects);
	Object ** RL_GetObjectArray(RESOURCEFILE resfile, Object * object, RESOURCEID resourceid);
	BOOL RL_SetResourceScreen(RESOURCEFILE resfile, struct Screen * screen);

private:
	struct Library *Base;
};

ResourceLibrary ResourceLibrary::Default;

#endif

