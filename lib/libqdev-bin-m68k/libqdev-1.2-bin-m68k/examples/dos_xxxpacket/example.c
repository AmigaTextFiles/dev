/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_replypacket()
 * dos_waitpacket()
 *
*/

#include "../gid.h"

#define DEVICENAME   "TEST0:"
#define DEVICETSIG   SIGBREAKF_CTRL_C
#define DEVICETEXT   "This is test device, currently there is "   \
                     "nobody inside, so leave the message after " \
                     "the tone. Thank you! Beeeeeeep...\n"



int GID_main(void)
{
  struct DosList *dol;
  struct DosPacket *dp;
  LONG res1;
  LONG res2;
  LONG eof = 0;
  LONG quit = 0;
  LONG clients = 0;
  UBYTE *text = DEVICETEXT;
  LONG tlen = sizeof(DEVICETEXT) - 1;


  /*
   * Create our test DOS device.
  */
  if ((dol = dos_makedevice(DEVICENAME)))
  {
    /*
     * Handle incoming packets, until someone decides to kill
     * this device.
    */
    while (!((quit) && (clients == 0)))
    {
      /*
       * Wait for packets, callers will be sending. Additional
       * termination signal can be used.
      */
      if ((dp = dos_waitpacket(dol->dol_Task, DEVICETSIG)))
      {
        switch (dp->dp_Type)
        {
          /*
           * OK. This device is really primitive. Run this code
           * in one shell and type: 'type TEST0:' in another.
          */
          case ACTION_FINDINPUT:
          {
            res1 = DOSTRUE;

            res2 = 0;

            clients++;

            break;
          }

          case ACTION_END:
          {
            res1 = DOSTRUE;

            res2 = 0;

            clients--;

            break;
          }

          case ACTION_READ:
          {
            if (eof)
            {
              res1 = 0;
            }
            else
            {
              res1 = QDEV_HLP_MIN(dp->dp_Arg3, tlen);

              if (res1 > 0)
              {
                CopyMem((void *)text, (void *)dp->dp_Arg2, res1);
              }
            }

            res2 = 0;

            eof ^= 1;
   
            break;
          }

          case ACTION_IS_FILESYSTEM:
          {
            res1 = DOSFALSE;

            res2 = 0;

            break;
          }

          case ACTION_DIE:
          {
            if (clients == 0)
            {
              res1 = DOSTRUE;

              res2 = 0;
            }
            else
            {
              res1 = DOSFALSE;

              res2 = ERROR_OBJECT_IN_USE;
            }

            quit = 1;

            break;
          }

          default:
          {
            res1 = DOSFALSE;

            res2 = ERROR_ACTION_NOT_KNOWN;
          }
        }

        /*
         * At this point reply the other side. We are complete.
        */
        dos_replypacket(dp, dol->dol_Task, res1, res2);
      }
      else
      {
        /*
         * Termination signal was caught, so indicate that we
         * should really be gone.
        */
        quit = 1;
      }
    }

    dos_killdevice(dol);
  }

  return 0;
}
