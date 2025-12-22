#ifndef PROTO_ICONOBJECT_H
#define PROTO_ICONOBJECT_H
#include <exec/types.h>

extern struct Library *IconobjectBase;
#include <clib/iconobject_protos.h>

#ifdef VBCC
	#include <inline/iconobject_protos.h>
#else
	#include <pragmas/iconobject_pragmas.h>
#endif
