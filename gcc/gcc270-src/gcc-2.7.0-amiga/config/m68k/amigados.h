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

/* Phil.B 12-Mar-95: Define USE_GAS if GCC is supposed to work with the GNU
   assembler, GNU linker and GNU debugger using DBX debugging information. */

#define USE_GAS

/* Control assembler-syntax conditionals in m68k.md.  */

#ifndef USE_GAS
#define MOTOROLA		/* Use Motorola syntax rather than "MIT" */
#endif /* !USE_GAS */

#include "m68k/m68k.h"

/* See m68k.h for bits in TARGET_DEFAULT.
   0 means 68000, no hardware fpu (68881/68882/68040).
   7 means 68020 (or higher) with hardware fpu.  */

#ifndef TARGET_DEFAULT
#define TARGET_DEFAULT 0
#endif

/* Define __HAVE_68881__ in preprocessor according to the -m flags.
   This will control the use of inline 68881 insns in certain macros.
   Also inform the program which CPU this is for.  */

#if TARGET_DEFAULT & 02

/* -m68881 is the default */
#define CPP_SPEC \
"%{!msoft-float:-D__HAVE_68881__ }\
%{!ansi:%{m68000:-Dmc68010}%{mc68000:-Dmc68010}%{m68030:-Dmc68030}%{mc68030:-Dmc68030}%{m68040:-Dmc68040}\
%{mc68040:-Dmc68040}%{!mc68000:%{!m68000:-Dmc68020}}}"

#else

/* -msoft-float is the default, assume -mc68000 as well */
#define CPP_SPEC \
"%{m68881:-D__HAVE_68881__ }\
%{!ansi:%{m68020:-Dmc68020}%{mc68020:-Dmc68020}%{m68030:-Dmc68030}%{mc68030:-Dmc68030}%{m68040:-Dmc68040}\
%{mc68040:-Dmc68040}%{!mc68020:%{!m68020:%{!mc68030:%{!m68030:%{!mc68040:%{!m68040:-Dmc68010}}}}}}}"

/* Don't try using XFmode since we don't have appropriate runtime software
   support.  */
#undef LONG_DOUBLE_TYPE_SIZE
#define LONG_DOUBLE_TYPE_SIZE 64

#endif

/* -m68000 requires special flags to the assembler.  */

#define ASM_SPEC \
 "%{m68000:-mc68010} %{mc68000:-mc68010} %{m68020:-mc68020} %{mc68020:-mc68020} %{m68030:-mc68030} %{mc68030:-mc68030} \
%{m68040:-mc68040} %{mc68040:-mc68040} %{m68020-40:-mc68020} %{mc68020-40:-mc68020} \
%{!mc68000:%{!m68000:%{!mc68020:%{!m68020:%{!mc68030:%{!m68030:%{!mc68040:%{!m68040:%{!m68020-40:%{!mc68020-40:-mc68010}}}}}}}}}} %{msmall-code:-l}"

/* amiga/amigados are the new "standard" defines for the Amiga, MCH_AMIGA
 * was used before and is included for compatibility reasons */

#define CPP_PREDEFINES "-Dmc68000 -Damiga -Damigados -DMCH_AMIGA -DAMIGA -Asystem(amigados) -Acpu(m68k) -Amachine(m68k)"

/* Choose the right startup file, depending on whether we use base relative
   code, base relative code with automatic relocation (-resident), or plain
   crt0.o. 
  
   Profiling is currently only available for plain startup.
   mcrt0.o does not (yet) exist. */

#define STARTFILE_SPEC \
 "%{!noixemul:%{resident:rcrt0.o%s}%{!resident:%{!fbaserel:%{pg:gcrt0.o%s}%{!pg:%{p:mcrt0.o%s}%{!p:crt0.o%s}}}\
%{fbaserel:%{pg:bgcrt0.o%s}%{!pg:%{p:bmcrt0.o%s}%{!p:bcrt0.o%s}}}}}\
%{noixemul:%{resident:libnix/nrcrt0.o%s}%{!resident:%{fbaserel:libnix/nbcrt0.o%s}%{!fbaserel:libnix/ncrt0.o%s}}}"

