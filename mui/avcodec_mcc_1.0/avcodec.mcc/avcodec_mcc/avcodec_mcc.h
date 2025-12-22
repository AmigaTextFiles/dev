


/*** Include stuff ***/

#ifndef AVCODEC_MCC_H
#define AVCODEC_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif

#include <proto/cairo.h>

/*** MUI Defines ***/

#define MUIC_Avcodec "avcodec.mcc"
#define AvcodecObject MUI_NewObject(MUIC_Avcodec


/*** Method structs ***/

struct MUIP_AVCODEC_String { ULONG MessageID; STRPTR String; };
struct MUIP_AVCODEC_Number { ULONG MessageID; ULONG Number; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6





/*** Attributes ***/
#define MUIA_AVCODEC_PATH MUISERIALNO_CARSTEN
#define MUIM_AVCODEC_START MUISERIALNO_CARSTEN + 1
#define MUIM_AVCODEC_STOP MUISERIALNO_CARSTEN + 2
#define MUIM_AVCODEC_DRAW MUISERIALNO_CARSTEN + 3












#endif /* AVCODEC_MCC_H */


