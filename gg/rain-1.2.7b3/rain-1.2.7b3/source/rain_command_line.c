/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_command_line.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_command_line.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_command_line.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:26  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"



/*
 * filters unwanted characters out of the command line arguments
 * for hopes to avoid any rare (but possible) overflows.        
 */
extern char *
filter_argument(char *arg) {
  int i = 0;
  
  while(arg[i]) {
    if((arg[i] == '%') || (arg[i] == '&') || (arg[i] == '/')) { 
      arg[i] = '\0';
      printf("\nWARNING: Do not use special characters in command line!\n");
    }
    i++;
  }
  return arg;
}


/*
 * Parses our command line arguments, storing various options
 * in various packet structures..                             
 */
void parse_command_line(int argc, char **argv,
                        struct pkt_info *pkt,
                        struct pkt_info_tcp  *pkttcp,
                        struct pkt_info_icmp *pkticmp,
                        struct pkt_info_igmp *pktigmp,
                        u_short *have_target_host)
{

  int i = 1; /* Set i to 1 so we don't touch argv[0] */
  int userid = getuid();
  

  /* 
   * Loop through the arguments 
   */
  while(i < argc) {
    /* filter out character used to exploit i/o */
    argv[i] = filter_argument(argv[i]);

    if( (argv[i][0] == '-')  && (strlen(argv[i]) == 2) ) {
      switch(argv[i][1]) {

/* TARGET IS BROADCAST */
	case 'B':
	case 'b':{
          pkt->bcast = 1;
	  break;
	}
/* PACKET COUNT */
	case 'C':
	case 'c':{
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
	  pkt->num = atoi(argv[i + 1]);
	  if(pkt->num == 0) pkt->num = -1;
	  break;
	}

/* DELAY IN MICROSECONDS */
        case 'D':
        case 'd':{
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->delay = (u_long)atol(argv[i + 1]);
          break;
        }

/* GATEWAY/GROUP ADDRESS */
        case 'G':
        case 'g':{
          UID_CHECK(userid,argv[i]);
          if((pkt->type != IGMP) && (pkt->type != ICMP))
            DieWithError("-g can only be used with ICMP and IGMP", 0);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          strcpy(pkt->gaddr, argv[i + 1]);
          break;
        }

/* DESTINATION PORT */
        case 'P':
        case 'p':{
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->dport = (u_int16_t)atoi(argv[i + 1]);
          if(pkt->dport == 0) pkt->rdport = 1;
          break;
        }          

/* SOURCE ADDRESS */
        case 'S':
        case 's':{
          UID_CHECK(userid,argv[i]);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          if((pkt->type == TCPSTREAM) || (pkt->type == TCPCONNECT))
            DieWithError("streamed connections cannot be spoofed",R_NOSPOOF);
          strcpy(pkt->saddr, argv[i + 1]);
          pkt->randip = 0;
          if(ctoi(argv[i + 1][0]) == 0) pkt->randip = 1;
          break;
        }

/* TARGET ADDRESS */
        case 'T':
        case 't':{
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          strcpy(pkt->daddr, argv[i + 1]);
          *have_target_host = TRUE;
          break;
        }

/* VERBOSE MODE */
        case 'v':{ UID_CHECK(userid,argv[i]); if(!(verbose > 10)) verbose++; break; }
        case 'V':{
          DieWithVersion();
        }

/* UNKNOWN SINGLE CHAR OPTION */
        default:{
          DieWithBadArg(argv[i]);
        }
      }

/*
 * We're done with the single letter options..
 * Now, let's go on to the "whole word" options.. 
 */
    } else if ( (argv[i][0] == '-')  && (strlen(argv[i]) > 2) ) {

/* PRINT HELP */
        if(strcmp(argv[i], "--help") == 0) {
          if(argv[i + 1] == NULL) DieWithHelp(argv[0], NULL);
          else DieWithHelp(argv[0], argv[i + 1]);
        }

/* PACKET SIZE */
        else if(strcmp(argv[i], "--size") == 0) {
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          packetsize = (u_int16_t)atoi(argv[i + 1]);
        }

/* DESTINATION PORT */
        else if((strcmp(argv[i], "--dport") == 0) || (strcmp(argv[i], "--destination-port") == 0)) {
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->dport = (u_int16_t)atoi(argv[i + 1]);
          if(pkt->dport == 0) pkt->rdport = 1;
        }

/* SOURCE ADDRESS */
        else if(strcmp(argv[i], "--source") == 0) {
          UID_CHECK(userid,argv[i]);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
            DieWithError("streamed connections cannot be spoofed", R_NOSPOOF);
          strcpy(pkt->saddr, argv[i + 1]);
          pkt->randip = 0;
          if(atoi(argv[i + 1]) == 0) pkt->randip = 1;
          break;
        }

/* SOURCE PORT */
        else if((strcmp(argv[i], "--sport") == 0) || (strcmp(argv[i], "--source-port") == 0)) {
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->sport = (u_int16_t)atoi(argv[i + 1]);
          if(pkt->sport == 0) pkt->rsport = 1;
        }

/* TIMEOUT IN SECONDS */
        else if(strcmp(argv[i], "--timeout") == 0) {
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->timeout = atoi(argv[i + 1]);
        }        

/* SIMULATION MODE */
        else if(strcmp(argv[i], "--sim") == 0) {
          UID_CHECK(userid,argv[i]);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->simulate = 1;
          pkt->simtype  = atoi(argv[i + 1]);
          switch(pkt->simtype) {

            /* fawx2.c */
            case 0: { pkt->type = IGMP; pktigmp->type = 2; pktigmp->code = 31; pkt->frag = 1; 
                      pkt->frag_off = htons(0|0x2000); pkt->id = 27565; pkt->tos = 0; 
            break; }

            /* bloop.c */
            case 1: { pkt->type = ICMP; pkticmp->type = 12; pkticmp->code = 0; pkt->frag = 1; pkt->frag_off = (8>>3); 
            pkt->tos = 0; break; }

            /* jolt2.c */
            case 2: { pkt->type = ICMP; pkticmp->type = 8; pkticmp->code = 0; pkt->frag = 1; pkt->frag_off = 8190;
            pkt->tos = 0; break; }
            
            /* trash2.c */
            case 3: { pkt->type = IGMP; pktigmp->type = 0; pktigmp->code = 0; pkt->randip = 1; pkt->frag = 1; 
                      pkt->frag_off = 0x2000; 
            pkt->tos = 0; break; }
           
            /* raped.c */
            case 4: { pkt->type = TCP; pkttcp->ack = 1; pkt->tos = 0x08; pkt->ttl = 255; pkt->randip = 1;
                      pkt->sport = 0; pkt->dport = 0; break; }

            default: { DieWithError("Uncrecognized simulation type. Try --help --sim\n", 0); }
          }
        }

/* UDP */
        else if(strcmp(argv[i], "--udp") == 0) {
          if((pkt->type != DEFAULT) && (pkt->type != USERDEFAULT) && (pkt->type != UDP)) 
		  DieWithError("conflicting protocol types", R_CONFLICT);
          pkt->type = UDP;
        }

/* TCP */
        else if(strcmp(argv[i], "--tcp") == 0) {
          if((pkt->type != DEFAULT) && (pkt->type != USERDEFAULT) && (pkt->type != TCP)) 
            DieWithError("conflicting protocol types", R_CONFLICT);
          if(pkt->type == USERDEFAULT) pkt->type = TCPSTREAM;
          else pkt->type = TCP;
        }

/* NON-BLOCKING I/O */
	else if(strcmp(argv[i], "--noblock") == 0) {
          pkt->noblock = 1;
        }

/* TCP STREAM */
        else if(strcmp(argv[i], "--stream") == 0) {
          if((pkt->type != DEFAULT) && (pkt->type != TCP) && (pkt->type != USERDEFAULT)) 
            DieWithError("conflicting protocol types", R_CONFLICT);
            if(pkttcp->beenset == 1) DieWithError("you cannot customize packets with --stream", 0);
          pkt->type = TCPSTREAM;
        }

/* TCP CONNECT */
        else if(strcmp(argv[i], "--connect") == 0) {
          if((pkt->type != DEFAULT) && (pkt->type != TCP) && (pkt->type != USERDEFAULT)) 
            DieWithError("conflicting protocol types", R_CONFLICT);
            if(pkttcp->beenset == 1) DieWithError("you cannot customize packets with --connect", 0);
          pkt->type = TCPCONNECT;
        }

/* TCP SEQUENCE NUMBER */
        else if(strcmp(argv[i], "--seq") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != TCP)) DieWithError("conflicting protocol types", R_CONFLICT);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->type = TCP;
          pkttcp->seq  = (u_int16_t)atoi(argv[i + 1]);
        }

/* TCP WINDOW SIZE */
        else if(strcmp(argv[i], "--win") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != TCP)) DieWithError("conflicting protocol types", R_CONFLICT);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->type = TCP;
          pkttcp->window = (u_int16_t)atoi(argv[i + 1]);
        }

