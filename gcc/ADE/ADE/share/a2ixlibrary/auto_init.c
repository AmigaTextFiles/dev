
#include <exec/types.h>
#include <proto/exec.h>
#include <exec/execbase.h>

#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#include "a2ixlibrary.h"

asm(".text
_" xstr(CLOSEINST) ": 	movel	_" xstr(BASE) ",a0
			jmp	a0@(-30:w)

_" xstr(RELOCINST) ":	movel	_" xstr(BASE) ",a0
			jmp	a0@(-36:w)

_" xstr(SETVARSINST) ":	movel	_" xstr(BASE) ",a0
			jmp	a0@(-42:w)
");

struct Library * BASE = 0;

/* externs from crt0.c */
extern void *ixemulbase;
extern int errno;
extern char *_ctype_;
extern void *__sF;
extern void *__stk_limit;

void CLOSEINST(void);
int  RELOCINST();
void SETVARSINST();

#define STRING(a) a, sizeof (a) - 1

void TFSTART();
void TDSTART();
void DFSTART();
void DDSTART();
void _stext();
void _sdata();
void _etext();
void _bss_start();
void __text_size();

static void
constructor()
{
  if (!(BASE = OpenLibrary ("lib" SNAME ".ixlibrary", VERSION)))
    {
      write(2, STRING("Can't open lib" SNAME ".ixlibrary!\n"));
      exit(100);
    }

  if (!(RELOCINST(_stext, TFSTART - _bss_start + _etext,
		          TDSTART - _bss_start + _etext,
		  _sdata, DFSTART - _bss_start + _etext,
			  DDSTART - _bss_start + _etext,
		  NULL)))
    {
      CLOSEINST();
      CloseLibrary(BASE);
      BASE = 0;
      write(2, STRING("Some externals are missing in lib" SNAME ".ixlibrary!\n"));
      exit(100);
    }
  CacheClearE(_stext, (long)__text_size, CACRF_ClearI|CACRF_ClearD);
  SETVARSINST(5, ixemulbase, &errno, _ctype_, __sF, &__stk_limit);
#ifdef CONSTRUCTOR
  {
    CONSTRUCTOR;
  }
#endif
}

static void
destructor()
{
  if (BASE)
    {
#ifdef DESTRUCTOR
      {
        DESTRUCTOR;
      }
#endif
      CLOSEINST();
      CloseLibrary(BASE);
      BASE = 0;
    }
}

asm ("	.text; 	.stabs \"___CTOR_LIST__\",22,0,0,_constructor");
asm ("	.text; 	.stabs \"___DTOR_LIST__\",22,0,0,_destructor");
