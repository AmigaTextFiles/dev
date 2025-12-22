/*
** ObjectiveAmiga: objc.library protos
** See GNU:lib/libobjam/ReadMe for details
*/


#ifndef PROTO_OBJC_H
#define PROTO_OBJC_H

#include <clib/objc_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/objc.h>
#endif
#ifndef __NOLIBBASE__
extern struct ObjcBase *ObjcBase;
#endif

#endif
