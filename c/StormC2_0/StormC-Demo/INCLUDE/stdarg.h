#ifndef _INCLUDE_STDARG_H
#define _INCLUDE_STDARG_H

/*
**  $VER: stdarg.h 1.1 (13.6.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned int va_list;

#define va_start(vl,lastarg) (vl) = (unsigned int)(&lastarg) + ((sizeof(lastarg) + 1) & 0xfffffffe);
#define va_arg(vl,type) ((vl) += sizeof(type) <= 4 ? 4 : (sizeof(type) + 1) & 0xfffffffe, \
                         *((type *) (vl - sizeof(type))))
#define va_end(vl) __never_inline

#ifdef __cplusplus
}
#endif

#endif
