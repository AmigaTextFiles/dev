
/* Author Anders K */

#ifndef GSERVER_H
#define GSERVER_H

#include "gsystem/GObject.h"
#include "gmisc/GSocket.h"

class GSocket;

class GServer : public GObject
{
public:
//	GServer() { memset((GAPTR)this, 0, sizeof(GServer)); };
	GServer();
	~GServer();

	BOOL AddGSocket(GSocket *socket);
	BOOL RemoveGSocket(GSocket *socket);
	GSocket *GetGSocket(GWORD number);

	GSocket *ListenNext(GWORD timeout);


protected:
	GSocket *Listener;
	GSocket *FirstGSocket;	// if NULL: First one
};

#endif /* GSERVER_H */
