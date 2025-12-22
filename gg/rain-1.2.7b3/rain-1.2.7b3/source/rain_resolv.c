/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_resolv.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_resolv.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_resolv.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:26  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"



/* 
 * Resolves host and stores address in addr structure 
 */
extern int 
resolv(const char *name, struct sockaddr_in *addr)
{
    struct hostent *host;
    memset(addr, 0, sizeof(struct sockaddr_in));

    addr->sin_addr.s_addr = inet_addr(name);

    if (addr->sin_addr.s_addr == -1) {
        if ((host = gethostbyname(name)) == NULL)
            return -1;
        addr->sin_family = host->h_addrtype;
        memcpy((caddr_t) & addr->sin_addr, host->h_addr, host->h_length);
    }
    return 0;

}


/* 
 * Similar to above, but addr structure is type in_addr (Not sockaddr_in) 
 */
extern int
resolv_nosin(const char *name, struct in_addr *addr)
{
    struct hostent *host;
    memset(addr, 0, sizeof(struct in_addr));

    addr->s_addr = inet_addr(name);

    if (addr->s_addr == -1) {
        if ((host = gethostbyname(name)) == NULL)
            return -1;
        memcpy((caddr_t) & addr, host->h_addr, host->h_length);
    }
    return 0;
}
