


/*** Include stuff ***/

#ifndef REGGAE_MCC_H
#define REGGAE_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif


/*** MUI Defines ***/

#define MUIC_Reggae "Reggae.mcc"
#define ReggaeObject MUI_NewObject(MUIC_Reggae


/*** Method structs ***/

struct MUIP_REGGAE_String { ULONG MessageID; STRPTR String; };
struct MUIP_REGGAE_Number { ULONG MessageID; ULONG Number; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6


enum {
TAG_DUMMY = ( MUISERIALNO_CARSTEN << 16 ) | 0x0100,





/*** Attributes ***/
MUIA_REGGAE_PATH,








};



#endif /* REGGAE_MCC_H */


