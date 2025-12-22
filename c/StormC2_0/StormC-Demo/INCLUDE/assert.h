#ifndef _INCLUDE_ASSERT_H
#define _INCLUDE_ASSERT_H

/*
**  $VER: assert.h 1.01 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifdef NDEBUG
#define assert(C)
#else
#ifdef __cplusplus
extern "C" {
#endif
void do_assert(char *, char *, char *, unsigned int);
#ifdef __cplusplus
}
#endif
#define assert(C) { if(!(C)) do_assert(#C, __FILE__, __FUNC__, __LINE__); }
#endif

#endif
