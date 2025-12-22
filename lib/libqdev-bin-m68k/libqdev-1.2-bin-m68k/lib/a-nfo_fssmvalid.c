/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * nfo_fssmvalid()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'FSSMV'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'FSSMV'  is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: a-nfo_fssmvalid.c 1.00 (26/01/2011) FSSMV
 * AUTH: Scout Team, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Concept taken from "Scout".
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qsupp.h"

#ifdef __amigaos__
#include <proto/exec.h>
#include <proto/dos.h>
#include <dos/filehandler.h>
#else
#include "qclone.h"
#endif

#include "qdev.h"



void *nfo_fssmvalid(void *fssmptr)
{
  struct FileSysStartupMsg *fssm = 
                             (struct FileSysStartupMsg *)fssmptr;
  struct DosEnvec *de;
  UBYTE *ptr;


  QDEVDEBUG(QDEVDBFARGS "(fssmptr = 0x%08lx)\n", fssmptr);

  if (((ULONG)fssm > 1024)        &&
      (TypeOfMem(fssm)))
  {
    ptr = (UBYTE *)QDEV_HLP_BADDR(fssm->fssm_Device);

    if ((fssm->fssm_Unit < 256)   &&
        (ptr)                     &&
        (TypeOfMem(ptr))          &&
        (*ptr)                    &&
        (*++ptr))
    {
      de = (struct DosEnvec *)QDEV_HLP_BADDR(fssm->fssm_Environ);

      if ((de)                    &&
          (TypeOfMem(de)))
      {
        return fssmptr;
      }
    }
  }

  return NULL;

  QDEVDEBUGIO();
}
