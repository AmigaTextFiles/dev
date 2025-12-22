/*
 * showbug.c
 * by megacz@usa.com
 *
 * This code demonstrates what happens when 'AmiSSL' is being initialised
 * from under the 'ixlibrary' with 'ixemul_errno'('&errno') passed to the 
 * 'InitAmiSSL()' function and also shows how to workaround that nasty side 
 * effect(see 'Makefile' for more details).
 *
 * Note! 'errno' will become '*ixemul_errno' automagically during building
 * process through the use of '-malways-restore-a4' flag.
*/



#include <errno.h>

#include <asiheader.h>

#ifdef SHAREDLIB
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>



static struct sockaddr_in *showbug_gethostbyname(const char *host, int port)
{
  static struct sockaddr_in sin;
  struct hostent *hp;


  if (!inet_aton(host, &sin.sin_addr))
  {
    if (!(hp = gethostbyname(host)))
    {
      return NULL;
    }

    memset(&sin, 0, sizeof(struct sockaddr_in));

    memcpy(&sin.sin_addr.s_addr, hp->h_addr, hp->h_length);

    sin.sin_family = hp->h_addrtype;
  }
  else
  {
    sin.sin_family = AF_INET;
  }

  sin.sin_port = htons(port);

  return &sin;
}

static int showbug_test_non_blocking_connect(const char *host, unsigned short port)
{
  struct sockaddr_in *sin;
  int fd = -1;


  if (!(sin = showbug_gethostbyname(host, port)))
  {
    return -1;
  }

  if ((fd = socket(sin->sin_family, SOCK_STREAM, 0)) < 0)
  {
    return -1;
  }

  fcntl(fd, F_SETFL, O_NONBLOCK);

  if ((connect(fd, (struct sockaddr *)sin, sizeof(*sin)) < 0) && 
      (!(errno == EINPROGRESS || errno == EINTR)))
  {
    if (errno > 0)
    {
      printf("status: 'connect()' failed with 'errno' of %d(the right behaviour)!\n", errno);
    }
    else
    {
      printf("status: 'connect()' failed with 'errno' of %d(what the fuck dude?)!\n", errno);
    }
  }
  else
  {
    printf("status: 'connect()' is most probably in progress('errno' == %d)(ok).\n", errno);
  }

  close(fd);

  return -1;
}

void showbug_will_ya(const char *host, unsigned short port)
{
  showbug_test_non_blocking_connect(host, port);
}
#else
#ifdef INITAMISSL

#endif

void showbug_will_ya(const char *, unsigned short);

int main(void)
{
#ifdef INITAMISSL
  if (asi_InitAmiSSL(&errno))
  {
#endif
    showbug_will_ya("localhost", 13);
#ifdef INITAMISSL
    asi_CleanupAmiSSL();
  }
#endif
}
#endif
