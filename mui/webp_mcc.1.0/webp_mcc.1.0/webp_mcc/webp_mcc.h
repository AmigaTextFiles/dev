


/*** Include stuff ***/

#ifndef WEBP_MCC_H
#define WEBP_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif


/*** MUI Defines ***/

#define MUIC_Webp "Webp.mcc"
#define WebpObject MUI_NewObject(MUIC_Webp


/*** Method structs ***/

struct MUIP_WEBP_String { ULONG MessageID; STRPTR String; };
struct MUIP_WEBP_Number { ULONG MessageID; ULONG Number; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6
enum {
TAG_DUMMY = ( MUISERIALNO_CARSTEN << 16 ) | 0x0100,





MUIM_WEBP_DISPLAY_UPDATE,


/*** Attributes ***/
MUIA_WEBP_PATH,
MUIA_WEBP_WIDTH,
MUIA_WEBP_HEIGHT,
MUIA_WEBP_BACKGROUNG_COLOR,





};









#endif /* WEBP_MCC_H */


