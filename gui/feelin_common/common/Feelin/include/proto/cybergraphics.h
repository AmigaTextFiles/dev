#ifndef PROTO_CYBERGRAPHICS_H
#define PROTO_CYBERGRAPHICS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#if !defined(CLIB_CYBERGRAPHICS_PROTO_H) && !defined(__GNUC__)
#include <clib/cybergraphics_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *CyberGfxBase;
#endif

#ifdef __GNUC__
#include <inline/cybergraphics.h>
#else
#include <pragmas/cybergraphics_pragmas.h>
#endif

#endif /* !PROTO_CYBERGRAPHICS_H */
