


/*** Include stuff ***/

#ifndef XCF_MCC_H
#define XCF_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif


/*** MUI Defines ***/

#define MUIC_Xcf "xcf.mcc"
#define XcfObject MUI_NewObject(MUIC_Xcf


/*** Method structs ***/

struct MUIP_XCF_String { ULONG MessageID; STRPTR String; };
struct MUIP_XCF_Number { ULONG MessageID; ULONG Number; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6


#define MUIA_XCF_PATH MUISERIALNO_CARSTEN + 280
#define MUIA_XCF_ED MUISERIALNO_CARSTEN + 281
#define MUIA_XCF_WIDTH MUISERIALNO_CARSTEN + 282
#define MUIA_XCF_HEIGHT MUISERIALNO_CARSTEN + 283
#define MUIA_XCF_SIZE_NR MUISERIALNO_CARSTEN + 284














#endif /* XCF_MCC_H */


