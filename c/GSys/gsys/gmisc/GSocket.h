
/* Author Anders K */

#ifndef GSOCKET_H
#define GSOCKET_H

#include "winsock2.h"

#include "gsystem/GObject.h"
#include "gmisc/GServer.h"

WORD WSAver;
WSADATA WSAdata;

class GServer;

class GSocket : public GObject
{
public:
//	GSocket() { memset((GAPTR)this, 0, sizeof(GSocket)); };
	GSocket();
	~GSocket();

	GWORD GSocket::Init(int af, int type, int prot);

	GServer *GetGServer();
	GSocket *GetNext();
	GSocket *GetPrev();
	BOOL SetGServer(GServer *server);
	BOOL SetNext(GSocket *next);
	BOOL SetPrev(GSocket *next);
	BOOL SetSocket(SOCKET s);

/* SOCKET functions */
	GWORD SockRecv(char *buffer, GWORD len, GWORD flags);
	GWORD SockSend(char *buffer, GWORD len, GWORD flags);
	GWORD SockListen();
	GWORD SockBind(GSTRPTR address, GUWORD port);
	GWORD SockConnect(GSTRPTR address, GUWORD port);
	GWORD SockSetOpt(GWORD level, GWORD optname, char *optval, GWORD optlen);
	GSocket *SockAccept();
	
//	GWORD SetLocalAddress(GSTRPTR address, GUWORD port);	// address==NULL means localhost

protected:
	GWORD type;
	GServer *MServer;
	GSocket *Prev;	// if NULL: First one
	GSocket *Next;	// if NULL: Last one

#ifdef GWINDOWS
	hostent *Hostent;
	servent *Servent;
	sockaddr_in LocalAddr;
	sockaddr_in PeerAddr;
	SOCKET Socket;
#endif

};

#endif /* GSOCKET_H */
