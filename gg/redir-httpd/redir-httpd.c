/***

 redir-httpd is an ultra-minimalist, non-RFC-compliant HTTP server that
 will ONLY issue redirects to another site. It's good for running on
 home systems that have permanent connectivity (i.e. DSL and cable-modem
 subscribers). It should be short enough to be easily understood (and
 thus audited for potential security issues), and still fairly robust.

 It *is* vulnerable to DOS attacks, but what the hell. I wrote it
 in like a half-hour.

 Its testing consists of, well, my system. Reports and bugs are welcome.
 Email 'em to dave@bureau42.com or dave@technopagan.org.

 All configuration is done via the list of #define statements below.

 To compile: try something like gcc redir-httpd.c -o redir-httpd

 To run it in standalone: just put something like
   /usr/sbin/redir-httpd &
   in your favorite system startup script.
 To run it from inetd: Uh, I dunno. Anyone?

 (C)2001 David E. Smith <dave@bureau42.com> . Released under GNU GPL v2.

***/

#define SERVER_ADMIN "dave@bureau42.com"
// #define SERVER_TARGET "http://www.bureau42.com/"
#define SERVER_TARGET "http://amigaonly.ahol.com"
#define SERVER_PORT 80
#define ERROR_CODE 302

/* A note on the ERROR_CODE: 301 is "Moved Permanently", 302 is "Found"
   (i.e. a temporary redirect), and 303 is "See Other". 303 is probably
   the most "correct" one to use, but Netscape doesn't like it. I 
   default to using 302, but hey, it's your server... */

#define LOGGING 1

/* if LOGGING is defined, we'll record some stuff to syslog. Recommended. */

#define STANDALONE 1
/* if STANDALONE, well, you figure it out (as opposed to running from
   inetd or similar). The standalone memory footprint should be small
   enough that you'll not need to run from inetd, though you may want
   to do so for tcpwrappers or somesuch. */

/* no user-serviceable parts below this point */

#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#ifdef LOGGING
  #include <syslog.h>
#endif

#define TRUE 1
#define FALSE !TRUE
#define SERVER_NAME "redir-httpd"
#define SERVER_VERSION "0.1.1"

/* sigkill and friends handler -- should actually be installed at some stage */
int funeral(int sig) {
  #ifdef LOGGING
    syslog(LOG_WARNING, "shutting down (received signal %i)", sig);
    closelog();
  #endif
  exit(EXIT_SUCCESS);
  return 0;
}

/* print stuff to remote site */
/* As a side effect, this zeroes out its input. Wheee. */
int render (int fd, char *str) {
  int ret = write (fd, str, strlen(str));
  memset (str, '\0', strlen(str));
  return ret;
}

int iscool (char c) {
  if ( (c=='\n') || (c=='\r') ) return TRUE;
  return FALSE;
}

int main(void) {
  int server_sockfd, client_sockfd;
  int server_len, client_len;
  int errtrack;
  struct sockaddr_in server_address;
  struct sockaddr_in client_address;
  char outstr[1024];
  char ch, ch1, ch2, ch3, ch4;
  time_t now;

  #ifdef LOGGING
    openlog(SERVER_NAME,LOG_PID,LOG_DAEMON);
    syslog(LOG_INFO, "launching (target %s) on port %i", SERVER_TARGET, SERVER_PORT);
  #endif

  /* install signal handlers now, so we can die quickly if need be */
  signal(SIGTERM, (void *)funeral);
  signal(SIGKILL, (void *)funeral);
  signal(SIGINT,  (void *)funeral);
  signal(SIGSEGV, (void *)funeral);

  server_sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if (server_sockfd == -1) {
    #ifdef LOGGING
      syslog (LOG_ERR, "unable to start");
    #endif
    exit(EXIT_FAILURE);
  }
  server_address.sin_family = AF_INET;
  server_address.sin_addr.s_addr = htonl(INADDR_ANY);
  server_address.sin_port = htons(SERVER_PORT);
  server_len = sizeof(server_address);
  errtrack = bind(server_sockfd, (struct sockaddr *)&server_address, server_len);
  if (errtrack == -1) {
    #ifdef LOGGING
      syslog (LOG_ERR, "unable to bind() socket");
    #endif
    exit(EXIT_FAILURE);
  }
  errtrack = listen(server_sockfd, 5);
  if (errtrack == -1) {
    #ifdef LOGGING
      syslog (LOG_ERR, "unable to listen() to socket");
    #endif
    exit(EXIT_FAILURE);
  }

#ifdef STANDALONE
  while(1) {
#endif

    client_sockfd = accept(server_sockfd, 
        (struct sockaddr *)&client_address, &client_len);

    /* wait 'til we get 4 OK chars. NON standard, but quick'n'easy */
    /* The HTTP RFC specifies that we wait for two CR/LF linefeeds */

    while (read(client_sockfd, &ch, 1)) {
      ch1 = ch2; ch2 = ch3; ch3 = ch4; ch4 = ch;
      if ( (iscool(ch1)) && (iscool(ch2)) &&
           (iscool(ch3)) && (iscool(ch4)) ) {
        now = time((time_t*)0);
        sprintf (outstr, "HTTP/1.1 %i Try Again\n", ERROR_CODE);
        render (client_sockfd, outstr);
        sprintf (outstr, "Server: %s %s\n", SERVER_NAME, SERVER_VERSION);
        render (client_sockfd, outstr);
        sprintf (outstr, "X-Server-Admin: %s\n", SERVER_ADMIN);
        render (client_sockfd, outstr);
        (void) strftime (outstr, sizeof(outstr), "Date: %a, %d %b %Y %H:%M:%S GMT\n", gmtime(&now));
        render (client_sockfd, outstr);
        sprintf (outstr, "Location: %s\n", SERVER_TARGET);
        render (client_sockfd, outstr);
        sprintf (outstr, "Cache-Control: public\n");
        render (client_sockfd, outstr);
        sprintf (outstr, "Connection: close\n");
        render (client_sockfd, outstr);
        sprintf (outstr, "Content-Type: text/html\n\n");
        render (client_sockfd, outstr);

        sprintf (outstr, "<HTML><HEAD><TITLE>%i Try Again</TITLE></HEAD>\n", ERROR_CODE);
        render (client_sockfd, outstr);
        sprintf (outstr, "</HEAD><BODY>\n");
        render (client_sockfd, outstr);
        sprintf (outstr, "The document has moved <A HREF=\"%s\">here</A>.\n", SERVER_TARGET);
        render (client_sockfd, outstr);
        sprintf (outstr, "</BODY></HTML>\n");
        render (client_sockfd, outstr);


        #ifdef LOGGING
          syslog(LOG_INFO, "connection accepted from %s", 
                 inet_ntoa(client_address.sin_addr) );
        #endif
        close(client_sockfd);
        ch = ch1 = ch2 = ch3 = ch4 = '0' ;
        break;
      }  /* if */
    }    /* while read */
#ifdef STANDALONE
  }      /* while 1 */
#endif
}        /* main() */

/* Thus endeth the lesson. */

/* changelog:
   0.0.1	initial version
   0.0.2	added logging
   0.1.0	added standalone option
   0.1.1	added Date: header
*/
