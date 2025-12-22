/*
			Definition of functions declared in librares/mui.hpp
         Copyright Tomasz Kaczanowski (Kaczus)
*/
#include <libraries/mui.hpp>
#include <iostream>

using namespace std;

APTR CMUI_Object ::poolHeader = NULL;
ULONG CMUI_Object ::poolCounter = 0;
APTR Reg_Cointainer::poolHeader = NULL;


struct EmulLibEntry GATE_CustomClass_Dispatcher = { TRAP_LIB, 0, (void (*)(void)) CustomClass_Dispatcher };
ULONG CustomClass_Dispatcher(void)
{ struct IClass *cl=(struct IClass*)REG_A0;
  Msg msg=(Msg)REG_A1;
	Object *obj=(Object *)REG_A2;
   
   ULONG ret;
   InformationObject *IObj;
   if(msg->MethodID==OM_NEW)
   {
		ret= DoSuperMethodA (cl, obj, msg);
		return ret;
	}
   IObj= (InformationObject *)INST_DATA(cl,obj);
   return (IObj->objx->*(IObj->Disp))(cl,obj,msg);
}

void *CMUI_Object ::operator new(size_t Rozm)
{
    if (poolHeader)
    {
        poolCounter++;
        return AllocVecPooled(poolHeader,Rozm);
    }
    else
    {
        throw std::bad_alloc();
    }

}

int INITMuiPlus()
{
   if (CMUI_Object::poolHeader==NULL)
   {
       CMUI_Object::poolHeader= CreatePool(MEMF_SEM_PROTECTED |MEMF_PUBLIC,4096,4096);
       CMUI_Object::poolCounter=0;
	}
   if (Custom_Object::ClasesNameSpace==NULL)
   {
      Custom_Object::ClasesNameSpace=new Reg_Cointainer(NULL);
      CMUI_Object::CCCointainer=Custom_Object::ClasesNameSpace;
   }
   if (CMUI_Object::poolHeader&&Custom_Object::ClasesNameSpace&&CMUI_Object::CCCointainer)
   {
      return 1;

	}
   else
   	return 0;

}

void DisposeMuiPlus()
{
   if (CMUI_Object::poolHeader!=NULL)
   {
       DeletePool(CMUI_Object::poolHeader);
   	 CMUI_Object::poolHeader=NULL;
   }
   if (Custom_Object::ClasesNameSpace!=NULL)
   {
      delete Custom_Object::ClasesNameSpace;
      Custom_Object::ClasesNameSpace=NULL;
      CMUI_Object::CCCointainer=NULL;

   }
}


void CMUI_Object::operator delete(void *wsk)
{
    if (wsk)
    	FreeVecPooled(poolHeader,wsk);
    poolCounter--;
}

Reg_Cointainer *Custom_Object::ClasesNameSpace=NULL;//(NULL);
Reg_Cointainer *CMUI_Object::CCCointainer=NULL;//&Custom_Object::ClasesNameSpace;

Reg_Cointainer::Reg_Cointainer(const char *name)
{
    First=NULL;
    Last=NULL;
    Act=NULL;
    if (poolHeader==NULL)
    {
      poolHeader= CreatePool(MEMF_SEM_PROTECTED |MEMF_PUBLIC,4096,4096);
    }

}
Reg_Cointainer::~Reg_Cointainer()
{
    if (First)
    {
    	delete First;
    }
    First=NULL;
    Last=NULL;
    Act=NULL;
    if (poolHeader)
    {
      DeletePool(poolHeader);
    }

}
void Reg_Cointainer::Dispose()
{
    if (First)
    {
    	delete First;
    }
    First=NULL;
    Last=NULL;
    Act=NULL;
    

}
Custom_ClassReg *Reg_Cointainer::RegisterClass(const char *name)
{
	int res=(First==NULL)?1:0;
   if (poolHeader==NULL)
   {
		poolHeader= CreatePool(MEMF_SEM_PROTECTED |MEMF_PUBLIC,4096,4096);
   }
   Act=First;
   while (res==0)
   {
      if (strcmp(Act->name,name)==0)
      {
      	res=2;
      }
      else
      {
         if (Act->Next)
         {
         	Act=Act->Next;
         }
         else
         {
            res=1;
         }

    	}

	}
   if (res==1)
   {
		Act=new Custom_ClassReg(name);
      if (First==NULL)
      {
				First=Act;
            Last=Act;
      }
      else
      {
      	Last->Next=Act;
         Act->Prev=Last;
        	Last=Act;
      }

	}
   return Act;
}

Custom_ClassReg::Custom_ClassReg(const char *n)
{
   if (n)
   {
   	name=(char *)AllocVecPooled(Reg_Cointainer::poolHeader,strlen(n)+1);
      strcpy(name,n);
   }
   else
   {
      name=NULL;
  	}
   Prev=NULL;
   Next=NULL;
   NewClass=NULL;
}
Custom_ClassReg::~Custom_ClassReg()
{
   if (Next)
   {
   	delete Next;
      Next=NULL;
   }
   if (NewClass)
		MUI_DeleteCustomClass (NewClass);

   if (name)
   {
      FreeVecPooled(Reg_Cointainer::poolHeader,name);
      name=NULL;
	}

}



