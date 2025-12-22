/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_icmp.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_icmp.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_icmp.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:26  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"


/* 
 * Prints all the ICMP type/code combinations 
 */
extern void
print_icmp_info(void) {
  printf("\n[ rain %s by Evil (mystic@tenebrous.com) ] [pid:%d]\n", RAIN_VERSION, getpid());
  printf("\n"
         "       ICMP type/code combinations      \n"
         "       ---------------------------    \n\n"
         "Echo (ping) reply......: Type 0,  Code 0\n"
         "\n"
	 "Destination unreachable: Type 3,\n" 
         "                Network:          Code 0\n"
         "                   Host:          Code 1\n"
         "               Protocol:          Code 2\n"
         "                   Port:          Code 3\n"
         "            Frag needed:          Code 4\n"
         "    Source route failed:          Code 5\n"
         "        Unknown network:          Code 6\n"
         "           Unknown host:          Code 7\n"
         "          Host isolated:          Code 8\n"
         "    Net com. prohibited:          Code 9\n"
         "   Host com. prohibited:          Code 10\n"
         "        Net unreach TOS:          Code 11\n"
         "       Host unreach TOS:          Code 12\n"
         "        Packet filtered:          Code 13\n"
         "   Precedence violation:          Code 14\n"
         "      Precedence cutoff:          Code 15\n"
         "\n"
         "Source quench..........: Type 4,  Code 0\n"
         "\n"
	 "Redirect (change route): Type 5,\n"
         "                    Net:          Code 0\n"
         "                   Host:          Code 1\n"
         "            Net for TOS:          Code 2\n"
         "           Host for TOS:          Code 3\n"
         "\n"
         "Echo (ping) request....: Type 8,  Code 0\n"
         "\n"
	 "Time exceeded..........: Type 11,\n"
         "              TTL count:          Code 0\n"
         "    Fragment reassembly:          Code 1\n"
         "\n"
         "Parameter problem......: Type 12, Code 0\n"
         "Timestamp request......: Type 13, Code 0\n"
         "Timestamp reply........: Type 14, Code 0\n"
         "Information request....: Type 15, Code 0\n"
         "Information reply......: Type 16, Code 0\n"
         "Address mask request...: Type 17, Code 0\n"
         "Address mask reply.....: Type 18, Code 0\n");
  exit(0);
}


/* 
 * initializes an array that stores information 
 * on ICMP types and codes 
 */
