#include <intuition/classes.h>
#include <proto/intuition.h>
#include "protos.h"

#include <dos.h>

ULONG __asm A6Loader(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M);

Class *i_MakeClass(STRPTR ClassID, STRPTR SuperClassID, APTR SuperClassPtr, ULONG ISize, ULONG Nil, ULONG(*Entry)() )
{
  Class *c;
  // Hook
  
  if(c=MakeClass(ClassID,SuperClassID,SuperClassPtr,ISize,Nil)) 
  {
    c->cl_Dispatcher.h_Entry    =(HOOKFUNC)A6Loader;
    c->cl_Dispatcher.h_SubEntry =Entry;
    c->cl_Dispatcher.h_Data     =getreg(REG_A6);
  }
  return(c);  
}

ULONG __asm A6Loader(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M)
{
  ULONG __asm (*entry)(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M, register __a6 APTR Lib);
  
  entry=Cl->cl_Dispatcher.h_SubEntry;
  
  return(entry(Cl,Obj,M,(struct Library *)Cl->cl_Dispatcher.h_Data));
}
