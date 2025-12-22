#ifndef PROTO_FEELINCLASS_H
#define PROTO_FEELINCLASS_H

/*
**    proto/feelinclass.h
**
**    2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 09.00 (2005/09/29)

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

    #ifndef __USE_BASETYPE__

        extern struct Library *
        #ifdef __CONSTLIBBASEDECL__
        __CONSTLIBBASEDECL__
        #endif
        ClassBase;

    #else

        extern struct in_ClassBase *
        #ifdef __CONSTLIBBASEDECL__
        __CONSTLIBBASEDECL__
        #endif
        ClassBase;

    #endif

#endif

/***********************************************************************************************/

#ifdef __amigaos4__

    #include <interfaces/feelinclass.h>

    #ifndef CLIB_FEELINCLASS_PROTOS_H

        #define CLIB_FEELINCLASS_PROTOS_H 1
        #include <clib/SASC_func_protos.h>

    #endif

    #ifndef __NOGLOBALIFACE__

        extern struct FeelinClassIFace *IFeelinClass;

    #endif

#else

    #ifndef CLIB_FEELINCLASS_PROTOS_H

        #include <clib/feelinclass_protos.h>

    #endif

    #if defined(__GNUC__)

        #if defined(__AROS__)

            #ifndef NOLIBDEFINS
            #include <defines/feelinclass.h>
            #endif

        #elif defined(__PPC__)

            #ifndef _NO_PPCINLINE
            #include <ppcinline/feelinclass.h>
            #endif

        #else

            #ifndef _NO_INLINE
            #include <inline/feelinclass.h>
            #endif

        #endif

    #elif defined(__VBCC__)

        #include <inline/feelinclass_protos.h>

    #else

        #include <pragma/feelinclass_lib.h>

    #endif

#endif

/***********************************************************************************************/

#endif
