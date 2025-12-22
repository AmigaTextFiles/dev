/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_grabqarea()
 *
*/

#include "../gid.h"

/*
 * This private header must be included when qarea struct.
 * is to be inspected.
*/
#include "a-mem_grabqarea.h"

#define MYIDVALUE   0xAABBCCDD



struct mynode
{
  struct Node mn_node;
  UBYTE       mn_text[32];
};



int GID_main(void)
{
  struct mynode *mn;
  struct qarea *qa;
  LONG linkin = 1;


  /*
   * By calling this function you either create the area or
   * you resolve it. In either case 'qa' is all initialized
   * and ready.
  */
  qa = mem_grabqarea();

  /*
   * For now you can use the list freely for your data. Do
   * not forget though that others can also use it, so mark
   * your stuff in some way! It is safe to use the node for
   * that.
  */
  QDEV_HLP_NOINTSEC
  (
    QDEV_HLP_ITERATE(&qa->qa_ulist, struct mynode *, mn)
    {
      if (mn->mn_node.ln_Name == (void *)MYIDVALUE)
      {
        linkin = 0;

        break;
      }
    }
  );

  if (linkin)
  {
    /*
     * OK, this is our first time.
    */
    if ((mn = AllocVec(sizeof(struct mynode), MEMF_PUBLIC)))
    {
      mn->mn_node.ln_Name = (void *)MYIDVALUE;

      mn->mn_text[0] = '\0';

      txt_strncat(mn->mn_text,
                   "Hellow ye world!", sizeof(mn->mn_text));

      QDEV_HLP_NOINTSEC
      (
        AddTail(
           (struct List *)&qa->qa_ulist, (struct Node *)mn);
      );

      FPrintf(Output(), "Added the node, start me again\n");
    }
  }
  else
  {
    /*
     * We did identify our node.
    */
    FPrintf(Output(), "0x%08lx, %s\n",
              (LONG)mn->mn_node.ln_Name, (LONG)mn->mn_text);
  }

  return 0;
}
