
/* Author Anders Kjeldsen */

#ifndef GOBJECT_CPP
#define GOBJECT_CPP

#include "gsystem/GObject.h"
#include "gsystem/GError.cpp"

GObject::GObject()
{
	memset((void *)this, 0, sizeof (GObject) );
}

GObject::~GObject()
{
}

BOOL GObject::InitGObject(GSTRPTR type)
{
	strncpy(ObjectType, type, 31);
	return TRUE;
}

void GObject::PrintObjectType()
{
	printf("%s\n", ObjectType);
}

GWORD GObject::GetErrors()
{
	GError *current = ErrorList;
	GWORD i = 0;
	while (current)
	{
		i++;
		current = current->GetNextError();
	}	
	return i;
}

BOOL GObject::IsErrorFree()
{
	if ( ErrorList == 0 ) return TRUE;
	return FALSE;
}

BOOL GObject::AddError( GSTRPTR id, GSTRPTR errormsg )
{
	GError *newerror = new GError(id, errormsg);

	if ( newerror )
	{
		if ( ErrorList )
		{
			return ErrorList->AttachError(newerror);
		}
		else
		{
			ErrorList = newerror;
			return TRUE;	
		}
	}
}

GError *GObject::GetFirstError()
{
	return ErrorList;
}

void GObject::PrintErrors()
{
	printf("printing errors:\n");
	if ( ErrorList )
	{
		printf("begins..\n");
		ErrorList->PrintErrors();
	}
}


#endif /* GOBJECT_CPP */