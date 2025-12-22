/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_inet_common.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_inet_common.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_inet_common.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 03:36:15  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"



/*
 * Internet checksum routine (RFC 1071) 
 */
extern unsigned short
in_cksum(const u_int16_t *addr, register int len, u_short csum)
{
        int nleft = len;
        const u_short *w = addr;
        u_short answer;
        int sum = csum;

        /*
         *  Our algorithm is simple, using a 32 bit accumulator (sum),
         *  we add sequential 16 bit words to it, and at the end, fold
         *  back all the carry bits from the top 16 bits into the lower
         *  16 bits.
         */
        while (nleft > 1)  {
                sum += *w++;
                nleft -= 2;
        }
        if (nleft == 1)
                sum += htons(*(u_char *)w<<8);

        /*
         * add back carry outs from top 16 bits to low 16 bits
         */
        sum = (sum >> 16) + (sum & 0xffff);     /* add hi 16 to low 16 */
        sum += (sum >> 16);                     /* add carry */
        answer = ~sum;                          /* truncate to 16 bits */
        return (answer);
}


/*
 * Sets IP_HDRINCL for specified socket
 * This is required on BSD systems
 */
extern void 
sethdrinclude(int sd)
{
#ifdef IP_HDRINCL
    int one = 1;
    setsockopt(sd, IPPROTO_IP, IP_HDRINCL, (const char *) &one,
               sizeof(one));
#endif
}


/* 
 * Sets the Time to Live in streamed sockets 
 */
extern void
setttl(int sd, u_int8_t ttl)
{
#ifdef IP_TTL
  setsockopt(sd, IPPROTO_IP, IP_TTL, &ttl, sizeof(ttl));
#endif
}


/*
 * Sets the Type of Service in streamed sockets 
 */
extern void
settos(int sd, u_int8_t tos)
{
#ifdef IP_TOS
  setsockopt(sd, IPPROTO_IP, IP_TOS, &tos, sizeof(tos));
#endif
}


/* 
 * Sets the socket send buffer size 
 */
extern void
setsndbuf(int sd, int size)
{
#ifdef SO_RCVBUF
  printf("--- Overwriting send buffer size to %d\n", size);
  if(setsockopt(sd, SOL_SOCKET, SO_SNDBUF, &size, sizeof(size)) < 0)
    DieWithError("unable to set send buffer size",0);
#endif
}


/* 
 * Sets the socket receive buffer size 
 */
extern void
setrcvbuf(int sd, int size)
{
  printf("--- Overwriting receive buffer size to %d\n", size);
#ifdef SO_RCVBUF
  if(setsockopt(sd, SOL_SOCKET, SO_RCVBUF, &size, sizeof(size)) < 0)
    DieWithError("unable to set receive buffer size",0);
#endif
}


/*
 * Allows broadcast messages
 */
extern void
setbcast(int sd)
{
  int one = 1;
#ifdef SO_BROADCAST
  if(setsockopt(sd, SOL_SOCKET, SO_BROADCAST, &one, sizeof(one)) < 0)
    DieWithError("could not allow broadcast messages",0);
#endif
}
