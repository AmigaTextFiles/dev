/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_openifh()
 * mem_closeifh()
 *
*/

#include "../gid.h"

/*
 * Include this private header when you need to implement your
 * own packet handler.
*/
#include "a-mem_xxxifh.h"

#define MYARGUMENTS "Parsing The Arguments\n"



/*
 * Please note that the packet handler code will be executed
 * from private task exception(pseudo-interrupt), so you cannot
 * use most of the OS routines who refer to shared resources!
*/
__saveds __interrupt ULONG mypackethandler(REGARG(ULONG sigs, d0),
                               REGARG(struct mem_ifh_data *id, a1))
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));


  if ((id->id_dp = QDEV_MEM_PRV_GETPKT(id)))
  {
    switch (id->id_dp->dp_Type)
    {
      case ACTION_READ:
      {
        id->id_res1 = QDEV_HLP_MIN(id->id_dp->dp_Arg3, 
                                (id->id_datalen - id->id_datapos));
   
        if (id->id_res1 > 0)
        {
          CopyMem((void *)((LONG)id->id_dataptr + 
                                             (LONG)id->id_datapos), 
                          (void *)id->id_dp->dp_Arg2, id->id_res1);
   
          id->id_datapos += id->id_res1;
        }

        id->id_res2 = 0;
   
        break;
      }
   
      default:
      {
        id->id_res1 = DOSFALSE;

        id->id_res2 = ERROR_ACTION_NOT_KNOWN;
      }
    }

    QDEV_MEM_PRV_REPLYPKT(id, id->id_res1, id->id_res2);
  }

  return sigs;
}

int GID_main(void)
{
  struct RDArgs *rda;
  LONG argv[3];
  LONG old;
  LONG fd;


  /*
   * Read command line arguments from our own source the other
   * way, i.e. using virtual file instead of aux RDArgs.
  */
  if ((fd = mem_openifh(
           MYARGUMENTS, sizeof(MYARGUMENTS) - 1, mypackethandler)))
  {
    /*
     * Pick new 'Input()' which is our virtual file.
    */
    old = SelectInput(fd);

    /*
     * Prepare the argv array and parse the arguments using OS
     * stuff.
    */
    QDEV_HLP_QUICKFILL(&argv[0], LONG, 0, sizeof(argv));

    rda = ReadArgs("ARG1,ARG2,ARG3", argv, NULL);

    if (rda)
    {
      if (argv[0])
      {
        FPrintf(Output(), "argv[0] = %s\n", argv[0]);
      }

      if (argv[1])
      {
        FPrintf(Output(), "argv[1] = %s\n", argv[1]);
      }

      if (argv[2])
      {
        FPrintf(Output(), "argv[2] = %s\n", argv[2]);
      }

      FreeArgs(rda);
    }

    /*
     * Clean up.
    */
    SelectInput(old);

    mem_closeifh(fd);
  }

  return 0;
}
