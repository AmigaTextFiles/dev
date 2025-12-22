#ifndef DEBUG_H
#define DEBUG_H

/* debug.h
**
** $VER: debug.h 1.2 (17.11.94)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 17.11.94 : 001.002 :  added __LINE__ option
** 31.03.94 : 001.001 : initial
*/

#ifdef DEBUG_CODE

#define bug           kprintf
#define DB(x)        { kprintf(__FILE__ "(%4ld):" __FUNC__ "() : ",__LINE__); \
                      kprintf x ; }
#define D(x)        x

extern void kprintf(char *fmt,...);
#else
#define DB(x)
#define D(x)
#endif

#endif   /* DEBUG_H */

