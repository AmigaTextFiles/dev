#ifndef MYINCLUDE_REGISTER_H
#define MYINCLUDE_REGISTER_H

/* register.h
**
** $VER: register.h 0.1 (31.03.94)
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
** 31.03.94 : 000.001 : initial
*/

#ifdef __SASC
#define LibCall      __asm __saveds
#define RegCall      __asm
#define GetA4        __saveds

#define REGA0        register __a0
#define REGA1        register __a1
#define REGA2        register __a2
#define REGA3        register __a3
#define REGA4        register __a4
#define REGA5        register __a5
#define REGA6        register __a6
#define REGA7        register __a7

#define REGD0        register __d0
#define REGD1        register __d1
#define REGD2        register __d2
#define REGD3        register __d3
#define REGD4        register __d4
#define REGD5        register __d5
#define REGD6        register __d6
#define REGD7        register __d7
#endif

#ifdef _DCC
#define GetA4        __geta4
#define LibCall      __geta4
#define RegCall      __regargs

#define REGA0        __A0
#define REGA1        __A1
#define REGA2        __A2
#define REGA3        __A3
#define REGA4        __A4
#define REGA5        __A5
#define REGA6        __A6
#define REGA7        __A7

#define REGD0        __D0
#define REGD1        __D1
#define REGD2        __D2
#define REGD3        __D3
#define REGD4        __D4
#define REGD5        __D5
#define REGD6        __D6
#define REGD7        __D7
#endif

#endif /* !MYINCLUDE_REGISTER_H */

