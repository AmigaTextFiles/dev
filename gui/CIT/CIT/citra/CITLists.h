//
//       CITList and CITNode include
//
//						 StormC
//
//            version 2001.12.29
//

#ifndef CIT_LISTS_H
#define CIT_LISTS_H TRUE

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <proto/exec.h>

//
// CIT node types
//
#define CITAPPCLASSNODE      100
#define CITSCREENCLASSNODE   101
#define CITWINDOWCLASSNODE   102

class CITNode:public Node
{
  public:
    CITNode();
    
    void  NodeType(UBYTE t) { ln_Type = t; }
    UBYTE NodeType() { return ln_Type; }
    void  Priority(BYTE p);
    BYTE  Priority() { return ln_Pri; }
    void  NodeName(char* name) { ln_Name = name; }
    char* NodeName() { return ln_Name; }
    
    class CITNode *Succ()
      { return( ln_Succ->ln_Succ ? (class CITNode *)ln_Succ : NULL); }
    class CITNode *Pred()
      { return( ln_Pred->ln_Pred ? (class CITNode *)ln_Pred : NULL); }
    BOOL Inserted() { return( (ln_Succ!=NULL) && (ln_Pred!=NULL) ); }
};

//
// Enqueue modes
//
#define ENQUEUE_PRIORITY      0
#define ENQUEUE_NAME          1
#define ENQUEUE_PRIORITYNAME  2
#define ENQUEUE_NAMEPRIORITY  3
#define ENQUEUE_NOCASE        0x8000

class CITList:public List
{
  public:
    CITList();
    
    void AddHead(class CITNode *np) { ::AddHead(this,np); }
    void AddTail(class CITNode *np) { ::AddTail(this,np); }
    void Enqueue(class CITNode *np,short mode = ENQUEUE_PRIORITY);
    void Insert(class CITNode *n,class CITNode *ln) {::Insert(this,n,ln);}
    void Remove(class CITNode *np);
    class CITNode *RemHead();
    class CITNode *RemTail();
    class CITNode *Head()
      { return( lh_Head->ln_Succ ? (class CITNode *)lh_Head : NULL ); }
    class CITNode *Tail()
      { return( lh_Head->ln_Succ ? (class CITNode *)lh_TailPred : NULL ); }
    class CITNode *FindName(char *s)
      {return( (class CITNode *)::FindName(this,s) );}
    class CITNode *FindName(class CITNode *np,char *s)
      {return( (class CITNode *)::FindName((class CITList *)np,s) );}
};

#endif
