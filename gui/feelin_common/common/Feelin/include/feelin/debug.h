#ifndef FEELIN_DEBUG_H
#define FEELIN_DEBUG_H

/*
**  Debug interface
**
**  2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 01.10 (2005/12/28)

    HOMBRE : Debug macros for library OPEN / CLOSE / EXPUNGE moved here

$VER: 01.00 (2005/12/08)

************************************************************************************************/

#ifndef NDEBUG

#ifndef __AROS__
#include <clib/debug_protos.h>
#endif

#define DEBUG_NULL(x)       KPrintF x
#ifdef __SASC
#define DEBUG_FCT(x)        DEBUG_NULL(x)
#else
#define DEBUG_FCT(x)        KPrintF("%s: ", __FUNCTION__); DEBUG_NULL(x)
#endif
#define DEBUG_INIT(b,sl,sb) KPrintF("init: libbase (0x%08lx) seglist (0x%08lx) sysbase (0x%08lx)\n", (b), (sl), (sb));
#define DEBUG_LIBFCT(n, b)  KPrintF("LIB_" n ": FeelinBase 0x%08lx <%s> OpenCount %ld\n", (b), (b)->Public.Libnode.lib_Node.ln_Name, (b)->Public.Libnode.lib_OpenCnt);
#define DEBUG_OPEN(b)       DEBUG_LIBFCT("Open", b)
#define DEBUG_CLOSE(b)      DEBUG_LIBFCT("Close", b)
#define DEBUG_EXPUNGE(b)    DEBUG_LIBFCT("Expunge", b)

#else

#define DEBUG_NULL(x)
#define DEBUG_FCT(x)
#define DEBUG_INIT(b, sl, sb)
#define DEBUG_LIBFCT(n, b)
#define DEBUG_OPEN(b)
#define DEBUG_CLOSE(b)
#define DEBUG_EXPUNGE(b)

#endif /* !NDEBUG */

#endif /* FEELIN_DEBUG_H */
