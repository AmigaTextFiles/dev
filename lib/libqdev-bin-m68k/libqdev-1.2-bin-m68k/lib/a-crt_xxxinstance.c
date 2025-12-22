/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * crt_xxxinstance()
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
 * $VER: a-crt_xxxinstance.c 1.00 (23/04/2014) QCRT0
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Don't forget to read the autodocs!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qsupp.h"

#ifdef __amigaos__
#include <proto/exec.h>
#else
#include "qclone.h"
#endif

/*
 * OOPS: This function cannot be enhanced with memory pools!
*/
#undef ___QDEV_FORCEPOOLS

#include "qdev.h"

#include "qcrt0.h"



LONG crt_newinstance(struct qcrtregs *cr)
{
  QBASEDECL2(
  struct ExecBase *, SysBase, (*((struct ExecBase **) 4)));
  REGISTER LONG *reloc;
  REGISTER LONG *end;
  REGISTER LONG mem;
  REGISTER LONG _a4;


  QDEVDEBUG(QDEVDBFARGS "(cr = 0x%08lx)\n", cr);

  /*
   * Check if data have to be copied to new location.
  */
  if (cr->cr.m68k->d[4])
  {
    if ((mem = (LONG)AllocMem(
                          cr->cr.m68k->d[3], MEMF_PUBLIC)))
    {
      _a4 = ((LONG)cr->cr.m68k->a[3] - QDEV_QCRT_DDIST);

      CopyMemQuick(
              (LONG *)_a4, (LONG *)mem, cr->cr.m68k->d[3]);

      /*
       * Check if pointers have to be relocated in new
       * instance.
      */
      if (*cr->cr.m68k->a[5])
      {
        reloc = cr->cr.m68k->a[5];

        end = reloc;

        end++;

        end += *reloc;

        while (++reloc < end)
        {
          *(LONG *)(mem + *reloc) -= (_a4 - mem);
        }
      }

      cr->cr.m68k->a[4] = (LONG *)(mem + QDEV_QCRT_DDIST);

      if (!(cr->cr_f & QDEV_QCRT_F_NOA4))
      {
        QDEV_HLP_SETREG(a4, cr->cr.m68k->a[4]);
      }
    }
  }
  else
  {
    /*
     * No new instance is necessary so set dummy return
     * value just to continue.
    */
    mem = 0x7FFFFFFF;
  }

  return mem;

  QDEVDEBUGIO();
}

void crt_freeinstance(struct qcrtregs *cr)
{
  QBASEDECL2(
  struct ExecBase *, SysBase, (*((struct ExecBase **) 4)));


  QDEVDEBUG(QDEVDBFARGS "(cr = 0x%08lx)\n", cr);

  /*
   * Check if new instance has to be freed. Lets hope
   * that user did not touch the regs.
  */
  if (cr->cr.m68k->d[4])
  {
    if (!(cr->cr_f & QDEV_QCRT_F_NOA4))
    {
      QDEV_HLP_SETREG(a4, cr->cr.m68k->a[3]);
    }

    FreeMem(
       (void *)((LONG)cr->cr.m68k->a[4] - QDEV_QCRT_DDIST),
                                        cr->cr.m68k->d[3]);

    cr->cr.m68k->a[4] = cr->cr.m68k->a[3];
  }

  QDEVDEBUGIO();
}
