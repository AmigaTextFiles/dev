#include <exec/execbase.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

FD3(39,void,Insert,struct List *list,A0,struct Node *node,A1,struct Node *prev,A2)
{ if(prev==NULL)
    prev=(struct Node *)list;
  node->ln_Succ=prev->ln_Succ;
  node->ln_Pred=prev;
  prev->ln_Succ=node;
  node->ln_Succ->ln_Pred=node;
}

FD1(42,void,Remove,struct Node *node,A1)
{ node->ln_Succ->ln_Pred=node->ln_Pred;
  node->ln_Pred->ln_Succ=node->ln_Succ;
}

FD2(40,void,AddHead,struct List *list,A0,struct Node *node,A1)
{
  node->ln_Succ=list->lh_Head;
  node->ln_Pred=(struct Node *)list;
  list->lh_Head=node;
  node->ln_Succ->ln_Pred=node;
}

FD1(43,struct Node *,RemHead,struct List *list,A0)
{ struct Node *node;
  node=list->lh_Head->ln_Succ;
  if(node!=NULL)
  {
    node->ln_Pred=(struct Node *)list;
    node=list->lh_Head;
    list->lh_Head=node->ln_Succ;
  }
  return node;
}
  
FD2(41,void,AddTail,struct List *list,A0,struct Node *node,A1)
{ node->ln_Pred=list->lh_TailPred;
  node->ln_Succ=(struct Node *)&list->lh_Tail;
  list->lh_TailPred=node;
  node->ln_Pred->ln_Succ=node;
}

FD1(44,struct Node *,RemTail,struct List *list,A0)
{ struct Node *node;
  node=list->lh_TailPred->ln_Pred;
  if(node!=NULL)
  {
    node->ln_Succ=(struct Node *)&list->lh_Tail;
    node=list->lh_TailPred;
    list->lh_TailPred=node->ln_Pred;
  }
  return node;
}

FD2(45,void,Enqueue,struct List *list,A0,struct Node *node,A1)
{ struct Node *n;
  n=list->lh_Head;
  while(n->ln_Succ!=NULL)
  {
    if(n->ln_Pri<node->ln_Pri)
      break;
     n=n->ln_Succ;
  }
  node->ln_Succ=n;
  node->ln_Pred=n->ln_Pred;
  node->ln_Pred->ln_Succ=node;
  n->ln_Pred=node;
}

FD2(46,struct Node *,FindName,struct List *list,A0,STRPTR name,A1)
{ struct Node *node;
  node=list->lh_Head;
  while(node->ln_Succ!=NULL)
  {
    char *s1=node->ln_Name;
    char *s2=name;
    while(*s1++==*s2)
      if(!*s2++)
        return node;
    node=node->ln_Succ;
  }
  return NULL;
}
