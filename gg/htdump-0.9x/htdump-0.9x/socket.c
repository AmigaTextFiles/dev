/***************************************************************************\
**                                                                         **
**  htdump                                                                 **
**                                                                         **
**  Program to make http requests and redirect, save or pipe the output.   **
**  Ideal for automation and debugging.                                    **
**                                                                         **
**                                                                         **
**  By Ren Hoek (ren@arak.cs.hro.nl) Under Artistic License, 2000          **
**                                                                         **
\***************************************************************************/

/** globals: ssl, host, service
    need to be correctly initialised before calling OpenSocket()
***/







/***************************************************************************/
/** Includes                                                              **/

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>  /* ip_addr */

#include "global.h"

#if SSL_ENABLED
  #warning ----------------------------------
  #warning SSL ENABLED
  #warning ----------------------------------
  #include <openssl/ssl.h>
#endif





static unsigned int ConnectSocket(char *Host, char *Service, char *Protocol);
unsigned int OpenSocket(void);
unsigned int ReadSocket(unsigned int Socket, char *Buffer, unsigned int Length);
unsigned int WriteSocket(unsigned int Socket, char *Buffer, unsigned int Length);
void CloseSocket(unsigned int Socket);


#if SSL_ENABLED
  static SSL             *ssl_socket        = NULL;      /* Struct for SSL bookkeeping */
  static SSL_CTX         *ctx               = NULL;
#endif        




unsigned int OpenSocket(void)
{
/***************************************************************************/
/** Declare variables and pointers                                        **/

unsigned int       ssocket            = 0;


/***************************************************************************/
/** Initialise SSL stuff                                                  **/

if(CONFIG.ssl)                        /* SSL structs initialise, if using SSL     */
  {
  #if SSL_ENABLED
    SSLeay_add_ssl_algorithms();
    ctx=SSL_CTX_new(SSLv23_client_method());
    if(ctx == NULL)
      {
      fprintf(stderr, "\nError! Could not allocate memory for SSL CTX\n\n");
      exit(1);
      }
    ssl_socket=SSL_new(ctx);
  #else
    fprintf(stderr, "\nError! SSL not compiled into htdump, can not use SSL\n\n");
    exit(1);
  #endif
  }


/***************************************************************************/
/** Open (SSL) socket                                                     **/

ssocket = ConnectSocket(CONFIG.url_host, CONFIG.url_service, "tcp");   /* See connect.c           */


/* Take over the socket, all further communication is done with
   the SSL lib as a layer between the socket and the actual
   data send and read
*/

#if SSL_ENABLED
  if(CONFIG.ssl)
    {
    SSL_set_fd(ssl_socket, ssocket);
    if(SSL_connect(ssl_socket) == -1)
      {
      fprintf(stderr, "\nError! Could not SSL connect to server\n\n");
      exit(1);
      }
    if(CONFIG.debug)
      fprintf(stderr, "-------------------------------------\nSSL connection using %s\n", SSL_get_cipher(ssl_socket));
    }
#endif

return ssocket;

} /* End of SocketConnect() */





unsigned int WriteSocket(unsigned int Socket, char *Buffer, unsigned int Length)
{
unsigned int t = 0;

if(CONFIG.debug>1) Mem2Hex(Buffer, Length);

if(CONFIG.ssl)             /* Do either an SSL read or normal, effect is the same */
  {
  #if SSL_ENABLED
    t=SSL_write(ssl_socket, Buffer, Length);
  #endif
  }
  else
  t=write(Socket, Buffer, Length);

if(t==-1)  
  {
  fprintf(stderr, "\nError! Could not write request to server\n\n");
  exit(1);
  }

return t;

} /* End of WriteSocket() */






unsigned int ReadSocket(unsigned int Socket, char *Buffer, unsigned int Length)
{
unsigned int t = 0;

if(CONFIG.ssl)
  {
  #if SSL_ENABLED
    t = SSL_read(ssl_socket, Buffer, Length);
  #endif
  }
  else
  t = read(Socket, Buffer, Length);

if(t==-1)
  {
  fprintf(stderr, "\nError - Could not read from socket!\n\n");
  exit(1);
  }

return t;

} /* End of ReadSocket() */



void CloseSocket(unsigned int Socket)
{
#if SSL_ENABLED
  if(CONFIG.ssl) SSL_shutdown(ssl_socket);  /* send SSL/TLS close_notify */
#endif

close(Socket);

#if SSL_ENABLED
  SSL_free(ssl_socket);
  SSL_CTX_free(ctx);
#endif

} /* End of CloseSocket() */







/***************************************************************************\
**                                                                         **
**    ConnectSocket(...)                                                   **
**                                                                         **
**    Host      - Name or IP address of the target machine                 **
**    Service   - Name or number of the service (eg. www)                  **
**    Protocol  - Name of the protocol to use (either tcp or udp)          **
**                                                                         **
**    Returns a unsigned int, namely the socket handler.                   **
**                                                                         **
**                                                                         **
**    This function will exit the program with errorcode:                  **
**                                                                         **
**    1 - Specified wrong argument for the socket to connect to            **
**    2 - Network error                                                    **
**                                                                         **
\***************************************************************************/


static unsigned int ConnectSocket(char *Host, char *Service, char *Protocol)
{
struct hostent      *phe;      /* pointer to host information entry    */
struct servent      *pse;      /* pointer to service information entry */
struct protoent     *ppe;      /* pointer to protocol information entry*/
struct sockaddr_in   ssin;     /* an Internet endpoint address         */
unsigned int         s;        /* socket descriptor                    */
unsigned int         type;     /* socket type                          */


/* clean the 'sin' struct */
bzero((char *)&ssin, sizeof(ssin));

/* define type Internet in 'sin' */
ssin.sin_family = AF_INET;

/* map service name to port number */
if((pse=getservbyname(Service, Protocol))) 
  ssin.sin_port = pse->s_port;
  else
  {
  if( (ssin.sin_port=htons((u_short)atoi(Service))) == 0)
    {
    fprintf(stderr, "\nCannot get service number for [%s]\n\n", Service);
    exit(1);
    }
  }

/* map host name to IP address, allowing for dotted decimal */
if((phe=gethostbyname(Host)))
  bcopy(phe->h_addr, (char *)&ssin.sin_addr, phe->h_length);
  else
  {
  if( (ssin.sin_addr.s_addr = inet_addr(Host)) == INADDR_NONE)
    {
    fprintf(stderr, "\nCannot get IP number for [%s]\n\n", Host);
    exit(1);
    }
  }

/* map protocol name to protocol number */
if( (ppe=getprotobyname(Protocol)) == 0)
  {
  fprintf(stderr, "\nWrong protocol specified [%s]\n\n", Protocol);
  exit(1);
  }

/* use protocol to choose a socket type */
if(strcmp(Protocol, "udp") == 0)
  type = SOCK_DGRAM;
  else
  type = SOCK_STREAM;

/* allocate a socket */
s=socket(PF_INET, type, ppe->p_proto);
if(s==-1)
  {
  fprintf(stderr, "\nCannot create socket\n\n");
  exit(2);
  }

/* connect the socket */
if(connect(s, (struct sockaddr *)&ssin, sizeof(ssin)) == -1)
  {
  fprintf(stderr, "\nCannot connect to [%s:%s]\n\n", Host, Service);
  exit(2);
  }

return s;
}
