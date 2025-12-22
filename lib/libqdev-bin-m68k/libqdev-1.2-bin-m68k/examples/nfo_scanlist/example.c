/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_scanlist()
 *
*/

#include "../gid.h"

#define TEXTSIZE   128
#define MINCHUNKS    8      /* MINCHUNKS * (sizeof(struct mynode) + 4) !    */

#define E_ALLOK      0      /* NULL means OK, this is hardcoded!            */
#define E_NOMEM      1



struct mynode
{
  struct Library  mn_lib;
  UBYTE           mn_name[TEXTSIZE];
  UBYTE           mn_idstr[TEXTSIZE];
};

struct mydata
{
  void           *md_clu;
  struct MinList  md_list;
};



LONG isROM(void *addr)
{
  /*
   * This is really, really symbolic and may fail on some
   * setups!
  */
  if ((addr >= (void *)0x00F80000)  &&
      (addr <  (void *)0x00FFFFFF))
  {
    return 1;
  }

  return 0;
}

ULONG mylibcollect(struct nfo_sct_cb *_tc)
{
  struct Library *lib = _tc->tc_itemaddr;
  struct mydata *md = _tc->tc_userdata;
  struct mynode *mn;
  LONG size;


  /*
   * Lets get the memory for our new node from the cluster.
  */
  if ((mn = mem_getmemcluster(md->md_clu)))
  {
    /*
     * Copy the library data, and then fix the strings.
    */
    mn->mn_lib = *lib;

    /*
     * Copy the name to our local buffer.
    */
    mn->mn_name[0] = '\0';

    txt_strncat(
        mn->mn_name, mn->mn_lib.lib_Node.ln_Name, TEXTSIZE);

    /*
     * Fix pointer!
    */
    mn->mn_lib.lib_Node.ln_Name = mn->mn_name;

    /*
     * Copy the idstring to our local buffer if it is not
     * NULL.
    */
    mn->mn_idstr[0] = '\0';

    if ((isROM(mn->mn_lib.lib_IdString))       ||
        (TypeOfMem(mn->mn_lib.lib_IdString)))
    {
      size = txt_strncat(
           mn->mn_idstr, mn->mn_lib.lib_IdString, TEXTSIZE);

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

    /*
     * Fix pointer!
    */
    mn->mn_lib.lib_IdString = mn->mn_idstr;

    /*
     * Put this entry on our local list.
    */
    AddTail((struct List *)&md->md_list, (struct Node *)mn);

    return E_ALLOK;
  }

  return E_NOMEM;
}

/*
 * This pretty example shows how to use single code to get
 * similar objects in one go.
*/
int GID_main(void)
{
  struct mynode *mn;
  struct mydata md;
  ULONG thelist[] =
  {
    (ULONG)&SysBase->LibList,
    (ULONG)&SysBase->DeviceList,
    (ULONG)&SysBase->ResourceList,
    NULL
  };
  LONG res;


  /*
   * Allocate the min. cluster for collecting libraries.
   * It will expand every MINCHUNKS, due to MEMF_LARGEST!
  */
  if ((md.md_clu = mem_alloccluster(
                           sizeof(struct mynode), MINCHUNKS,
                               MEMF_PUBLIC | MEMF_LARGEST)))
  {
    /*
     * Initialize our local library list.
    */
    NewList((struct List *)&md.md_list);

    /*
     * Attempt library collection, so that we can inspect
     * all fields afterwards and give some feedback.
    */
    QDEV_HLP_NOSWITCH
    (
      res = nfo_scanlist(thelist, &md, mylibcollect);
    );

    if (res == E_ALLOK)
    {
      QDEV_HLP_ITERATE(&md.md_list, struct mynode *, mn)
      {
        FPrintf(Output(), "ln_Type      = %ld\n"
                          "ln_Pri       = %ld\n"
                          "ln_Name      = %s\n"
                          "lib_Flags    = 0x%08lx\n"
                          "lib_NegSize  = %ld\n"
                          "lib_PosSize  = %ld\n"
                          "lib_Version  = %ld\n"
                          "lib_Revision = %ld\n"
                          "lib_IdString = %s\n"
                          "lib_Sum      = 0x%08lx\n"
                          "lib_OpenCnt  = %ld\n\n",
                                mn->mn_lib.lib_Node.ln_Type,
                                 mn->mn_lib.lib_Node.ln_Pri,
                          (LONG)mn->mn_lib.lib_Node.ln_Name,
                                       mn->mn_lib.lib_Flags,
                                     mn->mn_lib.lib_NegSize,
                                     mn->mn_lib.lib_PosSize,
                                     mn->mn_lib.lib_Version,
                                    mn->mn_lib.lib_Revision,
                              (LONG)mn->mn_lib.lib_IdString,
                                         mn->mn_lib.lib_Sum,
                                    mn->mn_lib.lib_OpenCnt);
      }
    }

    /*
     * This will free all local library entries we have
     * collected.
    */
    mem_freecluster(md.md_clu);
  }

  return 0;
}
