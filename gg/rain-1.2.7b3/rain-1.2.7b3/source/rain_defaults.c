/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_defaults.c,v 1.1 2001/06/27 21:26:29 root Exp root $
 * $Author: root $
 * rain_defaults.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_defaults.c,v $
 * Revision 1.1  2001/06/27 21:26:29  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"



/* 
 * sets default values for all packet types
 */
void set_defaults(struct pkt_info *pkt,
                  struct pkt_info_tcp *pkttcp,
                  struct pkt_info_icmp *pkticmp,
                  struct pkt_info_igmp *pktigmp)
{

  /* 
   * set default pkt info 
   */
  packetsize      =     TCP_MSS;
  verbose         =           0;  /* 0 is the default verbose mode, more output for each nubmer > 0 */
 
  pkt->num        =          -1;  /* infinite */
  pkt->dport      =         138;
  pkt->sport      =         420;
  strcpy(pkt->saddr,"127.0.0.1");
  pkt->delay      =       10000;  /* delay in microseconds between sends */
  pkt->timeout    =          10;  /* operation timeout in seconds */
  if(getuid() == 0) {
    pkt->type     =     DEFAULT;  /* see rain_inet_common.h */
  } else {
    pkt->type     = USERDEFAULT;  /* see rain_inet_common.h */
  }
  pkt->tos        =           0;  /* see rain_inet_common.h */
  pkt->ttl        =          64;  /* well known default */
  pkt->tot_len    =           0;
  pkt->id         =    getpid();
  pkt->id_of      =           0;
  pkt->frag       =           0;
  pkt->frag_off   =           0;
  pkt->simulate   =           0;
  pkt->randip     =           0;
  pkt->rdport     =           0;
  pkt->rsport     =           0;
  pkt->filler     =        0xA1; /* random hex value (A1 steak sauce!!) */
  pkt->dfrag      =           0;
  strcpy(pkt->payload,"0");
  strcpy(pkt->gaddr,"127.0.0.1");
  pkt->sndbuf     =           0;
  pkt->rcvbuf     =           0;
  pkt->bcast      =           0;

  /* 
   * set default pkt_info_tcp 
   */
  pkttcp->seq     = getpid();
  pkttcp->window  =       56;
  pkttcp->urg     =        0;
  pkttcp->ack     =        0;
  pkttcp->ack_seq =        0;
  pkttcp->psh     =        0;
  pkttcp->rst     =        0;
  pkttcp->fin     =        0;
  pkttcp->syn     =        0;
  pkttcp->beenset =        0; /* flag set to 1 when one of the previous flags are set; *
                               * only syn and ack can be combined                      */


  /* 
   * set default pkt_info_icmp
   */
  pkticmp->type =    0; /* echo */
  pkticmp->code =    0; /* echo reply */
  pkticmp->id   =    0;
  pkticmp->mtu  = 1500;
  pkticmp->gw   =    0;


  /* 
   * set default pkt_info_igmp 
   */
  pktigmp->type = 0x11; /* membership query */
  pktigmp->code = 0x0; /* max response time: 0 */


  return;
}
