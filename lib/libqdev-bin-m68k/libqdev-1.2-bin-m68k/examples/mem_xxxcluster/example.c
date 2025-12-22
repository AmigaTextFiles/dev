/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_alloccluster()
 * mem_freecluster()
 * mem_getmemcluster()
 * mem_freememcluster()
 *
*/

#include "../gid.h"

/*
 * It is especially important to pre-examine chunk size, so that
 * first cluster will be of reasonable size(will just fit in low
 * memory situation). Knowing that the node structure is 166 b.
 * long, add sizeof(LONG) to it and multiply by a num. of chunks.
 * (166 + 4) * 24 = 4080, a single cluster will take about 4 k.
 * of memory. That should do even when the memory is fragmented
 * like a Swiss cheese.
*/
#define TEXTSIZE   128
#define MINCHUNKS   24      /* MINCHUNKS * (sizeof(struct mynode) + 4) !    */

#define E_ALLOK      0      /* NULL means OK, this is hardcoded!            */
#define E_NOMEM      1



/*
 * This structure will need 166 bytes of memory each time there
 * is a need to collect new entry.
*/
struct mynode
{
  struct MsgPort  mn_mp;
  ULONG           mn_addr;
  UBYTE           mn_name[TEXTSIZE];
};

struct mydata
{
  void           *md_clu;
  struct MinList  md_list;
};



ULONG mymsgportcollect(struct nfo_sct_cb *_tc)
{
  struct MsgPort *mp = _tc->tc_itemaddr;
  struct mydata *md = _tc->tc_userdata;
  struct mynode *mn;


  /*
   * Lets get the memory from the cluster we did allocate in
   * the main function.
  */
  if ((mn = mem_getmemcluster(md->md_clu)))
  {
    /*
     * Raw-copy the message port structure and its address.
    */
    mn->mn_mp = *mp;

    mn->mn_addr = (ULONG)mp;

    /*
     * Now copy the message port name. Its a pointer that may
     * be invalid after scan is complete, so we have to copy. 
    */
    mn->mn_name[0] = '\0';

    txt_strncat(
              mn->mn_name, mn->mn_mp.mp_Node.ln_Name, TEXTSIZE);

    /*
     * Now fix the pointer!
    */
    mn->mn_mp.mp_Node.ln_Name = mn->mn_name;

    /*
     * And connect this very entry to our local list.
    */
    AddTail((struct List *)&md->md_list, (struct Node *)mn);

    return E_ALLOK;
  }

  /*
   * Unfortunately there is no more memory available in the OS.
  */
  return E_NOMEM;
}

/*
 * In this example we will collect all public message ports with
 * the help of cluster allocator which will reduce greatly the
 * amount of real memory allocations(about 23 times less calls
 * per 24 entries, about 46 t. less calls per 48 entries, ...).
 * It will also keep track on all allocations, so we are free to
 * just allocate.
*/
int GID_main(void)
{
  struct mynode *mn;
  struct mydata md;
  ULONG thelist[] =
  {
    (ULONG)&SysBase->PortList,
    NULL
  };
  UBYTE *state;
  LONG res;


  /*
   * Allocate the minimal cluster for collecting ports. It will
   * expand every MINCHUNKS, due to MEMF_LARGEST!
  */
  if ((md.md_clu = mem_alloccluster(
                               sizeof(struct mynode), MINCHUNKS,
                                   MEMF_PUBLIC | MEMF_LARGEST)))
  {
    /*
     * Then initialize the list.
    */
    NewList((struct List *)&md.md_list);

    /*
     * Attempt message port collection. Notice that this very op
     * happens when the task switches are disabled!
    */
    QDEV_HLP_NOSWITCH
    (
      res = nfo_scanlist(thelist, &md, mymsgportcollect);
    );

    /*
     * If all is upto the plan the continue. We can now dump the
     * list safely.
    */
    if (res == E_ALLOK)
    {
      FPrintf(Output(),
         "Address   Type  Pri  State     Signal      Name  \n");

      FPrintf(Output(),
         "--------- ----  ---- -----     ---------   ------\n");

      QDEV_HLP_ITERATE(&md.md_list, struct mynode *, mn)
      {
        switch (mn->mn_mp.mp_Flags)
        {
          case PA_SIGNAL:
          {
            state = "signal   ";
  
            break;
          }
  
          case PA_SOFTINT:
          {
            state = "softint  ";
  
            break;
          }
  
          case PA_IGNORE:
          {
            state = "ignore   ";
  
            break;
          }

          default:
          {
            state = "invalid  ";
          }
        }

        FPrintf(Output(), "$%08lx %s %4ld %s $%08lX   %s\n",
                                                    mn->mn_addr,
                                                  (LONG)"port ",
                                 (LONG)mn->mn_mp.mp_Node.ln_Pri,
                                                    (LONG)state,
                             (ULONG)(1L << mn->mn_mp.mp_SigBit),
                               (LONG)mn->mn_mp.mp_Node.ln_Name);
      }
    }

    /*
     * Notice that if you were to use memory allocator directly
     * you would be forced to free each entry separatly. In this
     * particular case its just a matter of freeing the cluster.
    */
    mem_freecluster(md.md_clu);
  }

  return 0;
}