extern void
icmp_info_init(struct pkt_info_icmp *pkticmp) {

  switch(pkticmp->type) {
    case ICMP_ECHOREPLY:
    case ICMP_DEST_UNREACH:
    case ICMP_SOURCE_QUENCH:
    case ICMP_REDIRECT:
    case ICMP_ECHO:
    case ICMP_TIME_EXCEEDED:
    case ICMP_PARAMETERPROB:
    case ICMP_TIMESTAMP:
    case ICMP_TIMESTAMPREPLY:
    case ICMP_INFO_REQUEST:
    case ICMP_INFO_REPLY:
    case ICMP_ADDRESS:
    case ICMP_ADDRESSREPLY:{ break; }
    default: { DieWithError("unknown ICMP type", R_UNKNOWNICMP); }
  }

  memset(icmpinfo, 0xFF, sizeof(icmpinfo));

/* 
 * type 0: echo reply 
 */
  if((pkticmp->type == 0) && (pkticmp->code != 0))
    DieWithError("ICMP type 0 must have code 0", 0);
  strcpy(icmpinfo[0][0]," echo reply"); 


/* 
 * type: 3 (unreachable) 
 */
  if((pkticmp->type == 3) && (pkticmp->code > 15))
    DieWithError("unknown ICMP code (Unreachable must be 0-15)", 0);
  strcpy(icmpinfo[3][0],  " network unreachable");
  strcpy(icmpinfo[3][1],  " host unreachable");
  strcpy(icmpinfo[3][2],  " protocol unreachable");
  strcpy(icmpinfo[3][3],  " port unreachable");
  strcpy(icmpinfo[3][4],  " frag needed but DF set");
  strcpy(icmpinfo[3][5],  " source route failed");
  strcpy(icmpinfo[3][6],  " unknown network");
  strcpy(icmpinfo[3][7],  " unknown host");
  strcpy(icmpinfo[3][8],  " host isolated");
  strcpy(icmpinfo[3][9],  " communication with network prohibited");
  strcpy(icmpinfo[3][10], " communication with host prohibited");
  strcpy(icmpinfo[3][11], " network unreach TOS");
  strcpy(icmpinfo[3][12], " host unreach TOS");
  strcpy(icmpinfo[3][13], " packet filtered");
  strcpy(icmpinfo[3][14], " precedence violation");
  strcpy(icmpinfo[3][15], " precedence cutoff");

/* 
 * type 4: source quench 
 */
  if((pkticmp->type == 4) && (pkticmp->code != 0))
    DieWithError("ICMP type 4 must have code 0", 0);
  strcpy(icmpinfo[4][0], " source quench message");

/*
 * type 5: redirect 
 */
  if((pkticmp->type == 5) && (pkticmp->code > 3))
    DieWithError("unknown ICMP code (Redirect must be 0-3)", 0);
  strcpy(icmpinfo[5][0]," redirect dgrams for network");
  strcpy(icmpinfo[5][1]," redirect dgrams for host");
  strcpy(icmpinfo[5][2]," redirect dgrams for ToS and network");
  strcpy(icmpinfo[5][3]," redirect dgrams for Tos and host");

/*
 * type 8: echo or echo reply 
 */
  if((pkticmp->type == 8) && (pkticmp->code != 0))
    DieWithError("ICMP type 8 must have code 0", 0);
  strcpy(icmpinfo[8][0]," echo request"); 

/* 
 * type 11: time exceeded 
 */
  if((pkticmp->type == 11) && (pkticmp->code > 1))
    DieWithError("ICMP type 11 must have code 0 or 1",0);
  strcpy(icmpinfo[11][0], " ttl exceeded in transit");
  strcpy(icmpinfo[11][1], " fragment reassembly time exceeded");

/* 
 * type 12: parameter problem 
 */
  if((pkticmp->type == 12) && (pkticmp->code != 0))
    DieWithError("ICMP type 12 must have code 0", 0);
  strcpy(icmpinfo[12][0]," parameter problem message");

/* 
 * type 13: timestamp message 
 */
  if((pkticmp->type == 13) && (pkticmp->code != 0))
    DieWithError("ICMP type 13 must have code 0", 0);
  strcpy(icmpinfo[13][0]," timestamp");

/* 
 * type 14: timestamp reply 
 */
  if((pkticmp->type == 14) && (pkticmp->code != 0))
    DieWithError("ICMP type 14 must have code 0", 0);
  strcpy(icmpinfo[14][0]," timestamp reply");

/* 
 * type 15: info request 
 */
  if((pkticmp->type == 15) && (pkticmp->code != 0))
    DieWithError("ICMP type 15 must have code 0", 0);
  strcpy(icmpinfo[15][0]," information request");

/* 
 * type 16: info reply 
 */
  if((pkticmp->type == 16) && (pkticmp->code != 0))
    DieWithError("ICMP type 16 must have code 0", 0);
  strcpy(icmpinfo[16][0]," information reply");

/* 
 * type 17: address mask request 
 */
   if((pkticmp->type == 17) && (pkticmp->code != 0))
     DieWithError("ICMP type 17 must have code 0", 0);
   strcpy(icmpinfo[17][0], " address mask request");  

/* 
 * type 18: address mask reply 
 */
   if((pkticmp->type == 18) && (pkticmp->code != 0))
     DieWithError("ICMP type 18 must have code 0", 0);
   strcpy(icmpinfo[18][0], " address mask reply");  

  return;
}


/*
 * icmp_shower():
 *
 * Sends fully customized ICMP
 * packets to a targeta:port
 */
