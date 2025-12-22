
/*
** $Id: tipboard_mcc.h,v 1.3 1999/11/13 22:55:19 carlos Exp $
*/


/*** Include stuff ***/


#ifndef TIPBOARD_MCC_H
#define TIPBOARD_MCC_H

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif


/*** MUI Defines ***/

#define MUIC_Tipboard   "Tipboard.mcc"
#define MUIC_Tipboardp  "Tipboard.mcp"
#define TipboardObject  MUI_NewObject( MUIC_Tipboard

#ifndef CARLOS_MUI
#define MUISERIALNR_CARLOS 2447
#define TAGBASE_CARLOS (TAG_USER | ( MUISERIALNR_CARLOS << 16))
#define CARLOS_MUI
#endif

#define TBTODB TAGBASE_CARLOS + 0x120


/*** Methods ***/

#define MUIM_Tipb_InitTipsFile    (TBTODB + 0x0000)       /* PRIVATE */
#define MUIM_Tipb_LoadTipcData    (TBTODB + 0x0001)       /* PRIVATE */
#define MUIM_Tipb_SaveTipcData    (TBTODB + 0x0002)       /* PRIVATE */
#define MUIM_Tipb_Show            (TBTODB + 0x0003)       /* PRIVATE */
#define MUIM_Tipb_ReadTip         (TBTODB + 0x0004)       /* PRIVATE */
#define MUIM_Tipb_GetDefFileBase  (TBTODB + 0x0005)       /* PRIVATE */

/*** Method structs ***/


/*** Special method values ***/


/*** Special method flags ***/


/*** Attributes ***/


#define MUIA_Tipb_FileBase       (TBTODB + 0x0010)    /* v15 {ISG} PRIVATE */
#define MUIA_Tipb_ShowOnStartup  (TBTODB + 0x0011)    /* v15 (ISG) PRIVATE */


/*** Special attribute values ***/

#define MUIV_Tipb_Show_Startup  0
#define MUIV_Tipb_Show_Next     1
#define MUIV_Tipb_Show_Prev     2
#define MUIV_Tipb_Show_Random   3


/*** Structures, Flags & Values ***/

struct MUIP_Tipb_Show       { ULONG MethodID; ULONG Flags; };



/*** Configs ***/



/*** Other things ***/

#define ID_VERS    MAKE_ID('V','E','R','S')
#define ID_TIPS    MAKE_ID('T','I','P','S')     // Tips file
#define ID_MAX     MAKE_ID('M','A','X',' ')     // Total #of tips in file
#define ID_LAST    MAKE_ID('L','A','S','T')     // last shown tip
#define ID_SHOW    MAKE_ID('S','H','O','W')     // show on startup

#define TIP_LEN 512


struct BaseVersion
{
  UWORD Version;
  UWORD Revision;
};



#endif /* TIPBOARD_MCC_H */

