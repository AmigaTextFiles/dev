
#ifndef _DATATYPESLIBRARY_H
#define _DATATYPESLIBRARY_H

#include <exec/types.h>
#include <exec/lists.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <utility/tagitem.h>
#include <datatypes/datatypes.h>
#include <rexx/storage.h>

class DataTypesLibrary
{
public:
	DataTypesLibrary();
	~DataTypesLibrary();

	static class DataTypesLibrary Default;

	struct DataType * ObtainDataTypeA(ULONG type, APTR handle, struct TagItem * attrs);
	VOID ReleaseDataType(struct DataType * dt);
	Object * NewDTObjectA(APTR name, struct TagItem * attrs);
	VOID DisposeDTObject(Object * o);
	ULONG SetDTAttrsA(Object * o, struct Window * win, struct Requester * req, struct TagItem * attrs);
	ULONG GetDTAttrsA(Object * o, struct TagItem * attrs);
	LONG AddDTObject(struct Window * win, struct Requester * req, Object * o, LONG pos);
	VOID RefreshDTObjectA(Object * o, struct Window * win, struct Requester * req, struct TagItem * attrs);
	ULONG DoAsyncLayout(Object * o, struct gpLayout * gpl);
	ULONG DoDTMethodA(Object * o, struct Window * win, struct Requester * req, Msg msg);
	LONG RemoveDTObject(struct Window * win, Object * o);
	ULONG * GetDTMethods(Object * object);
	struct DTMethods * GetDTTriggerMethods(Object * object);
	ULONG PrintDTObjectA(Object * o, struct Window * w, struct Requester * r, struct dtPrint * msg);
	STRPTR GetDTString(ULONG id);

private:
	struct Library *Base;
};

DataTypesLibrary DataTypesLibrary::Default;

#endif

