/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getconioreq()
 *
*/

#include "../gid.h"

#define THESTRING "Transferred as if you typed it!"



struct mydata
{
  struct IOStdReq *md_io;
  UBYTE           *md_ptr;
};



/*
 * In case program waits at 'FGets()' there is most probably
 * 1024 bytes available in io_Data, you can confirm this by
 * looking at io_Length. In raw mode io_Length should be 1.
*/ 
__interrupt ULONG conputtext(REGARG(ULONG sigs, d0),
                                   REGARG(struct mydata *md, a1))
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));
  REGISTER UBYTE *from;
  REGISTER UBYTE *to;
  REGISTER UBYTE *end;


  if (!(CheckIO((struct IORequest *)md->md_io)))
  {
    /*
     * Prepare pointers only when it is certain that the request
     * in enqueued.
    */
    from = md->md_ptr;

    to = (UBYTE *)md->md_io->io_Data;

    end = to;

    end += md->md_io->io_Length;

    /*
     * Copy string into the buffer.
    */
    while ((*from) && (to < end))
    {
      *to++ = *from++;
    }

    /*
     * Tell how long the string is.
    */
    md->md_io->io_Actual = ((LONG)to - (LONG)md->md_io->io_Data);

    /*
     * Remove request from existing queue and reply. We are in
     * forbidden state here, so safe to call these.
    */
    Remove((struct Node *)md->md_io);

    ReplyMsg((struct Message *)md->md_io);
  }

  return sigs;
}

int GID_main(void)
{
  struct mydata md;
  UBYTE buf[64] = {0};
  LONG fd;


  if ((fd = Open("CONSOLE:", MODE_OLDFILE)))
  {
    /*
     * We need the request space that the handler uses to obtain
     * data from input/console.
    */
    if ((md.md_io = nfo_getconioreq(fd)))
    {
      /*
       * For the sake of this example we will need an exception
       * to be able to export string.
      */
      md.md_ptr = THESTRING;

      if (mem_addexhandler(
                         SIGBREAKB_CTRL_C, conputtext, &md) > -1)
      {
        FPrintf(
           fd, "Press <CTRL + C> or type something and <Ret>: ");

        Flush(fd);

        /*
         * Will block here waiting for the input!
        */
        FGets(fd, buf, sizeof(buf));

        FPrintf(fd, "Result: %s", (LONG)buf);

        mem_remexhandler(SIGBREAKB_CTRL_C);

        SetSignal(0L, SIGBREAKF_CTRL_C);
      }
    }

    Close(fd);
  }

  return 0;
}
