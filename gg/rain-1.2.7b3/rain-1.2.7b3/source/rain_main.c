/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_main.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_main.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU/GPL
 *
 * $Log: rain_main.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:26  root
 * Initial revision
 *
 *-------------------------------------------------*/

#include "rain_common.h"


/* Prints banner */
void banner(void) {
  printf("\n[ rain %s by Evil (mystic@tenebrous.com) ] [pid:%d]\n", RAIN_VERSION, getpid());
  return;
}


int main(int argc, char **argv) 
{
  /* 
   * our raw socket descriptor 
   */
  int raw_socket; 
  
  /* 
   * target and source internet structures 
   */
  struct sockaddr_in target, source;

  /* 
   * This is set to TRUE when we know a 
   * target host was specified 
   */
  u_short have_target_host = FALSE;

  /* 
   * Generic packet info structure 
   * This structure is the "meat" of rain.
   */
  struct pkt_info *pkt = malloc(sizeof(struct pkt_info));

  /* 
   * Packet info ICMP structure 
   */
  struct pkt_info_icmp *pkticmp  = malloc(sizeof(struct pkt_info_icmp));

  /* 
   * Packet info IGMP structure 
   */
  struct pkt_info_igmp *pktigmp  = malloc(sizeof(struct pkt_info_igmp));

  /* 
   * Packet info TCP structure 
   */
  struct pkt_info_tcp  *pkttcp   = malloc(sizeof(struct pkt_info_tcp));

  /* 
   * siminfo is used to print simulation types 
   */
  static unsigned char siminfo[6][16] = {
    "fawx2.c",
    "bloop.c",
    "jolt2.c",
    "trash2.c",
    "raped.c"
  };



  /* 
   * Make stdout unbuffered, so that text is displayed immediately 
   */
  setvbuf(stdout,NULL,_IONBF,0);


  /* 
   * Signal handling (required)
   */
  signal_init();


  /* 
   * set defaults for all packet types: 
   */
    set_defaults(pkt, 
                 pkttcp,
                 pkticmp,
                 pktigmp);

    packets_sent = 0;

  

  


  /* 
   * process command line arguments 
   */
  /*---------------------------------------------------------------------------------------------------*/
  parse_command_line(argc, 
                     argv, 
                     pkt, 
                     pkttcp, 
                     pkticmp, 
                     pktigmp, 
                     &have_target_host);
  /*---------------------------------------------------------------------------------------------------*/


  /* 
   * display banner 
   */
  banner();


  /* 
   * If no protocol was specified, we'll do that now: 
   */
  if(pkt->type == DEFAULT) pkt->type = TCP;

  
  /* 
   * Die with usage if user didn't specify a target host (the only mandatory option) 
   */
  if(have_target_host == FALSE) DieWithUsage(argv[0]);



  /* 
   * Make sure length of payload doesn't exceed packetsize 
   */
  if(strlen(pkt->payload) > (packetsize-128))
    DieWithError("Payload too large", R_TOOBIG);

  /* 
   * Resolve target host and set the port number 
   */
  if(resolv(pkt->daddr, &target) < 0) DieWithError("could not resolve target hostname", TRY_AGAIN);
  target.sin_port   = htons(pkt->dport);


  /*
   * Resolve source host
   */
  if(pkt->randip == 0) {
    if(resolv(pkt->saddr, &source) < 0) 
      DieWithError("could not resolve source hostname", TRY_AGAIN);
  } else {
    source.sin_addr.s_addr = rand();
    strcpy(pkt->saddr, inet_ntoa(source.sin_addr));
  }


  /* Set the source port */
  source.sin_port = htons(pkt->sport);   



/* IF ROOT START */

  if(getuid() == 0) {
    /* 
     * Create a RAW socket 
     */ 
      if((raw_socket = socket(AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0)
        DieWithError("raw socket()", 0);



    /*
     * IP_HDRINCL 
     * This socket options tells the kernel that we are going to
     * include our own IP header. In Linux, by default, the
     * kernel automatically appends its own IP header to outgoing
     * datagrams. However, this is not the case in *BSD.. so we will
     * include our own IP headers anyway.
     */
     sethdrinclude(raw_socket);


    /*
     * Set socket non-blocking if specified 
     * This simply means that socket functions
     * will not wait until a specified criteria has been met
     * before returning from the specified calls..
     */
    if(pkt->noblock == 1)
      fcntl(raw_socket, F_SETFL, O_NONBLOCK);


    /* 
     * Set the socket's send buffer size if specified 
     */
    if(pkt->sndbuf == 1)
      setsndbuf(raw_socket, packetsize);

   
    /*
     * Set the socket's receive buffer size if specified
     * note: There is no need to implement this. (yet)   
     */
/*
    if(pkt->rcvbuf == 1)
      setrcvbuf(raw_socket, packetsize);
*/


   /*
    * Allows broadcast messages if -b is specified
    */
    if(pkt->bcast == 1)
      setbcast(raw_socket);



 } /* IF ROOT END */




  /* set the start-time */
  send_start = time(NULL);

/**********************************************************************************
 *     O U T P U T  S T A R T S  H E R E                                          *
 **********************************************************************************/

  /*
   * This prints if user specified --sim <num>
   */
  if(pkt->simulate == 1) printf("\n--- Using simulation mode: %s", siminfo[pkt->simtype]);


  /*
   * This prints if user specified --noblock
   */
  if(pkt->noblock == 1)  printf("\n--- Using non-blocking I/O");

   /* 
    * -b was not specified, but destination looks like a broadcast
    * address.. We'll allow broadcast just incase. 
    * If we're wrong, this will have no effect.
    */
    if((pkt->bcast == 0) && (strstr(pkt->daddr,"255") != NULL)) {
      printf("\n--- Assuming %s is a broadcast address\n", pkt->daddr);
      if(getuid() == 0)
        setbcast(raw_socket);
    }



  /* 
   * MAIN OUTPUT
   */
  printf("\n");
  printf("source host/port: ");

  if(pkt->randip == 1) printf("random hosts / ");
  else printf("%s / ",pkt->saddr); 

  /*
   * Prints service associated with port
   * (prints port if no service is associated)
   */
  printf("%s\n", service_name(pkt->sport, pkt));

  printf("target host/port: %s / %s\n", pkt->daddr, service_name(pkt->dport, pkt));
  printf("packet style....: ");

  /*
   * Different packet types have different verbose output
   */
  switch(pkt->type) {
    case TCPCONNECT:{ printf("TCP connection (streamed)\n"); break; }
    case TCPSTREAM:{ printf("TCP send (streamed)\n"); break; }
    case TCP:{ tcp_info_init(pkttcp); 
               if(tcpinfo[0] == 0)
                 printf("TCP (no flags set)\n");
               else
                 printf("TCP (%s)\n", tcpinfo);
               break;
             }

    case UDP:{ if(getuid() == 0) { printf("UDP\n"); break; } else { printf("UDP (non-spoofed)\n"); break; }  }
    case ICMP:{ icmp_info_init(pkticmp); printf("ICMP%s\n", icmpinfo[pkticmp->type][pkticmp->code]); break; }
    case IGMP:{ igmp_info_init(pktigmp); printf("IGMP%s\n", igmpinfo[pktigmp->type][pktigmp->code]); break; }
    default:{ DieWithError("You must specify a protocol to use",R_NOPROTO); } /* shouldn't be reached */ 
  }


  if(verbose > 0) {
    printf("flags...........: tos=%s; frag offset=%s;", 
            hex2str(pkt->tos), pkt->frag == 1 ? hex2str(pkt->frag_off) : "none");
    if(pkt->dfrag == 1) printf(" DF;");
  }


  if(verbose > 1) {
    printf("\n                : ttl=%d; id=%s;", pkt->ttl, (pkt->id_of == 1 ? "overflow" : itoa(pkt->id)));


    switch(pkt->type) {
      case TCP:
      case TCPSTREAM:
      case TCPCONNECT:{ printf(" window size=%d; ack sequence=%s;", pkttcp->window,
                                (pkttcp->ack_seq == 0 ? "overflow" : itoa(pkttcp->ack_seq)));
                                                 
                        break;
                      }
      case ICMP:{ 
        if((verbose > 1) && (pkticmp->type == 11)) {
          time_t now = time(NULL);
          char *mytime = ctime(&now);
           mytime = chop(mytime);
           printf("\n                : otime, rtime, ttime=%s;", mytime); 

        }
           if(ctoi(pkt->gaddr[0]) == 0)
             printf("\n                : gateway=random;");
	   else
             printf("\n                : gateway=%s;", pkt->gaddr);
        break;
      }

      case IGMP:{ 
                  printf(" group=%s; ", pkt->gaddr);
                  if(pktigmp->type == 17) 
                    printf("\n                : max response time=%d;", pktigmp->code);
                  break;
                } 
   }
  }


  if(verbose > 0) printf("\n");

  /* 
   * Print description of the packet's Type of Service 
   */
  if(verbose > 1) { 

    printf("type of service.: "); 

    if(pkt->tos & TOS_LOW_DELAY)          printf("low delay; ");
      else printf("normal delay; ");

    if(pkt->tos & TOS_HIGH_THROUGHPUT)    printf("high throughput; ");
      else printf("normal throughput; ");

    if(pkt->tos & TOS_HIGH_RELIABILITY)   printf("high reliability; ");
      else printf("normal reliability; ");


    printf("\n");

    printf("tos precedence..: ");
    if(pkt->tos & TOSP_NETWORK_CONTROL)      printf("network control; ");
    if(pkt->tos & TOSP_INTERNETWORK_CONTROL) printf("internetwork control; ");
    if(pkt->tos & TOSP_CRITIC_ECP)           printf("critic/ecp; ");
    if(pkt->tos & TOSP_FLASH_OVERRIDE)       printf("flash override; ");
    if(pkt->tos & TOSP_FLASH)                printf("flash; ");
    if(pkt->tos & TOSP_IMMEDIATE)            printf("immediate; ");
    if(pkt->tos & TOSP_PRIORITY)             printf("priority; ");
    if(pkt->tos & TOSP_ROUTINE)              printf("routine; ");
    printf("\n");
  }


  if(verbose > 1) { printf("payload.........: %s\n", pkt->payload); } 
 


  /* 
   * start the timer: 
   */
  send_start = time(NULL);


  printf("\nShowering %s (%.1fk) drops; Hit CTRL+C to stop\n", int2str(pkt->num), ((float)packetsize/1024));


  /* 
   * send packets based on type 
   */
  switch(pkt->type) {

    case TCPCONNECT: {
      if(tcp_shower_connect(&target, pkt) < 0) 
        DieWithError("error in TCP stream shower", 0);
      /*
       * This could is only reached if the user specifies -c <number>
       * Normally, packets will be sent until a SIGINT (CTRL+C) is received.
       * This will raise a SIGINT signal when the shower exits.
       */
      raise(SIGINT);
      break;
    }

    case TCPSTREAM: {
      if(tcp_shower_stream(&target, pkt) < 0) 
        DieWithError("error in TCP stream shower", 0);
      raise(SIGINT);
      break;
    }

    case TCP:{
      if(tcp_shower(raw_socket, &source, &target, pkt, pkttcp) < 0) 
        DieWithError("error in TCP shower", 0);
      raise(SIGINT);
      break;
    }

    case UDP:{
      if(getuid() == 0) { /* root */
        if(udp_shower(raw_socket, &source, &target, pkt) < 0) 
          DieWithError("error in UDP shower", 0);
        raise(SIGINT);
        break;
      } else { /* non-root */
        if(udp_shower_normal(&target, pkt) < 0) 
          DieWithError("error in UDP shower (non-spoofed)", 0);
        raise(SIGINT);
        break;
      }
    }

    case ICMP:{
      if(icmp_shower(raw_socket, &source, &target, pkt, pkticmp) < 0) 
        DieWithError("error in ICMP shower", 0);
      raise(SIGINT);
      break;
    }

    case IGMP:{
      if(igmp_shower(raw_socket, &source, &target, pkt, pktigmp) < 0) 
        DieWithError("error in IGMP shower", 0);
      raise(SIGINT);
      break;
    }
    default:{ DieWithError("You must specify a protocol to use", R_NOPROTO); }
  }

  return 0;
}


/* 
 * Used for the RCS 'ident' program  - PLEASE DO NOT REMOVE OR ALTER 
 */
static const char author[]    = {"$Creator: rain by Evil (mystic@tenebrous.com) $"};
static const char copyright[] = {"$Copyright: (c) 2001 mystic@tenebrous.com $"};
