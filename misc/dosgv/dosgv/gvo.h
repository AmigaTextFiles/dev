/*
 * 5/2018 -=ONIX=-
 * :ts=4
 *
 * NOTE: All names for the identifiers (e.g. g_start) were chosen by me due to
 *		 lack of available documentation; I've ask for assistance but no one
 *		 was able to help out.
 *		 If you have their original names at hand, please let me know.
 *
 * Some useful Tripos DOS based function indices.
 *
 * WARNING
 * It's a really bad idea to use these functions without running under a Tripos
 * based AmigaDOS; for OS2+ it's more than recommended to use AmigaDOS API calls!
 *
 * Material provided just to show that the old v33/v34 DOS had more to offer
 * than what MetaComCo/Commodore Amiga thought developers should know.
 *
 * The Global Vector is not just a function table, but a table also holding
 * variables, f.e. its size (index 0).
 * For AmigaDOS it differs to its primary shape in that all task/process
 * related stuff is removed and instead the Exec library is responsible to
 * carry out these tasks, e.g. task switching.
 * Because all the task/process management was removed, the freed vectors
 * are used by different, compared with the original vector, functions and with
 * that, all indices were moved in the vector, only their BCPL identifiers are
 * the same (almost). Next, normally index 200 is the first unassigned global
 * variable that a BCPL program can use, for AmigaDOS compiled programs 150
 * (0x96) is the first unassigned global variable, if and only if the negative
 * indices (AmigaDOS API) are really addressed as negative ones from BCPL
 * compiled programs!
 * I cannot verify that yet because I don't have time to disassemble each of
 * the old CLI commands.
 */

#ifndef _GV_TRIPOS_DOS_OFFSETS_
#define _GV_TRIPOS_DOS_OFFSETS_

#include <exec/types.h>

#include <stdarg.h>

/*
 * Negative indices form the old AmigaDOS API calls; they do not exist any
 * longer in OS2+ - without creating and initialising a *local* Global Vector!
 * Positive indices where never officially published by Commodore Amiga AFAIK,
 * anyway, here is what I found out so far and what I think can be published
 * without having to know about special in-house details, except g_start,
 * and g_globin; those two are only mentioned because the BCPL startup-code
 * uses them.
 */

#define g_globsize		(0x00)	/* Positive size of GV in amount of long words */
#define g_start			(0x01)	/* Index to launch the desired code associated with GV (arg1 = 0)
								   or by specifying an explicit address (must be within segment
								   associated to GV).
								   Note that the BCPL stack offset should be here 32 instead
								   of 12; don't ask me why (related to g_longjump?). */
#define g_stop			(0x02)	/* Index returning control to callee (falsely misinterpreted as
								   Exit() - exit to the CLI/Shell is only performed by an
								   unmodified, system prepared GV!). As usual, the return code
								   is placed in arg1.
								   The function which gets the return code (receiver) has to
								   fetch it as usual out of register D1! */
#define g_mul			(0x03)	/* Index to multiply arg1 with arg2 (32 bits * 32 bits)*/
#define g_div			(0x04)	/* Index to divide arg1 by arg2 (32 bits / 32 bits) */
#define g_mod			(0x05)	/* Index to get modulo; arg1 % arg2 */
#define g_res2			(0x0A)	/* Index to return or set secondary (pr_Result2) error code;
								   arg1 unequal 0 means to set secondary error code (arg2) */
#define g_stackbase		(0x0C)	/* Initial stack base; BPTR address */
#define g_findtask		(0x0E)	/* Index to return task control block (iow, it returns the message
								   port of this process, because it's outsourced to Exec).
								   The AmigaDOS version of Tripos is missing all its task/process
								   management, while Exec must have been extended in mind Tripos! */
#define g_getchar		(0x0F)	/* Index to return char at BPTR/BSTR (arg1) at offset 'N' (arg2) */
#define g_putchar		(0x10)	/* Index to put char (arg3) in BPTR/BSTR (arg1) at offset 'N' (arg2) */
#define g_frameptr		(0x11)	/* Index to return initial BCPL stack base pointer */
/* I don't know where AROS got its information regarding BCPL (Tripos) functions from, but "level"
   is just a "setjump" for BCPL compiled programs... */