#define ENDFILE_SPEC "%{noixemul:-lstubs}"

/* Automatically search libamiga.a for AmigaDOS specific functions.  Note
   that we first search the standard C library to resolve as much as
   possible from there, since it has names that are duplicated in libamiga.a
   which we *don't* want from there.  Then search the standard C library
   again to resolve any references that libamiga.a might have generated.
   This may only be a temporary solution since it might be better to simply
   remove the things from libamiga.a that should be pulled in from libc.a
   instead, which would eliminate the first reference to libc.a. */

#define LIB_SPEC "%{!noixemul:%{!p:%{!pg:-lc -lamiga -lc}}%{p:-lc_p}%{pg:-lc_p}}%{noixemul:-lnixmain -lnix -lamiga}"

/* if debugging, tell the linker to output amiga-hunk symbols *and* a BSD
   compatible debug hunk (which will probably change in the future, it's not
   tremendously useful in its current state). */

#define LINK_SPEC "%{noixemul:-shortdata -fl libnix} %{fbaserel:%{!resident:-databss-together -fl libb}}\
%{resident:-databss-together -datadata-reloc -fl libb} %{g:-amiga-debug-hunk} \
%{m68020:-fl libm020} %{m68030:-fl libm020} %{m68040:-fl libm020} %{m68020-40:-fl libm020} %{m68881:-fl libm881}\
%{mc68020:-fl libm020} %{mc68030:-fl libm020} %{mc68040:-fl libm020} %{mc68020-40:-fl libm020} %{mc68881:-fl libm881}"

#define CC1_SPEC "%{m68040:-mbitfield }%{mc68040:-mbitfield }%{resident:-fbaserel }%{msmall-code:-fno-function-cse }%{!noixemul:-mfixedstack} "

#define CC1PLUS_SPEC "%{m68040:-mbitfield }%{mc68040:-mbitfield }%{resident:-fbaserel }%{msmall-code:-fno-function-cse }%{!noixemul:-mfixedstack} "

/* Omit frame pointer at high optimization levels. (This doesn't hurt, since
   GDB doesn't work under AmigaDOS at the moment anyway..) */
  
#define OPTIMIZATION_OPTIONS(OPTIMIZE) \
{  								\
  if (OPTIMIZE >= 2) 						\
    flag_omit_frame_pointer = 1;				\
}

/* provide a dummy entry for the small-code switch. This is currently only
   needed by the assembler (explanations: m68k.h), but will be used by cc1
   to output 16bit pc-relative code later.
   PhB 21-Jun-95: use now SUBTARGET_SWITCHES instead of redefining
   whole TARGET_SWITCHES, means that all additions made to m68k.* are
   now taken into account */

#undef SUBTARGET_SWITCHES
#define SUBTARGET_SWITCHES  \
    { "small-code", 0 },/* Affects *_SPEC and/or GAS.  */	\
    { "stackcheck", 02000},			\
    { "nostackcheck", -02000},			\
    { "stackextend", 04000},			\
    { "nostackextend", -04000},			\
    { "fixedstack", -04200},

#define TARGET_STACKCHECK	(target_flags&02000)
#define TARGET_STACKEXTEND	(!TARGET_STACKCHECK&&(target_flags&04000))

/* Every structure or union's size must be a multiple of 2 bytes.  */

#define STRUCTURE_SIZE_BOUNDARY 16

/* This is (almost;-)) BSD, so it wants DBX format.  */

#define DBX_DEBUGGING_INFO

/* Allow folding division by zero.  */
#define REAL_INFINITY

/* The following was hacked into final.c, to allow some notice of
 * source line and filename to be injected into the assembly code,
 * even if not using one of the "approved" debuggers (albaugh@agames.com).
 */
#if 0
#define ASM_NOTE_SOURCE_LINE(FILE, LINE, FILENAME)\
  fprintf(file,"*#line %d \"%s\"\n",(LINE),(FILENAME))
