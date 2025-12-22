/*
 * Copyright 1995 Bruno Haible, <haible@ma2s2.mathematik.uni-karlsruhe.de>
 *
 * This is free software distributed under the GNU General Public Licence
 * described in the file COPYING. Contact the author if you don't have this
 * or can't live with it. There is ABSOLUTELY NO WARRANTY, explicit or implied,
 * on this software.
 */

#ifndef FOR_AMIGA_CLISP
#include <stdio.h>
#else
#include <exec/types.h>
#include <exec/execbase.h>
#include <proto/exec.h>
extern BPTR Input_handle;
extern struct ExecBase * const SysBase;
#endif

#include "vacall.h"
#include "config.h"

/* This is the function called by vacall(). */
#if defined(__STDC__) || defined(__GNUC__)
void (* vacall_function) (va_alist);
#else
void (* vacall_function) ();
#endif

/* Room for returning structs according to the pcc non-reentrant struct return convention. */
__va_struct_buffer_t __va_struct_buffer;

extern ABORT_VOLATILE RETABORTTYPE abort ();

int /* no return type, since this never returns */
__va_error1 (start_type, return_type)
  enum __VAtype start_type;
  enum __VAtype return_type;
{
  /* If you see this, fix your code. */
#ifndef FOR_AMIGA_CLISP
  fprintf (stderr, "vacall: va_start type %d and va_return type %d disagree.\n",
                   (int)start_type, (int)return_type);
  abort();
#else
  BPTRfprintf (Input_handle, "vacall: va_start type %ld and va_return type %ld disagree.\n",
                   (long)start_type, (long)return_type);
  fehler_sint64(0);	/* do anything */
#endif
}

int /* no return type, since this never returns */
__va_error2 (size)
  unsigned int size;
{
  /* If you see this, increase __VA_ALIST_WORDS: */
#ifndef FOR_AMIGA_CLISP
  fprintf (stderr, "vacall: struct of size %u too large for pcc struct return.\n",
                   size);
  abort();
#else
  BPTRfprintf (Input_handle, "vacall: struct of size %lu too large for pcc struct return.\n",
                   (unsigned long)size);
  fehler_sint64(0);	/* do anything */
#endif
}

#ifdef FOR_AMIGA_CLISP
/* they come from foreign.o and I have to find a libgcc for them */
void __extendsfdf2()
{ fehler_uint64(0);
}
void __truncdfsf2()
{ fehler_uint64(0);
}
#endif
