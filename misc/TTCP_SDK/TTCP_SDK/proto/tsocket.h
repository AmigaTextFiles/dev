/*
 * tsocket_protos.h
 */

#ifndef _TSOCKET_PROTOS_H
#define _TSOCKET_PROTOS_H

#include <sys/types.h>

int accept(
        int                   Socket,
        struct sockaddr      *Addr,
        int                  *AddrLen);

int bind(
        int                   Socket,
        char                 *Name,
        int                   NameLen);

int CloseSocket(
        int                   Socket);

int connect(
        int                   Socket,
        struct sockaddr      *Name,
        int                   NameLen);

struct hostent *gethostbyaddr(
        char                 *Addr,
        int                   Length,
        int                   Type);


struct hostent *gethostbyname(
        char                 *Name);

unsigned long gethostid(void);	

int gethostname(
        char                 *hostname,
        int                   size);

struct protoent *getprotobyname(
        char                 *Name);

struct protoent *getprotobynumber(
        int                   Number);

struct servent *getservbyname(
        char                 *Service,
        char                 *Protocol);

int getsockname(
        int                   Socket,
        char                 *Buf,
        int                  *BufLen);

int inet_addr(
        char                 *Addr);

char *inet_ntoa(
        long                  Addr);

int IoctlSocket(
        int                   Socket,
        int                   cmd,
        char                 *data);

int listen(
        int                   Socket,
        int                   BackLog);

int recv(
        int                   Socket,
        char                 *Buffer,
        int                   Length,
        int                   Flags);

int recvfrom(
        int                   s,
        char                 *buf,
        int                   len,
        int                   flags,
        char                 *from,
        int                  *fromlenaddr);

int send(
        int                   Socket,
        char                 *Msg,
        int                   Length,
        int                   Flags);

int sendto(
        int                   s,
        char                 *buf,
        int                   len,
        int                   flags,
        char                 *to,
        int                   tolen);

void SetErrnoPtr(
        int                  *ErrnoPtr);

void SetSocketSignals(
        unsigned long        IntrMask,
        unsigned long        IOMask,
        unsigned long        UrgMask);

int setsockopt(
        int                   s,
        int                   level,
        int                   name,
        char                 *val,
        int                   valsize);

int shutdown(
        int                   s,
        int                   How);

int socket(
        int                   Domain,
        int                   Type,
        int                   Protocol);

int SocketBaseTagList(
        struct TagItem       *tagList);	

int WaitSelect(
        int                   NumFDS,
        fd_set               *ReadFDS,
        fd_set               *WriteFDS,
        fd_set               *ExceptFDS,
        struct timeval       *Timeout,
        unsigned long        *Signals);

#define select(a, b, c, d, e) WaitSelect(a, b, c, d, e, NULL)

#endif /* !_TSOCKET_PROTOS_H */

