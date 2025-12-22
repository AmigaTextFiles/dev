/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_maketokenlist()
 * mem_freetokenlist()
 *
*/

#include "../gid.h"

#define MYTEXT   "Once upon a time there was a line of text"



int GID_main(void)
{
  struct MinList *ml;
  struct mem_mtl_iter *mi;


  /*
   * If you need to tokenize a pile of text, so that is can
   * easily be processed further then use this function.
  */
  if ((ml = mem_maketokenlist(MYTEXT, ' ')))
  {
    /*
     * Since entries carry MinNode, all standard operations
     * are possible(Remove(), AddTail(), ...). There is no 
     * need to worry about certain entries being 'Remove()'d
     * permanently, they will be still referenced thanks to
     * the cluster allocator!
    */
    QDEV_HLP_ITERATE(ml, struct mem_mtl_iter *, mi)
    {
      FPrintf(Output(), "%s\n", (LONG)mi->mi_token);
    }

    mem_freetokenlist(ml);
  }

  return 0;
}
