#include "ares_setup.h"
#if defined(AOS3) || defined(AROS)

/*
 * Written by Carsten Larsen.
 * Public domain.
 */

#include <stdio.h>
#include <stdlib.h>
#include <clib/exec_protos.h>
#include <clib/timer_protos.h>
#include <clib/utility_protos.h>
#include <clib/alib_protos.h>

#define OPEN_ERROR       "Cannot open %s.\n"
#define OPEN_VER_ERROR   "Cannot open %s (%d.0)\n"
#define DOSLIB_NAME      "dos.library"
#define DOSLIB_REV       37L
#define BSDLIB_NAME      "bsdsocket.library"
#define BSDLIB_REV       03L
#define LIB_ERROR        5

#ifdef AOS3
#define IPTR ULONG
#endif

#ifdef AOS3
int h_errno;
#endif

struct Library* DOSBase     = NULL;
struct Library* SocketBase  = NULL;

char *prog;

void amiga_open_error(char *name)
{
    printf(OPEN_ERROR, name);
}

void amiga_open_lib_error(char *name, int version)
{
    printf(OPEN_VER_ERROR, name, version);
}

void ares_amiga_cleanup()
{
    if (SocketBase != NULL) {
        CloseLibrary(SocketBase);
        SocketBase = NULL;
    }

    if (DOSBase != NULL) {
        CloseLibrary(DOSBase);
        DOSBase = NULL;
    }
}

int ares_amiga_init()
{
    if((DOSBase = OpenLibrary((STRPTR)DOSLIB_NAME, DOSLIB_REV)) == NULL) {
        amiga_open_lib_error(DOSLIB_NAME, DOSLIB_REV);
        return LIB_ERROR;
    }

    if((SocketBase = OpenLibrary((STRPTR)BSDLIB_NAME, BSDLIB_REV)) == NULL) {
        amiga_open_lib_error(BSDLIB_NAME, BSDLIB_REV);
        return LIB_ERROR;
    } else {
        SocketBaseTags(
            SBTM_SETVAL(SBTC_ERRNOPTR(sizeof(errno))), (IPTR) &errno,
            SBTM_SETVAL(SBTC_HERRNOLONGPTR),           (IPTR) &h_errno,
            SBTM_SETVAL(SBTC_LOGTAGPTR),               (IPTR) &prog,
            TAG_DONE );
    }
    
    return 0;
}

#endif

