/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_services.c,v 1.1 2001/06/29 05:17:34 root Exp $
 * $Author: root $
 * rain_services.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_services.c,v $
 * Revision 1.1  2001/06/29 05:17:34  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"



/*
 * Gets service name from /etc/services 
 * (used in output only)               
 */
extern char *
service_name(int port, struct pkt_info *pkt) {
  struct servent *service = malloc(sizeof(struct servent));
  char *sname = malloc(sizeof(char)*24);
 
  if(port == 0) return "random ports";

  switch(pkt->type) {
    case DEFAULT:
    case SYN:
    case TCP:
    case TCPCONNECT:
    case TCPSTREAM:{
      if((service = getservbyport(htons(port), "tcp")) == NULL)
        return(itoa(port));
      break;
    }
    case UDP:{
      if((service = getservbyport(htons(port), "udp")) == NULL)
        return(itoa(port));
      break;
    }
    case ICMP:
    case IGMP:{ if(port == 0) return "random port"; else return(itoa(port)); }
  }      
  strcpy(sname, service->s_name);

  return sname;
}
