


/*** Include stuff ***/

#ifndef PCD_MCC_H
#define PCD_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif


/*** MUI Defines ***/

#define MUIC_Pcd "pcd.mcc"
#define PcdObject MUI_NewObject(MUIC_Pcd


/*** Method structs ***/

struct MUIP_PCD_String { ULONG MessageID; STRPTR String; };
struct MUIP_PCD_Number { ULONG MessageID; ULONG Number; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6


#define MUIA_PCD_PATH MUISERIALNO_CARSTEN + 270
#define MUIA_PCD_ED MUISERIALNO_CARSTEN + 271
#define MUIA_PCD_WIDTH MUISERIALNO_CARSTEN + 272
#define MUIA_PCD_HEIGHT MUISERIALNO_CARSTEN + 273
#define MUIA_PCD_SIZE_NR MUISERIALNO_CARSTEN + 274














#endif /* PCD_MCC_H */


