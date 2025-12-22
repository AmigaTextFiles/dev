# Setting up a connection to an X server
# Bruno Haible 19.6.1994
# Marcus Daniels 28.9.1995

# This code comes from the X11R5 distribution, file mit/X/XConnDis.c,
# with the following modifications:
# - no support for DNETCONN or STREAMSCONN,
# - display name has already been split into hostname and display number,
# - doesn't return full host&display name and auth info,
# - doesn't depend on the X include files.

# mit/X/XConnDis.c carries the following copyright notice:
/*
 * $XConsortium: XConnDis.c,v 11.85 91/07/19 23:07:39 gildea Exp $
 *
 * Copyright 1989 Massachusetts Institute of Technology
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted, provided
 * that the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name of M.I.T. not be used in advertising
 * or publicity pertaining to distribution of the software without specific,
 * written prior permission.  M.I.T. makes no representations about the
 * suitability of this software for any purpose.  It is provided "as is"
 * without express or implied warranty.
 *
 * M.I.T. DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL M.I.T.
 * BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *
 * This file contains operating system dependencies.
 */

# These are the only things we need from lispbibl.c :
#include "config.h"
#define global
#define local static
#define var

# We assume that if we have gethostbyname(), we have a networking Unix.
# and have either UNIX domain connections or TCP/IP connections.
#ifdef HAVE_GETHOSTBYNAME

#ifdef HAVE_SYS_UN_H  # have <sys/un.h> and Unix domain sockets?
  #define UNIXCONN  # use Unix domain sockets
#endif
#ifdef HAVE_NETINET_IN_H  # have <netinet/in.h> ?
  #define TCPCONN  # use TCP/IP sockets
#endif

#ifdef TCPCONN
  #define SOCKET_STREAMS
#endif

#include <sys/types.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h> # declares fcntl(), close(), sleep()
#endif

#ifdef HAVE_MEMSET
  #include <string.h>
  extern void* memset (void* ptr, int c, size_t len); # siehe MEMORY(3)
  #define bzero(ptr,len)  memset(ptr,0,len)
  #define bcopy(source,dest,len) memcpy(dest,source,len)
#else
  extern void bzero (void* ptr, int len); # siehe BZERO(3)
  extern void bcopy (void *source, void *dest, int len);
#endif

#include <errno.h>
extern int errno;
#ifndef ENOSYS
  #define ENOSYS  EINVAL
#endif

#include <fcntl.h> # declares fcntl() and defines F_SETFD
#ifdef FCNTL_DOTS
  extern int fcntl (int fd, int cmd, ...);
#else
  extern int fcntl (int fd, int cmd, int arg);
#endif
#ifndef FD_CLOEXEC
  #define FD_CLOEXEC  1
#endif

extern int close (int fd);
#define CLOSE(fd)  while ((close(fd) < 0) && (errno == EINTR)) ;

#ifdef __CYGWIN32__
struct servent *cygwin32_getservbyport(int port,const char *proto) { abort(); }
unsigned short ntohs(unsigned short netshort) { abort(); }
#endif

#if defined(UNIXCONN) || defined(TCPCONN)

# include <sys/types.h>
#include <sys/socket.h> # declares socket(), connect(), defines AF_UNIX, AF_INET
extern int socket (int domain, int type, int protocol);
extern int connect (int fd, CONNECT_CONST CONNECT_NAME_T name, int namelen);

# A wrapper around the connect() function.
  global int nonintr_connect (int fd, struct sockaddr * name, int namelen);
  global int nonintr_connect(fd,name,namelen)
    var int fd;
    var struct sockaddr * name;
    var int namelen;
    { var int retval;
      do { retval = connect(fd,name,namelen); }
         while ((retval < 0) && (errno == EINTR));
      return retval;
    }
  #define connect nonintr_connect

extern unsigned int sleep (unsigned int seconds);

#endif

#ifdef UNIXCONN
  #include <stdio.h>   # declares sprintf()
  #include <string.h>  # declares strcmp(), strlen()
  #ifdef RETSTRLENTYPE /* unless strlen() is a macro */
    extern RETSTRLENTYPE strlen (STRLEN_CONST char* s);
  #endif
  #include <sys/un.h>  # defines struct sockaddr_un
  # set X_UNIX_PATH and - on hpux only - OLD_UNIX_PATH
  #ifndef X_UNIX_PATH
    #ifndef hpux
      #define X_UNIX_PATH "/tmp/.X11-unix/X"
    #else
      #define X_UNIX_PATH "/usr/spool/sockets/X11/"
      #define OLD_UNIX_PATH "/tmp/.X11-unix/X"
    #endif
  #endif
