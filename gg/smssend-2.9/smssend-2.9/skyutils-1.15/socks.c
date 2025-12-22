/****************************************************************/
/* Socket unit - TCP/UDP                                        */
/* (c) Christophe CALMEJANE (Ze KiLleR) - 1999-01               */
/****************************************************************/

#undef malloc
#undef calloc
#undef realloc
#undef strdup
#undef free

#include "skyutils.h"

#define SOCKET_VERSION "0.28"

int SU_GetPortByName(char *port,char *proto) {
   struct servent *PSE;

   PSE = getservbyname(port,proto);
   if( PSE == NULL )
      return atoi(port);
   return ntohs(PSE->s_port);
}

char *SU_GetMachineName(char *RemoteHost) {
   char *tmp,*tmp2;
   tmp = strchr(RemoteHost,'.');
   if( tmp == NULL )
   {
     return strdup(RemoteHost);
   }
   tmp2 = (char *)malloc(tmp-RemoteHost+1);
   SU_strcpy(tmp2,RemoteHost,tmp-RemoteHost+1);
   return tmp2;
}

char *SU_NameOfPort(char *Host) {
   struct hostent *hp;
   struct in_addr inp;

   inp.s_addr = inet_addr(Host);
   if( inp.s_addr == INADDR_NONE )
     return NULL;
   hp = gethostbyaddr((char *)&inp,4,AF_INET);
   if( hp == NULL)
     return NULL;
   return hp->h_name;
}

char *SU_AdrsOfPort(char *Host) {
  struct hostent *hp;
  struct in_addr inp;

  hp = gethostbyname(Host);
  if( hp == NULL)
    return NULL;
  memcpy((void *)&inp, hp->h_addr, hp->h_length);
  return inet_ntoa(inp);
}

//------------------------------------------------------------
SU_PServerInfo SU_CreateServer(int port,int type,bool ReUseAdrs)
{
  SU_PServerInfo SI;
  int len;

  SI = (SU_PServerInfo) malloc(sizeof(SU_ServerInfo));
  memset(SI,0,sizeof(SU_ServerInfo));
  if( type == SOCK_STREAM )
    SI->sock = socket(AF_INET,type,getprotobyname("tcp")->p_proto);
  else if( type == SOCK_DGRAM )
    SI->sock = socket(AF_INET,type,getprotobyname("udp")->p_proto);
  else
    return NULL;
  if( SI->sock == -1 ) {
    free(SI);
    return NULL;
  }
  memset(&(SI->SAddr),0,sizeof(struct sockaddr_in));
#ifdef __unix__
  if(ReUseAdrs)
  {
    len = sizeof(struct sockaddr_in);
    if( getsockname(SI->sock,(struct sockaddr *)&(SI->SAddr),&len) == -1 ) {
      close(SI->sock);
      free(SI);
      return NULL;
    }
    len = 1;
    setsockopt(SI->sock,SOL_SOCKET,SO_REUSEADDR,(char *)&len,sizeof(len));
  }
#endif
  SI->SAddr.sin_family = AF_INET;
  SI->SAddr.sin_port = htons(port);
  SI->SAddr.sin_addr.s_addr = 0;
  if( bind(SI->sock,(struct sockaddr *)&(SI->SAddr), sizeof(SI->SAddr)) == -1 ) {
#ifdef __unix__
    close(SI->sock);
#else
    closesocket(SI->sock);
#endif
    free(SI);
    return NULL;
  }

#ifdef _WIN32
  if(ReUseAdrs)
  {
    len = sizeof(struct sockaddr_in);
    if( getsockname(SI->sock,(struct sockaddr *)&(SI->SAddr),&len) == -1 ) {
      closesocket(SI->sock);
      free(SI);
      return NULL;
    }
    len = 1;
    setsockopt(SI->sock,SOL_SOCKET,SO_REUSEADDR,(char *)&len,sizeof(len));
  }
#endif

  return SI;
}

int SU_ServerListen(SU_PServerInfo SI) {
  if( SI == NULL )
    return SOCKET_ERROR;
  if( listen(SI->sock,5) == -1 )
    return SOCKET_ERROR;
  return 0;
}

SU_PClientSocket SU_ServerAcceptConnection(SU_PServerInfo SI) {
  struct sockaddr sad;
  int len;
  int tmpsock;
  SU_PClientSocket CS;

  if( SI == NULL)
    return NULL;
  len = sizeof(sad);
  tmpsock = accept(SI->sock,&sad,&len);
  if( tmpsock == -1 )
    return NULL;
  CS = (SU_PClientSocket) malloc(sizeof(SU_ClientSocket));
  memset(CS,0,sizeof(SU_ClientSocket));
  CS->sock = tmpsock;
  memcpy(&CS->SAddr,&sad,sizeof(CS->SAddr));
  return CS;
}

