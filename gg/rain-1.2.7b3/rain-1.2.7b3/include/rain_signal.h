/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_signal.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 *
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_signal.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:47  root
 * Initial revision
 *
 *-------------------------------------------------*/

#ifndef _RAIN_SIGNAL_H
#define _RAIN_SIGNAL_H

extern void signal_init(void);
extern RETSIGTYPE catch_signal(int);


#endif /* _RAIN_SIGNAL_H */
