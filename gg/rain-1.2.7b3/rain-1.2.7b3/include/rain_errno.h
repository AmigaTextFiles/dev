/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_errno.h,v 1.1 2001/07/04 20:53:45 root Exp root $
 * $Author: root $
 *
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_errno.h,v $
 * Revision 1.1  2001/07/04 20:53:45  root
 * Initial revision
 *
 *-------------------------------------------------*/
#ifndef _RAIN_ERRNO_H_
#define _RAIN_ERRNO_H_


#define R_CONFLICT    1500 /* conflicting protocol types */
#define R_CONFLICTTCP 1501 /* conflicting tcp flags */
#define R_NOSPOOF     1502 /* can't be spoofed/can't customize packets */
#define R_UNKNOWNICMP 1503 /* unknown ICMP type */
#define R_NOPROTO     1504 /* no protocol specified */
#define R_MAXLINES    1505 /* too many lines in config file */
#define R_TOOBIG      1506 /* payload length too large */

#endif /* rain_errno.h */
