


/*** Include stuff ***/

#ifndef WMF_MCC_H
#define WMF_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif

#include <proto/cairo.h>

/*** MUI Defines ***/

#define MUIC_Wmf "Wmf.mcc"
#define WmfObject MUI_NewObject(MUIC_Wmf


/*** Method structs ***/

struct MUIP_WMF_String { ULONG MessageID; STRPTR String; };
struct MUIP_WMF_Number { ULONG MessageID; ULONG Number; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6


enum {
TAG_DUMMY = ( MUISERIALNO_CARSTEN << 16 ) | 0x0100,





/*** Attributes ***/
MUIA_WMF_PATH,








};



#endif /* WMF_MCC_H */


