#define __USE_SYSBASE
//#include <clib/extras_protos.h>
//#include <clib/extras/exec_protos.h>
#include <exec/lists.h>
#include <proto/exec.h>
#include <string.h>

/****** extras.lib/EnqueueName ******************************************
*
*   NAME
*       EnqueueName -- Place a Node in a sorted List.
*
*   SYNOPSIS
*       EnqueueName(List,Node)
*
*       void EnqueueName(struct List *,struct Node*)
*
*   FUNCTION
*       Place a Node in a sorted List prioritized by Node.ln_Name 
*       and ln_Pri.
*
*   INPUTS
*       List - pointer to a List to place Node into.
*       Node - pointer to a Node to be placed in the List.
*
*   RESULT
*       None.
*
*   NOTES
*       The List must be presorted by ln_Name and ln_Pri.
*       Every node must have its ln_Name field pointing to
*       a NULL terminated string.
*
******************************************************************************
*
*/

void  EnqueueName(struct List *List,
                  struct Node *Node)
{
  struct Node *n;
  LONG cmp;
  
  if(List && Node)
  {
    n=List->lh_Head;
    while(n->ln_Succ)
    {
      cmp=stricmp(Node->ln_Name,n->ln_Name);
      if(cmp<=0)
      {
        if((cmp==0 && Node->ln_Pri>n->ln_Pri) || cmp<0)
        { 
          Insert(List,Node,n->ln_Pred);
          return;
        }
      }
      n=n->ln_Succ;
    }
    Insert(List,Node,n);
  }
}
