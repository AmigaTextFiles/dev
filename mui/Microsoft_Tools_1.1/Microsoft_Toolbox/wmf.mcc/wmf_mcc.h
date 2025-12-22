


/*** Include stuff ***/

#ifndef WMF_MCC_H
#define WMF_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif


/*** MUI Defines ***/

#define MUIC_Wmf "wmf.mcc"
#define WmfObject MUI_NewObject(MUIC_Wmf


/*** Method structs ***/

struct MUIP_WMF_String { ULONG MessageID; STRPTR String; };
struct MUIP_WMF_Number { ULONG MessageID; ULONG Number; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6


#define MUIA_WMF_PATH MUISERIALNO_CARSTEN + 70
#define MUIA_WMF_ED MUISERIALNO_CARSTEN + 71
#define MUIA_WMF_WIDTH MUISERIALNO_CARSTEN + 72
#define MUIA_WMF_HEIGHT MUISERIALNO_CARSTEN + 73














#endif /* WMF_MCC_H */


