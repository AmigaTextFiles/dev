#ifndef _INCLUDE_PRAGMA_TRANSLATOR_LIB_H
#define _INCLUDE_PRAGMA_TRANSLATOR_LIB_H

/*
**  $VER: translator_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_TRANSLATOR_PROTOS_H
#include <clib/translator_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(TranslatorBase, 0x1e, Translate(a0,d0,a1,d1))

#ifdef __cplusplus
}
#endif

#endif
