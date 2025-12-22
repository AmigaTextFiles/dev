#ifndef _PROTO_C2P_H
#define _PROTO_C2P_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#if !defined(CLIB_C2P_PROTOS_H) && !defined(__GNUC__)
#include "./clib/c2p_protos.h"
#endif

#ifndef __NOLIBBASE__
extern struct Library *C2PBase;
#endif

#ifdef __GNUC__
#include <inline/c2p.h>
#elif defined(__VBCC__)
/*
#if defined(__MORPHOS__) || !defined(__PPC__)
#include <inline/c2p_protos.h>
#endif
*/
#else
#include <pragma/c2p_lib.h>
#endif

#include "c2p_system.h"
#include "c2p_context.h"

#endif	/*  _PROTO_C2P_H  */
