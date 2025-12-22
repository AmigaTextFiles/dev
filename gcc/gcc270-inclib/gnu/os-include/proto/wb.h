#ifndef PROTO_WB_H
#define PROTO_WB_H

#ifndef DOS_DOSEXTENS_H
#include <dos/dosextens.h>
#endif
#include <clib/wb_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/wb.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *WorkbenchBase;
#endif

#endif
