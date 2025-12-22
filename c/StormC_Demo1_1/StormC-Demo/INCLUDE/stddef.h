#ifndef _INCLUDE_STDDEF_H
#define _INCLUDE_STDDEF_H

/*
**  $VER: stddef.h 1.01 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef NULL
#define NULL 0
#endif

#define offsetof(s,m) ((unsigned int) &((s *) NULL)->m)

typedef unsigned size_t;
typedef int ptrdiff_t;
typedef int wchar_t;

// obsolete Defs

#define __asm
#define __stdargs

#endif
