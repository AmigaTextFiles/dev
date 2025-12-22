OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/x86_64-linux-gnu/bits/types/sigset_t'
MODULE 'target/x86_64-linux-gnu/bits/types/stack_t'
{#include <x86_64-linux-gnu/sys/ucontext.h>}
/* Copyright (C) 2001-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

NATIVE {_SYS_UCONTEXT_H}	CONST ->_SYS_UCONTEXT_H	= 1


 ->NATIVE {__ctx} PROC	->define __ctx(fld) fld


/* Type for general register.  */
 NATIVE {greg_t} OBJECT
TYPE GREG_T IS NATIVE {greg_t} BIGVALUE

/* Number of general registers.  */
NATIVE {__NGREG}	CONST NGREG__	= 23
 NATIVE {NGREG}	CONST NGREG	= NGREG__

/* Container for all general registers.  */
->typedef greg_t[NGREG__] gregset_t;
NATIVE {gregset_t} OBJECT
TYPE GREGSET_T IS NATIVE {gregset_t} ARRAY OF GREG_T

/* Number of each register in the `GREGSET_T' array.  */
NATIVE {REG_R8} CONST REG_R8 = 0
NATIVE {REG_R9}	CONST REG_R9 = 1
NATIVE {REG_R10}	CONST REG_R10 = 2
NATIVE {REG_R11}	CONST REG_R11 = 3
NATIVE {REG_R12}	CONST REG_R12 = 4
NATIVE {REG_R13}	CONST REG_R13 = 5
NATIVE {REG_R14}	CONST REG_R14 = 6
NATIVE {REG_R15}	CONST REG_R15 = 7
NATIVE {REG_RDI}	CONST REG_RDI = 8
NATIVE {REG_RSI}	CONST REG_RSI = 9
NATIVE {REG_RBP}	CONST REG_RBP = 10
NATIVE {REG_RBX}	CONST REG_RBX = 11
NATIVE {REG_RDX}	CONST REG_RDX = 12
NATIVE {REG_RAX}	CONST REG_RAX = 13
NATIVE {REG_RCX}	CONST REG_RCX = 14
NATIVE {REG_RSP}	CONST REG_RSP = 15
NATIVE {REG_RIP}	CONST REG_RIP = 16
NATIVE {REG_EFL}	CONST REG_EFL = 17
NATIVE {REG_CSGSFS}	CONST REG_CSGSFS = 18		/* Actually short cs, gs, fs, __pad0.  */
NATIVE {REG_ERR}	CONST REG_ERR = 19
NATIVE {REG_TRAPNO}	CONST REG_TRAPNO = 20
NATIVE {REG_OLDMASK}	CONST REG_OLDMASK = 21
NATIVE {REG_CR2}	CONST REG_CR2 = 22

NATIVE {_libc_fpxreg} OBJECT _libc_fpxreg
  {significand}	significand[4]	:ARRAY OF UINT
  {exponent}	exponent	:UINT
->  {__glibc_reserved1}	__glibc_reserved1[3]	:ARRAY OF UINT
ENDOBJECT

NATIVE {_libc_xmmreg} OBJECT _libc_xmmreg
  {element}	element[4]	:ARRAY OF UINT32_T__
ENDOBJECT

NATIVE {_libc_fpstate} OBJECT _libc_fpstate
  /* 64-bit FXSAVE format.  */
  {cwd}	cwd	:UINT16_T__
  {swd}	swd	:UINT16_T__
  {ftw}	ftw	:UINT16_T__
  {fop}	fop	:UINT16_T__
  {rip}	rip	:UINT64_T__
  {rdp}	rdp	:UINT64_T__
  {mxcsr}	mxcsr	:UINT32_T__
  {mxcr_mask}	mxcr_mask	:UINT32_T__
  {_st}	_st[8]	:ARRAY OF _libc_fpxreg
  {_xmm}	_xmm[16]	:ARRAY OF _libc_xmmreg
->  {__glibc_reserved1}	__glibc_reserved1[24]	:ARRAY OF UINT32_T__
ENDOBJECT

/* Structure to describe FPU registers.  */
NATIVE {fpregset_t} OBJECT fpregset_t OF _libc_fpstate
ENDOBJECT

/* Context to describe whole processor state.  */
NATIVE {mcontext_t} OBJECT mcontext_t
    {gregs}	gregs	:GREGSET_T
    /* Note that fpregs is a pointer.  */
    {fpregs}	fpregs	:fpregset_t
->     {__reserved1}	__reserved1[8]	:ARRAY OF UBIGVALUE
ENDOBJECT 

/* Userlevel context.  */
NATIVE {ucontext_t} OBJECT ucontext_t
    {uc_flags}	uc_flags	:UCLONG
    {uc_link}	uc_link	:PTR TO ucontext_t
    {uc_stack}	uc_stack	:stack_t
    {uc_mcontext}	uc_mcontext	:mcontext_t
    {uc_sigmask}	uc_sigmask	:sigset_t
    {__fpregs_mem}	__fpregs_mem	:_libc_fpstate
    {__ssp}	__ssp[4]	:ARRAY OF UBIGVALUE
  ENDOBJECT
