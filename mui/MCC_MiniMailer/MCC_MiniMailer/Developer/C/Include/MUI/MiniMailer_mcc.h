#ifndef MINIMAILER_H
#define MINIMAILER_H

/*
**  $VER: MiniMailer.h 20.1 (28.7.2005)
**  Includes Release 20.1
**
**  (C) Copyright 2004-2005 Alfonso [alfie] Ranieri <alforan@tin.it>
**      All rights reserved
*/

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

#if defined(__GNUC__)
# pragma pack(2)
#endif

/***********************************************************************/

#define MUIC_MiniMailer "MiniMailer.mcc"
#define MiniMailerObject MUI_NewObject(MUIC_MiniMailer

#define MMBASE_TAG(n) ((int)(0xFEC901C4+(n)))

/***********************************************************************/
/*
** Methos
**/

#define MUIM_MiniMailer_Send           MMBASE_TAG(0)  /* v15 Msg *                                  */
#define MUIM_MiniMailer_Stop           MMBASE_TAG(1)  /* v15 Msg *                                  */
#define MUIM_MiniMailer_LoadPrefs      MMBASE_TAG(2)  /* v15 struct MUIP_MiniMailer_LoadPrefs *     */
#define MUIM_MiniMailer_SavePrefs      MMBASE_TAG(3)  /* v15 struct MUIP_MiniMailer_SavePrefs *     */
#define MUIM_MiniMailer_Status         MMBASE_TAG(4)  /* v15 struct MUIP_MiniMailer_Status *        */
#define MUIM_MiniMailer_Clear          MMBASE_TAG(5)  /* v15 Msg *                                  */
#define MUIM_MiniMailer_Translate      MMBASE_TAG(6)  /* v16 struct MUIP_MiniMailer_Translate *     */
#define MUIM_MiniMailer_FreeTranslated MMBASE_TAG(7)  /* v16 struct MUIP_MiniMailer_FreeTranslate * */
#define MUIM_MiniMailer_ClearAttaches  MMBASE_TAG(9)  /* v20 Msg *                                  */
#define MUIM_MiniMailer_AddAttach      MMBASE_TAG(10) /* v20 struct MUIP_MiniMailer_AddAttach *     */

/***********************************************************************/
/*
** Methos structures
**/

struct MUIP_MiniMailer_LoadPrefs
{
    ULONG  MethodID;
    STRPTR file;
};

struct MUIP_MiniMailer_SavePrefs
{
    ULONG  MethodID;
    STRPTR file;
};

struct MUIP_MiniMailer_Status
{
    ULONG MethodID;
    ULONG status;
    ULONG err;
};

enum
{
    MUIV_MiniMailer_Resolving,
    MUIV_MiniMailer_Connecting,
    MUIV_MiniMailer_Sending,
    MUIV_MiniMailer_Done,
};

struct MUIP_MiniMailer_Translate
{
    ULONG  MethodID;
    STRPTR text;
    STRPTR codesetName;
    ULONG  codesetNameLen;
    ULONG  flags;
};

struct MUIP_MiniMailer_FreeTranslate
{
    ULONG  MethodID;
    STRPTR text;
};

struct MUIP_MiniMailer_AddAttach
{
    ULONG  MethodID;
    STRPTR file;
};

/***********************************************************************/
/*
** Attributes
*/

#define MUIA_MiniMailer_MinVer             MMBASE_TAG(0)  /* v15 [I...] ULONG            */
#define MUIA_MiniMailer_Host               MMBASE_TAG(1)  /* v15 [ISG.] STRPTR           */
#define MUIA_MiniMailer_HostPort           MMBASE_TAG(2)  /* v15 [ISG.] STRPTR           */
#define MUIA_MiniMailer_EMail              MMBASE_TAG(3)  /* v15 [ISG.] STRPTR           */
#define MUIA_MiniMailer_RealName           MMBASE_TAG(4)  /* v15 [ISG.] STRPTR           */
#define MUIA_MiniMailer_To                 MMBASE_TAG(5)  /* v15 [ISG.] STRPTR           */
#define MUIA_MiniMailer_Subject            MMBASE_TAG(6)  /* v15 [ISG.] STRPTR           */
#define MUIA_MiniMailer_Text               MMBASE_TAG(7)  /* v15 [ISG.] STRPTR           */
#define MUIA_MiniMailer_ShowPrefs          MMBASE_TAG(8)  /* v15 [ISGN] BOOL             */
#define MUIA_MiniMailer_TranslateHook      MMBASE_TAG(9)  /* v16 [ISG.] struct Hook *    */
#define MUIA_MiniMailer_FreeTranslatedHook MMBASE_TAG(10) /* v16 [ISG.] struct Hook *    */
#define MUIA_MiniMailer_TranslateObj       MMBASE_TAG(11) /* v17 [IS..] Object *         */
#define MUIA_MiniMailer_Attaches  	       MMBASE_TAG(12) /* v20 [..G.] struct MinList * */

/***********************************************************************/
/*
** Structures
*/

struct MUIS_MiniMailer_Translate
{
    STRPTR text;
    STRPTR codesetName;
    ULONG  codesetNameLen;
    ULONG  flags;
};

struct MUIS_MiniMailer_Attach
{
    struct MinNode link;
    STRPTR	       file;
};

/***********************************************************************/

#if defined(__GNUC__)
# pragma pack()
#endif

#endif /* MINIMAILER_H */
