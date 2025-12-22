


/*** Include stuff ***/

#ifndef FILTER_MCC_H
#define FILTER_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif


/*** MUI Defines ***/

#define MUIC_Filter "filter.mcc"
#define FilterObject MUI_NewObject(MUIC_Filter


/*** Method structs ***/

struct MUIP_FILTER_String { ULONG MessageID; STRPTR String; };
struct MUIP_FILTER_Number { ULONG MessageID; ULONG Number; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6


#define MUIA_FILTER_PATH MUISERIALNO_CARSTEN + 250
#define MUIA_FILTER_ED MUISERIALNO_CARSTEN + 251
#define MUIA_FILTER_WIDTH MUISERIALNO_CARSTEN + 252
#define MUIA_FILTER_HEIGHT MUISERIALNO_CARSTEN + 253

#define MUIM_FILTER_OPEN_PIC MUISERIALNO_CARSTEN + 254
#define MUIM_FILTER_OPEN_PATH MUISERIALNO_CARSTEN + 255
#define MUIM_FILTER_SET_FILTER MUISERIALNO_CARSTEN + 256
#define MUIM_FILTER_SET_VALUE MUISERIALNO_CARSTEN + 257
#define MUIM_FILTER_SAVE_PIC MUISERIALNO_CARSTEN + 258

#define MUIA_FILTER_SAVEWINDOW MUISERIALNO_CARSTEN + 259













#endif /* FILTER_MCC_H */


