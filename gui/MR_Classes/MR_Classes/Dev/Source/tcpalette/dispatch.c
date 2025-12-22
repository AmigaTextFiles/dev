#define DEBUG
#include <debug.h>

#include "private.h"
#include "protos.h"

ULONG INST_SIZE=m_INST_SIZE;


extern Class *ClassPtr;

Class * __saveds __asm LIB_TCPALETTE_GetClass(void)
{
  return(ClassPtr);
}

ULONG __saveds __asm Dispatcher(register __a0 Class *C, register __a2 struct Gadget *Gad, register __a1 Msgs M, register __a6 struct Library *LibBase )
{
  struct GadData *gdata;
  ULONG retval=0;

  gdata=INST_DATA(C, Gad);

//  DKP("Dispatcher MethodID %08lx\n", M->MethodID);

  switch(M->MethodID)
  {
    case OM_NEW:
      if(Gad=(struct Gadget *)DoSuperMethodA(C,(Object *)Gad,(Msg)M))
      {
        gdata=INST_DATA(C, Gad);
        
        SetSuperAttrs(C,Gad, GA_TabCycle,1,TAG_DONE);
        
        gdata->Pattern=NewObject(0,(UBYTE *)"mlr_ordered.pattern", TAG_DONE);
        {
          if(gdata->Bevel=BevelObject, BEVEL_Style, BVS_BUTTON, BEVEL_FillPen, -1, End)
          {
            gdata->Precision=8;
            gdata->ShowSelected=1;
            
            gad_SetAttrs(C,Gad,(struct opSet *)M);
            retval=(ULONG)Gad;
          }
        } 
      }
      break;

    case OM_UPDATE:
    case OM_SET:
      retval=DoSuperMethodA(C,(Object *)Gad,(Msg)M);
      gad_SetAttrs(C,Gad,(struct opSet *)M);
     break;

    case OM_GET:
      gad_GetAttr(C,Gad,(struct opGet *)M);
     break;
     

    case OM_DISPOSE:
      DisposeObject(gdata->Pattern);
      DisposeObject(gdata->Bevel);
      retval=DoSuperMethodA(C,(Object *)Gad,(Msg)M);
      break;

    case GM_HITTEST:
      retval = GMR_GADGETHIT;
      break;
      
    case GM_GOACTIVE:
      Gad->Flags |= GFLG_SELECTED;
      retval=gad_HandleInput(C,Gad,(struct gpInput *)M);      
//      gad_Render(C,Gad,(APTR)M,GREDRAW_UPDATE);
//      retval=GMR_MEACTIVE;
      break;
      
    case GM_GOINACTIVE:
      Gad->Flags &= ~GFLG_SELECTED;
      gad_Render(C,Gad,(APTR)M,GREDRAW_UPDATE);
      break;

    case GM_LAYOUT:
      retval=gad_Layout(C,Gad,(struct gpLayout *)M);
      break;
      
    case GM_RENDER:
      retval=gad_Render(C,Gad,(struct gpRender *)M,0);
      break;

    case GM_HANDLEINPUT:
      retval=gad_HandleInput(C,Gad,(struct gpInput *)M);
      break;
      
    case GM_DOMAIN:
      gad_Domain(C, Gad, (APTR)M);
      retval=1;
      break;
      
    default:
      retval=DoSuperMethodA(C,(Object *)Gad,(Msg)M);
      break;
  }
  return(retval);
}

