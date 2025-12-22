#ifndef GLOBAL_H
#define GLOBAL_H

#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif

#ifndef LIBRARIES_GAMESUPPORT_H
#include "libraries/GameSupport.h"
#endif

extern struct GameSupportBase *GameSupportBase;

#ifndef PRAGMAS_GAMESUPPORT_PRAGMAS_H
#include "pragmas/GameSupport_pragmas.h"
#endif

#ifndef CLIB_GAMESUPPORT_PROTOS_H
#include "clib/GameSupport_protos.h"
#endif

/************************************************************************/

#ifdef DEBUG
void kprintf(const char *, ...);
#define assert(x) if (!(x)) {kprintf("assertion failed: file %s, line %lu\n",__FILE__,__LINE__); while (*((UBYTE *)0x00bfe001) & 0x80) *((UWORD *)0x00dff180)=0x0f00;}
#define debug_printf(x) kprintf x
#else
#define assert(x) ((void)0)
#define debug_printf(x) ((void)0)
#endif

/************************************************************************/

LONG (MyWriteChunkBytes)(struct Library *, struct IFFHandle *, const void *, ULONG);
LONG (MyReadChunkBytes)(struct Library *, struct IFFHandle *, void *, ULONG);

/************************************************************************/

#define ARRAYSIZE(x) (sizeof(x)/sizeof((x)[0]))

/************************************************************************/

#ifdef __GNUC__
#define INLINE __inline__
#define ALIGN(Variable) Variable __attribute__((aligned(4)))
#else
#define INLINE
#define ALIGN(Variable) __aligned Variable
#endif

/************************************************************************/

#if defined(__GNUC__) && defined(__OPTIMIZE__)
extern __inline__ ULONG strlen(const char *String)
{
  const char *t;

  t=String;
  while(*t++)
    ;
  return ~(String-t);
}
#elif defined(__SASC)
ULONG __builtin_strlen(const char *);
#define strlen(String) __builtin_strlen(String)
#else
ULONG strlen(const char *);
#endif

/************************************************************************/

#if defined(__GNUC__) && defined(__OPTIMIZE__)
extern inline int strcmp(const char *String1, const char *String2)
{
  int Result;

  while (!(Result=*String1++-*String2) && *String2++)
    ;
  return Result;
}
#elif defined(__SASC)
int __builtin_strcmp(const char *, const char *);
#define strcmp(String1,String2) __builtin_strcmp((String1),(String2))
#else
int strcmp(const char *, const char *);
#endif

/************************************************************************/

#if defined(__GNUC__) && defined(__OPTIMIZE__)
extern __inline__ char *Stpcpy(char *Dest, const char *Source)
{
  while ((*Dest++=*Source++))
    ;
  return Dest-1;
}
#else
char *Stpcpy(char *, const char *);
#endif

/************************************************************************/

extern struct ExecBase *SysBase;
extern struct Library *UtilityBase;
extern struct DosLibrary *DOSBase;
extern struct GfxBase *GfxBase;
extern struct Library *LocaleBase;
extern struct IntuitionBase *IntuitionBase;

extern struct SignalSemaphore JoystickSemaphore;
extern struct SignalSemaphore HappyBlankerSemaphore;
extern struct SignalSemaphore HappyBlankerSemaphore2;
extern struct SignalSemaphore UserlistSemaphore;

/************************************************************************/

extern char IFFParseName[];
extern char GameStuff[];
extern char ProgDir[];

/************************************************************************/

#include "Saveds.h"
#include "SavedsAsmD0.h"
#include "SavedsAsmA0.h"
#include "SavedsAsmD0A0.h"
#include "SavedsAsmA0A1.h"
#include "SavedsAsmD0A0A1.h"
#include "SavedsAsmA0A1A2.h"
#include "SavedsAsmA0A1A2A3.h"
#include "SavedsAsmD0A0A1A2.h"

#ifndef PROTOS_H
#include "protos.h"
#endif

/************************************************************************/

#endif  /* GLOBAL_H */