/* TCP URG BIT */
        else if(strcmp(argv[i], "--urg") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != TCP)) DieWithError("conflicting protocol types", R_CONFLICT);
          pkt->type = TCP;
          pkttcp->beenset = 1;
          pkttcp->urg = 1;
        }

/* TCP ACK BIT */
        else if(strcmp(argv[i], "--ack") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != TCP)) DieWithError("conflicting protocol types", R_CONFLICT);
          if(pkt->simulate == 1) DieWithError("arguments conflict with simulation mode", 0);
          pkt->type = TCP;
          pkttcp->beenset = 1;
          pkttcp->ack = 1;
        }

/* TCP ACK SEQUENCE */
        else if(strcmp(argv[i], "--ack-seq") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != TCP)) DieWithError("conflicting protocol types", R_CONFLICT);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->type = TCP;
          if((argv[i + 1][0] == '0') && (argv[i + 1][1] == 'x'))
            pkttcp->ack_seq = atohex(argv[i + 1]);
          else
            pkttcp->ack_seq  = atoi(argv[i + 1]);
        }

/* TCP PSH BIT */
        else if(strcmp(argv[i], "--psh") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != TCP)) DieWithError("conflicting protocol types", R_CONFLICT);
          pkt->type = TCP;
          pkttcp->beenset = 1;
          pkttcp->psh = 1;
        }

