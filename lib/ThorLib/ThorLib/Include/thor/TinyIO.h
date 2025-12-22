/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.01  25th December 1995     © 1995 THOR-Software inc       **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** tiny formatted printing                                             **
 **                                                                     **
 *************************************************************************/

#ifndef TINYIO_H
#define TINYIO_H

void __stdargs tinyprintf(char *,...);          /* print formatted to stdout */
void __stdargs tinyvprintf(char *,void *);      /* same with vector argument */
void __stdargs tinysprintf(char *,char *,...);  /* print formatted to string */
void __stdargs tinyvsprintf(char *,char *,void *); /* same with vector argument */

#ifdef USE_TINYIO
#define printf tinyprintf
#define sprintf tinysprintf
#define vprintf tinyvprintf
#define vsprintf tinyvsprintf
#endif

#endif


