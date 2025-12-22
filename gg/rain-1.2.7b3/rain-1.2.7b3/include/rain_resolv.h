/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_resolv.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_resolv.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_resolv.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:47  root
 * Initial revision
 *
 *-------------------------------------------------*/

#ifndef _RAIN_RESOLV_H
#define _RAIN_RESOLV_H

extern int resolv(const char *, struct sockaddr_in *);
extern int resolv_nosin(const char *, struct in_addr *);

#endif /* _RAIN_RESOLV_H */