#define g_globin		(0x1C)	/* Index to set up local allocated GV; arg = segment or segment
								   list array.
								   This function associates segments with this local GV and
								   establishes with that global functions shared between different
								   segments (modules).
								   Next, this functions files the negative function offsets
								   (official API).
								   This function is a set of issues under AmigaOS 1.2/1.3!
								   The storage (GV area) must be 50 long words larger than the
								   GV size (default; 0x95 long words), iow 0x95 + 50!
								   The register A2 must point to the new GV where the additional
								   50 long words will be addressed negative, i.e. GV = &GV[50].
								   First, one must differentiate between ROM and RAM modules.
								   For ROM modules, use the pr_SegList entries and call g_globin
								   for the first time.
								   If you need additional modules, initialise them now, e.g. by
								   g_globin( g_loadseg( "segment_name")), aka dynamic linking.
								   Then call g_globin once more for the RAM resident segment
								   (your code).
								   Next, the new allocated GV must be partly initialised by hand!
								   The new BCPL stack base must be properly set up (index 0x0C)!
								   Just then a call to g_start can be performed!
								   Next, from index $86 onward, once the local GV was set up, one
								   has to copy over the entire CommandLineInterface on his own.
								   This function is a mess... - see BCPL startup-code -
								   and, DosGV() cannot be used to execute this function!!! */
#define g_getmem		(0x1D)	/* Index to allocate 'N' long words of memory with flag MEMF_PUBLIC.
								   Returned value is a BPTR address */
#define g_freemem		(0x1E)	/* Index to free allocated memory (BPTR) */
#define g_break			(0x25)	/* Index to clear (arg1 != 1) break signal or to react (arg1 = 1)
								   on it */
#define g_alert			(0x26)	/* Index to display alert; arg = number */
#define g_findrootnode	(0x27)	/* Index to return BPTR dl_RootNode, most important DOS structure
								   for Tripos based OSs */
#define g_endtask		(0x2E)	/* Index to exit current process; segment unloaded, task killed,
								   arg1 = segment of process - DO NOT USE IT FOR C COMPILED
								   BINARIES! :-> */
#define g_delay			(0x2F)	/* Index to wait specific time; arg = timeout (ticks per second
								   = 50) */
#define g_sysrequest	(0x34)	/* Index to display requester; 3 BSTRs */
#define g_writepad		(0x35)	/* Index to pad console output by 'character' 'n' times */
#define g_findinput		(0x3B)	/* Index to open input file; arg = BSTR file name */
#define g_findoutput	(0x3C)	/* Index to open output file; arg = BSTR file name */
#define g_selectinput	(0x3D)	/* Index to select handle (arg1) as input stream */
#define g_selectoutput	(0x3E)	/* Index to select handle (arg1) as output stream */
#define g_newline		(0x44)	/* Index to output linefeed onto console */
#define g_writed		(0x45)	/* Index to output decimal 'value' as amount 'N' digits onto
								   console */
#define g_writen		(0x46)	/* Index to output decimal number 'value' onto console */
#define g_writehex		(0x47)	/* Index to output hexadecimal 'value' as amount 'N' digits onto
								   console */
#define g_writeoct		(0x48)	/* Index to output octal 'value' as amount 'N' digits onto console */
#define g_writes		(0x49)	/* Index to output BSTR onto console */
#define g_writef		(0x4A)	/* Index to output formatted parameters onto console, BSTR plus args,
								   more than 3 args must be placed onto BCPL stack manually */
#define g_rdargs		(0x4E)	/* Index to read formatted parameters from CMD line
								   NOTE: pr_CIS must be for this function intact, i.e.
								   as initially set up by CLI/Shell
								   arg1 = template (BSTR)
								   arg2 = result array (BPTR to long words) (standard: 656 bytes!)
								   arg3 = max amount of resulting long words (standard: 80, then,
								          arg2 = min 656 bytes, even CLI commands used 340, use
								          always 656 bytes - danger of a buffer overflow is
								          with this minimised!)
								   NOTE: Due to a bug the BCPL stack frame must be at least 364
								   bytes in size, because upon using the question mark, the long
								   word at index 90 (= bytes 360 to 363) is trashed */
#define g_findseglist	(0x59)	/* Index to return current to GV 'linked' SegList array, see
								   pr_SegList */
#define g_runcommand	(0x65)	/* Index to run command, equals Execute; args: BSTR cmd, input and
								   output handle */
#define g_fault			(0x68)	/* Index to output errorcode as text onto console */
#define g_copystring	(0x6B)	/* Index to copy BSTR, always 31 characters (aka 8 long words) */ 
#define g_putword		(0x6E)	/* Index to return long word of BPTR array (arg1) at offset 'N'
								   (arg2) */
