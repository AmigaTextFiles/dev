/*
 *  This file is part of ixemul.library for the Amiga.
 *  Copyright (C) 1991, 1992  Markus M. Wild
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  ixemul.h,v 1.1.1.1 1994/04/04 04:29:38 amiga Exp
 *
 *  ixemul.h,v
 * Revision 1.1.1.1  1994/04/04  04:29:38  amiga
 * Initial CVS check in.
 *
 *  Revision 1.4  1993/11/05  22:14:40  mwild
 *  changes there, here...
 *
 *  Revision 1.3  1992/10/20  16:32:33  mwild
 *  *** empty log message ***
 *
 *  Revision 1.2  1992/07/04  19:25:26  mwild
 *  change __rwport to reflect the current state of the (now global) async port
 *
 * Revision 1.1  1992/05/14  20:36:14  mwild
 * Initial revision
 *
 */

#ifdef START
#include "version.h"

/* definitions for the assembler startup file */

/* when I've REALLY lots of free time, I'll rewrite header files, but now... */

/* amazingly works, contains only defines ;-)) */
#include <exec/alerts.h>

#define _LVOOpenLibrary		-0x228
#define _LVOCloseLibrary 	-0x19e
#define _LVOAlert		-0x6c
#define _LVOFreeMem		-0xd2
#define _LVORemove		-0xfc

#define RTC_MATCHWORD	0x4afc
#define RTF_AUTOINIT	(1<<7)

#define LIBF_CHANGED	(1<<1)
#define LIBF_SUMUSED	(1<<2)
/* seems there is an assembler bug in expression evaluation here.. */
#define LIBF_CHANGED_SUMUSED 0x6
#define LIBF_DELEXP	(1<<3)
#define LIBB_DELEXP	3

#define LN_TYPE		8
#define LN_NAME		10
#define NT_LIBRARY	9
#define MP_FLAGS	14
#define PA_IGNORE	2

#define LIST_SIZEOF	14

#define THISTASK	276

#define INITBYTE(field,val)	.word 0xe000; .word (field); .byte (val); .byte 0
#define INITWORD(field,val)	.word 0xd000; .word (field); .word (val)
#define INITLONG(field,val)	.word 0xc000; .word (field); .long (val)

/*
 * our library base.. 
 */

/* struct library */
#define	IXBASE_NODE	0
#define IXBASE_FLAGS	14
#define IXBASE_NEGSIZE	16
#define IXBASE_POSSIZE	18
#define IXBASE_VERSION	20
#define IXBASE_REVISION	22
#define IXBASE_IDSTRING	24
#define IXBASE_SUM	28
#define IXBASE_OPENCNT	32
#define IXBASE_LIBRARY	34	/* size of library */

/* custom part */
#define IXBASE_MYFLAGS		(IXBASE_LIBRARY + 0)
#define IXBASE_SYSLIB		(IXBASE_MYFLAGS + 2)
#define IXBASE_SEGLIST		(IXBASE_SYSLIB  + 4)
#define IXBASE_C_PRIVATE	(IXBASE_SEGLIST + 4)
/* get size of C_PRIVATE with print_base_size.c */
#define IXBASE_SIZEOF		(IXBASE_C_PRIVATE + 490)

#else  /* C-part */

#include <exec/types.h>
#include <exec/libraries.h>
#include <exec/execbase.h>
#include <exec/ports.h>
#include <libraries/dosextens.h>
#include <intuition/intuition.h>

#include <sys/types.h>
#ifdef KERNEL
#define _INTERNAL_FILE
#endif
#include <sys/file.h>
#include <sys/param.h>
#include <packets.h>
#include <sys/syscall.h>
#include <signal.h>
#ifdef KERNEL
#include <user.h>
#endif
#include <errno.h>

/* configure this to the number of hash queues you like, 
 * use a prime number !!
 */
#define IX_NUM_SLEEP_QUEUES	31

struct ixemul_base {
  struct Library	ix_lib;
  unsigned char		ix_myflags;
  unsigned char		ix_pad;
  struct ExecBase*	ix_sys_base;
  BPTR			ix_seg_list;

