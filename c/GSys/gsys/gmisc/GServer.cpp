
/* Author Anders Kjeldsen */

#ifndef GSERVER_CPP
#define GSERVER_CPP

#include "gmisc/GServer.h"
#include "gsystem/GObject.cpp"
#include "gmisc/GSocket.cpp"

GServer::GServer()
{
	memset((void *)this, 0, sizeof (GServer) );

	if ( InitObject("GServer") )
	{
	}
}

GServer::~GServer()
{
}

/*
	0 = first
	n = n'th
	-1 = last

  */
GSocket *GServer::GetGSocket(GWORD number)
{
	if (number == -1)
	{
		GSocket *current = FirstGSocket;
		if (current)
		{
			while ( current->GetNext() )
			{
				current = current->GetNext();
			}
			return current;
		}
		return NULL;
	}
	GSocket *current = FirstGSocket;
	for (int i=0; i<number; i++)
	{
		if ( current == NULL ) return NULL;
		current = current->GetNext();
	}
	return current;
}

BOOL GServer::AddGSocket(GSocket *socket)
{
	GSocket *prev = GetGSocket(-1);
	if (prev && socket)
	{
		prev->SetNext(socket);
		socket->SetPrev(prev);
	}
	return TRUE;
}

BOOL GServer::RemoveGSocket(GSocket *socket)
{
	GSocket *current = FirstGSocket;
	if (current)
	{
		while ( current->GetNext() )
		{
			if ( current == socket ) break;
		}
		if ( current == socket )
		{
			socket->GetNext()->SetPrev(socket->GetPrev());
			socket->GetPrev()->SetNext(socket->GetNext());
			socket->SetNext(NULL);
			socket->SetPrev(NULL);
			return TRUE;
		}
	}
	return NULL;
}

#endif /* GSOCKET_CPP */
