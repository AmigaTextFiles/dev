/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_string.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_string.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_string.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 *-------------------------------------------------*/

#ifndef _RAIN_STRING_H
#define _RAIN_STRING_H

extern char *hex2str(u_int16_t);
extern char *int2str(int);
extern char *itoa(int);
extern unsigned int atohex(char *);
extern int   ctoi(char);
extern char *strip_leading_dashes(char *);
extern char *chop(char*);


#endif /* _RAIN_STRING_H */
