OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'libraries/mui'

->MODULE 'exec/types'

->#ifndef TEAROFFPANEL_MCC_H
->#define TEAROFFPANEL_MCC_H

->#ifndef LIBRARIES_MUI_H
->#include "libraries/mui.h"
->#endif

#define MUIC_TearOffPanel 'TearOffPanel.mcc'
#define TearOffPanelObject Mui_NewObjectA(MUIC_TearOffPanel,[TAG_IGNORE,0

CONST MUIA_TearOffPanel_State       =$fa34ffc0
CONST MUIA_TearOffPanel_Contents    =$fa34ffc1
CONST MUIA_TearOffPanel_Label       =$fa34ffc4
CONST MUIA_TearOffPanel_Bay         =$fa34ffc3
CONST MUIA_TearOffPanel_Horiz       =$fa34ffc5
CONST MUIA_TearOffPanel_CanFlipShape=$fa34ffc6
CONST MUIA_TearOffPanel_WindowTags  =$fa34ffc8

CONST MUIV_TearOffPanel_State_Fixed =  0
CONST MUIV_TearOffPanel_State_Torn  =  1
CONST MUIV_TearOffPanel_State_Hidden=  2
CONST MUIV_TearOffPanel_State_Cycle =  999

->#endif

