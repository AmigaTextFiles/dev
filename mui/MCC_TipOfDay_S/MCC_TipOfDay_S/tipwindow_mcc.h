
/*
** $Id: tipwindow_mcc.h,v 1.5 2000/06/29 22:41:48 carlos Exp $
*/


/*** Include stuff ***/


#ifndef TIPOFTHEDAY_MCC_H
#define TIPOFTHEDAY_MCC_H

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif


/*** MUI Defines ***/

#define MUIC_Tipwindow       "Tipwindow.mcc"
#define MUIC_TipwindowP      "Tipwindow.mcp"
#define TipwindowObject      MUI_NewObject( MUIC_Tipwindow

#ifndef CARLOS_MUI
#define MUISERIALNR_CARLOS 2447
#define TAGBASE_CARLOS (TAG_USER | ( MUISERIALNR_CARLOS << 16))
#define CARLOS_MUI
#endif

#define TBTOD TAGBASE_CARLOS + 0x100


/*** Methods ***/

#define MUIM_Tip_Show       (TBTOD + 0x0000)
#define MUIM_Tip_GoHomePage (TBTOD + 0x0001)


/*** Method structs ***/


/*** Special method values ***/


/*** Special method flags ***/


/*** Attributes ***/

#define MUIA_Tip_FileBase     (TBTOD + 0x0010)    /* v15 {ISG} STRPTR   */
#define MUIA_Tip_WindowObject (TBTOD + 0x0011)    /* v15 {..G} APTR     */
#define MUIA_Tip_BulbObject   (TBTOD + 0x0012)    /* v15 {I..} APTR     */


/*** Special attribute values ***/

#define MUIV_Tip_Show_Startup  0
#define MUIV_Tip_Show_Next     1
#define MUIV_Tip_Show_Prev     2
#define MUIV_Tip_Show_Random   3

/*** Structures, Flags & Values ***/

struct MUIP_Tip_Show       { ULONG MethodID; ULONG Flags; };


/*** Configs ***/



/*** Other things ***/


#endif /* TIPOFTHEDAY_MCC_H */

