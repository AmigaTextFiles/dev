/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_qfopen()
 * dos_qfclose()
 * dos_qfread()
 * dos_qfwrite()
 * dos_qfsetmode()
 * dos_qfsetfctwait()
 * dos_qfwait()
 *
*/

#include "../gid.h"

/*
 * Use these macros to control CPU usage of this process and
 * to determine how checks are going to be made. -1 == coop,
 * 0 = no delay, 1 and up == delay in ticks. 
*/
#define QFWAITLOOP   0                          /* boolean */
#define QFWAITFCT   -1                          /* value   */



/*
 * This is a very simple 'Copy' alike program. It demonstrates
 * how to perform disk related ops and to utilise time that is
 * needed for the handler to process requests. In other words
 * instead of waiting for the handler to reply we can do other
 * things meantime.
*/
int GID_main(void)
{
  struct qfile *fdi;
  struct qfile *fdo;
  struct RDArgs *rda;
  LONG argv[2];
  UBYTE buf[1024];
  LONG read;
  LONG write;
  LONG error;


  /*
   * Lets read the arguments. Two files are needed: source &
   * destination.
  */
  error = 1;

  argv[0] = 0;

  argv[1] = 0;

  rda = ReadArgs("IF=INPUTFILE/A,"
                 "OF=OUTPUTFILE/A",
  argv, NULL);

  if (rda)
  {
    if ((argv[0]) && (argv[1]))
    {
      /*
       * Lets open the files user gave us. For the sake of
       * better show use some slow devices, such as DF0: and
       * files of at least 4 kilos.
      */
      error = 2;

      if ((fdi = dos_qfopen(
                            (UBYTE *)argv[0], MODE_OLDFILE)))
      {
        error = 3;

        if ((fdo = dos_qfopen(
                            (UBYTE *)argv[1], MODE_NEWFILE)))
        {
          /*
           * Set both handles to asynchronous and change the
           * waitstate.
          */
          dos_qfsetmode(fdi, QFILE_ASYNC);

          dos_qfsetmode(fdo, QFILE_ASYNC);

          /*
           * If QFWAITLOOP is 0 then these shall not be both
           * set to -1 in QFWAITFCT! Ususally the input FH
           * should be something like 1 to balance CPU load!
          */
          dos_qfsetfctwait(fdi, QFWAITFCT);

          dos_qfsetfctwait(fdo, QFWAITFCT);

          /*
           * Enter the transfer loop. Looks quite normal at
           * first.
          */
          error = 0;

          while ((read = dos_qfread(fdi, buf, sizeof(buf))))
          {
            ___read:

            if (read == -1)
            {
              /*
               * We have got read error its time to leave...
              */
              error = 4;

              break;
            }
            else if (read == -2)
            {
              /*
               * Operation is still in progress, we can do
               * something in here. Each time we are forced
               * to wait we will output 'r'.
              */
              Write(Output(), "r", 1);

#if QFWAITLOOP
              /*
               * At this point we could go back and repeat
               * but lets wait so the system load will be
               * low.
              */
              read = dos_qfwait(fdi, 0);

              goto ___read;
#endif
            }
            else
            {
              while ((write = dos_qfwrite(
                                     fdo, buf, read)) == -2)
              {
                /*
                 * The operation is in progress, so we will
                 * have to wait. Each time we are forced to
                 * wait we will output 'w'.
                */
                Write(Output(), "w", 1);

#if QFWAITLOOP
                /*
                 * At this point we could go back and stuff
                 * new charcter but that is not necessary,
                 * so lets wait.
                */
                if ((write = dos_qfwait(fdo, 0)) > -2)
                {
                  break;
                }
#endif
              }

              if ((write == 0) || (write == -1))
              {
                /*
                 * We have got write error. Time to leave...
                */
                error = 5;

                break;
              }
            }
          }

          Write(Output(), "\n", 1);

          dos_qfclose(fdo);
        }

        dos_qfclose(fdi);
      }
    }

    FreeArgs(rda);
  }

  FPrintf(Output(), "error = %ld\n", error);

  return 0;
}
