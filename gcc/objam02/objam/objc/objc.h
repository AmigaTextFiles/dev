/*
** ObjectiveAmiga: Include basic Objective C headers
** See GNU:lib/libobjam/ReadMe for details
*/


#ifndef __objc_INCLUDE_GNU
#define __objc_INCLUDE_GNU

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>
#include <libraries/objc.h>
#include <proto/objc.h>


/* Global variables */

#ifndef NOLIBNIX

extern int __argv;
extern char **__argc;

#define NXArgc __argc;
#define NXArgv __argv;

#endif


/* Inlined messager */

#if defined(__OBJC__)

extern id nil_method(id rcv, SEL op, ...);

extern __inline__ IMP objc_msg_lookup(id receiver, SEL op)
{
  if(receiver) return sarray_get(receiver->class_pointer->dtable, (size_t)(op));
  else return nil_method;
}

#else

IMP objc_msg_lookup(id receiver, SEL op);

#endif


#ifdef __cplusplus
}
#endif

#endif /* not __objc_INCLUDE_GNU */
