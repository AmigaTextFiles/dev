OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/bits/types'
->{#include <x86_64-linux-gnu/bits/sigcontext.h>}
/* Copyright (C) 2002-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

NATIVE {_BITS_SIGCONTEXT_H}  CONST ->_BITS_SIGCONTEXT_H  = 1

NATIVE {FP_XSTATE_MAGIC1}	CONST FP_XSTATE_MAGIC1	= $46505853
NATIVE {FP_XSTATE_MAGIC2}	CONST FP_XSTATE_MAGIC2	= $46505845
NATIVE {FP_XSTATE_MAGIC2_SIZE}	CONST ->FP_XSTATE_MAGIC2_SIZE	= sizeof FP_XSTATE_MAGIC2

NATIVE {_fpx_sw_bytes} OBJECT _fpx_sw_bytes
  {magic1}	magic1	:UINT32_T__
  {extended_size}	extended_size	:UINT32_T__
  {xstate_bv}	xstate_bv	:UINT64_T__
  {xstate_size}	xstate_size	:UINT32_T__
->  {__glibc_reserved1}	__glibc_reserved1[7]	:ARRAY OF UINT32_T__
ENDOBJECT

NATIVE {_fpreg} OBJECT _fpreg
  {significand}	significand[4]	:ARRAY OF UINT
  {exponent}	exponent	:UINT
ENDOBJECT

NATIVE {_fpxreg} OBJECT _fpxreg
  {significand}	significand[4]	:ARRAY OF UINT
  {exponent}	exponent	:UINT
->  {__glibc_reserved1}	__glibc_reserved1[3]	:ARRAY OF UINT
ENDOBJECT

NATIVE {_xmmreg} OBJECT _xmmreg
  {element}	element[4]	:ARRAY OF UINT32_T__
ENDOBJECT



NATIVE {_fpstate} OBJECT _fpstate
  /* FPU environment matching the 64-bit FXSAVE layout.  */
  {cwd}	cwd	:UINT16_T__
  {swd}	swd	:UINT16_T__
  {ftw}	ftw	:UINT16_T__
  {fop}	fop	:UINT16_T__
  {rip}	rip	:UINT64_T__
  {rdp}	rdp	:UINT64_T__
  {mxcsr}	mxcsr	:UINT32_T__
  {mxcr_mask}	mxcr_mask	:UINT32_T__
  {_st}	_st[8]	:ARRAY OF _fpxreg
  {_xmm}	_xmm[16]	:ARRAY OF _xmmreg
->  {__glibc_reserved1}	__glibc_reserved1[24]	:ARRAY OF UINT32_T__
ENDOBJECT

NATIVE {sigcontext} OBJECT sigcontext
  {r8}	r8	:UINT64_T__
  {r9}	r9	:UINT64_T__
  {r10}	r10	:UINT64_T__
  {r11}	r11	:UINT64_T__
  {r12}	r12	:UINT64_T__
  {r13}	r13	:UINT64_T__
  {r14}	r14	:UINT64_T__
  {r15}	r15	:UINT64_T__
  {rdi}	rdi	:UINT64_T__
  {rsi}	rsi	:UINT64_T__
  {rbp}	rbp	:UINT64_T__
  {rbx}	rbx	:UINT64_T__
  {rdx}	rdx	:UINT64_T__
  {rax}	rax	:UINT64_T__
  {rcx}	rcx	:UINT64_T__
  {rsp}	rsp	:UINT64_T__
  {rip}	rip	:UINT64_T__
  {eflags}	eflags	:UINT64_T__
  {cs}	cs	:UINT
  {gs}	gs	:UINT
  {fs}	fs	:UINT
->  {__pad0}	__pad0	:UINT
  {err}	err	:UINT64_T__
  {trapno}	trapno	:UINT64_T__
  {oldmask}	oldmask	:UINT64_T__
  {cr2}	cr2	:UINT64_T__
      {fpstate}	fpstate	:PTR TO _fpstate
      {__fpstate_word}	__fpstate_word	:UINT64_T__
->   {__reserved1}	__reserved1[8]	:ARRAY OF UINT64_T__
ENDOBJECT


NATIVE {_xsave_hdr} OBJECT _xsave_hdr
  {xstate_bv}	xstate_bv	:UINT64_T__
->  {__glibc_reserved1}	__glibc_reserved1[2]	:ARRAY OF UINT64_T__
->  {__glibc_reserved2}	__glibc_reserved2[5]	:ARRAY OF UINT64_T__
ENDOBJECT

NATIVE {_ymmh_state} OBJECT _ymmh_state
  {ymmh_space}	ymmh_space[64]	:ARRAY OF UINT32_T__
ENDOBJECT

NATIVE {_xstate} OBJECT _xstate
  {fpstate}	fpstate	:_fpstate
  {xstate_hdr}	xstate_hdr	:_xsave_hdr
  {ymmh}	ymmh	:_ymmh_state
ENDOBJECT