void SU_ServerDisconnect(SU_PServerInfo SI) {
  if( SI == NULL )
    return;
#ifdef __unix__
  close(SI->sock);
#else
  closesocket(SI->sock);
#endif
}

//------------------------------------------------------------
SU_PClientSocket SU_ClientConnect(char *adrs,char *port,int type) {
  struct servent *SE;
  struct sockaddr_in sin;
  struct hostent *HE;
  SU_PClientSocket CS;

  CS = (SU_PClientSocket) malloc(sizeof(SU_ClientSocket));
  memset(CS,0,sizeof(SU_ClientSocket));
  if( type == SOCK_STREAM )
    CS->sock = socket(AF_INET,SOCK_STREAM,getprotobyname("tcp")->p_proto);
  else if( type == SOCK_DGRAM )
    CS->sock = socket(AF_INET,SOCK_DGRAM,getprotobyname("udp")->p_proto);
  else
    return NULL;
  if( CS->sock == -1 ) {
    free(CS);
    return NULL;
  }
  sin.sin_family = AF_INET;
  if( type == SOCK_STREAM )
    SE = getservbyname(port,"tcp");
  else if( type == SOCK_DGRAM )
    SE = getservbyname(port,"udp");
  else
    return NULL;
  if( SE == NULL)
    sin.sin_port = htons(atoi(port));
  else
    sin.sin_port = SE->s_port;
  sin.sin_addr.s_addr = inet_addr(adrs);
  if( sin.sin_addr.s_addr == INADDR_NONE ) {
    HE = gethostbyname(adrs);
    if( HE == NULL )
    {
      printf("SkyUtils_ClientConnect : Unknown Host : %s\n",adrs);
      return NULL;
    }
    sin.sin_addr = *(struct in_addr *)(HE->h_addr_list[0]);
  }
  if( connect(CS->sock,(struct sockaddr *)(&sin),sizeof(sin)) == -1 ) {
#ifdef __unix__
    close(CS->sock);
#else
    closesocket(CS->sock);
#endif
    free(CS);
    return NULL;
  }
  memcpy(&CS->SAddr,&sin,sizeof(CS->SAddr));
  return CS;
}

int SU_ClientSend(SU_PClientSocket CS,char *msg) {
  if( CS == NULL )
    return SOCKET_ERROR;
  return send(CS->sock,msg,strlen(msg),SU_MSG_NOSIGNAL);
}

int SU_ClientSendBuf(SU_PClientSocket CS,char *buf,int len) {
  if( CS == NULL )
    return SOCKET_ERROR;
  return send(CS->sock,buf,len,SU_MSG_NOSIGNAL);
}

//------------------------------------------------------------
int SU_UDPSendBroadcast(SU_PServerInfo SI,char *Text,int len,char *port) {
  struct sockaddr_in sin;
  int i,si;
  int total = 0,packet;

  if( SI == NULL )
    return SOCKET_ERROR;
  si = sizeof(int);
  if( getsockopt(SI->sock,SOL_SOCKET,SO_BROADCAST,&i,&si) == SOCKET_ERROR )
    return SOCKET_ERROR;
  if( i == 0 )
  {
    i = 1;
    if(SU_SetSocketOptions(SI->sock,SOL_SOCKET,SO_BROADCAST) == -1)
      return SOCKET_ERROR;
    if( getsockopt(SI->sock,SOL_SOCKET,SO_BROADCAST,&i,&si) == SOCKET_ERROR )
      return SOCKET_ERROR;
  }
  sin.sin_family = AF_INET;
  sin.sin_port = htons(SU_GetPortByName(port,"udp"));
  sin.sin_addr.s_addr = INADDR_BROADCAST;

  while(len > 0)
  {
    packet = len;
    if(packet > SU_UDP_MAX_LENGTH)
      packet = SU_UDP_MAX_LENGTH;
    i += sendto(SI->sock,Text,len,0,(struct sockaddr *)&sin,sizeof(sin));
    total += packet;
    len -= packet;
    if(len != 0)
#ifdef _WIN32
      Sleep(500);       /* Sleep for 500 msec */
#else /* _WIN32 */
      usleep(500*1000); /* Sleep for 500 msec */
#endif /* _WIN32 */
  }
  return i;
}

