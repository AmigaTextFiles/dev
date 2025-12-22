/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * crt_xxxmethod()
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
 * $VER: a-crt_xxxmethod.c 1.00 (25/04/2014) QCRT0
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

#include "qdev.h"

#include "qcrt0.h"



void crt_initmethod(struct qcrtregs *cr)
{
  QBASEDECL2(
  struct ExecBase *, SysBase, (*((struct ExecBase **) 4)));
  struct Process *pr = (struct Process *)SysBase->ThisTask;


  QDEVDEBUG(QDEVDBFARGS "(cr = 0x%08lx)\n", cr);

  if (pr->pr_Task.tc_Node.ln_Type == NT_PROCESS)
  {
    if (pr->pr_CLI)
    {
      cr->cr_f |= QDEV_QCRT_M_CLI;
    }
    else
    {
      WaitPort(&pr->pr_MsgPort);

      cr->cr.m68k->a[0] = (LONG *)GetMsg(&pr->pr_MsgPort);

      cr->cr_f |= QDEV_QCRT_M_WB;
    }
  }
  else
  {
    cr->cr_f |= QDEV_QCRT_M_BOOT;
  }

  QDEVDEBUGIO();
}

void crt_exitmethod(struct qcrtregs *cr)
{
  QBASEDECL2(
  struct ExecBase *, SysBase, (*((struct ExecBase **) 4)));


  QDEVDEBUG(QDEVDBFARGS "(cr = 0x%08lx)\n", cr);

  if ((cr->cr_f & QDEV_QCRT_M_WB) && (cr->cr.m68k->a[0]))
  {
    /*
     * Started from Workbench so lets wait for deallocate.
    */
    Forbid();

    ReplyMsg((struct Message *)cr->cr.m68k->a[0]);
  }

  QDEVDEBUGIO();
}
