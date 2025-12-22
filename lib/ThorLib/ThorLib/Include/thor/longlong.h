/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  23th December 1997    © 1997 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Serviceprocedures for long long integer                             **
 **                                                                     **
 *************************************************************************/

#ifndef LONGLONG_H
#define LONGLONG_H

/* A bad trick to allocate enough memory to hold long longs... */
typedef double longlong;

extern longlong __stdargs addll(longlong a,longlong b);
extern longlong __stdargs subll(longlong a,longlong b);   /* a - b */
extern longlong __stdargs mulll(longlong a,longlong b);
extern longlong __stdargs divll(longlong a,longlong b);   /* a / b */
extern longlong __stdargs remll(longlong a,longlong b);
extern longlong __stdargs negll(longlong a);
extern longlong __regargs l2ll(long a);
extern longlong __regargs ul2ll(unsigned long a);
extern longlong __stdargs maxll(longlong a,longlong b);
extern longlong __stdargs minll(longlong a,longlong b);
extern longlong __stdargs absll(longlong a);
extern int __stdargs cmpll(longlong a,longlong b);
extern longlong __stdargs shlll(longlong a,unsigned short bits);
extern longlong __stdargs shrll(longlong a,unsigned short bits);
extern long __stdargs ll2l(longlong a);

#endif
