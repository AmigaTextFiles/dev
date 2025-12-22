/**
 **    $VER:  page_protos.h 1.0 (09.09.96)
 **
 **    prototypes for BOOPSI page.gadget
 **
 **    (C) Copyright 1996 by Jens Tröger
 **    All rights reserved.
 **
 **/

#ifndef CLIB_PAGE_PROTOS_H
#define CLIB_PAGE_PROTOS_H

#ifndef PAGE_PAGE_H
#include <page/page.h>
#endif

APTR PAGE_GetClass(void);
APTR PAGE_GetCopyright(void);

#ifndef PRAGMAS_PAGE_H
#include <pragma/page_lib.h>
#endif

#endif /* CLIB_PAGE_PROTOS_H */

