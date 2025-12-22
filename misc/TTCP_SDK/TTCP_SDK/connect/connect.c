/*
 * This is a simple program that shows the basics of creating, connecting to 
 * and getting data from a socket
 *
 */


#include <pragmas/tsocket_pragmas.h>
#include <proto/tsocket.h>

struct Library *TSocketBase;

#include <exec/libraries.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define BUFFSIZE 256

void ReadSocket(int sock);


int main(int argc, char *argv[])
{

    char *hostname;    
    struct sockaddr_in hostaddr;
    struct hostent *host;
    struct servent *service;
    fd_set sockmask, readmask;
    int sock;

    if ( argc < 2 )
    {
        printf("usage: %s <host>\n", argv[0]);
        return 10;
    }

    hostname = argv[1];


    if ( !(TSocketBase = OpenLibrary("tsocket.library", 0)) )
    {
        printf("TermiteTCP is not running.\n");
        return 10;
    }

    printf("\nUsing: %s\n", TSocketBase->lib_IdString);

    /*
     * Create an internet stream socket
     */

    if ( (sock = socket(AF_INET, SOCK_STREAM, 0)) != -1 )
    {
        /* 
         * See if the hostname is numerical or alphanumeric
         */

        if ( (hostaddr.sin_addr.s_addr = inet_addr(hostname)) == INADDR_NONE )
        {
            /* 
             * hostname is not a dotted numerical address, look it up as a name
             */

            if ( (host = gethostbyname(hostname)) != NULL )
            {
                /*
                 * We found it.  Copy out the numerical address.
                 */

                CopyMem(host->h_addr, &hostaddr.sin_addr, host->h_length);
            }
            else
            {
                printf("host not found: %s\n", hostname);

                /* Do the following to flag an error */

                hostname[0] = NULL;
            }
        }

        /* if no error occurred above */

        if ( hostname[0] )
        {
            /*
             * Look up the service (port) number for ftp
             */           

            if ( (service = getservbyname("ftp", "tcp")) != NULL )
            {
                hostaddr.sin_port   = service->s_port;
                hostaddr.sin_family = AF_INET;
    
                /*
                 * Now try to connect to it
                 */

                if ( (connect(sock, 
                                (struct sockaddr *)&hostaddr, 
                                sizeof(struct sockaddr_in))) != -1 )
                {
                    printf("Connected to %s\n", hostname);

                    /*
                     * Create an fdset (sockmask), consisting of just
                     * one socket (sock).
                     */

                    FD_ZERO(&sockmask);
                    FD_SET(sock, &sockmask);

                    /*
                     * Wait for a socket in our fdset to become 
                     * readable.
                     */

                     readmask = sockmask;

                     if ( (WaitSelect(2, &readmask, NULL, NULL, NULL, NULL)) != -1 )
                     {
                         /* sock is in the readable set? */
    
                         if ( FD_ISSET(sock, &readmask) )
                             ReadSocket(sock);
                     }
                     else
                     {
                         printf("Aborted.\n");
                     }

                }
                else
                    printf("Can't connect to %s\n", hostname);
            }
            else
                printf("unknown service: telnet\n");
        }

        CloseSocket(sock);
    }
    else
        printf("Can't create socket.\n");

#ifndef TERMITE_TCP
    CloseLibrary(SocketBase);
#else
    CloseLibrary(TSocketBase);
#endif       

    return 0;
}


void ReadSocket(int sock)
{
    int bytesleft, bytesrecvd;
    unsigned char buff[BUFFSIZE];
    static BPTR output = NULL;

    while ( 1 )
    {
        /*
         * See how many bytes remain to be read.
         */

        if ( (IoctlSocket(sock, FIONREAD, (char *)&bytesleft)) == -1 )
        {
            printf("ioctl error\n");
            break;
        }

        if ( bytesleft <= 0 )
            break;

        /*
         * Take precautions to avoid overflowing our buffer
         */
    
        if ( bytesleft > BUFFSIZE )
            bytesleft = BUFFSIZE;

        /*
         * Read bytes from socket
         */

        bytesrecvd = recv(sock, buff, bytesleft, 0);

        if ( bytesrecvd == -1 )
        {
            printf("recv error\n");
            break;
        }
        
        /*
         * Dump any bytes received from socket
         */

        if ( bytesrecvd > 0 )
        {
            if ( !output )
                output = Output();
        
            Write(output, buff, bytesrecvd);
        }
    }
}
