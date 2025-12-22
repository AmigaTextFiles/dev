OPT MODULE
OPT PREPROCESS
OPT EXPORT
/*
**  $VER: freedb.h 10.2 (27.6.2004)
**  Includes Release 10.2
**
**  Written by Alfonso [alfie] Ranieri <alforan@tin.it>.
**
**  Released under the terms of the
**  GNU Public Licence version 2.
*/

MODULE 'exec/types', 'exec/ports', 'exec/memory', 'exec/semaphores'
MODULE 'dos/dosextens'
MODULE 'utility/tagitem'
MODULE 'utility/hooks'
MODULE 'devices/cd'
MODULE 'devices/scsidisk'

/***********************************************************************/

#define FreeDBName      'freedb.library'
#define FreeDBVersion   9
#define GUIAPI_VERSION  6

/***********************************************************************/
/* Note
** FREEDBS_XXX FreeDB structure
** FREEDBV_XXX FreeDB value
** FREEDBM_XXX FreeDB macro
*/

/***********************************************************************/
/*
** Tags
*/

->#define FREEDBLIB_TAG(n) ((int)(0xFEC901F4+(n)))

CONST FREEDBA_Base                =$FEC901F4+0
CONST FREEDBA_Pool                =$FEC901F4+0
CONST FREEDBA_ErrorPtr            =$FEC901F4+1
CONST FREEDBA_TOC                 =$FEC901F4+2
CONST FREEDBA_TOCPtr              =$FEC901F4+3
CONST FREEDBA_DiscInfo            =$FEC901F4+4
CONST FREEDBA_FriendDiscInfo      =$FEC901F4+5
CONST FREEDBA_Categ               =$FEC901F4+6
CONST FREEDBA_DiscID              =$FEC901F4+7
CONST FREEDBA_Device              =$FEC901F4+8
CONST FREEDBA_Unit                =$FEC901F4+9
CONST FREEDBA_DeviceName          =$FEC901F4+10
CONST FREEDBA_Lun                 =$FEC901F4+11
CONST FREEDBA_UseTOCID            =$FEC901F4+12
CONST FREEDBA_OrigHeader          =$FEC901F4+13
CONST FREEDBA_OverWrite           =$FEC901F4+14
CONST FREEDBA_Prg                 =$FEC901F4+15
CONST FREEDBA_Ver                 =$FEC901F4+16
CONST FREEDBA_StatusHook          =$FEC901F4+17
CONST FREEDBA_MultiHook           =$FEC901F4+18
CONST FREEDBA_SitesHook           =$FEC901F4+19
CONST FREEDBA_LsCatHook           =$FEC901F4+20
CONST FREEDBA_Handle              =$FEC901F4+21
CONST FREEDBA_HandlePtr           =$FEC901F4+22
CONST FREEDBA_Mode                =$FEC901F4+23
CONST FREEDBA_Title               =$FEC901F4+24
CONST FREEDBA_Titles              =$FEC901F4+25
CONST FREEDBA_Tracks              =$FEC901F4+26
CONST FREEDBA_Year                =$FEC901F4+27
CONST FREEDBA_Genre               =$FEC901F4+28
CONST FREEDBA_Artist              =$FEC901F4+29
CONST FREEDBA_Extd                =$FEC901F4+30
CONST FREEDBA_PlayOrder           =$FEC901F4+31
CONST FREEDBA_Revision            =$FEC901F4+32
CONST FREEDBA_NoRequester         =$FEC901F4+33
CONST FREEDBA_BumpRev             =$FEC901F4+34
CONST FREEDBA_ErrorBuffer         =$FEC901F4+35
CONST FREEDBA_ErrorBufferLen      =$FEC901F4+36
CONST FREEDBA_Addr                =$FEC901F4+37
CONST FREEDBA_Len                 =$FEC901F4+38
CONST FREEDBA_Play10              =$FEC901F4+39
CONST FREEDBA_GD                  =$FEC901F4+40
CONST FREEDBA_GetDisc             =$FEC901F4+41
CONST FREEDBA_AutoSave            =$FEC901F4+42
CONST FREEDBA_QuickMatch          =$FEC901F4+43
CONST FREEDBA_UTF8                =$FEC901F4+44
CONST FREEDBA_Artists             =$FEC901F4+45
CONST FREEDBA_Key                 =$FEC901F4+46

/***********************************************************************/
/*
** scsi proto 2 stuff
**/

CONST FREEDBV_TOCSIZE=804, FREEDBV_MAXTRACKS=100

OBJECT freedbs_track
      track
      startAddr
      endAddr
      frames
      startMin
      startSec
      startFrame
      endMin
      endSec
      endFrame
      min
      sec
      frame
      flags