  /* needed library bases */
  struct Library	*ix_dos_base;
  struct IntuitionBase	*ix_intui_base;
  struct GfxBase	*ix_gfx_base;
  struct MathIeeeSingBasBase	*ix_ms_base;
  void			*ix_libs;	/* was ix_mst_base */
  struct MathIeeeDoubBasBase	*ix_md_base;
  struct MathIeeeDoubTransBase	*ix_mdt_base;


  /* the global file table with current size */
  struct file		*ix_file_tab;
  struct file		*ix_fileNFILE;
  struct file		*ix_lastf;

  /* size of start of red zone from bottom of stack */
  int			ix_red_zone_size;

  struct SignalSemaphore ix_semaph;
  int			ix_membuf_limit;
  
  /* multiplier for id_BytesPerBlock to get to st_blksize, default 64 */
  int			ix_fs_buf_factor;

  int			:21,
                        ix_no_insert_disk_requester:1,
                        ix_unix_pattern_matching_case_sensitive:1,
                        ix_unix_pattern_matching:1,
                        ix_no_ces_then_open_console:1,
  			ix_ignore_global_env:1,
  			ix_disable_fibcache:1,
  			ix_translate_dots:1,
  			ix_watch_stack:1,
			ix_force_translation:1,
  			ix_translate_symlinks:1,
			ix_translate_slash:1;

  struct MinList	ix_sleep_queues [IX_NUM_SLEEP_QUEUES];

  struct MinList	ix_socket_list;
};


/* this is the only prototype of library functions, that are really used inside
 * the library. (So a user can patch a function, and the library will use
 * the new entry, and not a hard compiled address */
#if 0
int syscall (enum _syscall_ vector, ...);
#else
/* now that gcc can deal with varargs-macros, this can be inlined! */
#define syscall(vec, args...) \
  ({register int (*_sc)()=(void *)(&((char *)ixemulbase)[-((vec)+4)*6]); _sc(args);})
#endif

#ifdef KERNEL
extern int ix_panic (const char *msg);
extern struct ixemul_base *ixemulbase;
extern struct user *curproc;
#define ix (*ixemulbase)
#if 0
#define u_save (*(struct user *)((*(struct ExecBase **)4)->ThisTask->tc_TrapData))
#define u (*curproc)
#else
#define u_save (*(struct user *)((*(struct ExecBase **)4)->ThisTask->tc_TrapData))
#define u (*(struct user *)((*(struct ExecBase **)4)->ThisTask->tc_TrapData))
#endif

static inline u_int get_usp (void) 
{ 
  u_int res;
  asm volatile ("movel	usp,%0" : "=a" (res));
  return res;
}

static inline void set_usp (u_int new_usp)
{
  asm volatile ("movel  %0,usp" : /* no output */ : "a" (new_usp));
}

static inline u_int get_sp (void) 
{ 
  u_int res;
  asm volatile ("movel	sp,%0" : "=a" (res));
  return res;
}

static inline void set_sp (u_int new_sp)
{
  asm volatile ("movel  %0,sp" : /* no output */ : "a" (new_sp));
}

static inline u_short get_sr (void) 
{ 
  u_short res;
  asm volatile ("movew	sr,%0" : "=g" (res));
  return res;
}

static inline u_int get_fp (void) 
{ 
  u_int res;
  asm volatile ("movel	a5,%0" : "=g" (res));
  return res;
}

#define PRIVATE
#include <inline/exec.h>
#undef PRIVATE

#define BASE_EXT_DECL
#define BASE_EXT_DECL0
#define BASE_PAR_DECL	
#define BASE_PAR_DECL0	
#define BASE_NAME	((struct DosLibrary *) ix.ix_dos_base)
#include <inline/dos.h>

#define errno (* u.u_errno)
extern struct MsgPort *ix_async_mp;
#define __rwport (ix_async_mp)
#else
#define ix_errno (*((struct user *)(ixbase->ix_sys_base->ThisTask->tc_TrapData))->u_errno)
#endif

/* *BLOODY* commododities.h defines IX_VERSION too, so wait for our defines
   to come last, and undef the sucker now!! */
#undef IX_VERSION
#include "version.h"

#endif


