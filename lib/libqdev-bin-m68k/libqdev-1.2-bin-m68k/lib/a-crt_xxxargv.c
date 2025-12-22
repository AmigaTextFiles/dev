/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * crt_xxxargv()
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
 * $VER: a-crt_xxxargv.c 1.00 (03/05/2014) QCRT0
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



LONG crt_createargv(struct qcrtregs *cr, int *argc, char ***argv)
{
  QBASEDECL2(
         struct ExecBase *, SysBase, (*((struct ExecBase **) 4)));
  struct Process *pr = (struct Process *)SysBase->ThisTask;
  struct CommandLineInterface *cli;
  UBYTE *ptr;
  LONG **array = NULL;
  LONG size[3];
  LONG count;


  QDEVDEBUG(QDEVDBFARGS
               "(cr = 0x%08lx, argc = 0x%08lx, argv = 0x%08lx)\n",
                                                  cr, argc, argv);

  if ((pr->pr_Task.tc_Node.ln_Type == NT_PROCESS) && (pr->pr_CLI))
  {
    /*
     * First, lets get into command name. This will be put in [0].
    */
    cli = QDEV_HLP_BADDR(pr->pr_CLI);

    ptr = QDEV_HLP_BADDR(cli->cli_CommandName);

    /*
     * Then lets see how many arguments were supplied by the user.
    */
    count = txt_parseline((UBYTE *)cr->cr.m68k->a[0], NULL);

    /*
     * There is [n] arguments + ptr for the command name + array
     * terminator + allocation length store.
    */
    size[0] = (count + 1 + 1 + 1) * sizeof(LONG);

    /*
     * Command name length + NULL terminator. And, arguments line
     * length + NULL terminator.
    */
    size[1] = ptr[0] + 1;

    size[2] = cr->cr.m68k->d[0] + 1;

    /*
     * Can now allocate that kind of memory. Must use 'AllocMem()'
     * to be compatible with V34 OS.
    */
    if ((array = AllocMem(
          size[0] + size[1] + size[2], MEMF_PUBLIC | MEMF_CLEAR)))
    {
      /*
       * Store the allocation size.
      */
      array[0] = (LONG *)(size[0] + size[1] + size[2]);

      /*
       * Attach command name buffer. This will effectively be [0]
       * when it comes to argv.
      */
      array[1] = (LONG *)((LONG)array + size[0]);

      CopyMem(&ptr[1], array[1], ptr[0]);

      /*
       * Attach arguments line buffer. Copy the line and parse the
       * args on that copy.
      */
      array[2] = (LONG *)((LONG)array[1] + size[1]);

      CopyMem(cr->cr.m68k->a[0], array[2], cr->cr.m68k->d[0]);

      txt_parseline((UBYTE *)array[2], &array[2]);

      txt_fixquotes(&array[2], count, QDEV_TXT_FQF_ASTERISK |
                 QDEV_TXT_FQF_BACKSLASH | QDEV_TXT_FQF_SINGQUOTE);

      *argv = (char **)++array;

      *argc = ++count;
    }
  }

  return (LONG)array;

  QDEVDEBUGIO();
}

void crt_destroyargv(struct qcrtregs *cr, int *argc, char ***argv)
{
  QBASEDECL2(
         struct ExecBase *, SysBase, (*((struct ExecBase **) 4)));
  LONG **array = (LONG **)*argv;


  QDEVDEBUG(QDEVDBFARGS
               "(cr = 0x%08lx, argc = 0x%08lx, argv = 0x%08lx)\n",
                                                  cr, argc, argv);

  if (cr != (void *)array)
  {
    FreeMem(--array, (LONG)*array);
  }

  *argv = (char **)cr;

  *argc = 1;

  QDEVDEBUGIO();
}
