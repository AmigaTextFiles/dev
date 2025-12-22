/*
 * connect.c V1.0.00
 *
 * UMS NNTP/SMTP create connection to a remote host
 *
 * (c) 1994-97 Stefan Becker
 */

#include "common.h"

/* Initialize date for remote connections */
BOOL GetConnectData(struct ConnectData *cd, const char *service)
{
 BOOL rc = TRUE;

 /* Is service name a port number? */
 if ((cd->cd_Port = strtol(service, NULL, 10)) == 0) {
  struct Library *SocketBase = cd->cd_SocketBase;
  struct servent *se;

  /* No, get port number by service name */
  if (se = GetServByName(service, "tcp"))
   cd->cd_Port = se->s_port;

  /* Unknown service */
  else
   rc = FALSE;
 }

 return(rc);
}

/* Free connection data */
void FreeConnectData(struct ConnectData *cd)
{
}

/* Create a connection to a remote host */
ULONG ConnectToHost(struct ConnectData *cd, const char *host)
{
 struct Library *SocketBase = cd->cd_SocketBase;
 ULONG rc                   = CONNECT_NOT_POSSIBLE;
 LONG NewSocket;

 /* Create socket */
 if ((NewSocket = Socket(PF_INET, SOCK_STREAM, 0)) >= 0) {
  struct hostent *he;

  /* Get address of host */
  if (he = GetHostByName(host)) {
   char **addrlist = he->h_addr_list;
   char *addr;

   /* Host is known, but may be not available */
   rc = CONNECT_NOT_AVAILABLE;

   /* Try to connect to the next address in the list */
   while (addr = *addrlist++) {

    /* Set socket address */
    cd->cd_Address.sin_family = AF_INET;
    cd->cd_Address.sin_port   = cd->cd_Port;
    memcpy(&cd->cd_Address.sin_addr, addr, he->h_length);

    /* Connect to remote host */
    if (Connect(NewSocket, (struct sockaddr *) &cd->cd_Address,
                           sizeof(struct sockaddr)) >= 0) {

     /* We are connected now */
     cd->cd_Socket = NewSocket;
     rc            = CONNECT_OK;
     break;
    }
   }
  }

  /* Close socket on error */
  if (rc != CONNECT_OK) CloseSocket(NewSocket);
 }

 return(rc);
}

/* Close connection to a remote host */
void CloseConnection(struct ConnectData *cd)
{
 struct Library *SocketBase = cd->cd_SocketBase;
 LONG OldSocket             = cd->cd_Socket;

 /* Send QUIT command */
 Send(OldSocket, "QUIT\r\n", 6, 0);

 /* Shut down connection */
 Shutdown(OldSocket, 2);

 /* Delete socket */
 CloseSocket(OldSocket);
}
