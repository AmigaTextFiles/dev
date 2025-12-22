#ifndef PROTO_SCALOS_H
#define PROTO_SCALOS_H

#include <exec/types.h>
extern struct Library *ScalosBase ;

#include <clib/scalos_protos.h>

#ifdef VBCC
	#include <inline/scalos_protos.h>
#else
	#include <pragmas/scalos_pragmas.h>
#endif

#endif