#ifndef GIFANIM_MCC_H
#define GIFANIM_MCC_H

/*
**  $VER: GIFAnim_mcc.h 19.5 (3.6.2005)
**  Includes Release 19.5
**
**  Written by Alfonso [alfie] Ranieri <alforan@tin.it>
**  All rights reserved
*/

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

#if defined(__GNUC__)
# pragma pack(2)
#endif

/***********************************************************************/

#define MUIC_GIFAnim  "GIFAnim.mcc"
#define GIFAnimObject MUI_NewObject(MUIC_GIFAnim

/***********************************************************************/
/*
** Methods
*/

#define MUIM_GIFAnim_Play        0xFEC90116
#define MUIM_GIFAnim_Next        0xFEC90117
#define MUIM_GIFAnim_Pred        0xFEC90118
#define MUIM_GIFAnim_First       0xFEC90119
#define MUIM_GIFAnim_Last        0xFEC9011A

struct MUIP_GIFAnim_Play
{
    ULONG MethodID;
    ULONG flags;
};

enum
{
    MUIV_GIFAnim_Play_Off    = 0<<0,
    MUIV_GIFAnim_Play_On     = 1<<0,
    MUIV_GIFAnim_Play_Rewind = MUIV_GIFAnim_Play_On|(1<<1),
    MUIV_GIFAnim_Play_Once   = MUIV_GIFAnim_Play_On|(1<<2),
};

/***********************************************************************/
/*
** Attributes
*/

#define MUIA_GIFAnim_File        0xFEC90116 /*  STRPTR, [I...] */
#define MUIA_GIFAnim_Anim        0xFEC90117 /*  ULONG,  [I.G.] */
#define MUIA_GIFAnim_Decoded     0xFEC90118 /*  ULONG,  [..GN] */
#define MUIA_GIFAnim_Fallback    0xFEC90119 /*  BOOL,   [I...] */
#define MUIA_GIFAnim_Transparent 0xFEC9011A /*  BOOL,   [IS..] */
#define MUIA_GIFAnim_Pics        0xFEC9011B /*  ULONG,  [..G.] */
#define MUIA_GIFAnim_Current     0xFEC9011C /*  ULONG,  [ISGN] */
#define MUIA_GIFAnim_Invalid     0xFEC9011E /*  BOOL,   [..GN] */
#define MUIA_GIFAnim_Sync        0xFEC90120 /*  BOOL,   [I...] */
#define MUIA_GIFAnim_Data        0xFEC90121 /*  ULONG,  [I...] */
#define MUIA_GIFAnim_DataSize    0xFEC90122 /*  ULONG,  [I...] */
#define MUIA_GIFAnim_Scale       0xFEC90123 /*  ULONG,  [I...] */
#define MUIA_GIFAnim_Precision   0xFEC90124 /*  ULONG,  [I...] */

/***********************************************************************/

#if defined(__GNUC__)
# pragma pack()
#endif

#endif /* GIFANIM_MCC_H */