#define g_getword		(0x6F)	/* Index to put long word (arg3) in BPTR array (arg1) at offset
								   'N' (arg2) */
/* OS1.2+ function! */
#define g_findcli		(0x86)	/* Index to return BPTR to CommandLineInterface */
/* CLI record uses globals 0x86 to 0x95, overriding g_findcli!
 * Once a local GV was set up, no call to g_findcli may be performed anymore,
 * instead, one has to deal with items of the CLI record directly.
 * See notes for globin. */

/* Following indices form - or are identical/similar to AmigaDOS API functions */
#define g_newproc		(0x21)
#define g_parentdir		(0x23)
#define g_currdir		(0x33)	/* Index to get/set current directory, arg1 = get/set, arg2 = lock */
#define g_input			(0x41)
#define g_output		(0x42)
#define g_unloadseg		(0x52)
#define g_waitforchar	(0x57)
#define g_delete		(0x5A)
#define g_rename		(0x5B)
#define g_close			(0x5D)
#define g_lock			(0x6C)
#define g_unlock		(0x6D)
#define g_duplock		(0x71)
#define g_createdir		(0x7D)



/* Remember, normally, negative indices were publish as API to the outside!
 *
 * NOTE: For OS2+ retrieving any negative offset via DosGV() without setting up
 * a local Global Vector will bomb the machine because the OS2+ setted up GV
 * does not contain any longer these offsets per se, for that, you have to call
 * g_globin first.
 */
#define g_execute		(-27)	/* Any negative index will point to 0x00000000 */
#define g_isinteractive	(-26)	/* under OS2+ or later without creating a local */
#define g_datestamp		(-25)	/* GV - WATCH OUT! */
#define g_setprotect	(-24)
#define g_setcomment	(-23)
#define g_deviceproc	(-22)
#define	g_queuepacket	(-21)
#define	g_getpacket		(-20)
#define g_loadseg		(-19)
#define g_createproc	(-18)	/* See g_newproc (0x21) */
#define g_ioerror		(-17)
#define g_currentdir	(-16)	/* See g_currdir (0x33) */
#define g_doscreatedir	(-15)	/* Same as g_createdir (0x7D) */
#define g_info			(-14)
#define g_exnext		(-13)
#define g_examine		(-12)
#define g_doslock		(-11)	/* Same as g_lock (0x6C) */
#define g_dosrename		(-10)	/* Same as g_rename (0x5B) */
#define	g_deletefile	(-9)	/* Same as g_delete (0x5A) */
#define g_seek			(-8)
#define g_write			(-6)
/* -4 and -5 not checked yet */
#define	g_read			(-3)
/* -2 - yet not checked what's hidden here */
#define g_open			(-1)

/* OS1.2 limits; required only in case one has to set up a local GV */
#define G_GV_POSITIVE_SIZE	(0x95L)
#define G_GV_NEGATIVE_SIZE	(0x32L)	/* ... local GV is thus 796 bytes in size */

/* Flags */
#define g_flag_break	(1L)
#define g_flag_commbrk	(2L)
#define g_flag_get		(0L)	/* Getter */
#define g_flag_set		(1L)	/* Setter */

/*
 * Align 'whatsoever' at a longword boundary within the user stack frame.
 * This is compiler independent instead of the __attribute__ keyword, which is
 * gcc only.
*/
#define ALIGNLONG(type, var) \
  char __##var##__[sizeof(type) + 3]; \
  type *var = (type *) ((((unsigned long int) __##var##__) + 3) & -4)

/* dos.h of v33/34 is missing this; it works also for compilers treating an
   "int" as 16-bit value (sizeof(int) == 2)! */
#ifndef APTR_TYPEDEF
#define MKBADDR(x)	(LONG) ( ((ULONG)(x)) >> ((ULONG)2L) )
#endif

/* This function uses the Global Vector, setup by the AmigaDOS, for sending a
 * particular command!
 * It's unsuitable for a *local* Global Vector!
 * It assumes a BCPL stack frame offset of 12 bytes (3 long words (minimum)
 * and passes arguments placed on stack (if any) in the appropriate registers
 * for calling the BCPL compiled code (global vector function/routine).
 * All arguments (if any) must be 32 bits in width!
 */
extern
LONG DosGV( LONG * offset_stack_frame,	/* Zero or multiple of 4, normally 12 */
			LONG g_index,				/* Global vector index */
			... );						/* Arguments, up to 4, whatsoever... */

#endif 	/* _GV_TRIPOS_DOS_OFFSETS_ */