#endif

#ifdef TCPCONN
  #ifdef HAVE_GETHOSTNAME
    extern int gethostname (char* name, GETHOSTNAME_SIZE_T namelen);
  #endif
  #ifdef HAVE_SYS_UTSNAME_H
    #include <sys/utsname.h>
    extern int uname (struct utsname * buf);
  #endif
  #ifdef HAVE_GETHOSTBYNAME
    #include <sys/types.h>
    #ifdef HAVE_NETDB_H
      # include <sys/socket.h>
      #include <netdb.h>
    #else
      #include <sun/netdb.h>
    #endif
    extern struct hostent * gethostbyname (GETHOSTBYNAME_CONST char* name);
  #endif
  #ifndef MAXHOSTNAMELEN
    #define MAXHOSTNAMELEN 64
  #endif
  #include <netinet/in.h> # declares htons(), defines struct sockaddr_in
  #ifdef HAVE_ARPA_INET_H
    #include <arpa/inet.h> # declares inet_addr()
  #endif
  extern RET_INET_ADDR_TYPE inet_addr (INET_ADDR_CONST char* host);
  #ifdef HAVE_NETINET_TCP_H
    #include <netinet/in_systm.h>
    #if defined(__386BSD__) || defined(__NetBSD__)
      #include <machine/endian.h> # needed for <netinet/tcp.h>
    #endif
    #include <netinet/tcp.h> # declares TCP_NODELAY
  #endif
  extern int setsockopt (/* int fd, int level, int optname, char* optval, int optlen */);
  #define X_TCP_PORT  6000  # from <X11/Xproto.h>
#endif

# Attempts to connect to server, given host name and display number.
# Returns file descriptor (network socket). Returns -1 and sets errbo
# if connection fails.
# An empty hostname is interpreted as the most efficient local connection to
# a server on the same machine (usually a UNIX domain socket).
# hostname="unix" is interpreted as a UNIX domain connection.

