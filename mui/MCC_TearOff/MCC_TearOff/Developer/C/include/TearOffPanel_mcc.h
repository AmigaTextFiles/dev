#ifndef TEAROFFPANEL_MCC_H
#define TEAROFFPANEL_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif

#define MUIC_TearOffPanel "TearOffPanel.mcc"
#define TearOffPanelObject MUI_NewObject(MUIC_TearOffPanel

#define MUIA_TearOffPanel_State        0xfa34ffc0
#define MUIA_TearOffPanel_Contents     0xfa34ffc1
#define MUIA_TearOffPanel_Label        0xfa34ffc4
#define MUIA_TearOffPanel_Bay          0xfa34ffc3
#define MUIA_TearOffPanel_Horiz        0xfa34ffc5
#define MUIA_TearOffPanel_CanFlipShape 0xfa34ffc6
#define MUIA_TearOffPanel_WindowTags   0xfa34ffc8

#define MUIV_TearOffPanel_State_Fixed    0
#define MUIV_TearOffPanel_State_Torn     1
#define MUIV_TearOffPanel_State_Hidden   2
#define MUIV_TearOffPanel_State_Cycle    999

#endif

