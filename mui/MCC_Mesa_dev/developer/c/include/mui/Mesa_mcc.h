#ifndef MESA_MCC_H
#define MESA_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif

#define MUIC_Mesa "Mesa.mcc"
#define MUIC_MesaP "Mesa.mcp"
#define MesaObject MUI_NewObject(MUIC_Mesa

#define MUIM_Mesa_Redraw           0xfa34ff00
#define MUIM_Mesa_DrawUpdate       0xfa34ff01

#define MUIA_Mesa_Base           0xfa34ff00
#define MUIA_Mesa_Context        0xfa34ff01
#define MUIA_Mesa_DrawHook       0xfa34ff02
#define MUIA_Mesa_Tags           0xfa34ff03
#define MUIA_Mesa_Resized        0xfa34ff04
#define MUIA_Mesa_ResizeHook     0xfa34ff05
#define MUIA_Mesa_Display			0xfa34ff06
#define MUIA_Mesa_UseSubtask     0xfa34ff07
#define MUIA_Mesa_DriverBase     0xfa34ff08

#define MUIV_Mesa_ResizeHook_DefaultViewport	0x00000001

struct MCCMesaResizeData {long Width,Height;};

#define MUIV_Mesa_Display_Hidden		0x00000000
#define MUIV_Mesa_Display_OK			0x00000001
#define MUIV_Mesa_Display_Unable		0x00000002
#define MUIV_Mesa_Display_Waiting	0x00000003

#define MUICFG_Mesa_HandlerName     0xfa34ff00
#define MUICFG_Mesa_Buffered        0xfa34ff01
#define MUICFG_Mesa_HandlerParams   0xfa34ff02

#endif

