#ifndef PROTO_FEELIN_H
#define PROTO_FEELIN_H

/*
**    proto/feelin.h
**
**    2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 09.00 (2005/09/26)

    Added AROS and AOS4 support.

$VER: 08.00 (2004/12/18)

************************************************************************************************/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef FEELIN_TYPES_H
#include <feelin/types.h>
#endif

/***********************************************************************************************/

#ifndef __NOLIBBASE__

    #ifdef __amigaos4__

        #ifndef __USE_BASETYPE__

            extern struct Library *
            #ifdef __CONSTLIBBASEDECL__
            __CONSTLIBBASEDECL__
            #endif
            FeelinBase;

        #else

            extern struct FeelinBase *
            #ifdef __CONSTLIBBASEDECL__
            __CONSTLIBBASEDECL__
            #endif
            FeelinBase;

        #endif

    #else

        extern struct FeelinBase *FeelinBase;

    #endif

#endif

/***********************************************************************************************/

#ifdef __amigaos4__

    #include <interfaces/feelin.h>

    #ifndef CLIB_FEELIN_PROTOS_H

        #define CLIB_FEELIN_PROTOS_H
        #include <clib/SASC_func_protos.h>

    #endif

    #ifndef __NOGLOBALIFACE__

        extern struct FeelinIFace *IFeelin;

    #endif

#else

    #ifndef CLIB_FEELIN_PROTOS_H

        #include <clib/feelin_protos.h>

    #endif

    #if defined(__GNUC__)

        #if defined(__AROS__)

            #ifndef NOLIBDEFINS
            #include <defines/feelin.h>
            #endif

        #elif defined(__PPC__)

            #ifndef _NO_PPCINLINE
            #include <ppcinline/feelin.h>
            #endif

        #else

            #ifndef _NO_INLINE
            #include <inline/feelin.h>
            #endif

        #endif

    #elif defined(__VBCC__)

        #include <inline/feelin_protos.h>

    #else

        #include <pragma/feelin_lib.h>

    #endif

#endif

/***********************************************************************************************/

#endif
