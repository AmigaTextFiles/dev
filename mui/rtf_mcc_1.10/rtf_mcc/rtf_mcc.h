


/*** Include stuff ***/

#ifndef RTF_MCC_H
#define RTF_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif


/*** MUI Defines ***/

#define MUIC_Rtf "rtf.mcc"
#define RtfObject MUI_NewObject(MUIC_Rtf


/*** Method structs ***/

struct MUIP_RTF_String { ULONG MessageID; STRPTR String; };
struct MUIP_RTF_Number { ULONG MessageID; ULONG Number; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6


#define MUIA_RTF_PATH MUISERIALNO_CARSTEN + 190
#define MUIA_RTF_ED MUISERIALNO_CARSTEN + 191
#define MUIA_RTF_WIDTH MUISERIALNO_CARSTEN + 192
#define MUIA_RTF_HEIGHT MUISERIALNO_CARSTEN + 193
#define MUIA_RTF_SIZE_NR MUISERIALNO_CARSTEN + 194

#define MUIM_RTF_SAVE_PIC MUISERIALNO_CARSTEN + 195

#define MUIA_RTF_TITLE MUISERIALNO_CARSTEN + 196
#define MUIA_RTF_SUBJECT MUISERIALNO_CARSTEN + 197
#define MUIA_RTF_AUTHOR MUISERIALNO_CARSTEN + 198

#define MUIM_RTF_UPDATE_WINDOW MUISERIALNO_CARSTEN + 199












#endif /* RTF_MCC_H */


