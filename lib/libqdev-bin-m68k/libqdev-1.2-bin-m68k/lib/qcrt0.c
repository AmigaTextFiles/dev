/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * qcrt0.c
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QCRT0'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QCRT0'  is   distributed  in  the  hope  that  it  will  be useful,
 * but  WITHOUT  ANY  WARRANTY;  without  even  the implied warranty of
 * MERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.  See  the
 * GNU General Public License for more details.
 *
 * You  should  have  received a copy of the GNU General Public License
 * along  with  'qdev';  if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301   USA
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: qcrt0.c 1.00 (17/04/2014) QCRT0
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Minimalistic startup code with registers preservation - actual code.
 *
 * No globals, no BSS in it. Ideal solution for people who need to code
 * their own way or have to create ROM modules or ROM objects. Only one
 * startup object for  resident/non-resident programs. This  code  must
 * not be compiled as resident!
 *
 * Pre-set registers:
 * ^^^^^^^^^^^^^^^^^^
 * 
 * a[0]  -  BOOT = Seglist,   CLI = Cmd line args,   WB = Startup¹ msg.
 * d[0]  -  BOOT = 0      ,   CLI = Cmd line len.,   WB = Unspecified .
 *
 * a[2]  -  Code section pointer (this  is  the  entry  point address).
 * d[2]  -  Code section (in-memory) size.
 *
 * a[3]  -  Data section pointer (original data section, same as a[4]).
 * d[3]  -  Data + BSS sections (in-memory) size.
 *
 * a[4]  -  Data section pointer (should make a copy if d[4] is not 0).
 * d[4]  -  Data section has to be copied  and/or  relocated (boolean).
 * a[5]  -  Pointer to offset/relocation table (1st LONG  # of relocs).
 *
 * a[6]  -  Pointer to SysBase possibly.
 *
 * a[7]  -  Pointer to beginning of the  14 saved (on stack) registers.
 * d[7]  -  Address of the _exit point.
 *
 *
 * ¹     -  Only valid after using QDEV_QCRT_METHOD() macro in main() .
 *
 * Warning! You cannot rely on saved registers if this code reaches its
 * final PC since they all sit in stack! Make a copy first.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#undef ___QDEV_CODESNIPPET
#undef ___QDEV_FILESNIPPET

#include <proto/exec.h>

#include "qdev.h"
#include "qcrt0.h"



QDEV_HLP_ASMENTRY
(
  QDEV_QCRT_ENTRY,
  "\n\t	movem.l	d1-d7/a0-a6,-(sp)	"   /* Save 14 most important regs  */
  "\n\t	lea.l	__stext,a2		"   /* Attach code section pointer  */
  "\n\t	move.l	#___text_size,d2	"   /* Copy size of the code area   */
  "\n\t	lea.l	__sdata+" QDEV_HLP_MKSTR(   /* Attach data section pointer  */
                 QDEV_QCRT_DDIST) ",a3	"
  "\n\t	move.l	#___data_size,d3	"   /* Copy size of the data + BSS  */
  "\n\t	add.l	#___bss_size,d3		"
  "\n\t	movea.l	a3,a4			"   /* We need data pointer in A4!  */
  "\n\t	lea.l	___datadata_relocs,a5	"   /* Set the reloc table (ghost)  */
  "\n\t move.l	a5,d4			"   
  "\n\t	sub.l	#___datadata_noreloc,d4	"   /* Sub from ghost (0 no reloc)  */
  "\n\t	movem.l	d0-d7/a0-a7,-(sp)	"   /* Copy pre-set registers (16)  */
  "\n\t	lea.l	(4*16,sp),a0		"   /* Skip to previous reg. state  */
  "\n\t	move.l	a0,(4*15,sp)		"   /* Update a[7] with correct SP  */
  "\n\t	lea.l	(_exit,pc),a0		"   /* Determine safe exit address  */
  "\n\t	move.l	a0,(4*7,sp)		"   /* Update d[7] with _exit ptr   */
  "\n\t	movea.l	sp,a0			"   /* Pass pre-set regs to init    */
  "\n\t	bsr	_" QDEV_HLP_MKSTR(          /* Branch to higher level init  */
                          QDEV_QCRT_INIT)
  "\n\t	move.l	(sp),d0			"   /* Update D0 from d[0] result   */
  "\n\t	lea.l	(4*16,sp),sp		"   /* Jump over pre-set registers  */
  "\n\t	_exit:				"
  "\n\t	movem.l	(sp)+,d1-d7/a0-a6	"   /* Restore saved registers(14)  */
  "\n\t rts				"
);

QDEV_HLP_ASMENTRY
(
  __datadata_noreloc,
  "\n\t	dc.l	0			"
);

/*
 * This makes it possible to autosense if some objects were compiled
 * with '-resident' flag. If so then the alias is to be discarded in
 * the linking stage because '__datadata_relocs' is a ghost symbol
 * which only appears when globals are resolved through A4 register.
*/
QDEV_HLP_ASMALIAS
(
  __datadata_relocs,
  __datadata_noreloc
);

QDEV_HLP_ASMENTRY
(
  geta4,
  "\n\t rts				"
);

QDEV_HLP_ASMENTRY
(
  __main,
  "\n\t rts				"
);

void QDEV_QCRT_INIT(REGARG(void *regs, a0))
{
  struct qcrtregs cr;


  cr.cr_a = (LONG *)&cr.cr_id,

  cr.cr_id = QDEV_QCRT_IDVALUE;

  cr.cr_n = NULL;

  cr.cr_f = 0;

  cr.cr.m68k = regs;

  cr.cr.m68k->d[0] = main(1, (char **)&cr);
}
