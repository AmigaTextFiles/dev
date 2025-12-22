#ifndef _INCLUDE_NEW_H
#define _INCLUDE_NEW_H

/*
**  $VER: new.h 1.0 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef NULL
#define NULL 0
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned size_t;

void (*set_new_handler(void(*)(void)))(void);

#ifdef __cplusplus
}
#endif

#endif
