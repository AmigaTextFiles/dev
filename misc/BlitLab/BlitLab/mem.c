/*
 *   Memory allocation and deallocation for BlitLab.
 */
#include "structures.h"
struct memnode {
   struct memnode * next ;
   long size ;
} ;
static struct memnode *head ;
/*
 *   Replacement for AllocMem.  If not enough memory, we exit.
 */
void *allocmem(size, type)
long size ;
long type ;
{
   struct memnode *p ;
   extern void *AllocMem() ;

   p = (struct memnode *)AllocMem(size + sizeof(struct memnode), type) ;
   if (p==NULL)
      error("! out of memory") ;
   p->size = size + sizeof(struct memnode) ;
   p->next = head ;
   head = p ;
   return(p + 1) ;
}
/*
 *   Frees all allocated memory.
 */
freemem() {
   struct memnode *p ;

   while (head != NULL) {
      p = head->next ;
      FreeMem(head, head->size) ;
      head = p ;
   }
}
