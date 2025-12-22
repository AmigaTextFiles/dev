/*
 * amissltest - probe 
 * by megacz@usa.com
 *
 * This example demonstrates how to use already initialised base of
 * 'bsdsocket.library' in 'ixemul' and resolve real socket, so that
 * 'AmiSSL' can be fully operational without inlining or gluing to
 * TCP/IP stack directly. This has big advantages, cuz you do not
 * need to perform hardcore hacking on the program to make it work,
 * plus you will be as close to thread-safe model as possible thru
 * 'ixemul' + HScM'ed(Hard Syscall Mapping) 'pthreads'. 
 *
 * Please note 'AmiSSL' itself is not thread-safe! Functions like
 * 'SSL_write()' or 'SSL_read()' wont allow contexts to be switched,
 * however you can improvise and after each call enforce it with
 * 'pthread_switch_me()' - see bonus dir. in 'pthreads' package -.
 *
 * Important! Dont call 'CloseLibrary(SocketBase)' !
 *
 * Also important! Always setup your own CTRL_C handler when using
 * 'AmiSSL', cuz when you quit unexpectedly while it is initialised
 * and some callback or other crap is being processed then your
 * Miggy might get pranoid and commit suicide, due no code space.
 * So, if you want to quit, then remeber to clean up first.
 *
 * And some remark. Using 'AmiSSL' from under the 'ixlibrary' gives
 * you the ability to interrupt the process anytime you like without
 * the need of shielding it first with 'signal()', its because 
 * 'ixlibrary' takes care of init and cleanup - study this package
 * more closely to fully understand.
 *
 * And yet a warning! Initialisation from under the 'ixlibrary' with
 * 'ixemul_errno' clobbers the 'errno' of network functions like:
 * 'connect()' or accept(), i think that few others too. It will be
 * always 0, no matter if function failed or succeded! To solve that
 * problem define bases only and initialise in the process.
 *
 * To test try:
 *
 *    amissltest[ix] google.com 443
 *
 * SSL test stuff ripped from 'https.c' example file that is a part
 * of 'AmiSSL'.
 *
*/



#ifndef SHAREDLIB_BIN
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/signal.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <errno.h>

//###
//### 'timeval' conflict workaround
//###
#define DEVICES_TIMER_H 1

#include <proto/exec.h>
#include <exec/types.h>
#include <proto/dos.h>
#include <dos/dostags.h>
#include <dos/dosextens.h>
#include <utility/tagitem.h>

//###
//### AmiSSL API stuff
//###
#include <proto/amisslmaster.h>
#include <proto/amissl.h>
#include <libraries/amisslmaster.h>
#include <libraries/amissl.h>
#include <amissl/amissl.h>

//###
//### workaround common problems
//###
#include <fixamissl.h>

//###
//### native socket support
//###
#include <asiheader.h>



#ifndef SHAREDLIB
struct Library *AmiSSLMasterBase = NULL;
struct Library *AmiSSLBase = NULL;
struct Library *SocketBase = NULL;



void unix_control_c_handler(int signo) 
{
  Signal(FindTask(0L), SIGBREAKF_CTRL_C); 
}

