/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_tcp.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_tcp.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_tcp.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:26  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"



/* 
 * tcp_info_init():
 * 
 * This simply builds a text string based on the 
 * TCP packet type bits set in pkttcp
 */
extern void
tcp_info_init(struct pkt_info_tcp *pkttcp) {
  memset(tcpinfo, 0, strlen(tcpinfo));

  if(pkttcp->urg == 1) strcat(tcpinfo, "urg|");
  if(pkttcp->ack == 1) strcat(tcpinfo, "ack|");
  if(pkttcp->psh == 1) strcat(tcpinfo, "psh|");
  if(pkttcp->rst == 1) strcat(tcpinfo, "rst|");
  if(pkttcp->syn == 1) strcat(tcpinfo, "syn|");
  if(pkttcp->fin == 1) strcat(tcpinfo, "fin|");

  tcpinfo[strlen(tcpinfo) - 1] = '\0'; /* Remove the last '|' symbol */
}


/*
 * tcp_shower_connect():
 *
 * This is a streaming method of sending
 * many connect() calls to a specified target:port
 * Packet customization in this routine is limited
 * to the socket options in the sockets API
 */
extern
int tcp_shower_connect(struct sockaddr_in *target, struct pkt_info *pkt)
{
  int sock;


  while (packets_sent < pkt->num) {
    alarm(pkt->timeout); /* start timeout */

    if((sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
      DieWithError("socket(SOCK_STREAM)", 0);

    /* Set socket non-blocking if specified */
    if(pkt->noblock == 1)
      if(fcntl(sock, F_SETFL, O_NONBLOCK) < 0)
        DieWithError("couldn't set socket to non-blocking",0);


    /* If the user is using a streaming method of sending
     * packets (--connect or --stream), we obviously cannot
     * build the headers like we could with raw sockets, so
     * let's do what we can by changing the various aspects
     * of the streamed packets with setsockopt()
     */

    /* TTL */
      setttl(sock, pkt->ttl);

    /* TOS */
      settos(sock, pkt->tos);

    if((connect(sock, (struct sockaddr*)target, sizeof(struct sockaddr_in))) < 0)
      if(errno != EINPROGRESS)
        DieWithError("connect()", 0);

    close(sock);    

    usleep(pkt->delay);    

    alarm(0); /* clear timeout */

    packets_sent++;
  }

  return 0;
}


/* 
 * tcp_shower_stream():
 *
 * This is a streaming method which connects to a target:port
 * and proceeds to send lots of packets at a high speed.
 * Packet customization in this routine is limited
 * to the socket options in the sockets API
 */
extern 
int tcp_shower_stream(struct sockaddr_in *target, struct pkt_info *pkt) 
{
  int sock;
  int i = 0;


  buffer = malloc(sizeof(char)*packetsize);
  if(!buffer) DieWithError("malloc()", ENOMEM);
  memset(buffer, pkt->filler, (sizeof(char)*packetsize));


  /* 
   * store the user-specified string in the payload, 
   * if there is one.. 
   */
  if(ctoi(pkt->payload[0]) != 0) {
   for(; i < strlen(pkt->payload); i++)
     buffer[i] = pkt->payload[i];
  }


  if((sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
    DieWithError("socket(SOCK_STREAM)", 0);



  alarm(pkt->timeout); /* start timeout */

  if((connect(sock, (struct sockaddr*)target, sizeof(struct sockaddr_in))) < 0)
    if(errno != EINPROGRESS) /* rain doesn't care */
      DieWithError("connect()", 0);

  alarm(0); /* clear timeout */


  /* Set socket non-blocking if specified */
  if(pkt->noblock == 1)
    if(fcntl(sock, F_SETFL, O_NONBLOCK) < 0)
      DieWithError("couldn't set socket to non-blocking",0);



  /* If the user is using a streaming method of sending
   * packets (--connect or --stream), we obviously cannot
   * build the headers like we could with raw sockets, so
   * let's do what we can by changing the various aspects
   * of the streamed packets with setsockopt()
   */

  /* TTL */
    setttl(sock, pkt->ttl);

  /* TOS */
    settos(sock, pkt->tos);


  /*
   * Start sending the packets
   */

  while (packets_sent < pkt->num) {

    /*
     * Start timeout
     */
    alarm(pkt->timeout);


    if((send(sock, buffer, strlen(buffer), 0)) < 0)
      if(errno != EWOULDBLOCK) /* rain doesn't care */
        DieWithError("send()",0);

    /*
     * clear timeout
     */
    alarm(0);

    usleep(pkt->delay);

    packets_sent++;

  }

  close(sock);
  return 0;
}


/*
 * tcp_shower():
 * 
 * This is a RAW method of sending many
 * TCP segments (fully customized) to a target:port
 *
 * For BSD compatibility, we build our own IP header
 * and set IP_HDRINCL to tell the kernel not to prepend
 * it's own IP header.
 */
extern int 
tcp_shower(int raw_socket, struct sockaddr_in *source, struct sockaddr_in *target, struct pkt_info *pkt, struct pkt_info_tcp *pkttcp)
{
  struct iptcp *tcpsyn;
  struct ip      *ip;
  struct tcphdr *tcp;
  int i = 0;


/*
 * We use a global buffer to ward off memory leaks 
 * it will be freed when the program exits         
 */

  packetsize -= sizeof(struct tcphdr);

  buffer = malloc(sizeof(char)*packetsize);
  if(!buffer) DieWithError("malloc()", ENOMEM);
  memset(buffer, pkt->filler, (sizeof(char)*packetsize));

  tcpsyn = (struct iptcp*)buffer;
  ip = &tcpsyn->ip;
  tcp = &tcpsyn->tcp;




  /* 
   * store the user-specified string in the payload, 
   * if there is one.. 
   */
  if(ctoi(pkt->payload[0]) != 0) {
   for(; i < strlen(pkt->payload); i++)
     buffer[(sizeof(struct ip) + sizeof(struct tcphdr)) + i] = pkt->payload[i];
  }


  pkt->tot_len = (sizeof(struct tcphdr) + strlen(buffer));


  /* 
   * Let's build the TCP header: 
   */
  tcp->th_sport = htons(pkt->sport);
  tcp->th_dport = htons(pkt->dport);
  tcp->th_seq   = BYTE_FIX(pkttcp->seq);  /* BSD: host order, Linux: network order */
  tcp->th_off   = 0x0;  /* we really shouldn't set the data offset. Let the kernel do that.. */
  tcp->th_flags = 0x0;  /* No flags initially */

  if(pkttcp->urg == 1)  tcp->th_flags |=  TH_URG; 
  if(pkttcp->psh == 1)  tcp->th_flags |= TH_PUSH; 
  if(pkttcp->rst == 1)  tcp->th_flags |=  TH_RST; 
  if(pkttcp->ack == 1)  tcp->th_flags |=  TH_ACK; 
  if(pkttcp->fin == 1)  tcp->th_flags |=  TH_FIN; 
  if(pkttcp->syn == 1)  tcp->th_flags |=  TH_SYN; 

  if(pkttcp->urg == 1) { tcp->th_urp = 0x0; }
  if(pkttcp->ack == 1) { tcp->th_ack = htonl(pkttcp->ack_seq-1); }

  tcp->th_win  = htons(pkttcp->window);
  tcp->th_sum  = 0x0;
  tcp->th_sum  = in_cksum((u_int16_t*)tcp,sizeof(struct tcphdr), 0);

  pkt->tot_len += sizeof(struct ip);


  /* 
   * Cool. Now, let's build the IP header 
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
  ip->ip_p          = IPPROTO_TCP;
  if(strcmp(pkt->saddr,"127.0.0.1") == 0)
    ip->ip_src.s_addr = INADDR_ANY;
  else
    ip->ip_src.s_addr = source->sin_addr.s_addr;
  ip->ip_dst.s_addr = target->sin_addr.s_addr;
  ip->ip_sum        = 0x0;
  ip->ip_sum        = in_cksum((u_int16_t*)ip,sizeof(struct ip), 0);


  /*
   * Alright. Time to send the packets..
   */
  while(packets_sent < pkt->num) {


    if(sendto(raw_socket,
              tcpsyn,
              pkt->tot_len,
              0,
              (struct sockaddr*)target,
              sizeof(struct sockaddr_in)) < 0) return -1;

    /*
     * If this is an ACK packet, we'll increase the acknowledgement sequence,
     * provided the user does not specify their own..                        
     */ 
    if((pkttcp->ack == 1) && (pkttcp->ack_seq == 0)) {
      tcp->th_ack += (rand()%1400); tcp->th_sum = in_cksum((u_int16_t*)tcp, sizeof(struct tcphdr), 0); 
    }

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
      ip->ip_id = BYTE_FIX(++ip->ip_id) ; 
      ip->ip_sum = in_cksum((u_int16_t*)ip, sizeof(struct ip), 0); 
    }


    /* 
     * for random port 
     */
    if(pkt->rsport == 1) { 
      tcp->th_sport = BYTE_FIX((rand()%MAXPORT)); 
      tcp->th_sum = in_cksum((u_int16_t*)tcp,sizeof(struct tcphdr),0); 
    }

    if(pkt->rdport == 1) { 
      tcp->th_dport = BYTE_FIX((rand()%MAXPORT)); 
      tcp->th_sum = in_cksum((u_int16_t*)tcp,sizeof(struct tcphdr),0); 
    }


    usleep(pkt->delay);

  }
 
  return 0;
}
