/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_udp.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_udp.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_udp.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:47  root
 * Initial revision
 *
 *-------------------------------------------------*/
#ifndef _RAIN_UDP_H
#define _RAIN_UDP_H

extern int udp_shower_normal(struct sockaddr_in *, struct pkt_info *);
extern int udp_shower(int raw_socket, struct sockaddr_in *source, struct sockaddr_in *target, struct pkt_info *pkt);


#endif /* _RAIN_UDP_H */
