#ifndef PPCPROTO_AMIPX_H
#define PPCPROTO_AMIPX_H

#include <clib/amipx_protos.h>

#ifdef __GNUC__
#include <powerup/ppcinline/amipx.h>
#else /* SAS-C */
#include <powerup/ppcpragmas/amipx_pragmas.h>
#endif

#ifndef __NOLIBBASE__
extern struct AMIPX_Library *
#ifdef __CONSTLIBBASEDECL__
__CONSTLIBBASEDECL__
#endif
AMIPX_Library;
#endif

#endif	/*  PPCPROTO_AMIPX_H  */
