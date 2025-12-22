/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_die.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_die.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_die.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:47  root
 * Initial revision
 *
 *-------------------------------------------------*/
#ifndef _RAIN_DIE_H
#define _RAIN_DIE_H

extern void DieWithVersion(void);
extern void DieWithError(char *, int);
extern void DieWithIncompatible(char *, char *);
extern void DieWithHelp(char *, char *);
extern void DieWithRequire(char *);
extern void DieWithBadArg(char *);
extern void DieWithUsage(char *);

#endif /* _RAIN_DIE_H */
