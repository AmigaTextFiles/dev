/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * nfo_m68kcputype()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'MC060'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'MC060'  is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: a-nfo_m68kcputype.c 1.01 (05/06/2011) MC060
 * AUTH: Piru, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Original  CPU detection code by Harry 'Piru' Sintonen. This code has
 * been altered a little bit, i did comment on in too.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qsupp.h"

#ifdef __amigaos__
#include <proto/exec.h>
#include <exec/execbase.h>
#else
#include "qclone.h"
#endif

#include "qdev.h"



#ifndef ___nfo_detect68060
QDEV_HLP_ASMENTRY
(
  ___nfo_detect68060,
  "\n\t	movem.l a0/a1,-(sp)		"    /* Save a0 and a1 on stack     */
  "\n\t	move.l	a5,a0			"    /* Save a5 so we can hook in   */
  "\n\t	moveq	#0,d0			"    /* Indicate we have no 68060   */
  "\n\t	lea	(_cte_docheck,pc),a5	"    /* Attach check routine        */
  "\n\t	jsr	(-30,a6)		"    /* Call 'Supervisor()'         */
  "\n\t	movem.l	(sp)+,a0/a1		"    /* Restore a0 and a1           */ 
  "\n\t	rts				"                             
  "\n_cte_docheck:			"                             
  "\n\t	move.l	a0,a5			"    /* Restore a5                  */
  "\n\t	dc.w	0x4E7A,0x8801		"    /* movec	vbr,a0; Obtain VBR  */
  "\n\t	move.l	(0x10,a0),-(sp)		"    /* Put 'II' vector on stack    */
  "\n\t	move.l	(0x2C,a0),-(sp)		"    /* Put '1111' vector on stack  */
  "\n\t	move.l	a0,-(sp)		"    /* Put the address on stack    */
  "\n\t	lea	(_cte_exception,pc),a1	"    /* Get the addr. of new e. r.  */
  "\n\t	move.l	a1,(0x10,a0)		"    /* Attach it to 'II' vector    */
  "\n\t	move.l	a1,(0x2C,a0)		"    /* Attach it to '1111' vector  */
  "\n\t	dc.w	0x4E7A,0x0008		"    /* movec buscr,d0; Try BUSCR   */
  "\n\t	dc.w	0x4E7A,0x0808		"    /* movec pcr,d0; Try PCR       */
  "\n\t	moveq	#1,d0			"    /* This must be 68060          */
  "\n_cte_restore:			"
  "\n\t	move.l	(sp)+,a0		"    /* Restore old VBR address     */
  "\n\t	move.l	(sp)+,(0x2C,a0)		"    /* Restore old '1111' vector   */
  "\n\t	move.l	(sp)+,(0x10,a0)		"    /* Restore old 'II' vector     */
  "\n\t	nop				"    /* Synchronize pipelines       */
  "\n\t	rte				"
  "\n_cte_exception:			"
  "\n\t	lea	(_cte_restore,pc),a0	"    /* Load restore address in a0  */
  "\n\t	move.l	a0,(2,sp)		"    /* Trickily restore VBR vecs   */
  "\n\t	nop				"    /* Synchronize pipelines       */
  "\n\t	rte				"
);
#endif

LONG ___nfo_detect68060(void);

ULONG nfo_m68kcputype(void)
{
  REGISTER UWORD attnflags;
  REGISTER ULONG cpu;


  QDEVDEBUG(QDEVDBFARGS "(void)\n");

  attnflags = SysBase->AttnFlags;

  if (((attnflags & AFF_68060) == AFF_68060)  ||
      ((attnflags & AFF_68040) == AFF_68040))
  {
    Disable();

    if ((___nfo_detect68060()))
    {      
      cpu = AFF_68060;
    }
    else
    {      
      cpu = AFF_68040;
    }

    Enable();
  }
  else if ((attnflags & AFF_68030) == AFF_68030)
  {
    cpu = AFF_68030;
  }
  else if ((attnflags & AFF_68020) == AFF_68020)
  {
    cpu = AFF_68020;
  }
  else if ((attnflags & AFF_68010) == AFF_68010)
  {
    cpu = AFF_68010;
  }
  else
  {
    cpu = 0;
  }

  return cpu;

  QDEVDEBUGIO();
}