ENDOBJECT ->58

CONST FREEDBV_Track_Flags_Audio         = 1,
      FREEDBV_Track_Flags_ADR           = 2,
      FREEDBV_Track_Flags_CopyPerm      = 3,
      FREEDBV_Track_Flags_PreEmp        = 8,
      FREEDBV_Track_Flags_FourChannels  = 16,
      FREEDBV_Track_Flags_UserFlagsMask = $FF

OBJECT freedbs_toc
     numTracks
     firstTrack
     lastTrack
     startAddress
     endAddress
     frames
     min
     sec
     frame
     discID
     mediumType
     flags
     tracks[FREEDBV_MAXTRACKS]:ARRAY OF freedbs_track
ENDOBJECT

CONST FREEDBV_TOC_Flags_UserFlagsMask = $FF

ENUM FREEDBV_TOC_MediumType_Data,
     FREEDBV_TOC_MediumType_Audio,
     FREEDBV_TOC_MediumType_AudioData

/***********************************************************************/
/*
** FREEDBS_DiscInfo
*/

OBJECT freedbs_trackinfo
  title[256]:ARRAY OF CHAR
  artist[256]:ARRAY OF CHAR
  extd:/*STRPTR*/ ARRAY OF CHAR
  startAddr
  flags
ENDOBJECT

CONST FREEDBV_TrackInfo_Flags_Artist = 1

OBJECT ptr_to_freedbs_trackinfo
 pt:PTR TO freedbs_trackinfo
ENDOBJECT

OBJECT freedbs_discinfo
    discID
    discIDString[16]:ARRAY OF CHAR
    numTracks
    discTime
    header:/*STRPTR*/ ARRAY OF CHAR
    revision
    year
    categ[256]:ARRAY OF CHAR
    genre[256]:ARRAY OF CHAR
    title[256]:ARRAY OF CHAR
    artist[256]:ARRAY OF CHAR
    extd:/*STRPTR*/ ARRAY OF CHAR
    playOrder[256]:ARRAY OF CHAR
    tracks[FREEDBV_MAXTRACKS]:ARRAY OF ptr_to_freedbs_trackinfo ->PTR TO freedbs_trackinfo
    flags
ENDOBJECT

CONST FREEDBV_DiscInfo_Flags_Artist        = 1,
      FREEDBV_DiscInfo_Flags_MultiArtist   = 2,
      FREEDBV_DiscInfo_Flags_Offsets       = 4,
      FREEDBV_DiscInfo_Flags_NoSubmit      = 8,
      FREEDBV_DiscInfo_Flags_HeaderDone    = $200,
      FREEDBV_DiscInfo_Flags_DoingTracks   = $400,
      FREEDBV_DiscInfo_Flags_DoingTime     = $800

/***********************************************************************/
/*
**  FREEDBA_Mode
*/

ENUM FREEDBV_Mode_Normal, FREEDBV_Mode_Local, FREEDBV_Mode_Remote

/***********************************************************************/
/*
**  FREEDBA_Command
*/

ENUM FREEDBV_Command_QueryRead,
     FREEDBV_Command_Query,
     FREEDBV_Command_Read,
     FREEDBV_Command_Sites,
     FREEDBV_Command_LsCat,
     FREEDBV_Command_Submit

/***********************************************************************/
/*
** Hook messages
*/

OBJECT freedbs_multihookmessage
    link:mn
    size
    code
    categ[256]:ARRAY OF CHAR
    discID
    discIDString[16]:ARRAY OF CHAR
    artist[256]:ARRAY OF CHAR
    title[256]:ARRAY OF CHAR
ENDOBJECT

OBJECT freedbs_siteshookmessage
    link:mn
    size
    host[256]:ARRAY OF CHAR
    port:INT
    cgi[256]:ARRAY OF CHAR
    latitude[256]:ARRAY OF CHAR
    longitude[256]:ARRAY OF CHAR
    description[256]:ARRAY OF CHAR
ENDOBJECT

OBJECT freedbs_lscathookmessage
    link:mn
    size
    categ[256]:ARRAY OF CHAR
ENDOBJECT

/***********************************************************************/
/*
** FREEDBGetDiscA() results
*/

ENUM FREEDBV_GetDisc_LocalFound,
     FREEDBV_GetDisc_LocalMulti,
     FREEDBV_GetDisc_Remote,
     FREEDBV_GetDisc_Error

/***********************************************************************/
/*
** FREEDBAllocObject
*/

OBJECT freedbs_object
    pool
    type
    size
    flags
    mem[1]:ARRAY OF CHAR
