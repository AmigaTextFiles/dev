/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_common.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_common.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_common.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:47  root
 * Initial revision
 *
 *-------------------------------------------------*/
#ifndef _RAIN_COMMON_H
#define _RAIN_COMMON_H



#if (HAVE_CONFIG_H)
  #include "config.h"
#endif
#include <stdio.h>
#include <stdlib.h>
#if (HAVE_UNISTD_H)
  #include <unistd.h>
#endif
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <time.h>
#if (HAVE_FCNTL_H)
  #include <fcntl.h>
#endif
#include <sys/stat.h>
#if (HAVE_SYS_TIME_H)
  #include <sys/time.h>
#endif
#if (HAVE_SYS_TYPES_H)
  #include <sys/types.h>
#endif
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#ifndef __USE_BSD
  #define __USE_BSD
#endif
#ifndef __FAVOR_BSD
  #define __FAVOR_BSD
#endif
#ifndef __BSD_SOURCE
  #define __BSD_SOURCE
#endif

#include "config.h"
#include "rain_inet_common.h"
#include "rain_command_line.h"
#include "rain_tcp.h"
#include "rain_udp.h"
#include "rain_igmp.h"
#include "rain_die.h"
#include "rain_resolv.h"
#include "rain_signal.h"
#include "rain_string.h"
#include "rain_mem.h"
#include "rain_defaults.h"
#include "rain_services.h"
#include "rain_icmp.h"
#include "rain_errno.h"



#define TRUE  (1)
#define FALSE (0)

#define SUCCESS (0)
#define FAILURE (1)


#ifndef BYTE_FIX
  #if (RAIN_LINUX) 
    /* 
     * Linux style (network order) 
     */
    #define BYTE_FIX(x) htons(x)
    #define BYTE_UFIX(x) ntohs(x)
  #elif (RAIN_BSD) 
    /* 
     * BSD style (host order) 
     */
    #define BYTE_FIX(x) x
    #define BYTE_UFIX(x) x
  #else error "Unknown OS type (rain is currently only supported on Linux and *BSD)"
  #endif
#endif /* BYTE_FIX */

#define AMIGAOS 1
#ifdef AMIGAOS
    #define BYTE_FIX(x) x
    #define BYTE_UFIX(x) x
#endif

#define UID_CHECK(uid,opt) { \
  switch(uid) { \
    case  0: { break; } \
    default:{ \
      fprintf(stderr,"\n- - Error: uid %d is not permitted to use %s (must be root)\n",uid,opt); \
      exit(1); \
    } \
  } \
}

#endif /* _RAIN_H */
