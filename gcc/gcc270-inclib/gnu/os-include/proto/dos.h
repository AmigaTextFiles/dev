#ifndef PROTO_DOS_H
#define PROTO_DOS_H

#ifndef DOS_EXALL_H
#include <dos/exall.h>
#endif
#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#include <clib/dos_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/dos.h>
#endif
#ifndef __NOLIBBASE__
extern struct DosLibrary *DOSBase;
#endif

#endif