int main(int argc, char **argv)
#else
int amissltestmain(int argc, char **argv)
#endif
{
  struct sockaddr_in sin;
  struct sockaddr *sa;
  struct hostent *he;
  int port;
  int sock;
  int natsock;
  int ssl_errno;
  X509 *server_cert;
  SSL_CTX *ctx;
  SSL *ssl;
  char *string;
  char buffer[2048];
  const char *request = "GET / HTTP/1.0\r\n\r\n";
  unsigned long rc = 5;


#ifndef SHAREDLIB
  //### own control_c handler is a must in this code or else
  //### there will be nasty side effects, like alerts or gurus!
  //###
  if((signal(SIGINT, &unix_control_c_handler)) == SIG_ERR) 
  { 
    printf(" *** cannot attach SIGINT to this process!\n"); 
    return rc;
  }
#endif

  //###
  //### check for args
  //### 
  if (argc >= 2)
  {

#ifndef SHAREDLIB
    //###
    //### attach SocketBase from 'ixnet.library'
    //### 
    if ((SocketBase = ns_ObtainBSDSocketBase()))
    {
      printf(" /// 'ixnet.library' SocketBase attached.\n");

      //###
      //### initialise AmiSSL
      //###
      if ((AmiSSLMasterBase = OpenLibrary("amisslmaster.library", AMISSLMASTER_MIN_VERSION)))
      {
        if ((InitAmiSSLMaster(AMISSL_CURRENT_VERSION, TRUE)))
        {
          if ((AmiSSLBase = OpenAmiSSL()))
          {
            if (InitAmiSSL(AmiSSL_ErrNoPtr, (LONG)&errno, AmiSSL_SocketBase, (LONG)SocketBase, TAG_DONE, 0) == 0)
            {
              SSLeay_add_ssl_algorithms();

              SSL_load_error_strings();
#endif

              if ((ctx = SSL_CTX_new(SSLv23_client_method())))
              {
                SSL_CTX_set_default_verify_paths(ctx);

                SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER | SSL_VERIFY_FAIL_IF_NO_PEER_CERT, NULL);

                if ((ssl = SSL_new(ctx)))
                {
                  printf(" /// AmiSSL initialised.\n");

                  //###
                  //### check port
                  //###
                  port = atoi(argv[2]);
              
                  if ((port != 0) && (port < 65536))
                  {
                    //###
                    //### create standard socket
                    //###
                    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) >= 0 )
                    {
                      printf(" /// socket created successfully.\n");

                      //###
                      //### obtain real socket
                      //###
                      if ((natsock = ns_ObtainBSDSocketFD(sock)) >= 0)
                      {
                        printf(" /// native socket has been obtained.\n");

                        printf(" /// resolving '%s' ... \n", argv[1]);

                        //###
                        //### resolve host, prepare stuff, and try to connect
                        //###
                        if ((he = gethostbyname(argv[1])))
                        {
                          memset(&sin, 0, sizeof(sin));
                    
                          memcpy(&sin.sin_addr,he->h_addr,he->h_length);
  
                          sin.sin_len=sizeof(sin);
                          sin.sin_family=AF_INET;
                          sin.sin_port = htons(port);
                    
                          sa=(struct sockaddr *)&sin;
                    
                          if((connect(sock, sa, sa->sa_len)) >= 0)
                          {
                            printf(" /// connected to '%s' on port %s .\n", argv[1], argv[2]);
  
                            //###
                            //### handshake with SSL, all SSL related ops start here
                            //###
                            SSL_set_fd(ssl, natsock);
      
                            if ((ssl_errno = SSL_connect(ssl)) >= 0)
                            {
                              printf(" /// SSL_connect() successful.\n");
  
                              rc = 0;
  
                              //###
                              //### code below has been taken from AmiSSL example file('https.c').
                              //###
                              /* Certificate checking. This example is *very* basic */
                              if ((server_cert = SSL_get_peer_certificate(ssl)))
                              {
                                printf(" /// dumping server certificate and some info...\n\n");
  
                                if ((string = X509_NAME_oneline(X509_get_subject_name(server_cert), 0, 0)))
                                {
                                  printf("Subject: %s\n", string);
  
                                  OPENSSL_free(string);
                                }
                                else
                                  printf(" !!! warning: couldn't read subject name in certificate!\n");
  
                                if ((string = X509_NAME_oneline(X509_get_issuer_name(server_cert), 0, 0)))
                                {
                                  printf("Issuer: %s\n", string);
  
                                  OPENSSL_free(string);
                                }
                                else
                                  printf(" !!! warning: couldn't read issuer name in certificate!\n");
  
                                X509_free(server_cert);
  
                                /* Send a HTTP request. Again, this is just
                                 * a very basic example.
                                 */
                                if ((ssl_errno = SSL_write(ssl, request, strlen(request))) > 0)
                                {
                                  /* Dump everything to output */
                                  while ((ssl_errno = SSL_read(ssl, buffer, sizeof(buffer) - 1)) > 0)
                                       fwrite(buffer, 1, ssl_errno, stdout);
  
                                  fflush(stdout);
                                }
                                else
                                  printf(" !!! couldn't write request!\n");
                              }
                            }
                            //###
                            //### real error indication
                            //###
                            else
                              printf(" *** unable to SSL_connect() = %d, errno = %d!\n", SSL_get_error(ssl, ssl_errno) , errno);
                          }
                          else
                            printf(" *** unable to connect to '%s'!\n", argv[1]);
                        }
                        else
                          printf(" *** unable to resolve '%s'!\n", argv[1]);
                      }
                      else
                        printf(" *** unable to obtain native socket!\n");

                      close(sock);
                    }
                    else
                      printf(" *** unable to create socket!\n");
                  }
                  else
                    printf(" *** <port> is out of range!\n");
                }
                else
                  printf(" *** unable to setup AmiSSL context!\n");
              }
              else
                printf(" *** unable to create AmiSSL context!\n");

#ifndef SHAREDLIB
              CleanupAmiSSL(TAG_DONE);
            }
            else
              printf(" *** couldn't initialize AmiSSL!\n");
                
            CloseAmiSSL();
          }
          else
            printf(" *** couldn't open AmiSSL!\n");
        }
        else
          printf(" *** error, AmiSSL version is too old!\n");

        CloseLibrary(AmiSSLMasterBase);
      }
      else
        printf(" *** cant open 'amisslmaster.library' V%d+ !\n", AMISSLMASTER_MIN_VERSION);
    }
    else
      printf(" *** unable to attach SocketBase from 'ixnet.library'!\n");
#endif

  }
  else
    printf(" *** template: amissltest <address> <port>\n");

  return rc;
}
#else
int amissltestmain(int, char **);

int main(int argc, char **argv)
{
  return amissltestmain(argc, argv);
}
#endif
