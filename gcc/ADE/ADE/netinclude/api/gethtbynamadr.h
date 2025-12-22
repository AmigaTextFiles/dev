#ifndef API_GETHTBYNAMADR_H
#define API_GETHTBYNAMADR_H

#ifndef API_AMIGA_API_H 
#include <api/amiga_api.h>
#endif


struct hostent * _gethtbyname(struct SocketBase * libPtr,
			      const char * name);
struct hostent * _gethtbyaddr(struct SocketBase * libPtr,
			      const char * addr, int len, int type);

#endif /* API_GETHTBYNAMADR_H */