/* TCP RST BIT */
        else if(strcmp(argv[i], "--rst") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != TCP)) DieWithError("conflicting protocol types", R_CONFLICT);
          pkt->type = TCP;
          pkttcp->beenset = 1;
          pkttcp->rst = 1;
        }

/* TCP SYN BIT */
        else if(strcmp(argv[i], "--syn") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != TCP)) DieWithError("conflicting protocol types", R_CONFLICT);
          pkt->type = TCP;
          pkttcp->beenset = 1;
          pkttcp->syn = 1;
        }

/* TCP FIN BIT */
        else if(strcmp(argv[i], "--fin") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != TCP)) DieWithError("conflicting protocol types", R_CONFLICT);
          pkt->type = TCP;
          pkttcp->beenset = 1;
          pkttcp->fin = 1;
        } 

/* ICMP */     
        else if(strcmp(argv[i], "--icmp") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != ICMP)) DieWithError("conflicting protocol types", R_CONFLICT);
          pkt->type = ICMP;
        }

/* ICMP TYPE */
        else if(strcmp(argv[i], "--icmp-type") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->type = ICMP;
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          if((argv[i + 1][0] == '0') && (argv[i + 1][1] == 'x'))
            pkticmp->type = atohex(argv[i + 1]);
          else
            pkticmp->type = atoi(argv[i + 1]);
        }

/* ICMP CODE */
        else if(strcmp(argv[i], "--icmp-code") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->type = ICMP;
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          if((argv[i + 1][0] == '0') && (argv[i + 1][1] == 'x'))
            pkticmp->code = atohex(argv[i + 1]);
          else
            pkticmp->code = atoi(argv[i + 1]);
        }

/* ICMP ID (for echo) */
        else if(strcmp(argv[i], "--icmp-id") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->type = ICMP;
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkticmp->id = atoi(argv[i + 1]);
        }

/* ICMP SEQUENCE (for echo) */
        else if(strcmp(argv[i], "--icmp-seq") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->type = ICMP;
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkticmp->seq = atoi(argv[i + 1]);
        }

/* ICMP NEXT MTU */
        else if(strcmp(argv[i], "--icmp-mtu") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->type = ICMP;
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkticmp->mtu = atoi(argv[i + 1]);
        }

/* ICMP GATEWAY ADDRESS */
        else if(strcmp(argv[i], "--icmp-gw") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->type = ICMP;
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          strcpy(pkt->gaddr, argv[i + 1]);
        }

