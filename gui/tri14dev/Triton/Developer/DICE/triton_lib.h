/*
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Written by Stefan Zeiger in 1993-1994
 *
 *  (c) 1993-1994 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts
 *  of it for creating programs for AmigaOS which use the
 *  Triton GUI creation system. All other rights reserved.
 *
 */


#ifndef _TRITON_H
#define _TRITON_H

#define TR_NOMACROS
#define TR_NOSUPPORT

#ifdef _DCC

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#define REG(x) __ ## x
#define ASM
#define STACK  __stkargs
#define REGS   __regargs

#else

#ifdef __GNUC__

#define REG(x)
#define ASM
#define STACK
#define REGS

#else /* __SASC__ */

#define REG(x) register __ ## x
#define ASM    __asm
#define STACK  __stdargs
#define REGS   __regargs

#endif /* __GNUC__ */

#endif /* _DCC */

#ifndef _DCC
#include <dos.h>
#endif /* _DCC */

#include <utility/hooks.h>
#include <clib/exec_protos.h>
#include <pragmas/exec_pragmas.h>
#include <libraries/triton.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/triton.h>
#include <clib/alib_protos.h>
#include <ctype.h>

#endif /* _TRITON_H */
