/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mod_ktpresunlink()
 *
*/

#include "../gid.h"

#define TEXTSIZE   128
#define MINCHUNKS    8      /* MINCHUNKS * (sizeof(struct mynode) + 4) !    */



struct mynode
{
  struct MinNode  mn_node;
  UBYTE           mn_name[TEXTSIZE];
  UBYTE           mn_idstr[TEXTSIZE];
};



int GID_main(void)
{
  struct RDArgs *rda;
  struct mynode *mn;
  struct MinList list;
  struct Resident *rt;
  ULONG *currktp;
  LONG size;
  LONG cnt;
  LONG argv[1];
  LONG hash = 0;
  LONG ihash;
  LONG num = 0;
  void *cluster;


  /*
   * Lets read the optional argument that allows to pick
   * which module will be deleted. This can be its name
   * or temporary number.
  */
  argv[0] = 0;

  if ((rda = ReadArgs("NAME=NUM", argv, NULL)))
  {
    if (argv[0])
    {
      /*
       * Assume that the user gave us a number of the mod.
      */
      if (!(cnv_AtoLONG((UBYTE *)argv[0], &num, 0)))
      {
        /*
         * Well, that is a name ;-) , so lets hash it with
         * some good hashing routine that will output case
         * insensitive value.
        */
        hash = QDEV_HLP_FNV32IHASH((UBYTE *)argv[0]);
      }
    }

    FreeArgs(rda);
  }

  /*
   * Allocate the min. cluster for collecting modules.
   * It will expand every MINCHUNKS, due to MEMF_LARGEST!
  */
  if ((cluster = mem_alloccluster(
                         sizeof(struct mynode), MINCHUNKS,
                             MEMF_PUBLIC | MEMF_LARGEST)))
  {
    NewList((struct List *)&list);

    /*
     * Scan all KTP modules.
    */
    cnt = 1;

    QDEV_HLP_NOSWITCH
    (
      currktp = SysBase->KickTagPtr; 

      while(currktp)
      {
        rt = (void *)currktp[0];

        /*
         * Hash the name will ya?
        */
        ihash = 0;

        if (rt->rt_Name)
        {
          ihash = QDEV_HLP_FNV32IHASH(rt->rt_Name);
        }

        /*
         * Check which module is to be removed.
        */
        if ((cnt == num) || ((hash) && (ihash == hash)))
        {
          /*
           * At this point we are not worried by the module
           * chain integrity since we do not deallocate nor
           * trash that memory, so we can continue iterate.
          */
          mod_ktpresunlink(rt);
        }
        else
        {
          /*
           * Put this module on our local list.
          */
          if ((mn = mem_getmemcluster(cluster)))
          {
            mn->mn_name[0] = '\0';

            if (rt->rt_Name)
            {
              txt_strncat(
                        mn->mn_name, rt->rt_Name, TEXTSIZE);
            }

            mn->mn_idstr[0] = '\0';

            if (rt->rt_IdString)
            {
              size = txt_strncat(
                   mn->mn_idstr, rt->rt_IdString, TEXTSIZE);

              size = QDEV_HLP_ABS(size);

              /*
               * Get rid of newline in the idstring...
              */
              if (size--)
              {
                if (mn->mn_idstr[size] == '\n')
                {
                  mn->mn_idstr[size] = '\0';
                }

                if (--size)
                {
                  if (mn->mn_idstr[size] == '\n')
                  {
                    mn->mn_idstr[size] = '\0';
                  }
                }
              }
            }

            AddTail(
                   (struct List *)&list, (struct Node *)mn);
          }
        }

        /*
         * Resolve next module.
        */
        currktp = 
           (ULONG *)(currktp[1] & ~QDEV_MOD_KTL_PTRBITMASK);

        cnt++;
      }
    );

    /*
     * Now we can dump the list safely.
    */
    if (!(QDEV_HLP_ISLISTEMPTY(&list)))
    {
      cnt = 1;

      QDEV_HLP_ITERATE(&list, struct mynode *, mn)
      {
        FPrintf(Output(), "%03ld. [%25s]   %s\n",
                cnt, (LONG)mn->mn_name, (LONG)mn->mn_idstr);

        cnt++;
      }
    }
    else
    {
      FPrintf(Output(), "No KTP resident modules!\n");
    }

    mem_freecluster(cluster);
  }

  return 0;
}
