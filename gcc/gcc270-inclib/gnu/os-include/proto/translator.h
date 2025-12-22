#ifndef PROTO_TRANSLATOR_H
#define PROTO_TRANSLATOR_H

#include <clib/translator_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/translator.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *TranslatorBase;
#endif

#endif
