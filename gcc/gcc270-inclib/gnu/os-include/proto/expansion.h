#ifndef PROTO_EXPANSION_H
#define PROTO_EXPANSION_H

#ifndef DOS_FILEHANDLER_H
#include <dos/filehandler.h>
#endif
#ifndef LIBRARIES_CONFIGVARS_H
#include <libraries/configvars.h>
#endif
#include <clib/expansion_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/expansion.h>
#endif
#ifndef __NOLIBBASE__
extern struct ExpansionBase *ExpansionBase;
#endif

#endif