ENDOBJECT

ENUM FREEDBV_AllocObject_TOC,
     FREEDBV_AllocObject_DiscInfo,
     FREEDBV_AllocObject_DiscInfoTOC,
     FREEDBV_AllocObject_Config,
     FREEDBV_AllocObject_Site

#define FREEDBM_OBJ(m) (((m)-SIZEOF freedbs_object)+SIZEOF char[0])
#define FREEDBM_GETTOCFROMDI(di) (di+SIZEOF freedbs_discinfo)

/***********************************************************************/
/*
** Config
**/

OBJECT freedbs_site
    link:mn
    host[128]:ARRAY OF CHAR
    port:INT
    cgi[128]:ARRAY OF CHAR
    latitude[16]:ARRAY OF CHAR
    longitude[16]:ARRAY OF CHAR
    description[64]:ARRAY OF CHAR
    flags
ENDOBJECT

CONST FREEDBV_Site_Flags_Active = 1

OBJECT freedbs_config
    version
    sites:ml
    defaultSite:PTR TO freedbs_site
    activeSite:PTR TO freedbs_site
    proxy[128]:ARRAY OF CHAR
    proxyPort:INT
    useProxy:CHAR
    rootDir[256]:ARRAY OF CHAR
    user[64]:ARRAY OF CHAR
    email[256]:ARRAY OF CHAR
    gui[256]:ARRAY OF CHAR
    flags
    codesetsList:ml
    charset[256]:ARRAY OF CHAR
    current:ARRAY OF CHAR ->codeset
ENDOBJECT

CONST FREEDBV_Config_Flags_NoUser = 1, FREEDBV_Config_Version = 10

#define FREEDBV_Config_Default 'FreeDB:Default.FreeDB'

/***********************************************************************/
/*
** Errors and strings
**/

ENUM FREEDBV_Err_NoMem = 1001,
     FREEDBV_Err_NoParms,
     FREEDBV_Err_BadNumber,
     FREEDBV_Err_BadValue,
     FREEDBV_Err_Unknown,
     FREEDBV_Err_NoDevice,
     FREEDBV_Err_NoOpenDevice,
     FREEDBV_Err_NotCD,
     FREEDBV_Err_NoMedium,
     FREEDBV_Err_NoTOC,
     FREEDBV_Err_BadTOC,
     FREEDBV_Err_NoRootDir,
     FREEDBV_Err_NotFound,
     FREEDBV_Err_NoSocketBase,
     FREEDBV_Err_NoSocket,
     FREEDBV_Err_NoHost,
     FREEDBV_Err_NoProxy,
     FREEDBV_Err_CantConnect,
     FREEDBV_Err_Send,
     FREEDBV_Err_Recv,
     FREEDBV_Err_LinkClosed,
     FREEDBV_Err_ServerHTTPError,
     FREEDBV_Err_Aborted,
     FREEDBV_Err_ServerError,
     FREEDBV_Err_Multi,
     FREEDBV_Err_CantSave,
     FREEDBV_Err_FileExists,
     FREEDBV_Err_BadFormat,
     FREEDBV_Err_CantPlay,
     FREEDBV_Err_NoEmail,

     FREEDBV_Handle_Status_Base = 1500,
     FREEDBV_Handle_Status_ResolvingHost,
     FREEDBV_Handle_Status_Connecting,
     FREEDBV_Handle_Status_Sending,
     FREEDBV_Handle_Status_Receiving,
     FREEDBV_Handle_Status_Done,
     FREEDBV_Handle_Status_Error,

     FREEDBV_GUI_Failure = 2001

/***********************************************************************/
/*
** External GUI libraries - GetDisc Handle
*/

/* GetDisc Handle */
OBJECT freedbs_getdisc
    sem:ss
    stsem:ss
    proc:PTR TO process
    notiProc:PTR TO process
    notiSig:INT
    di:PTR TO freedbs_discinfo
    toc:PTR TO freedbs_toc
    status
    err
    flags
ENDOBJECT

ENUM FREEDBV_GUIGetDisc_Flags_Done   = 1,
     FREEDBV_GUIGetDisc_Flags_Found  = 2,
     FREEDBV_GUIGetDisc_Flags_Remote = 4

/* Attrs */
ENUM FREEDBV_GUIGetDisc_Signal,
     FREEDBV_GUIGetDisc_Done,
     FREEDBV_GUIGetDisc_Found,
     FREEDBV_GUIGetDisc_Remote,
     FREEDBV_GUIGetDisc_Error

/* Commands */
ENUM FREEDBV_GUIGetDiscCmd_Start,
     FREEDBV_GUIGetDiscCmd_Break