/* IGMP */
        else if(strcmp(argv[i], "--igmp") == 0) {
          UID_CHECK(userid,argv[i]);
          if((pkt->type != DEFAULT) && (pkt->type != IGMP)) DieWithError("conflicting protocol types", R_CONFLICT);
          pkt->type = IGMP;
        }

/* IGMP TYPE */
        else if(strcmp(argv[i], "--igmp-type") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->type = IGMP;
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          if((argv[i + 1][0] == '0') && (argv[i + 1][1] == 'x'))
            pktigmp->type = atohex(argv[i + 1]);
          else
            pktigmp->type = atoi(argv[i + 1]);
        }

/* IGMP CODE */
        else if(strcmp(argv[i], "--igmp-code") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->type = IGMP;
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          if((argv[i + 1][0] == '0') && (argv[i + 1][1] == 'x'))
            pktigmp->code = atohex(argv[i + 1]);
          else
            pktigmp->code = (u_int8_t)atoi(argv[i + 1]);
        }

/* IGMP GROUP ADDRESS */
        else if(strcmp(argv[i], "--igmp-ga") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->type = IGMP;
          if((pkt->type != IGMP) && (pkt->type != ICMP))
            DieWithError("--igmp-ga can only be used with ICMP and IGMP", 0);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          strcpy(pkt->gaddr, argv[i + 1]);
        }

/* LIST ICMP TYPES */
        else if(strcmp(argv[i], "--list-icmp") == 0) {
          print_icmp_info();
        }

/* LIST IGMP TYPES */
        else if(strcmp(argv[i], "--list-igmp") == 0) {
          print_igmp_info();
        }

/* PACKET PAYLOAD */
        else if((strcmp(argv[i], "--payload") == 0) || (strcmp(argv[i], "--pl") == 0)) {
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          strcpy(pkt->payload,argv[i + 1]);
          pkt->payload[strlen(pkt->payload) + 1] = '\0';
        }

/* PAYLOAD FILLER CHAR */
        else if((strcmp(argv[i], "--fill") == 0) || (strcmp(argv[i], "--pl") == 0)) {
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->filler = ctoi(argv[i + 1][0]);
        }

/* FRAGMENTATION OFFSET */
        else if(strcmp(argv[i], "--frag") == 0) {
          UID_CHECK(userid,argv[i]);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->frag = 1;
          if((argv[i + 1][0] == '0') && (argv[i + 1][1] == 'x'))
            pkt->frag_off = atohex(argv[i + 1]);
          else
            pkt->frag_off = (u_int16_t)atoi(argv[i + 1]);
        }

/* SET DON'T FRAGMENT BIT */
        else if(strcmp(argv[i], "--df") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->dfrag = 1;
        }

/* TYPE OF SERVICE (TOS) */
        else if(strcmp(argv[i], "--tos") == 0) {
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          if((argv[i + 1][0] == '0') && (argv[i + 1][1] == 'x'))
            pkt->tos = atohex(argv[i + 1]);
          else
            pkt->tos = (u_short)atoi(argv[i + 1]);
        }

/* TIME TO LIVE (TTL) */
        else if(strcmp(argv[i], "--ttl") == 0) {
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          pkt->ttl = (u_int8_t)atoi(argv[i + 1]);
	  if(pkt->ttl == 0) printf("WARNING: TTL is 0. Packet will most likely not reach the target host.\n");
        }

/* IP ID */
        else if(strcmp(argv[i], "--id") == 0) {
          UID_CHECK(userid,argv[i]);
          if((argv[i + 1] == NULL) || (argv[i + 1][0] == '-')) DieWithRequire(argv[i]);
          if((argv[i + 1][0] == '0') && (argv[i + 1][1] == 'x'))
            pkt->id = atohex(argv[i + 1]);
          else
            pkt->id = atoi(argv[i + 1]);
        }

/* OVERLOAD IP-ID FIELD */
        else if(strcmp(argv[i], "--id-of") == 0) {
          UID_CHECK(userid,argv[i]);
          pkt->id_of = 1;
        }

/* PRINT VERSION */
        else if(strcmp(argv[i], "--version") == 0) {
          DieWithVersion();
        } 

/* BAD ARGUMENT */
        else { DieWithBadArg(argv[i]); } 
      }
    i++;
  }

  return;
}
