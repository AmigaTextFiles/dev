
/* Author Anders Kjeldsen */

#ifndef GSOCKET_CPP
#define GSOCKET_CPP

#include "gmisc/GSocket.h"
#include "gsystem/GObject.cpp"
#include "gmisc/GServer.cpp"

GSocket::GSocket()
{
	memset((void *)this, 0, sizeof (GSocket) );

	if ( InitObject("GSocket") )
	{
	}
}

GSocket::~GSocket()
{
	if ( Socket )
	{
		shutdown(Socket, SD_SEND);
		closesocket(Socket);
	}
}

GWORD GSocket::Init(int af, int type, int prot)
{
	if ( IsErrorFree() )
	{
		if ( !WSAver )
		{
			WSAver = MAKEWORD(2, 2);
			WSAStartup(WSAver, &WSAdata);
		}
		Socket = socket(af, type, prot);
		return TRUE;
	}
	else return FALSE;
}					

GServer *GSocket::GetGServer()
{
	return MServer;
}

GSocket *GSocket::GetNext()
{
	return Next;
}

GSocket *GSocket::GetPrev()
{
	return Prev;
}

BOOL GSocket::SetGServer(GServer *server)
{
	MServer = server;
	return TRUE;
}

BOOL GSocket::SetNext(GSocket *next)
{
	Next = next;
	return TRUE;
}

BOOL GSocket::SetPrev(GSocket *prev)
{
	Prev = prev;
	return TRUE;
}

BOOL GSocket::SetSocket(SOCKET s)
{
	if ( IsErrorFree() )
	{
		WriteLog("Socket Set\n");
		Socket = s;
		return TRUE;
	}
	else return FALSE;
}

/*
GWORD GSocket::SetLocalAddress(GSTRPTR address, GUWORD port)
{
	struct servent *sp;
	struct hostent *hp;
	char *endptr;
	
	Local.sin_family = AF_INET;
	Local.sin_addr.s_addr = INADDR_ANY;
	Local.sin_port = htons(PORT);

	if (address)
	{
		if ( !inet_aton( address, &Local->sin_addr)
		{
			hp = gethostbyname(address)
			if (hp == NULL)
			{
				return 0;
			}
			sap->sin_addr = *hp->h_name;
		}
	}
	return 1;		
}
*/
GWORD GSocket::SockRecv(char *buffer, GWORD len, GWORD flags)
{
	if ( Socket && IsErrorFree() )
	{
		int c;
		c = recv(Socket, buffer, len, flags);
		WriteLog((char *)buffer);
		return c;
	}
	else return -1;
}

GWORD GSocket::SockSend(char *buffer, GWORD len, GWORD flags)
{
	if ( Socket && IsErrorFree() )
	{
		WriteLog((char *)buffer);
		return send(Socket, buffer, len, flags);
	}
	else return -1;
}

GWORD GSocket::SockListen()
{
	if ( Socket && IsErrorFree() ) return listen(Socket, 5);
	else return -1;
}

GWORD GSocket::SockBind(GSTRPTR address, GUWORD port)
{
	if ( Socket && IsErrorFree())
	{
		LocalAddr.sin_family = AF_INET;
		LocalAddr.sin_addr.s_addr = INADDR_ANY;
		LocalAddr.sin_port = htons(port);

		return bind(Socket, (sockaddr *)&LocalAddr, sizeof(sockaddr_in));
	}
	else return 0;
}

GWORD GSocket::SockSetOpt(GWORD level, GWORD optname, char *optval, GWORD optlen)
{
	if ( Socket && IsErrorFree() ) return setsockopt(Socket, level, optname, optval, optlen);
	else return -1;
}

GWORD GSocket::SockConnect(GSTRPTR address, GUWORD port)
{
	if ( Socket && IsErrorFree() )
	{
/*		Hostent = gethostbyaddr(address, strlen(address), 0);
		if ( ! Hostent )
		{
			WriteLog("Wrong Hostent\n");
			Hostent = gethostbyname(address);
		}
*/
//		if (Hostent && Hostent->h_name)
//		{
			if (address)
			{
				GUWORD ipadd = inet_addr(address);
				char gg[128];
				sprintf(gg, "address: 0x%x\n", ipadd);
				WriteLog(gg);
				PeerAddr.sin_family = AF_INET;
				PeerAddr.sin_addr.S_un.S_addr = ipadd; //*(struct in_addr *)Hostent->h_name;
				PeerAddr.sin_port = htons(port);
				return connect(Socket, (sockaddr *)&PeerAddr, sizeof(sockaddr_in));
			}
//		}
	}
	return 0;
}

GSocket *GSocket::SockAccept()
{
	if ( Socket && IsErrorFree() )
	{
		int peerlen = sizeof (PeerAddr);
		GSocket *newsock = new GSocket();
		newsock->SetSocket( accept(Socket, (sockaddr *)&PeerAddr, &peerlen) );
//		WriteLog("name ");
//		WriteLog((char *)&PeerAddr.sin_addr);
//		WriteLog("\n");
		return newsock;
	}
	else return NULL;
}

#endif /* GSOCKET_CPP */
