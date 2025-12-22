OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'libraries/mui'

->#ifndef TEAROFFBAY_MCC_H
->#define TEAROFFBAY_MCC_H

->#ifndef LIBRARIES_MUI_H
->#include "libraries/mui.h"
->#endif

#define MUIC_TearOffBay 'TearOffBay.mcc'
#define TearOffBayObject Mui_NewObjectA(MUIC_TearOffBay,[TAG_IGNORE,0

CONST MUIA_TearOffBay_LinkedBay =$fa34ffd0
CONST MUIA_TearOffBay_PrimaryBay=$fa34ffd1
CONST MUIA_TearOffBay_Horiz     =$fa34ffd2

->#endif