#endif

#if 0	/* This apparently is no longer necessary? */

/* This is how to output an assembler line defining a `double' constant.  */

#undef ASM_OUTPUT_DOUBLE
#define ASM_OUTPUT_DOUBLE(FILE,VALUE)					\
  {									\
    if (REAL_VALUE_ISINF (VALUE))					\
      fprintf (FILE, "\t.double 0r%s99e999\n", (VALUE) > 0 ? "" : "-");	\
    else if (isnan (VALUE))						\
      {									\
	union { double d; long l[2];} t;				\
	t.d = (VALUE);							\
	fprintf (FILE, "\t.long 0x%lx\n\t.long 0x%lx\n", t.l[0], t.l[1]); \
      }									\
    else								\
      fprintf (FILE, "\t.double 0r%.17g\n", VALUE);			\
  }

/* This is how to output an assembler line defining a `float' constant.  */

#undef ASM_OUTPUT_FLOAT
#define ASM_OUTPUT_FLOAT(FILE,VALUE)					\
  {									\
    if (REAL_VALUE_ISINF (VALUE))					\
      fprintf (FILE, "\t.single 0r%s99e999\n", (VALUE) > 0 ? "" : "-");	\
    else if (isnan (VALUE))						\
      {									\
	union { float f; long l;} t;					\
	t.f = (VALUE);							\
	fprintf (FILE, "\t.long 0x%lx\n", t.l);				\
      }									\
    else								\
      fprintf (FILE, "\t.single 0r%.9g\n", VALUE);			\
  }

/* This is how to output an assembler lines defining floating operands.
   There's no way to output a NaN's fraction, so we lose it.  */
  
#undef ASM_OUTPUT_FLOAT_OPERAND
#define ASM_OUTPUT_FLOAT_OPERAND(CODE,FILE,VALUE)				\
 do {								\
      if (CODE == 'f')						\
        {							\
          (REAL_VALUE_ISINF ((VALUE))						\
           ? asm_fprintf (FILE, "%I0r%s99e999", ((VALUE) > 0 ? "" : "-")) \
           : (VALUE) == -0.0							\
           ? asm_fprintf (FILE, "%I0r-0.0")					\
           : asm_fprintf (FILE, "%I0r%.9g", (VALUE))) \
        } else {                                        \
          long l;						\
          REAL_VALUE_TO_TARGET_SINGLE (VALUE, l);		\
          if (sizeof (int) == sizeof (long))			\
            asm_fprintf ((FILE), "%I0x%x", l);			\
          else							\
            asm_fprintf ((FILE), "%I0x%lx", l);			\
        }							\
     } while (0)

#undef ASM_OUTPUT_DOUBLE_OPERAND
#define ASM_OUTPUT_DOUBLE_OPERAND(FILE,VALUE)				\
  (REAL_VALUE_ISINF ((VALUE))						\
   ? asm_fprintf (FILE, "%I0r%s99e999", ((VALUE) > 0 ? "" : "-")) \
   : (VALUE) == -0.0							\
   ? asm_fprintf (FILE, "%I0r-0.0")					\
   : asm_fprintf (FILE, "%I0r%.17g", (VALUE)))

#endif	/* 0 */

/* use A5 as framepointer instead of A6, this makes A6 available as a
   general purpose register, and can thus be used without problems in
   direct library calls. */

#undef FRAME_POINTER_REGNUM
#define FRAME_POINTER_REGNUM 13
#undef ARG_POINTER_REGNUM
#define ARG_POINTER_REGNUM 13

/* we use A4 for this, not A5, which is the framepointer */
#undef PIC_OFFSET_TABLE_REGNUM
#define PIC_OFFSET_TABLE_REGNUM 12

/* setup a default shell return value for those (gazillion..) programs that
   (inspite of ANSI-C) declare main() to be void (or even VOID...) and thus
   cause the shell to randomly caugh upon executing such programs (contrary
   to Unix, AmigaDOS scripts are terminated with an error if a program returns
   with an error code above the `error' or even `failure' level
   (which is configurable with the FAILAT command) */

