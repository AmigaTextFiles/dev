/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_defaults.h,v 1.1 2001/06/27 21:26:29 root Exp root $
 * $Author: root $
 * rain_defaults.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_defaults.h,v $
 * Revision 1.1  2001/06/27 21:26:29  root
 * Initial revision
 *
 *-------------------------------------------------*/
#ifndef _RAIN_DEFAULTS_H_
#define _RAIN_DEFAULTS_H_

void set_defaults(struct pkt_info *,
                  struct pkt_info_tcp *,
                  struct pkt_info_icmp *,
                  struct pkt_info_igmp *);


#endif /* rain_defaults.h */