global int connect_to_server (char* host, int display);
global int connect_to_server(host,display)
  var char* host;  # host of display
  var int display; # display number (screen number always zero)
{ var int fd;      # file descriptor to return
  var int retries = 3; # number of retries on ECONNREFUSED

  var int conntype; # type of desired connection
  #define conn_none 0
  #define conn_unix 1
  #define conn_tcp  2
  #ifdef TCPCONN
    conntype = conn_tcp;
  #else
    conntype = conn_none;
  #endif
  #ifdef UNIXCONN
    if (host[0] == '\0')
      {
        #ifndef apollo # Unix domain sockets are *really* bad on apollos
        conntype = conn_unix;
        #endif
      }
    else if (strcmp(host,"unix")==0)
      { conntype = conn_unix; }
  #endif

  # Make the connection. Do retries in case server host has hit its
  # backlog (which, unfortunately, isn't distinguishable from there not
  # being a server listening at all, which is why we have to not retry
  # too many times).

  #ifdef UNIXCONN
  if (conntype == conn_unix)
    {
      var struct sockaddr_un unaddr;          # UNIX socket data block
      var struct sockaddr * addr;             # generic socket pointer
      var int addrlen;                        # length of addr
      #ifdef hpux /* this is disgusting */
      var struct sockaddr_un ounaddr;         # UNIX socket data block
      var struct sockaddr * oaddr;            # generic socket pointer
      var int oaddrlen;                       # length of addr
      #endif

      unaddr.sun_family = AF_UNIX;
      sprintf (unaddr.sun_path, "%s%d", X_UNIX_PATH, display);
      addr = (struct sockaddr *) &unaddr;
      #ifdef HAVE_SOCKADDR_UN_LEN /* this is AIX */
      unaddr.sun_len = strlen(unaddr.sun_path); addrlen = sizeof(unaddr);
      #else
      addrlen = strlen(unaddr.sun_path) + sizeof(unaddr.sun_family);
      #endif
      #ifdef hpux /* this is disgusting */
      ounaddr.sun_family = AF_UNIX;
      sprintf (ounaddr.sun_path, "%s%d", OLD_UNIX_PATH, display);
      oaddr = (struct sockaddr *) &ounaddr;
      #ifdef HAVE_SOCKADDR_UN_LEN /* this is AIX */
      ounaddr.sun_len = strlen(ounaddr.sun_path); oaddrlen = sizeof(ounaddr);
      #else
      oaddrlen = strlen(ounaddr.sun_path) + sizeof(ounaddr.sun_family);
      #endif
      #endif

      # Open the network connection.
      do { if ((fd = socket((int) addr->sa_family, SOCK_STREAM, 0)) >= 0)
             { if (connect (fd, addr, addrlen) >= 0)
                 break;
                 else
                 { int olderrno = errno; CLOSE(fd); errno = olderrno; }
             }
           #ifdef hpux /* this is disgusting */
           if (errno == ENOENT)
             { if ((fd = socket((int) oaddr->sa_family, SOCK_STREAM, 0)) >= 0)
                 { if (connect (fd, oaddr, oaddrlen) >= 0)
                     break;
                     else
                     { int olderrno = errno; CLOSE(fd); errno = olderrno; }
             }   }
           #endif
           if (!((errno == ENOENT) && (retries > 0)))
             { return -1; }
           sleep (1);
         }
         while (retries-- > 0);
    }
  else
  #endif

  #ifdef TCPCONN
  if (conntype == conn_tcp)
    {
      #if defined(HAVE_GETHOSTNAME)
      var char hostname[MAXHOSTNAMELEN+1];
      #elif defined(HAVE_SYS_UTSNAME_H)
      var struct utsname utsname;
      #endif
      var unsigned long hostinetaddr;       # result of inet_addr of arpa addr
      var struct sockaddr_in inaddr;        # IP socket
      var struct sockaddr * addr;           # generic socket pointer
      var int addrlen;                      # length of addr
      if (host[0] == '\0')
        { # get host name
          #if defined(HAVE_GETHOSTNAME)
          if (gethostname(&!hostname,MAXHOSTNAMELEN) < 0) { return -1; }
          hostname[MAXHOSTNAMELEN] = '\0';
          host = &!hostname;
          #elif defined(HAVE_SYS_UTSNAME_H)
          if (uname(&utsname) < 0) { return -1; }
          host = &!utsname.nodename;
          #else
          ??
          #endif
        }
      # if numeric host name then try to parse it as such; do the number
      # first because some systems return garbage instead of INVALID_INETADDR
      #define INVALID_INETADDR  ((unsigned long) -1)
      if ((host[0] >= '0') && (host[0] <= '9'))
        { hostinetaddr = inet_addr(host) INET_ADDR_SUFFIX ; }
        else
        { hostinetaddr = INVALID_INETADDR; }
      # try numeric
      if (hostinetaddr == INVALID_INETADDR)
        { var struct hostent * host_ptr; # entry in hosts table
          if ((host_ptr = gethostbyname(host)) == NULL)
            { errno = EINVAL; return -1; } # No such host!
          # Check the address type for an internet host.
          if (host_ptr->h_addrtype != AF_INET)
            { errno = EPROTOTYPE; return -1; } # Not an Internet host!
          # Set up the socket data.
          inaddr.sin_family = host_ptr->h_addrtype;
          inaddr.sin_addr = *(struct in_addr *)host_ptr->h_addr;
        }
        else
        { inaddr.sin_family = AF_INET;
          inaddr.sin_addr.s_addr = hostinetaddr;
        }

      inaddr.sin_port = X_TCP_PORT + display;
      inaddr.sin_port = htons(inaddr.sin_port);
      addr = (struct sockaddr *) &inaddr;
      addrlen = sizeof(struct sockaddr_in);

      # Open the network connection.
      do { if ((fd = socket ((int) addr->sa_family, SOCK_STREAM, 0)) < 0)
             { return -1; }
           #ifdef TCP_NODELAY
           # turn off TCP coalescence
           { int tmp = 1;
             setsockopt (fd, IPPROTO_TCP, TCP_NODELAY, &tmp, sizeof(int));
           }
           #endif
           # Connect to the socket.
           # If there is no X server or if the backlog has been reached,
           # then ECONNREFUSED will be returned.
           if (connect (fd, addr, addrlen) >= 0)
             break;
           { int olderrno = errno; CLOSE(fd); errno = olderrno; }
           if (!(
                 #ifdef ECONNREFUSED
                 (errno == ECONNREFUSED) && 
                 #endif
                 (retries > 0)))
             { return -1; }
           sleep (1);
         }
         while (retries-- > 0);
    }
  else
  #endif

  # (conntype == conn_none)
    { errno = ENOSYS; return -1; }

  # Set close-on-exec so that we won't get confused if we fork().
  fcntl(fd,F_SETFD,FD_CLOEXEC);

  return fd;
}

#endif # HAVE_GETHOSTBYNAME

#if defined(SOCKET_STREAMS)

# Creation of sockets on the server side:
# int socket_handle = create_server_socket(port);
#   creates a socket to which other processes can connect.
# int fd = accept_connection(socket_handle);
#   waits for a connection to another process.
#   This can (and should) be done multiple times for the same
#   socket_handle.