#define DEFAULT_MAIN_RETURN c_expand_return (integer_zero_node)

/* we do have an ansi-compliant c-library ;-) */
#define HAVE_VPRINTF
#define HAVE_VFPRINTF
#define HAVE_PUTENV
#define HAVE_STRERROR
#define HAVE_ATEXIT

/* given that symbolic_operand(X), return TRUE if no special
   base relative relocation is necessary */

#define LEGITIMATE_BASEREL_OPERAND_P(X) \
  (flag_pic >= 3 && read_only_operand (X))

#undef LEGITIMATE_PIC_OPERAND_P
#define LEGITIMATE_PIC_OPERAND_P(X) \
  (! symbolic_operand (X, VOIDmode) || LEGITIMATE_BASEREL_OPERAND_P (X))

/* Phil.B 12-Mar-95: check if this would fix some PIC problems */
/* In m68k svr4, a symbol_ref rtx can be a valid PIC operand if it is an
   operand of a function call. */
/* #undef LEGITIMATE_PIC_OPERAND_P
#define LEGITIMATE_PIC_OPERAND_P(X) \
  (! symbolic_operand (X, VOIDmode) \
   || ((GET_CODE(X) == SYMBOL_REF) && SYMBOL_REF_FLAG(X)))
*/

/* Define this macro if references to a symbol must be treated
   differently depending on something about the variable or
   function named by the symbol (such as what section it is in).

   The macro definition, if any, is executed immediately after the
   rtl for DECL or other node is created.
   The value of the rtl will be a `mem' whose address is a
   `symbol_ref'.

   The usual thing for this macro to do is to a flag in the
   `symbol_ref' (such as `SYMBOL_REF_FLAG') or to store a modified
   name string in the `symbol_ref' (if one bit is not enough
   information).

   On the Amiga we use this to indicate if a symbol is in text or
   data space.  */

#define ENCODE_SECTION_INFO(DECL)					\
do									\
  {									\
    if (TREE_CODE (DECL) == FUNCTION_DECL)				\
      SYMBOL_REF_FLAG (XEXP (DECL_RTL (DECL), 0)) = 1;			\
    else								\
      {									\
	rtx rtl = (TREE_CODE_CLASS (TREE_CODE (DECL)) != 'd'		\
		   ? TREE_CST_RTL (DECL) : DECL_RTL (DECL));		\
	if (flag_pic >= 3 && 						\
	    (TREE_CODE (DECL) == STRING_CST && !flag_writable_strings))	\
	  SYMBOL_REF_FLAG (XEXP (rtl, 0)) = 1;				\
	else if (flag_pic < 3 &&					\
		 RTX_UNCHANGING_P (rtl) && !MEM_VOLATILE_P (rtl))	\
	  SYMBOL_REF_FLAG (XEXP (rtl, 0)) = 1;				\
      }									\
  }									\
while (0)

#undef SELECT_RTX_SECTION
#define SELECT_RTX_SECTION(MODE, X) readonly_data_section ();

/* according to varasm.c, RELOC referrs *only* to whether constants (!)
   are addressed by address. This doesn't matter in baserelative code,
   so we allow (inspite of flag_pic) readonly_data_section() in that
   case */

#undef SELECT_SECTION
#define SELECT_SECTION(DECL, RELOC)					\
{									\
      if ((TREE_CODE (DECL) == STRING_CST) && !flag_writable_strings)	\
	readonly_data_section ();					\
      else if (flag_pic < 3						\
	  && TREE_READONLY (DECL)					\
	  && ! TREE_THIS_VOLATILE (DECL)				\
	  && DECL_INITIAL (DECL)					\
	  && (DECL_INITIAL (DECL) == error_mark_node			\
	      || TREE_CONSTANT (DECL_INITIAL (DECL)))			\
	  && ! (flag_pic && RELOC))					\
	readonly_data_section ();					\
      else								\
	data_section ();						\
}



