#ifndef PROTO_LOCALE_H
#define PROTO_LOCALE_H

#include <clib/locale_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/locale.h>
#endif
#ifndef __NOLIBBASE__
extern struct LocaleBase *LocaleBase;
#endif

#endif