extern int
icmp_shower(int raw_socket, struct sockaddr_in *source, struct sockaddr_in *target, struct pkt_info *pkt, struct pkt_info_icmp *pkticmp) {
  struct ipicmp *ip_icmp;  
  struct ip          *ip;
  struct icmp      *icmp;
  int i = 0;

  srand(time(NULL));


  packetsize -= sizeof(struct icmp);

  /*
   * We use a global buffer to ward off memory leaks
   * it will be freed when the program exits         
   */
  buffer = malloc(sizeof(char)*packetsize);
  if(!buffer) DieWithError("malloc()", ENOMEM);
  memset(buffer, pkt->filler, (sizeof(char)*packetsize));


  ip_icmp = (struct ipicmp*)buffer;
  ip = &ip_icmp->ip;
  icmp = &ip_icmp->icmp;

	
  /* 
   * store the user-specified string in the payload, 
   * if there is one.. 
   */
  if(ctoi(pkt->payload[0]) != 0) {
   for(; i < strlen(pkt->payload); i++)
     buffer[(sizeof(struct ip) + sizeof(struct icmp)) + i] = pkt->payload[i];
  }


  pkt->tot_len = (sizeof(struct icmp) + strlen(buffer));


  /*
   * Okay. Let's build our ICMP header
   */
  icmp->icmp_type  = pkticmp->type;
  icmp->icmp_code  = pkticmp->code;
  if((icmp->icmp_type == 13) || (icmp->icmp_code == 14)) {
    icmp->icmp_id  = pkticmp->id;
    icmp->icmp_seq = pkticmp->seq;
  }
  icmp->icmp_nextmtu = BYTE_FIX(pkticmp->mtu);
  if(ctoi(pkt->gaddr[0]) == 0) {
    icmp->icmp_gwaddr.s_addr = rand();
  } else {
    resolv_nosin(pkt->gaddr,&icmp->icmp_gwaddr);
  }

  /* 
   * Fill timestamp fields for type 11 
   */
  if(pkticmp->type == 1) {
    time_t now = time(NULL);
    icmp->icmp_otime = BYTE_FIX(now);
    icmp->icmp_rtime = BYTE_FIX(now);
    icmp->icmp_ttime = BYTE_FIX(now);
  }

  /*
   *  Set the parameter problem pointer for type 12 
   */
  if(pkticmp->type == 12)
    icmp->icmp_pptr = (u_int8_t)rand();

  /* 
   * Set the address mask for type 18 
   */
  if(pkticmp->type == 18)
    icmp->icmp_mask = rand();

  icmp->icmp_cksum = in_cksum((u_short*)icmp, sizeof(struct icmp), 0);



  pkt->tot_len += (sizeof(struct ip));
  

  /* 
   * Now, for the IP header.. 
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
    ip->ip_off = 0x0; /* No setting */
  }
  if(pkt->dfrag == 1) ip->ip_off |= BYTE_FIX(IP_DF); /* DONT FRAGMENT */
  ip->ip_ttl        = pkt->ttl;
  ip->ip_p          = IPPROTO_ICMP;
  if(strcmp(pkt->saddr,"127.0.0.1") == 0)
    ip->ip_src.s_addr = INADDR_ANY;
  else
    ip->ip_src.s_addr = source->sin_addr.s_addr;
  ip->ip_dst.s_addr = target->sin_addr.s_addr;
  ip->ip_sum        = 0x0;
  ip->ip_sum        = in_cksum((u_int16_t*)ip,sizeof(struct ip), 0);


 
  /*
   * Now, let's send the packets
   */
  while(packets_sent < pkt->num) {
    if(sendto(raw_socket,
              ip_icmp,
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
      ip->ip_id = BYTE_FIX(ip->ip_id); 
      ip->ip_sum = in_cksum((u_short*)ip, sizeof(struct ip), 0); 
    }


    usleep(pkt->delay);
  }

  return 0;
}