#if not_yet_working

/* starting support for amiga specific keywords
 * --------------------------------------------
 */

/* validate attributes that don't take a parameter. Currently we support
 * __attribute__ (saveds) and __attribute__ (interrupt)
 */
#define HANDLE_ATTRIBUTE0(attr) \
  (strcmp(attr, "saveds") != 0 && strcmp(attr, "interrupt") != 0)

/* (c-common.c)
 * install additional attributes
 */
#define HANDLE_EXTRA_ATTRIBUTES(a) 						\
  if (TREE_VALUE (a) != 0							\
      && TREE_CODE (TREE_VALUE (a)) == IDENTIFIER_NODE				\
      && TREE_VALUE (a) == get_identifier ("saveds"))				\
    {										\
      if (TREE_CODE (decl) != FUNCTION_DECL)					\
        {									\
          warning_with_decl (decl,						\
              "saveds attribute specified for non-function `%s'");		\
	  return;								\
        }									\
      										\
      attr_do_saveds (DECL_NAME (decl));					\
    }										\
  else if (TREE_VALUE (a) != 0							\
      && TREE_CODE (TREE_VALUE (a)) == IDENTIFIER_NODE				\
      && TREE_VALUE (a) == get_identifier ("interrupt"))			\
    {										\
      if (TREE_CODE (decl) != FUNCTION_DECL)					\
        {									\
          warning_with_decl (decl,						\
              "saveds attribute specified for non-function `%s'");		\
	  return;								\
        }									\
      										\
      attr_do_interrupt (DECL_NAME (decl));					\
    }										\


#define PROLOGUE_EXTRA_SAVE(mask)						\
  { extern char *current_function_name;						\
    /* saveds makes the function preserve d1/a0/a1 as well */			\
    if (attr_does_saveds (current_function_name))				\
      mask |= 0x40c0; }								\


#define EPILOGUE_EXTRA_RESTORE(mask, nregs)					\
  { extern char *current_function_name;						\
    /* restore those extra registers */						\
    if (attr_does_saveds (current_function_name))				\
      {										\
	mask |= 0x0302;								\
	nregs += 3;								\
      } }									\


#define EPILOGUE_EXTRA_BARRIER_KLUDGE(stream)					\
  { extern char *current_function_name;						\
    /* PLEASE Help! how is this done cleaner?? */				\
    if (attr_does_saveds (current_function_name))				\
      {										\
	fprintf (stderr, 							\
		 "warning: couldn't cleanup `saveds'-stack in `%s'.\n");	\
	fprintf (stderr,							\
		 "         this is only ok, if the function never returns!\n");	\
      }	}									\
        

#define EPILOGUE_EXTRA_TEST(stream)						\
  { extern char *current_function_name;						\
    /* with the interrupt-attribute, we have to set the cc before rts */	\
    if (attr_does_interrupt (current_function_name))				\
      asm_fprintf (stream, "\ttstl %s\n", reg_names[0]); }			\

#endif


/*
 * Support for automatic stack extension.
 */

#define HAVE_restore_stack_nonlocal 1
#define gen_restore_stack_nonlocal \
(TARGET_STACKEXTEND?gen_stack_cleanup_call:gen_move_insn)

#define HAVE_restore_stack_function 1
#define gen_restore_stack_function gen_restore_stack_nonlocal

#define HAVE_restore_stack_block 1
#define gen_restore_stack_block gen_restore_stack_nonlocal

/* Reserve PIC_OFFSET_TABLE_REGNUM (a5) for doing PIC relocation if position
   independent code is being generated, by making it a fixed register. */

#define CONDITIONAL_REGISTER_USAGE			\
{							\
  if (flag_pic)						\
    fixed_regs[PIC_OFFSET_TABLE_REGNUM] = 1;		\
  /* prevent saving/restoring of the base reg */	\
  if (flag_pic == 3)					\
    call_used_regs[PIC_OFFSET_TABLE_REGNUM] = 1;	\
}
