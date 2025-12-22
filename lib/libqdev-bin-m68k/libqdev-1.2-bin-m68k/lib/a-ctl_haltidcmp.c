/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * ctl_haltidcmp()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'HIDCMP' is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'HIDCMP' is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: a-ctl_haltidcmp.c 1.01 (15/02/2013) HIDCMP
 * AUTH: RKM, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This code has been borrowed from RKM-3.x.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qsupp.h"

#ifdef __amigaos__
#include <proto/exec.h>
#include <proto/intuition.h>
#else
#include "qclone.h"
#endif

#include "qdev.h"



void ctl_haltidcmp(struct Window *window)
{
  struct IntuiMessage *msg;
  struct Node *node;


  QDEVDEBUG(QDEVDBFARGS "(window = 0x%08lx)\n", window);

  QDEVDEBUG(QDEVDBSPACE
        "window->UserPort = 0x%08lx\n", window->UserPort);

  QDEV_HLP_NOSWITCH
  (
    if (window->UserPort)
    {
      msg = (void *)window->UserPort->mp_MsgList.lh_Head;

      while ((node = msg->ExecMessage.mn_Node.ln_Succ))
      {
        if (msg->IDCMPWindow == window)
        {
          Remove((struct Node *)msg);

          ReplyMsg((struct Message *)msg);
        }

        msg = (struct IntuiMessage *)node;
      }

      if (window->UserPort->mp_Node.ln_Type == NT_MSGPORT)
      {
        ModifyIDCMP(window, 0L);
      }
      else
      {
        window->UserPort = NULL;

        window->IDCMPFlags = 0;
      }
    }
  );

  QDEVDEBUGIO();
}
