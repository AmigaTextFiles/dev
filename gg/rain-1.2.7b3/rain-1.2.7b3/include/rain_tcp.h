/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_tcp.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_tcp.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_tcp.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:47  root
 * Initial revision
 *
 * Revision 1.1  2001/06/08 20:03:19  root
 * Initial revision
 *-------------------------------------------------*/
#ifndef _RAIN_TCP_H
#define _RAIN_TCP_H

unsigned char tcpinfo[25];

extern void tcp_info_init(struct pkt_info_tcp *);
extern int tcp_shower_connect(struct sockaddr_in *, struct pkt_info *);
extern int tcp_shower_stream(struct sockaddr_in *, struct pkt_info *);
extern int tcp_shower(int, struct sockaddr_in *, struct sockaddr_in *, struct pkt_info *, struct pkt_info_tcp *);
extern int tcpflood(int, struct sockaddr_in *);


#endif /* _RAIN_TCP_H */