int SU_UDPSendToAddr(SU_PServerInfo SI,char *Text,int len,char *Addr,char *port) {
  int i,si;
  struct sockaddr_in sin;
  struct hostent *PHE;
  int total = 0,packet;

  if( SI == NULL )
    return SOCKET_ERROR;
  si = sizeof(int);
  sin.sin_addr.s_addr = inet_addr(Addr);
  if( sin.sin_addr.s_addr == INADDR_NONE )
  {
    PHE = gethostbyname(Addr);
    if( PHE == NULL )
      return SOCKET_ERROR;
    sin.sin_addr = *(struct in_addr *)(PHE->h_addr_list[0]);
  }
  if( getsockopt(SI->sock,SOL_SOCKET,SO_BROADCAST,&i,&si) == SOCKET_ERROR )
    return SOCKET_ERROR;
  if( i == 0 )
  {
    i = 1;
    if( getsockopt(SI->sock,SOL_SOCKET,SO_BROADCAST,&i,&si) == SOCKET_ERROR )
      return SOCKET_ERROR;
  }
  sin.sin_family = AF_INET;
  sin.sin_port = htons(SU_GetPortByName(port,"udp"));

  i = 0;
  while(len > 0)
  {
    packet = len;
    if(packet > SU_UDP_MAX_LENGTH)
      packet = SU_UDP_MAX_LENGTH;
    i += sendto(SI->sock,Text+total,packet,0,(struct sockaddr *)&sin,sizeof(sin));
    total += packet;
    len -= packet;
    if(len != 0)
#ifdef _WIN32
      Sleep(500);       /* Sleep for 500 msec */
#else /* _WIN32 */
      usleep(500*1000); /* Sleep for 500 msec */
#endif /* _WIN32 */
  }
  return i;
}

int SU_UDPSendToSin(SU_PServerInfo SI,char *Text,int len,struct sockaddr_in sin) {
  int i = 0;
  int total = 0,packet;

  if( SI == NULL )
    return SOCKET_ERROR;
  while(len > 0)
  {
    packet = len;
    if(packet > SU_UDP_MAX_LENGTH)
      packet = SU_UDP_MAX_LENGTH;
    i += sendto(SI->sock,Text+total,packet,0,(struct sockaddr *)&sin,sizeof(struct sockaddr_in));
    total += packet;
    len -= packet;
    if(len != 0)
#ifdef _WIN32
      Sleep(500);       /* Sleep for 500 msec */
#else /* _WIN32 */
      usleep(500*1000); /* Sleep for 500 msec */
#endif /* _WIN32 */
  }
  return i;
}

int SU_UDPReceiveFrom(SU_PServerInfo SI,char *Text,int len,char **ip,int Blocking) {
   struct sockaddr_in sin;
   int ssin;
   int i;
   struct hostent *hp;

  if( SI == NULL )
    return SOCKET_ERROR;
   if(!Blocking)
   {
#ifndef _WIN32
     fcntl(SI->sock,F_SETFL,O_NONBLOCK);
#endif
   }
   ssin = sizeof(sin);
   i = recvfrom(SI->sock,Text,len,SU_MSG_NOSIGNAL,(struct sockaddr *)&sin,&ssin);
   if( i == SOCKET_ERROR )
     return SOCKET_ERROR;

   hp = gethostbyaddr((char *)&sin.sin_addr,4,AF_INET);
   if( hp == NULL )
     return i;
   *ip = (char *)hp->h_name;

   return i;
}

int SU_UDPReceiveFromSin(SU_PServerInfo SI,char *Text,int len,struct sockaddr_in *ret_sin,int Blocking) {
   struct sockaddr_in sin;
   int i;
   int ssin;

  if( SI == NULL )
    return SOCKET_ERROR;
   if(!Blocking)
   {
#ifndef _WIN32
     fcntl(SI->sock,F_SETFL,O_NONBLOCK);
#endif
   }
   ssin = sizeof(sin);
   i = recvfrom(SI->sock,Text,len,SU_MSG_NOSIGNAL,(struct sockaddr *)&sin,&ssin);
   if( i == SOCKET_ERROR )
     return SOCKET_ERROR;

   memcpy(ret_sin,&sin,sizeof(sin));

   return i;
}

int SU_SetSocketOptions(int sock,int Level,int Opt)
{
  int value = 1;

  return setsockopt(sock,Level,Opt,(char *)&value,sizeof(int));
}

#ifdef _WIN32
bool SU_WSInit(int Major,int Minor)
{
  WORD wVersionRequested;
  WSADATA wsaData;
  int err;

  wVersionRequested = MAKEWORD( Major, Minor );
  err = WSAStartup(wVersionRequested,&wsaData);
  if(err != 0)
    return false;
  if ( LOBYTE( wsaData.wVersion ) != 2 || HIBYTE( wsaData.wVersion ) != 2 )
  {
    WSACleanup();
    return false;
  }
  return true;
}

void SU_WSUninit(void)
{
  WSACleanup();
}
#endif
