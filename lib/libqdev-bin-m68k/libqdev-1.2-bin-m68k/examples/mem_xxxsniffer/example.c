/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_attachsniffer()
 * mem_detachsniffer()
 *
*/

#include "../gid.h"



/*
 * To see the output from sniffer you will have to hookup some
 * other machine to the serial port or use 'sashimi' redirector.
 * WARNING! CONSIDER THIS FUNCTION AN INTERRUPT! YOU CANNOT CALL
 * REGULAR OS ROUTINES THAT RELY ON SHARED SUBSYSTEMS HERE!
*/
QDEV_MEM_SNIFFUNC
(
  pktsniffer,

  /*
   * First statement is a private SysBase declaration so most
   * exec routines can be called here. The other statement is
   * userdata pointer.
  */
  QDEV_MEM_SNIFEXEC();
  QDEV_MEM_SNIFUSER(struct MsgPort *, mp);
  struct Message *mn;
  struct DosPacket *dp;


  QDEV_HLP_ITERATE(&mp->mp_MsgList, struct Message *, mn)
  {
    /*
     * Packet pointer is in 'ln_Name'!
    */
    if ((dp = (struct DosPacket *)mn->mn_Node.ln_Name))
    {
      switch (dp->dp_Type)
      {
        case ACTION_WRITE:
        {
          QDEVDEBUG_N("ACTION_WRITE\n"
                      "dp_Port      = 0x%08lx\n"
                      "mp_SigTask   = 0x%08lx\n"
                      "dp_Type      = %ld\n"
                      "dp_Arg1      = 0x%08lx\n"
                      "dp_Arg2      = 0x%08lx\n"
                      "dp_Arg3      = %ld\n"
                      "(dp_Arg2)    = %M%m\n\n",
                       dp->dp_Port,
                       dp->dp_Port->mp_SigTask,
                       dp->dp_Type,
                       dp->dp_Arg1,
                       dp->dp_Arg2,
                       dp->dp_Arg3,
                       dp->dp_Arg3,
                       dp->dp_Arg2);

          break;
        }

        case ACTION_READ_RETURN:
        {
          QDEVDEBUG_N("ACTION_READ_RETURN\n"
                      "mn_ReplyPort = 0x%08lx\n"
                      "mp_SigTask   = 0x%08lx\n"
                      "dp_Type      = %ld\n\n",
                       mn->mn_ReplyPort,
                       mn->mn_ReplyPort->mp_SigTask,
                       dp->dp_Type);

          break;
        }

        default:
        {
          QDEVDEBUG_N("PACKET NOT SUPPORTED!\n"
                      "dp_Port      = 0x%08lx\n"
                      "mp_SigTask   = 0x%08lx\n"
                      "dp_Type      = %ld\n\n",
                       dp->dp_Port,
                       dp->dp_Port->mp_SigTask,
                       dp->dp_Type);
        }
      }
    }
  }

  /*
   * A very important statement! It actually passes signal that
   * was patched. If this is not here then task that owns msg.
   * port will not know that something was sent to it! If you
   * want to drop certain packets then remember to cache nodes
   * and/or do not use QDEV_HLP_ITERATE()! Thus if there is no
   * packets left on the list then there is no point doing the
   * QDEV_MEM_SNIFPASS().
   * 
  */
  QDEV_MEM_SNIFPASS();
);

/*
 * This sniffer is to count how many signals have been sent to
 * the message port. Of course its accuracy is low cus signals
 * can be send from interrupts too.
*/
QDEV_MEM_SNIFFUNC
(
  sigdetect,

  QDEV_MEM_SNIFEXEC();
  QDEV_MEM_SNIFUSER(LONG *, cnt);


  (*cnt)++;

  /*
   * In theory 'pktsniffer' sets this already, but if it does
   * go away then 'sigdetect' must do it!
  */
  QDEV_MEM_SNIFPASS();
);

/*
 * This simple example shows how to spy on message port of the
 * CON: process. It is considered non-intrusive so you will not
 * know dp_Res1 and dp_Res2. But that is possible. All you have
 * to do is to patch dp_Port to point at your message port in
 * one sniffer and await reply at the other sniffer and then
 * revert dp_Port to its previous state and reply to the caller
 * so you catch incoming and outgoing packets in the end.
 *
 * Important! The sniffer code lives in your code space but it
 * gets executed in the context of a patched process! This way
 * no extra task switches are necessary when leaving sniffer
 * code. As soon as QDEV_MEM_SNIFPASS() is done and no other
 * sniffer is to be called normal task code continues.
 *
 * Message port sniffer is a very powerful tool. You can create
 * complex "local" hacks with its help so the OS function iface
 * stays intact. Moreover, it can also be attached regardless
 * of exception handler installed on the same signal.
*/
int GID_main(void)
{
  struct FileHandle *fh;
  struct MsgPort *mp;
  void *spy[2];
  LONG cnt = 0;
  LONG fd;


  if ((fd = Open("CONSOLE:", MODE_OLDFILE)))
  {
    fh = QDEV_HLP_BADDR(fd);

    mp = (struct MsgPort *)QDEV_HLP_ABS((LONG)fh->fh_Type);

    /*
     * Install our great packet sniffer.
    */
    if ((spy[0] = mem_attachsniffer(mp, pktsniffer, mp)))
    {
      /*
       * Then signal counter. Yes, it is possible to install
       * multiple sniffers on the same message port. It is
       * even possible to install them on top of exception
       * handlers which are exclusive btw :-) .
      */
      if ((spy[1] = mem_attachsniffer(mp, sigdetect, &cnt)))
      {
        FPuts(fd, "Write #1\n");

        FPuts(fd, "Write #2\n");

        FPuts(fd, "Write #3\n");

        mem_detachsniffer(spy[1]);
      }

      mem_detachsniffer(spy[0]);
    }

    Close(fd);

    FPrintf(Output(),
     "Caught %ld signals on mp = 0x%08lx\n", cnt, (LONG)mp);
  }

  return 0;
}
