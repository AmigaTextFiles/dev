/*-------------------------------------------------
  Name: GLArea.mcp
  Version: 0.40
  Date: 28.5.1999
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note: MUI Custom class for an OpenGL area
	StormC/GCC port
	StormMesa version
	MsgPort and Signal version
	MCCLib supported for the lib init
	TaskList handling vias Exec list
---------------------------------------------------*/
#include <exec/types.h>
#include <exec/execbase.h>
#include <dos/dosextens.h>
#include <proto/exec.h>
#include <libraries/mui.h>

// #include <mui/GLArea_mcc.h>
#include "GLArea_mcp.h"

#include "GLArea_mcp_lib.h"
#include "psi_screenon.bh"
#include <mui/MCCLib.c>

#define DEBUGCON    "KCON:"

BPTR gfh=NULL;

static BOOL ClassInitFunc(const struct Library *const base) {

    gfh=Open(DEBUGCON "0/0/400/100/GLArea.mcc",MODE_NEWFILE);
    FPrintf(gfh,"Version:" VERSIONSTR "\n");
}
static void ClassExitFunc(const struct Library *const base) {
    Close(gfh);
}

static ULONG GLArea_MCP_New(struct IClass *cl,Object *obj,struct opSet *msg)
{
  struct Data *data;

  if(!(obj = (Object *)DoSuperMethodA(cl, obj,(Msg) msg)))
    return(0);

  /*** init data ***/
  data = INST_DATA(cl,obj);

  /*** make group ***/
  data->mcp_group = VGroup,
    Child, StringObject,
      StringFrame,
    End,
    Child, ListviewObject,
      MUIA_Listview_List, ListObject,
	MUIA_Frame, MUIV_Frame_InputList,
	MUIA_List_AutoVisible, TRUE,
      End,
    End,
    Child, HGroup,
      GroupFrame,
      Child, ColGroup(12),
	Child, CheckMark(FALSE), Child, Label1("MCP GLArea" ),
	Child, HSpace(0),
	Child, MUI_MakeObject(MUIO_VBar,2),
	Child, HSpace(0),
	Child, CheckMark(FALSE), Child, Label1("MCP Mark2" ),
	Child, HSpace(0),
	Child, MUI_MakeObject(MUIO_VBar,2),
	Child, HSpace(0),
	Child, CheckMark(FALSE), Child, Label1("MCP Mark3" ),
      End,
    End,
  End;

  if(!data->mcp_group)
  {
    CoerceMethod(cl, obj, OM_DISPOSE);
    return(0);
  }

  DoMethod(obj, OM_ADDMEMBER, data->mcp_group);


  /*** Colors ***/

  /*** Speed ***/

  return ((ULONG)obj);
}


static ULONG GLArea_MCP_Dispose(struct IClass *cl,Object *obj,Msg msg)
{
  return(DoSuperMethodA(cl,obj,msg));
}


static ULONG GLArea_MCP_Setup(struct IClass *cl,Object *obj,struct MUIP_Setup *msg)
{
  struct Data *data = INST_DATA(cl, obj);
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


static ULONG GLArea_MCP_Cleanup(struct IClass *cl,Object *obj,struct MUIP_Cleanup *msg)
{
  struct Data *data = INST_DATA(cl, obj);

  if(!(DoSuperMethodA(cl,obj,(Msg) msg)))
    return(FALSE);

  return(TRUE);
}


ULONG Dispatcher (struct IClass *cl __asm("a0"), Object *obj __asm("a2"), Msg msg __asm("a1")) {
  switch (msg->MethodID)
  {
    case OM_NEW                  : return (     GLArea_MCP_New(cl,obj,(APTR)msg));
    case OM_DISPOSE              : return ( GLArea_MCP_Dispose(cl,obj,(APTR)msg));
    case MUIM_Setup              : return ( GLArea_MCP_Setup(cl,obj,(APTR)msg));
    case MUIM_Cleanup            : return ( GLArea_MCP_Cleanup(cl,obj,(APTR)msg));
  }
  return(DoSuperMethodA(cl,obj,msg));
}

