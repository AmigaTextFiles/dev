/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_igmp.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_igmp.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_igmp.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:47  root
 * Initial revision
 *
 *-------------------------------------------------*/
#ifndef _RAIN_IGMP_H
#define _RAIN_IGMP_H

unsigned char igmpinfo[56][56][5];


extern void print_igmp_info(void);
extern void igmp_info_init(struct pkt_info_igmp *);
extern int igmp_shower(int, struct sockaddr_in *, struct sockaddr_in *, struct pkt_info *, struct pkt_info_igmp *);


#endif /* _RAIN_IGMP_H */
