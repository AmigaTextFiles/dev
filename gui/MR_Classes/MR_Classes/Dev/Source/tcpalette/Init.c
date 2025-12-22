#define DEBUG
#include <debug.h>

#include "private.h"

extern ULONG INST_SIZE;

BOOL i_OpenLibs(void);
void i_CloseLibs(void);

ULONG __asm DispatcherStub(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M);

/**************************************************************************************/

UBYTE SuperName[]=m_SUPERCLASS_ID,
      ClassName[]=m_CLASS_ID;

//UBYTE version[]="$VER: " m_CLASS_ID " 1.0 "__AMIGADATE__;

Class *ClassPtr;

int __saveds __asm __UserLibInit(register __a6 struct Library *LibBase)
{
//  DKP("__UserLibInit()\n");

  if(i_OpenLibs())
  {
    if(ClassPtr=MakeClass(ClassName,SuperName,0,INST_SIZE,0))
    {
//      DKP("   A4=%8lx A6=%8lx UtilityBase:&%8lx = %8lx\n",getreg(REG_A4),getreg(REG_A6),&UtilityBase,UtilityBase);
      ClassPtr->cl_Dispatcher.h_Data=LibBase;
      ClassPtr->cl_Dispatcher.h_Entry=DispatcherStub;

      AddClass(ClassPtr);
      /* Success */
      return(0);
    }
    i_CloseLibs();
  }
  /* Fail */
  return(-1);
}

void __saveds __asm __UserLibCleanup(register __a6 struct Library *LibBase)
{
//  DKP("__UserLibCleanup()\n");
  RemoveClass(ClassPtr);
  FreeClass(ClassPtr);
  i_CloseLibs();
}

ULONG __asm DispatcherStub(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M)
{
  return(Dispatcher(Cl,Obj,M,(struct Library *)Cl->cl_Dispatcher.h_Data));
}
