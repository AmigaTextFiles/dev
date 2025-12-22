/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_scanturbo()
 *
*/

#include "../gid.h"

#define TEXTSIZE    64
#define MINCHUNKS    8      /* MINCHUNKS * (sizeof(struct mynode) + 4) !    */

#define E_ALLOK      0      /* NULL means OK, this is hardcoded!            */
#define E_NOMEM      1



struct mynode
{
  struct Library  mn_lib;
  ULONG           mn_addr;
  ULONG           mn_hash;
  UBYTE           mn_name[TEXTSIZE];
};

struct mydata
{
  void           *md_clu;
  struct MinList  md_list;
};



void fillwithdata(struct mynode *mn, struct Library *lib)
{
  mn->mn_lib = *lib;

  mn->mn_name[0] = '\0';

  txt_strncat(mn->mn_name, lib->lib_Node.ln_Name, TEXTSIZE);

  mn->mn_lib.lib_Node.ln_Name = mn->mn_name;

  mn->mn_addr = (ULONG)lib;

  mn->mn_hash = QDEV_HLP_FNV32IHASH(mn->mn_name);
}

void mylibcollect2(struct nfo_stu_cb *stu)
{
  struct mydata *md = stu->stu_udata;
  struct Library *lib[2] =
  {
    (struct Library *)QDEV_NFO_STURBO_NODEH(stu),
    (struct Library *)QDEV_NFO_STURBO_NODET(stu)
  };
  struct mynode *mn[2];


  /*
   * Lets get the memory for our new node from the cluster.
   * We have got space for two nodes here, they reside one
   * after another.
  */
  if ((mn[0] = mem_getmemcluster(md->md_clu)))
  {
    fillwithdata(mn[0], lib[0]);

    AddTail(
         (struct List *)&md->md_list, (struct Node *)mn[0]);

    /*
     * If Head-most node is not the same as Tail-most node
     * then continue.
    */
    if (lib[0] != lib[1])
    {
      mn[1] = mn[0];

      mn[1]++;

      fillwithdata(mn[1], lib[1]);

      AddTail(
         (struct List *)&md->md_list, (struct Node *)mn[1]);
    }
  }
  else
  {
    stu->stu_ures = E_NOMEM;

    QDEV_NFO_STURBO_BREAK(stu);
  }
}

void myliblocate2(struct nfo_stu_cb *stu)
{
  LONG *req = stu->stu_udata;
  struct mynode *mn[2] =
  {
    (struct mynode *)QDEV_NFO_STURBO_NODEH(stu),
    (struct mynode *)QDEV_NFO_STURBO_NODET(stu)
  };


  if (req[0])
  {
    /*
     * About to search by address.
    */
    if ((stu->stu_ures = (LONG)
                 (mn[0]->mn_addr == req[0] ? mn[0] :
                  mn[1]->mn_addr == req[0] ? mn[1] : NULL)))
    {
      QDEV_NFO_STURBO_BREAK(stu);
    }
  }
  else
  {
    /*
     * About to search by name (hash).
    */
    if (req[1])
    {
      if ((stu->stu_ures = (LONG)
                 (mn[0]->mn_hash == req[1] ? mn[0] :
                  mn[1]->mn_hash == req[1] ? mn[1] : NULL)))
      {
        QDEV_NFO_STURBO_BREAK(stu);
      }
    }
  }
}

/*
 * Turbo list scanner example with the ability to find the
 * resource and show some details.
*/
int GID_main(void)
{
  struct mynode *mn;
  struct mydata md;
  UBYTE buf[64];
  UBYTE *ptr;
  ULONG req[2];
  ULONG thelist[] =
  {
    (ULONG)&SysBase->LibList,
    (ULONG)&SysBase->DeviceList,
    (ULONG)&SysBase->ResourceList,
    NULL
  };
  ULONG newlist[] =
  {
    NULL,
    NULL
  };
  LONG res;


  /*
   * Allocate self expanding cluster of at least MINCHUNKS.
   * Note that single alloc here is 2x bigger!
  */
  if ((md.md_clu = mem_alloccluster(
                       sizeof(struct mynode) * 2, MINCHUNKS,
                               MEMF_PUBLIC | MEMF_LARGEST)))
  {
    /*
     * Initialize our local library list and scanner list.
    */
    NewList((struct List *)&md.md_list);

    newlist[0] = (LONG)&md.md_list;

    /*
     * Attempt library collection, so that we can inspect
     * all fields afterwards and give some feedback.
    */
    QDEV_HLP_NOSWITCH
    (
      res = nfo_scanturbo(thelist, &md, mylibcollect2);
    );

    if (res == E_ALLOK)
    {
      FPrintf(Output(),   "ADDR       HASH       NAME\n"
                          "----       ----       ----\n");

      QDEV_HLP_ITERATE(&md.md_list, struct mynode *, mn)
      {
        FPrintf(Output(), "0x%08lx 0x%08lx %s\n",
                                   mn->mn_addr, mn->mn_hash,
                         (LONG)mn->mn_lib.lib_Node.ln_Name);
      }

      while(1)
      {
        FPrintf(Output(),
                    "\nType in resource name or address: ");

        Flush(Output());

        Flush(Input());

        if (FGets(Input(), buf, sizeof(buf) - 1))
        {
          /*
           * Pressing just the Return key kills the program.
          */
          if(buf[0] != '\n')
          {
            if ((ptr = txt_strchr(buf, '\n')))
            {
              *ptr = '\0';
            }

            /*
             * Interested either in addr = [0] or hash = [1].
            */
            req[0] = 0;

            req[1] = 0;

            if (!(cnv_AtoULONG(buf, &req[0], 0)))
            {
              req[1] = QDEV_HLP_FNV32IHASH(buf);
            }

            if ((mn = (struct mynode *)nfo_scanturbo(
                       newlist, (void *)req, myliblocate2)))
            {
              FPrintf(Output(), "ADDRESS      = 0x%08lx\n"
                                "ln_Type      = %ld\n"
                                "ln_Pri       = %ld\n"
                                "ln_Name      = %s\n"
                                "lib_Flags    = 0x%08lx\n"
                                "lib_NegSize  = %ld\n"
                                "lib_PosSize  = %ld\n"
                                "lib_Version  = %ld\n"
                                "lib_Revision = %ld\n"
                                "lib_Sum      = 0x%08lx\n"
                                "lib_OpenCnt  = %ld\n\n",
                                                mn->mn_addr,
                                mn->mn_lib.lib_Node.ln_Type,
                                 mn->mn_lib.lib_Node.ln_Pri,
                          (LONG)mn->mn_lib.lib_Node.ln_Name,
                                       mn->mn_lib.lib_Flags,
                                     mn->mn_lib.lib_NegSize,
                                     mn->mn_lib.lib_PosSize,
                                     mn->mn_lib.lib_Version,
                                    mn->mn_lib.lib_Revision,
                                         mn->mn_lib.lib_Sum,
                                    mn->mn_lib.lib_OpenCnt);
            }
            else
            {
              FPrintf(Output(), "Not found!\n");
            }
          }
          else
          {
            break;
          }
        }
        else
        {
          break;
        }
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
