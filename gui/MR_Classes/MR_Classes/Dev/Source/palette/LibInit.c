//#define DEBUG
#include <debug.h>
#include <exec/types.h>
#include <intuition/classes.h>
#include <dos.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/locale.h>
#include <clib/alib_protos.h>


#include "edata.h"
#include "ui.h"

BOOL i_OpenLibs(void);
void i_CloseLibs(void);

struct Catalog *Catalog;

/**************************************************************************************/

Class   *EditorClassPtr;

struct Library *PaletteRequesterBase;

#define INIT_CLASS(class,entry)\
  class->cl_Dispatcher.h_Data=LibBase;\
  class->cl_Dispatcher.h_Entry=DispatcherStub;\
  class->cl_Dispatcher.h_SubEntry=(HOOKFUNC)entry;


int __saveds __asm __UserLibInit(register __a6 struct Library *LibBase)
{
  if(i_OpenLibs())
  {
    PaletteRequesterBase=LibBase;
    
    if(EditorClassPtr=MyMakeClass(0,"rootclass",0,sizeof(struct EData),0,EditorDispatcher))
    {
      Catalog=0;
      return(0);
    }
    i_CloseLibs();
  }
  /* Fail */
  return(-1);
}

void __saveds __asm __UserLibCleanup(register __a6 struct Library *LibBase)
{
  CloseCatalog(Catalog);
  FreeClass(EditorClassPtr);
  i_CloseLibs();
}

void __saveds __asm LIB_Dummy(void)
{
}

Class *MyMakeClass(STRPTR ClassID, STRPTR SuperClassID, APTR SuperClassPtr, ULONG ISize, ULONG Nil, ULONG(*Entry)() )
{
  Class *c;
  // Hook
  
  if(c=MakeClass(ClassID,SuperClassID,SuperClassPtr,ISize,Nil)) 
  {
    c->cl_Dispatcher.h_Data     =PaletteRequesterBase;
    c->cl_Dispatcher.h_Entry    =(HOOKFUNC)DispatcherStub;
    c->cl_Dispatcher.h_SubEntry =Entry;
  }
  return(c);  
}

ULONG __asm DispatcherStub(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M)
{
  ULONG __asm (*entry)(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M, register __a6 APTR Lib);
  
  entry=Cl->cl_Dispatcher.h_SubEntry;
  
  return(entry(Cl,Obj,M,(struct Library *)Cl->cl_Dispatcher.h_Data));
}


/*
ULONG __asm DispatcherStub(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M)
{
  return(EditorDispatcher(Cl,Obj,M,(struct Library *)Cl->cl_Dispatcher.h_Data));
}
*/
