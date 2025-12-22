/* Definitions of target machine for GNU compiler.  amiga 68000/68020 version.
   Copyright (C) 1992 Free Software Foundation, Inc.
   Contributed by Markus M. Wild (wild@amiga.physik.unizh.ch).

This file is part of GNU CC.

GNU CC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

GNU CC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU CC; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */

#include "m68k/m68k.c"

/* Does operand (which is a symbolic_operand) live in text space? If
   so SYMBOL_REF_FLAG, which is set by ENCODE_SECTION_INFO, will be true.

   This function is used in base relative code generation. */

int
read_only_operand (operand)
     rtx operand;
{
  if (GET_CODE (operand) == CONST)
    operand = XEXP (XEXP (operand, 0), 0);
  if (GET_CODE (operand) == SYMBOL_REF)
    return SYMBOL_REF_FLAG (operand) || CONSTANT_POOL_ADDRESS_P (operand);
  return 1;
}


/* the rest of the file is to implement AmigaDOS specific keywords some day.
   The approach used so far used __attribute__ for this, but this required
   changes to c-parse.y as well as if we'd use the common keywords used
   on commercial AmigaDOS C-compilers as well. So in the future I'll probably
   switch to __saveds and __interrupt keywords as well.

   The rest of this file is currently ignored, because it's no longer
   working with the current gcc version. */

#if not_yet_working

#include "tree.h"

struct attribute {
  tree ident;
  int  saveds : 1,
       interrupt : 1;
};


static struct attribute *a_tab = 0;
static int a_index, a_size;

void
add_attr_entry (attr)
    struct attribute *attr;
{
  if (! a_tab)
    {
      a_size = 10;
      a_index = 0;
      a_tab  = (struct attribute *) xmalloc (a_size * sizeof (struct attribute));
    }

  if (a_index == a_size)
    {
      a_size <<= 1;
      a_tab = (struct attribute *) xrealloc (a_tab, a_size * sizeof (struct attribute));
    }

  a_tab[a_index++] = *attr;
}


void
attr_do_saveds (function_ident)
      tree function_ident;
{
  struct attribute attr, *a;
  int i;

  for (i = 0, a = a_tab; i < a_index; i++, a++)
    if (a->ident == function_ident)
      {
	a->saveds = 1;
	return;
      }

  /* create a new entry for this function */
  attr.ident     = function_ident;
  attr.saveds    = 1;
  attr.interrupt = 0;
  add_attr_entry (&attr);
}

void
attr_do_interrupt (function_ident)
    tree function_ident;
{
  struct attribute attr, *a;
  int i;

  for (i = 0, a = a_tab; i < a_index; i++, a++)
    if (a->ident == function_ident)
      {
	/* __interrupt implies __saveds */
	a->saveds    = 1;
	a->interrupt = 1;
	return;
      }

  /* create a new entry for this function */
  attr.ident	 = function_ident;
  attr.saveds	 = 1;
  attr.interrupt = 1;
  add_attr_entry (&attr);
}

int
attr_does_saveds (function_name)
    char *function_name;
{
  tree ident = get_identifier (function_name);
  struct attribute *attr;
  int i;
  
  for (i = 0, attr = a_tab; i < a_index; i++, attr++)
    if (attr->ident == ident)
      return attr->saveds;

  return 0;
}

int
attr_does_interrupt (function_name)
    char *function_name;
{
  tree ident = get_identifier (function_name);
  struct attribute *attr;
  int i;
  
  for (i = 0, attr = a_tab; i < a_index; i++, attr++)
    if (attr->ident == ident)
      return attr->interrupt;

  return 0;
}

#endif

/*
Stack checking and auto-extend

This is my first attempt to implement stack extension with gcc.
If you think some things should be changed please write
to me immediately (fleischr@izfm.uni-stuttgart.de, or even better
to amiga-gcc-port@lists.funet.fi for discussion).

If you don't want to recompile gcc (to check it out) you can still
test the example supported (bigtest.c) or read the documentation.
Simply do a 'make' to build it.

Matthias
*/

rtx gen_stack_management_call (stack_pointer, arg, func)
     rtx stack_pointer; /* rtx to put the result into       */
     rtx arg;           /* The argument to put into d0      */
     char *func;        /* The name of the function to call */
{
  rtx fcall, assem;
  emit_move_insn (gen_rtx (REG, SImode, 0), arg); /* Move arg to d0 */
  assem = gen_rtx (ASM_OPERANDS, VOIDmode, func, "=r", 0,
                   rtvec_alloc(1), rtvec_alloc(1), "internal", 0);
  XVECEXP (assem, 3, 0) = gen_rtx (REG, SImode, 0);
  XVECEXP (assem, 4, 0) = gen_rtx (ASM_INPUT, SImode, "r");
  fcall = gen_rtx (PARALLEL, VOIDmode, rtvec_alloc(1+4));
  XVECEXP (fcall, 0, 0)
    = gen_rtx (SET, VOIDmode, stack_pointer, assem);
  XVECEXP (fcall, 0, 1)
    = gen_rtx (CLOBBER, VOIDmode, gen_rtx (REG, QImode, 9));
  XVECEXP (fcall, 0, 2)
    = gen_rtx (CLOBBER, VOIDmode, gen_rtx (REG, QImode, 8));
  XVECEXP (fcall, 0, 3)
    = gen_rtx (CLOBBER, VOIDmode, gen_rtx (REG, QImode, 1));
  XVECEXP (fcall, 0, 4)
    = gen_rtx (CLOBBER, VOIDmode, gen_rtx (REG, QImode, 0));  
  return fcall; /* call function sp=func(d0) */
}

rtx gen_stack_cleanup_call (stack_pointer,sa)
     rtx stack_pointer;
     rtx sa;
{
  return gen_stack_management_call (stack_pointer, sa, "jbsr ___move_d0_sp");
}
