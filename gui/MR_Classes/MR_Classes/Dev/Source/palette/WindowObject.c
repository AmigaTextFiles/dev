#include "ui.h"
#include "newgads.h"
#include "edata.h"
#include "apptags.h"

#include <tagitemmacros.h>
#include <stdio.h>
#include <classes/supermodel.h>

#define DEBUG
#include <debug.h>


Object *SetupModel(struct EData *edata);
ULONG __saveds __asm IDCMPDispatch( register __a0 struct Hook *hook,
                    				        register __a2 APTR	   object,
                                    register __a1 struct IntuiMessage *IMsg);

BOOL i_NewWindowObject(Class *C, Object *Obj, struct opSet *Set)
{
  struct EData *edata;

  edata=INST_DATA(C,Obj);
// Hook
//DKP("i_NewWindowObject()\n");

  edata->IDCMPHook.H.h_Entry    =(HOOKFUNC)DispatcherStub;
  edata->IDCMPHook.H.h_SubEntry =(HOOKFUNC)IDCMPDispatch;
  edata->IDCMPHook.H.h_Data     =PaletteRequesterBase;
  edata->IDCMPHook.EData        =edata;

  /* Create the window object. */
  if(edata->Win_Object = (Object *)WindowObject,
    			WA_SizeGadget,  TRUE,
    			WA_DepthGadget, TRUE,
    			WA_DragBar,     TRUE,
    			WA_CloseGadget, TRUE,
    			WA_Activate,    TRUE,
    			WA_SmartRefresh,      TRUE,
//          WA_IDCMP,       IDCMP_IDCMPUPDATE | IDCMP_CLOSEWINDOW,
//        WA_PubScreenName,   "MPTestScreen",
          WINDOW_IDCMPHook,       &edata->IDCMPHook,
          WINDOW_IDCMPHookBits,   IDCMP_IDCMPUPDATE,          

    			WINDOW_ParentGroup,     NewGadgets(edata),
    		EndWindow)
      /*  Object creation sucessful? */
  {
  //  DKP("Window object 0x%08lx\n",edata->Win_Object);
    
    if(edata->Model=SetupModel(edata))
    {
    //  DKP("Model object 0x%08lx\n",edata->Win_Object);

      return(1);
    }
    DisposeObject(edata->Win_Object);
  }
  return(0);
}


BOOL i_DisposeWindowObject(Class *C, Object *Obj)
{
  struct EData *edata;

  edata=INST_DATA(C,Obj);

  DisposeObject(edata->Model);
  DisposeObject(edata->Win_Object);

  return(1);
}


Object *SetupModel(struct EData *edata)
{
  /*
  edata->GlueHook.h_Entry=A6Loader;
  edata->GlueHook.h_SubEntry=GM_Set;
  edata->GlueHook.h_Data=SuperModelBase;
  */
  
  return(SM_NewSuperModel(
            SMA_GlueFuncA6,         PaletteRequesterBase,
            SMA_GlueFuncUserData,   edata,
            SMA_GlueFunc,           GM_Set, // Glue function
            
            ICA_TARGET,     ICTARGET_IDCMP,

            SMA_AddMember,  SM_SICMAP( edata->G_Palette,
                              TCPALETTE_SelectedRed,         APP_Red,
                              TCPALETTE_SelectedGreen,       APP_Green,
                              TCPALETTE_SelectedBlue,        APP_Blue,
                              TCPALETTE_EditMode,            APP_EditMode,
                              TCPALETTE_Undo,                APP_Undo,
                              TCPALETTE_NoUndo,              APP_NoUndo,
                              TAG_DONE),

            SMA_AddMember,  SM_SICMAP( edata->G_Red,
                              SLIDER_Level,                   APP_Red,
                              TAG_DONE),
            SMA_AddMember,  SM_SICMAP( edata->G_Green,
                              SLIDER_Level,                   APP_Green,
                              TAG_DONE),
            SMA_AddMember,  SM_SICMAP( edata->G_Blue,
                              SLIDER_Level,                   APP_Blue,
                              TAG_DONE),
            SMA_AddMember,  SM_SICMAP( edata->G_RedText,
                              BUTTON_Integer,                        APP_Red,
                              TAG_DONE),
            SMA_AddMember,  SM_SICMAP( edata->G_GreenText,
                              BUTTON_Integer,                   APP_Green,
                              TAG_DONE),
            SMA_AddMember,  SM_SICMAP( edata->G_BlueText,
                              BUTTON_Integer,                   APP_Blue,
                              TAG_DONE),

            SMA_AddMember,  SM_SICMAP( edata->G_Copy,
                              GA_Selected,                        APP_CopyMode,
                              TAG_DONE),
            SMA_AddMember,  SM_SICMAP( edata->G_Swap,
                              GA_Selected,                        APP_SwapMode,
                              TAG_DONE),
            SMA_AddMember,  SM_SICMAP( edata->G_Spread,
                              GA_Selected,                        APP_SpreadMode,
                              TAG_DONE),

/*
            SMA_AddMember,  SM_SICMAP( edata->G_Undo,
                              GA_Disabled,                        APP_NoUndo,
                              TAG_DONE),
*/
            
            TAG_DONE));
}

/*
ULONG __asm i_A6Loader(register __a0 struct Hook *Hook, register __a2 Object *Obj, register __a1 Msg M)
{
  ULONG __asm (*entry)(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M, register __a6 APTR Lib);
  
  entry=Cl->cl_Dispatcher.h_SubEntry;
  
  return(entry(Cl,Obj,M,(struct Library *)Cl->cl_Dispatcher.h_Data));
}
*/

