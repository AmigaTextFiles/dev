
/* Author Anders Kjeldsen */

#ifndef GERROR_CPP
#define GERROR_CPP

#include "gsystem/GError.h"
//#include "gsystem/GObject.cpp"

GError::GError(GSTRPTR id, GSTRPTR errormsg)
{
	memset((void *)this, 0, sizeof (GError) );
	ID = NULL;
	Msg = NULL;

	if ( id && errormsg )
	{
		ID = new char[ strlen(id) + 1 ];
		Msg = new char[ strlen(errormsg) + 1 ];
		if ( ID && Msg )
		{
			strcpy(ID, id);
			strcpy(Msg, errormsg);
		}
	}
}

GError::~GError()
{
	if ( ID ) delete ID;
	if ( Msg ) delete Msg;
	if ( NextError ) delete NextError;
}

BOOL GError::ChangeMsg(GSTRPTR errormsg)
{
	if ( errormsg )
	{
		if ( Msg )
		{
			if ( strlen(errormsg) > strlen(Msg) )
			{
				delete Msg;
				Msg = new char[ strlen(errormsg) + 1 ];
			}
			strcpy(Msg, errormsg);
			return TRUE;
		}
		else
		{
			Msg = new char[ strlen(errormsg) + 1 ];
			if (Msg)
			{
				strcpy(Msg, errormsg);
				return TRUE;
			}
			else return FALSE;
		}
	}
}

void GError::PrintError()
{
	if ( ID && Msg)
	{
		printf("Error (id: %s): %s\n", ID, Msg);
	}
}

void GError::PrintErrors()
{
	printf("printing error:\n");
	if ( ID && Msg)
	{
		printf("Error (id: %s): %s\n", ID, Msg);
		if ( NextError ) NextError->PrintErrors();
	}
}

BOOL GError::AttachError(GError *next)
{
	if (!next->PrevError)
	{
		if ( NextError )
		{
			next->NextError = NextError;
			NextError->PrevError = next;
			next->PrevError = this;
			NextError = next;
		}
		else
		{
			NextError = next;
			next->PrevError = this;
		}
		return TRUE;
	}
	return FALSE;	// Error already in middle of excisting list
}

BOOL GError::DetachError()
{
	if (PrevError)
	{
		NextError->PrevError = PrevError;
		PrevError->NextError = NextError;
		return TRUE;

	}
	return FALSE;	// cannot remove first entry in list
}

#endif /* GERROR_CPP */