/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * txt_debugprintf()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QDBPF'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QDBPF'  is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: p-txt_debugprintf.c 1.01 (07/11/2012) QDBPF
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Yes, this function is like so famous  'kprintf()'.  Patches such as:
 * 'sushi'  or  'sashimi'  redirect  the output without  any  problems.
 *
 * You cant debug this code, since it is being used to do that already!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#define ___QDEV_NOLOCALBASES
#include "qsupp.h"

#ifdef __amigaos__
#include <proto/exec.h>
#include <proto/dos.h>
#else
#include "qport.h"
#endif

#include "qdev.h"



static __nifunc __saveds __interrupt void
                                         ___qdev_prv_putfunc(
                REGARG(UBYTE *ptr, a0), REGARG(LONG chr, d0))
{
#ifndef _RawPutChar
  REGVAR(struct ExecBase *SysBase, a6) =
                                 (*((struct ExecBase **) 4));
  void (*_RawPutChar)(REGARG(LONG, d0)) =
                              mem_addrfromlvo(SysBase, -516);
#endif


  _RawPutChar(chr);
}

static __nifunc __saveds __interrupt void
                                   ___qdev_prv_initfunc(void)
{
#ifndef _RawIOInit
  REGVAR(struct ExecBase *SysBase, a6) =
                                 (*((struct ExecBase **) 4));
  void (*_RawIOInit)(void) = mem_addrfromlvo(SysBase, -504);
#endif


  _RawIOInit();
}

__nifunc __interrupt LONG txt_debugprintf(LONG maxwrite,
                                       const UBYTE *fmt, ...)
{
  va_list ap;
  REGISTER LONG res;


  va_start(ap, fmt);

  QDEVDBDISABLE();

  /*
   * Since we are sending debug info to built-in serial
   * port, no buffer is needed, but we still can set the
   * output limit which is a good thing.
  */
  ___qdev_prv_initfunc();

  res = txt_vcbpsnprintf(___qdev_prv_putfunc,
                                    NULL, maxwrite, fmt, ap);

  QDEVDBENABLE();

  va_end(ap);

  return res;
}

__nifunc __interrupt LONG txt_vdebugprintf(LONG maxwrite,
                                const UBYTE *fmt, va_list ap)
{
  REGISTER LONG res;


  QDEVDBDISABLE();

  ___qdev_prv_initfunc();

  res = txt_vcbpsnprintf(___qdev_prv_putfunc,
                                    NULL, maxwrite, fmt, ap);

  QDEVDBENABLE();

  return res;
}