global int create_server_socket (int port);
global int create_server_socket(port)
  var int port;
  {
    var struct sockaddr_in sa ;
    var int s;

    if ((s = socket(AF_INET, SOCK_STREAM, 0)) < 0)
      return -1;
    bzero((char *) &sa, sizeof(sa)) ;
    sa.sin_family = AF_INET ;
    sa.sin_addr.s_addr = htonl(INADDR_ANY) ;
    sa.sin_port = htons(port) ;

    if (bind(s, (struct sockaddr *) &sa, sizeof(sa)) < 0) 
      return -1 ;

    if (listen(s, 1) < 0) 
      return -1;

    return s ;
  }

global int accept_connection (int socket_handle);
global int accept_connection (socket_handle)
  var int socket_handle;
  {
    var struct sockaddr_in sa;
    var int active_socket;
    var int alen;
  
    alen = sizeof(sa);
    return accept(socket_handle,(struct sockaddr *)&sa,&alen);
  }

# Creation of sockets on the client side:
# int fd = create_client_socket(hostname,port);
#   creates a connection to a server (which must be waiting
#   on the specified host and port).

global int create_client_socket (char *hostname, int port);
global int create_client_socket(hostname,port)
  var char *hostname;
  var int port;
  {
    var struct sockaddr_in sa;
    var struct hostent *hp;
    var int a;
    var int s;
    var long addr;

    bzero(&sa, sizeof(sa));
    if ((addr = inet_addr(hostname)) != -1) 
      {
	# is Internet addr in octet notation
	bcopy(&addr, (char *) &sa.sin_addr, sizeof(addr)) ; # set address
	sa.sin_family = AF_INET;
      } 
    else 
      {
	if ((hp = gethostbyname(hostname)) == NULL)
          return -2;
	bcopy(hp->h_addr, (char *) &sa.sin_addr, hp->h_length);
	sa.sin_family = hp->h_addrtype;
      }

    sa.sin_port = htons((u_short) port);

    if ((s = socket(sa.sin_family, SOCK_STREAM, 0)) < 0)
      return -1;
    if (connect(s, (CONNECT_CONST CONNECT_NAME_T)&sa, sizeof(sa)) < 0)
      { close(s);
	return -1;
      }
    return s;
  }

# Auxiliary function:
# port = resolve_service("name_or_number",&name);
# parses the "name_or_number" and returns data about the
# specified TCP service: its name and its port number.

local int is_number (char *s);
local int is_number(s)
  var char *s;
  {
    while (*s)
      {
        if (*s < '0' || *s > '9')
          return 0 ;
        s++ ;
      }
    return 1 ;
  }

global int resolve_service (char *name_or_number, char **name);
global int resolve_service (name_or_number,name)
  char *name_or_number ;
  char **name ;
  {
    struct servent *servent ;
    int port;
    extern int atoi();

    if (is_number(name_or_number)) 
      {	port = atoi(name_or_number);
	if (name != NULL) 
          { servent = getservbyport(htons(port), "tcp");
	    if (servent != NULL)
	      *name = servent->s_name;
	    else
	      *name = NULL;
          }
	return port;
      }
    else
      {
	servent = getservbyname(name_or_number, "tcp");
	if (servent == NULL) 
          return -1;
	if (name != NULL)
          *name = servent->s_name;
	return ntohs(servent->s_port);
      }
  }

# Auxiliary function:
# socket_getpeername(fd)
# returns the name of the host to which IP socket fd is connected.
# Return value: A pointer to a statically allocated string!

global char *socket_getpeername (int socket_handle);
global char *socket_getpeername(socket_handle)
  var int socket_handle;
  {
    var struct hostent *hostent; 
    var struct sockaddr_in addr_in;
    var int len=sizeof(addr_in);
    var long norder;

    # Get host's IP address.
    if (getpeername(socket_handle,&addr_in,&len) == -1) return NULL;
    norder = htonl(addr_in.sin_addr.s_addr) ;

    # Convert it to an ASCII host name.
    hostent=gethostbyaddr(&norder,sizeof(norder),AF_INET);
    if (hostent == NULL) 
      {
        static char dotted[20] ;
        sprintf(dotted, "%d.%d.%d.%d",
                (norder >> 24) & 0xff,
                (norder >> 16) & 0xff,
                (norder >>  8) & 0xff,
                norder & 0xff) ;
        return dotted;
      }
    return hostent->h_name;
  }

#endif # SOCKET_STREAMS
