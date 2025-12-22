/*
  Simple.mcp (c) Copyright 1996 by Gilles MASSON
  Registered MUI class, Serial Number: 1d51
  simple_mcc.c
*/

#include <exec/types.h>
#include <exec/execbase.h>
#include <dos/dosextens.h>
#include <proto/exec.h>
#include <libraries/mui.h>
#include <clib/muimaster_protos.h>

/* #include <proto/muimaster.h> is alreday made in simple_mcp_lib ! */

extern struct Library *myLibPtr;
extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;
extern struct Library *UtilityBase;
extern struct Library *GfxBase;
extern struct Library *IntuitionBase;
extern struct Library *LayersBase;
extern struct Library *MUIMasterBase;
extern struct MUI_CustomClass *ThisClass;


#include "simple_mcc.h"


static ULONG mSMCC_New(struct IClass *cl,Object *obj,struct opSet *msg)
{
  struct Simple_MCC_Data *data;

  if(!(obj = (Object *)DoSuperMethodA(cl, obj,(Msg) msg)))
    return(0);

  /*** init data ***/
  data = INST_DATA(cl,obj);

  /*** make group ***/
  data->mcc_group = VGroup,
    Child, HGroup,
      GroupFrame,
      Child, ColGroup(12),
        Child, CheckMark(FALSE), Child, Label1("MCC Mark1" ),
        Child, HSpace(0),
        Child, MUI_MakeObject(MUIO_VBar,2),
        Child, HSpace(0),
        Child, CheckMark(FALSE), Child, Label1("MCC Mark2" ),
        Child, HSpace(0),
        Child, MUI_MakeObject(MUIO_VBar,2),
        Child, HSpace(0),
        Child, CheckMark(FALSE), Child, Label1("MCC Mark3" ),
        Child, CheckMark(FALSE), Child, Label1("MCC Mark4" ),
        Child, HSpace(0),
        Child, MUI_MakeObject(MUIO_VBar,2),
        Child, HSpace(0),
        Child, CheckMark(FALSE), Child, Label1("MCC Mark5" ),
        Child, HSpace(0),
        Child, MUI_MakeObject(MUIO_VBar,2),
        Child, HSpace(0),
        Child, CheckMark(FALSE), Child, Label1("MCC Mark6" ),
      End,
    End,
    Child, ListviewObject,
      MUIA_Listview_List, ListObject,
        MUIA_Frame, MUIV_Frame_InputList,
        MUIA_List_AutoVisible, TRUE,
      End,
    End,
  End;

  if(!data->mcc_group)
  {
    CoerceMethod(cl, obj, OM_DISPOSE);
    return(0);
  }

  DoMethod(obj, OM_ADDMEMBER, data->mcc_group);


  /*** Colors ***/

  /*** Speed ***/

  return ((ULONG)obj);
}


static ULONG mSMCC_Dispose(struct IClass *cl,Object *obj,Msg msg)
{
  return(DoSuperMethodA(cl,obj,msg));
}


static ULONG mSMCC_Setup(struct IClass *cl,Object *obj,struct MUIP_Setup *msg)
{
  struct Simple_MCC_Data *data = INST_DATA(cl, obj);
  ULONG d;

  if(!(DoSuperMethodA(cl,obj,(Msg) msg)))
    return(FALSE);

  /*** Colors ***/
/*
  get(data->pp_player1, MUIA_Pendisplay_Spec, &d);
  set(data->pp_player1, MUIA_Pendisplay_Spec, d);
  get(data->pp_player2, MUIA_Pendisplay_Spec, &d);
  set(data->pp_player2, MUIA_Pendisplay_Spec, d);
  get(data->pp_background, MUIA_Pendisplay_Spec, &d);
  set(data->pp_background, MUIA_Pendisplay_Spec, d);
*/
  /*** Speed ***/
/*
  get(data->sl_speed, MUIA_Slider_Level, &d);
  set(data->sl_speed, MUIA_Slider_Level, d);
*/
  return(TRUE);
}


static ULONG mSMCC_Cleanup(struct IClass *cl,Object *obj,struct MUIP_Cleanup *msg)
{
  struct Simple_MCC_Data *data = INST_DATA(cl, obj);

  if(!(DoSuperMethodA(cl,obj,(Msg) msg)))
    return(FALSE);

  return(TRUE);
}


ULONG Simple_MCC_Dispatcher(void)
{
  register struct IClass *a0 __asm("a0");
  struct IClass *cl = a0;
  register Object *a2 __asm("a2");
  Object *obj = a2;
  register Msg a1 __asm("a1");
  Msg msg = a1;

  switch (msg->MethodID)
  {
    case OM_NEW                  : return (     mSMCC_New(cl,obj,(APTR)msg));
    case OM_DISPOSE              : return ( mSMCC_Dispose(cl,obj,(APTR)msg));
    case MUIM_Setup              : return (   mSMCC_Setup(cl,obj,(APTR)msg));
    case MUIM_Cleanup            : return ( mSMCC_Cleanup(cl,obj,(APTR)msg));
  }
  return(DoSuperMethodA(cl,obj,msg));
}

