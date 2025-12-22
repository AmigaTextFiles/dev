/* $VER: application.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/devices/timer', 'target/dos/dos'
MODULE 'utility/tagitem', 'workbench/workbench', 'exec/types', 'exec/nodes', 'exec/ports'
{#include <libraries/application.h>}
NATIVE {LIBRARIES_APPLICATION_H} CONST

/******************************************************************************/
/* *************************** application tags ***************************** */
/******************************************************************************/

NATIVE {PrefsObject} CONST
TYPE PREFSOBJECT IS NATIVE {PrefsObject} VALUE


/**** iconType in struct ApplicationIconInfo ****/
NATIVE {enAppIconTypes} DEF
NATIVE {APPICONT_None}        CONST APPICONT_NONE        = 0 -> no icon ("invisible" application)
NATIVE {APPICONT_ProgramIcon} CONST APPICONT_PROGRAMICON = 1 -> the application's .info is used
NATIVE {APPICONT_CustomIcon}  CONST APPICONT_CUSTOMICON  = 2 -> custom icon is used
NATIVE {APPICONT_Docky}       CONST APPICONT_DOCKY       = 3  -> application docky



/**** tags for RegisterApplication ****/
NATIVE {enRegisterApplicationTags} DEF
NATIVE {REGAPP_UniqueApplication}    CONST REGAPP_UNIQUEAPPLICATION    = TAG_USER +  1 -> BOOL (default: FALSE)
NATIVE {REGAPP_LoadPrefs}            CONST REGAPP_LOADPREFS            = TAG_USER + 10 -> BOOL (default: FALSE)
NATIVE {REGAPP_SavePrefs}            CONST REGAPP_SAVEPREFS            = TAG_USER + 11 -> BOOL (default: FALSE)
NATIVE {REGAPP_CustomPrefsFileName}  CONST REGAPP_CUSTOMPREFSFILENAME  = TAG_USER + 12 -> STRPTR (sets automatically REGAPP_UsesPrefs to TRUE)
NATIVE {REGAPP_ENVDir}               CONST REGAPP_ENVDIR               = TAG_USER + 13 -> STRPTR (default: NULL)
NATIVE {REGAPP_CustomPrefsBaseName}  CONST REGAPP_CUSTOMPREFSBASENAME  = TAG_USER + 14 -> STRPTR (sets automatically REGAPP_UsesPrefs to TRUE)
NATIVE {REGAPP_WBStartup}            CONST REGAPP_WBSTARTUP            = TAG_USER + 20 -> struct WBStartup *
NATIVE {REGAPP_FileLock}             CONST REGAPP_FILELOCK             = TAG_USER + 21 -> BPTR
NATIVE {REGAPP_FileName}             CONST REGAPP_FILENAME             = TAG_USER + 22 -> STRPTR
NATIVE {REGAPP_URLIdentifier}        CONST REGAPP_URLIDENTIFIER        = TAG_USER + 23 -> STRPTR
NATIVE {REGAPP_NoIcon}               CONST REGAPP_NOICON               = TAG_USER + 30 -> BOOL (default: FALSE)
NATIVE {REGAPP_Hidden}               CONST REGAPP_HIDDEN               = TAG_USER + 31 -> BOOL (default: FALSE)
NATIVE {REGAPP_AppIconInfo}          CONST REGAPP_APPICONINFO          = TAG_USER + 32 -> struct ApplicationIconInfo *  (default: APPICONT_ProgramIcon)
NATIVE {REGAPP_AppNotifications}     CONST REGAPP_APPNOTIFICATIONS     = TAG_USER + 33 -> BOOL (default: FALSE)
NATIVE {REGAPP_BlankerNotifications} CONST REGAPP_BLANKERNOTIFICATIONS = TAG_USER + 34 -> BOOL (default: FALSE)
NATIVE {REGAPP_IdenticalNameCounter} CONST REGAPP_IDENTICALNAMECOUNTER = TAG_USER + 35 -> BOOL (default: TRUE)
NATIVE {REGAPP_AllowsBlanker}        CONST REGAPP_ALLOWSBLANKER        = TAG_USER + 40 -> BOOL (default: TRUE)
NATIVE {REGAPP_NeedsGameMode}        CONST REGAPP_NEEDSGAMEMODE        = TAG_USER + 41 -> BOOL (default: FALSE)
NATIVE {REGAPP_HasPrefsWindow}       CONST REGAPP_HASPREFSWINDOW       = TAG_USER + 42 -> BOOL (default: FALSE)
NATIVE {REGAPP_HasIconifyFeature}    CONST REGAPP_HASICONIFYFEATURE    = TAG_USER + 43 -> BOOL (default: FALSE)
NATIVE {REGAPP_CanCreateNewDocs}     CONST REGAPP_CANCREATENEWDOCS     = TAG_USER + 44 -> BOOL (default: FALSE)
NATIVE {REGAPP_CanPrintDocs}         CONST REGAPP_CANPRINTDOCS         = TAG_USER + 45 -> BOOL (default: FALSE)

NATIVE {REGAPP_Description}          CONST REGAPP_DESCRIPTION          = TAG_USER + 50  -> STRPTR (V53.2)


/**** tags for UnregisterApplication ****/
NATIVE {enUnregisterApplicationTags} DEF
NATIVE {UNREGAPP_WaitForUnlock}      CONST UNREGAPP_WAITFORUNLOCK      = TAG_USER + 1  -> BOOL (default: TRUE)


/**** tags for FindApplication ****/
NATIVE {enFindApplicationTags} DEF
NATIVE {FINDAPP_Name}          CONST FINDAPP_NAME          = TAG_USER + 1 -> STRPTR
NATIVE {FINDAPP_FileName}      CONST FINDAPP_FILENAME      = TAG_USER + 2 -> STRPTR
NATIVE {FINDAPP_AppIdentifier} CONST FINDAPP_APPIDENTIFIER = TAG_USER + 3  -> STRPTR


/**** tags for SetApplicationAttrs & GetApplicationAttrs ****/
NATIVE {enApplicationAttrsTags} DEF
NATIVE {APPATTR_Port}                 CONST APPATTR_PORT                 = TAG_USER +  1 -> struct MsgPort * (get only)
NATIVE {APPATTR_FileName}             CONST APPATTR_FILENAME             = TAG_USER +  2 -> STRPTR           (get only)
NATIVE {APPATTR_Name}                 CONST APPATTR_NAME                 = TAG_USER +  3 -> STRPTR           (get only)
NATIVE {APPATTR_URLIdentifier}        CONST APPATTR_URLIDENTIFIER        = TAG_USER +  4 -> STRPTR           (get only)
NATIVE {APPATTR_AppIdentifier}        CONST APPATTR_APPIDENTIFIER        = TAG_USER +  5 -> STRPTR           (get only)
NATIVE {APPATTR_Hidden}               CONST APPATTR_HIDDEN               = TAG_USER +  6 -> BOOL
NATIVE {APPATTR_IconType}             CONST APPATTR_ICONTYPE             = TAG_USER +  7 -> struct ApplicationIconInfo *
NATIVE {APPATTR_UniqueApplication}    CONST APPATTR_UNIQUEAPPLICATION    = TAG_USER +  8 -> BOOL             (get only)
NATIVE {APPATTR_SavePrefs}            CONST APPATTR_SAVEPREFS            = TAG_USER +  9 -> BOOL
NATIVE {APPATTR_AppNotifications}     CONST APPATTR_APPNOTIFICATIONS     = TAG_USER + 10 -> BOOL
NATIVE {APPATTR_BlankerNotifications} CONST APPATTR_BLANKERNOTIFICATIONS = TAG_USER + 11 -> BOOL
NATIVE {APPATTR_MainPrefsDict}        CONST APPATTR_MAINPREFSDICT        = TAG_USER + 12 -> PrefsObject *
NATIVE {APPATTR_AllowsBlanker}        CONST APPATTR_ALLOWSBLANKER        = TAG_USER + 13 -> BOOL
NATIVE {APPATTR_NeedsGameMode}        CONST APPATTR_NEEDSGAMEMODE        = TAG_USER + 14 -> BOOL
NATIVE {APPATTR_AppIdentifierCounter} CONST APPATTR_APPIDENTIFIERCOUNTER = TAG_USER + 15 -> BOOL             (get only)
NATIVE {APPATTR_FlushPrefs}           CONST APPATTR_FLUSHPREFS           = TAG_USER + 16 -> NULL             (set only)
NATIVE {APPATTR_LastUsedDocsArray}    CONST APPATTR_LASTUSEDDOCSARRAY    = TAG_USER + 17 -> PrefsObject *    (get only, a copied array is returned -> release afterwards!)
NATIVE {APPATTR_ClearLastUsedDocs}    CONST APPATTR_CLEARLASTUSEDDOCS    = TAG_USER + 18 -> BOOL             (set only)
NATIVE {APPATTR_HasPrefsWindow}       CONST APPATTR_HASPREFSWINDOW       = TAG_USER + 19 -> BOOL
NATIVE {APPATTR_HasIconifyFeature}    CONST APPATTR_HASICONIFYFEATURE    = TAG_USER + 20 -> BOOL
NATIVE {APPATTR_CanCreateNewDocs}     CONST APPATTR_CANCREATENEWDOCS     = TAG_USER + 21 -> BOOL
NATIVE {APPATTR_CanPrintDocs}         CONST APPATTR_CANPRINTDOCS         = TAG_USER + 22 -> BOOL
NATIVE {APPATTR_AppOpenedDocument}    CONST APPATTR_APPOPENEDDOCUMENT    = TAG_USER + 50  -> STRPTR          (set only)

NATIVE {APPATTR_Description}          CONST APPATTR_DESCRIPTION          = TAG_USER + 60  -> STRPTR           (get only) (V53.2)


/**** tags for GetAppLibAttrs ****/
NATIVE {enAppLibAttrsTags} DEF
NATIVE {APPLIBATTR_LastUsedAppsArray}    CONST APPLIBATTR_LASTUSEDAPPSARRAY    = TAG_USER +  1 -> PrefsObject *  (get only, a copied array is returned -> release afterwards!)
NATIVE {APPLIBATTR_LastUsedAppsMaxCount} CONST APPLIBATTR_LASTUSEDAPPSMAXCOUNT = TAG_USER +  2 -> uint32
NATIVE {APPLIBATTR_ClearLastUsedApps}    CONST APPLIBATTR_CLEARLASTUSEDAPPS    = TAG_USER +  3 -> BOOL           (set only)
NATIVE {APPLIBATTR_LastUsedDocsArray}    CONST APPLIBATTR_LASTUSEDDOCSARRAY    = TAG_USER + 10 -> PrefsObject *  (get only, a copied array is returned -> release afterwards!)
NATIVE {APPLIBATTR_LastUsedDocsMaxCount} CONST APPLIBATTR_LASTUSEDDOCSMAXCOUNT = TAG_USER + 11 -> uint32
NATIVE {APPLIBATTR_ClearLastUsedDocs}    CONST APPLIBATTR_CLEARLASTUSEDDOCS    = TAG_USER + 12 -> BOOL           (set only)
NATIVE {APPLIBATTR_BlankerIsAllowed}     CONST APPLIBATTR_BLANKERISALLOWED     = TAG_USER + 50 -> BOOL           (get only)
NATIVE {APPLIBATTR_GameModeIsActive}     CONST APPLIBATTR_GAMEMODEISACTIVE     = TAG_USER + 51  -> BOOL           (get only)


/**** keys for last used applications/documents dictionary entries ****/
NATIVE {LUA_BASE_KEY}          CONST ->STATIC LUA_BASE_KEY          = 'LastUsedApplications'
NATIVE {LUA_OPENDATE_KEY}      CONST ->STATIC LUA_OPENDATE_KEY      = 'openDate'
NATIVE {LUA_APPIDENTIFIER_KEY} CONST ->STATIC LUA_APPIDENTIFIER_KEY = 'appIdentifier'
NATIVE {LUA_APPNAME_KEY}       CONST ->STATIC LUA_APPNAME_KEY       = 'appName'
NATIVE {LUA_APPPATH_KEY}       CONST ->STATIC LUA_APPPATH_KEY       = 'appPath'

NATIVE {LUD_BASE_KEY}          CONST ->STATIC LUD_BASE_KEY          = 'LastUsedDocuments'
NATIVE {LUD_OPENDATE_KEY}      CONST ->STATIC LUD_OPENDATE_KEY      = 'openDate'
NATIVE {LUD_DOCPATH_KEY}       CONST ->STATIC LUD_DOCPATH_KEY       = 'docPath'
NATIVE {LUD_APPIDENTIFIER_KEY} CONST ->STATIC LUD_APPIDENTIFIER_KEY = 'appIdentifier'
NATIVE {LUD_APPPATH_KEY}       CONST ->STATIC LUD_APPPATH_KEY       = 'appPath'

/******************************************************************************/
/* ************************** application structs *************************** */
/******************************************************************************/

NATIVE {ApplicationIconInfo} OBJECT applicationiconinfo
	{iconType}	icontype	:VALUE -> enum enAppIconType
	{info.customIcon}	customicon	:PTR TO diskobject -> for APPICONT_CustomIcon
	{info.dockyBase}	dockybase	:PTR TO lib     -> for APPICONT_Docky
	{info.reserved}	reserved[8]	:ARRAY OF ULONG
ENDOBJECT

NATIVE {ApplicationNode} OBJECT applicationnode
	{node}	node	:mln
	{appID}	appid	:ULONG
	{name}	name	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT


/******************************************************************************/
/* *********************** application message system *********************** */
/******************************************************************************/

NATIVE {enApplicationMsgType} DEF
NATIVE {APPLIBMT_AppRegister}            CONST APPLIBMT_APPREGISTER            = 1 -> - (this message is always broadcast)
NATIVE {APPLIBMT_AppUnregister}          CONST APPLIBMT_APPUNREGISTER          = 2 -> - (this message is always broadcast)
NATIVE {APPLIBMT_AppWantsChangeIconType} CONST APPLIBMT_APPWANTSCHANGEICONTYPE = 3 -> - (this message is always broadcast)
NATIVE {APPLIBMT_AppDidChangeIconType}   CONST APPLIBMT_APPDIDCHANGEICONTYPE   = 4 -> - (this message is always broadcast)
NATIVE {APPLIBMT_AppDidChangeHidden}     CONST APPLIBMT_APPDIDCHANGEHIDDEN     = 5 -> - (this message is always broadcast)
NATIVE {APPLIBMT_LastAppDocChange}       CONST APPLIBMT_LASTAPPDOCCHANGE       = 6 -> - (this message is always broadcast)

NATIVE {APPLIBMT_Quit}                   CONST APPLIBMT_QUIT                   = 100 -> -
NATIVE {APPLIBMT_ForceQuit}              CONST APPLIBMT_FORCEQUIT              = 101 -> - Don't ask to save changed documents
NATIVE {APPLIBMT_Hide}                   CONST APPLIBMT_HIDE                   = 102 -> -
NATIVE {APPLIBMT_Unhide}                 CONST APPLIBMT_UNHIDE                 = 103 -> -
NATIVE {APPLIBMT_ToFront}                CONST APPLIBMT_TOFRONT                = 104 -> -
NATIVE {APPLIBMT_Unique}                 CONST APPLIBMT_UNIQUE                 = 105 -> -

NATIVE {APPLIBMT_OpenPrefs}              CONST APPLIBMT_OPENPREFS              = 200 -> -
NATIVE {APPLIBMT_ReloadPrefs}            CONST APPLIBMT_RELOADPREFS            = 201 -> -

NATIVE {APPLIBMT_NewBlankDoc}            CONST APPLIBMT_NEWBLANKDOC            = 300 -> -
NATIVE {APPLIBMT_OpenDoc}                CONST APPLIBMT_OPENDOC                = 301 -> struct AppLibOpenPrintDocMsg *
NATIVE {APPLIBMT_PrintDoc}               CONST APPLIBMT_PRINTDOC               = 302 -> struct AppLibOpenPrintDocMsg *

NATIVE {APPLIBMT_BlankerAllow}           CONST APPLIBMT_BLANKERALLOW           = 400 -> - (this message is always broadcast)
NATIVE {APPLIBMT_BlankerDisallow}        CONST APPLIBMT_BLANKERDISALLOW        = 401 -> - (this message is always broadcast)
NATIVE {APPLIBMT_BlankerBlank}           CONST APPLIBMT_BLANKERBLANK           = 402 -> - (this message is always broadcast)
NATIVE {APPLIBMT_BlankerMonitorOff}      CONST APPLIBMT_BLANKERMONITOROFF      = 403 -> - (this message is always broadcast)
NATIVE {APPLIBMT_BlankerUnBlank}         CONST APPLIBMT_BLANKERUNBLANK         = 404 -> - (this message is always broadcast)

NATIVE {APPLIBMT_GameModeEntered}        CONST APPLIBMT_GAMEMODEENTERED        = 500 -> - (this message is always broadcast)
NATIVE {APPLIBMT_GameModeLeft}           CONST APPLIBMT_GAMEMODELEFT           = 501 -> - (this message is always broadcast)

NATIVE {APPLIBMT_CustomMsg}              CONST APPLIBMT_CUSTOMMSG              = 9999  -> - Allows applications to send/receive customs msgs


NATIVE {ApplicationMsg} OBJECT applicationmsg
	{msg}	msg	:mn
	{senderAppID}	senderappid	:ULONG -> the application (or 0 [no app]) which sent this message
	{type}	type	:ULONG        -> enum enAppLibMessageType
ENDOBJECT

NATIVE {ApplicationOpenPrintDocMsg} OBJECT applicationopenprintdocmsg
	{almsg}	almsg	:applicationmsg
	{fileName}	filename	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT

NATIVE {ApplicationCustomMsg} OBJECT applicationcustommsg
	{almsg}	almsg	:applicationmsg
	{customMsg}	custommsg	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT

NATIVE {enNotifyTags} DEF
NATIVE {APPNOTIFY_Title}          CONST APPNOTIFY_TITLE          = TAG_USER + 1  -> CONST_STRPTR
NATIVE {APPNOTIFY_Update}         CONST APPNOTIFY_UPDATE         = TAG_USER + 2  -> BOOL (default: FALSE)
NATIVE {APPNOTIFY_Pri}            CONST APPNOTIFY_PRI            = TAG_USER + 3  -> uint32 (default: 0) not currently implemented
NATIVE {APPNOTIFY_PubScreenName}  CONST APPNOTIFY_PUBSCREENNAME  = TAG_USER + 4  -> CONST_STRPTR
NATIVE {APPNOTIFY_ImageFile}      CONST APPNOTIFY_IMAGEFILE      = TAG_USER + 5  -> CONST_STRPTR
NATIVE {APPNOTIFY_BackMsg}        CONST APPNOTIFY_BACKMSG        = TAG_USER + 6  -> CONST_STRPTR
NATIVE {APPNOTIFY_CloseOnDC}      CONST APPNOTIFY_CLOSEONDC      = TAG_USER + 7  -> BOOL
NATIVE {APPNOTIFY_Text}           CONST APPNOTIFY_TEXT           = TAG_USER + 8  -> CONST_STRPTR
NATIVE {APPNOTIFY_ImageVertAlign} CONST APPNOTIFY_IMAGEVERTALIGN = TAG_USER + 9  -> uint32 (defaul: 0=TOP)
NATIVE {APPNOTIFY_LogOnly}        CONST APPNOTIFY_LOGONLY        = TAG_USER + 10  -> BOOL (default: FALSE)


/**** return codes for Notify ****/
NATIVE {APPNOTIFY_OK_MSGQUEUED}                 CONST APPNOTIFY_OK_MSGQUEUED                 = 0
NATIVE {APPNOTIFY_OK_APPREGISTERED}             CONST APPNOTIFY_OK_APPREGISTERED             = 1
NATIVE {APPNOTIFY_ERROR_OUTOFMEM}              CONST APPNOTIFY_ERROR_OUTOFMEM              = 10
NATIVE {APPNOTIFY_ERROR_TOOMANYMESSAGESQUEUED} CONST APPNOTIFY_ERROR_TOOMANYMESSAGESQUEUED = 20
NATIVE {APPNOTIFY_ERROR_APPALREADYREGISTERED}  CONST APPNOTIFY_ERROR_APPALREADYREGISTERED  = 30
NATIVE {APPNOTIFY_ERROR_NOAPPNAME}             CONST APPNOTIFY_ERROR_NOAPPNAME             = 40
NATIVE {APPNOTIFY_ERROR_APPNOTALLOWED}         CONST APPNOTIFY_ERROR_APPNOTALLOWED         = 50
NATIVE {APPNOTIFY_ERROR_APPNOTREGISTERED}      CONST APPNOTIFY_ERROR_APPNOTREGISTERED      = 60
NATIVE {APPNOTIFY_ERROR_GAMEMODEACTIVE}        CONST APPNOTIFY_ERROR_GAMEMODEACTIVE        = 70
NATIVE {APPNOTIFY_ERROR_TAGS}                 CONST APPNOTIFY_ERROR_TAGS                 = 100
NATIVE {APPNOTIFY_ERROR_TIMEOUT}              CONST APPNOTIFY_ERROR_TIMEOUT              = 110
NATIVE {APPNOTIFY_ERROR_SERVERNOTRUNNING}     CONST APPNOTIFY_ERROR_SERVERNOTRUNNING     = 120
NATIVE {APPNOTIFY_ERROR_GENERIC}              CONST APPNOTIFY_ERROR_GENERIC              = 300

/**** return strings for Notify from the ARexx interface ****/
NATIVE {APPNOTIFY_OK_MSGQUEUED_STR}                CONST ->STATIC APPNOTIFY_OK_MSGQUEUED_STR                = 'OK, MSG QUEUED'
NATIVE {APPNOTIFY_OK_APPREGISTERED_STR}            CONST ->STATIC APPNOTIFY_OK_APPREGISTERED_STR            = 'OK, APP REGISTERED'
NATIVE {APPNOTIFY_ERROR_OUTOFMEM_STR}              CONST ->STATIC APPNOTIFY_ERROR_OUTOFMEM_STR              = 'ERROR: OUT OF MEMORY'
NATIVE {APPNOTIFY_ERROR_TOOMANYMESSAGESQUEUED_STR} CONST ->STATIC APPNOTIFY_ERROR_TOOMANYMESSAGESQUEUED_STR = 'ERROR: TOO MANY MESSAGES QUEUED'
NATIVE {APPNOTIFY_ERROR_APPALREADYREGISTERED_STR}  CONST ->STATIC APPNOTIFY_ERROR_APPALREADYREGISTERED_STR  = 'ERROR: APP ALREADY REGISTERED'
NATIVE {APPNOTIFY_ERROR_NOAPPNAME_STR}             CONST ->STATIC APPNOTIFY_ERROR_NOAPPNAME_STR             = 'ERROR: NO APP NAME'
NATIVE {APPNOTIFY_ERROR_APPNOTALLOWED_STR}         CONST ->STATIC APPNOTIFY_ERROR_APPNOTALLOWED_STR         = 'ERROR: APP NOT ALLOWED'
NATIVE {APPNOTIFY_ERROR_APPNOTREGISTERED_STR}      CONST ->STATIC APPNOTIFY_ERROR_APPNOTREGISTERED_STR      = 'ERROR: APP NOT REGISTERED'
NATIVE {APPNOTIFY_ERROR_GAMEMODEACTIVE_STR}        CONST ->STATIC APPNOTIFY_ERROR_GAMEMODEACTIVE_STR        = 'ERROR: GAME MODE ACTIVE'
NATIVE {APPNOTIFY_ERROR_TAGS_STR}                  CONST ->STATIC APPNOTIFY_ERROR_TAGS_STR                  = 'ERROR: WRONG TAGS'
NATIVE {APPNOTIFY_ERROR_TIMEOUT_STR}               CONST ->STATIC APPNOTIFY_ERROR_TIMEOUT_STR               = 'ERROR: TIMEOUT'
NATIVE {APPNOTIFY_ERROR_SERVERNOTRUNNING_STR}      CONST ->STATIC APPNOTIFY_ERROR_SERVERNOTRUNNING_STR      = 'ERROR: SERVER NOT RUNNING'
NATIVE {APPNOTIFY_ERROR_GENERIC_STR}               CONST ->STATIC APPNOTIFY_ERROR_GENERIC_STR               = 'ERROR: GENERIC ERROR'


/******************************************************************************/
/* *************************** PrefsObjects system ************************** */
/******************************************************************************/

NATIVE {TAGBUFFER_SIZE} CONST TAGBUFFER_SIZE = 150

NATIVE {enALPOEncodings} DEF
NATIVE {ALPOENC_ISO8859} CONST ALPOENC_ISO8859 = 0 -> currently only partly supported (for encoding only)
NATIVE {ALPOENC_UTF8}	CONST ALPOENC_UTF8 = 1


NATIVE {ALPOGetProcInfo} OBJECT alpogetprocinfo
	{getChProc}	getchproc	:PTR /*int32 (*getChProc)(struct ALPOGetProcInfo *pi)*/
	{unGetChProc}	ungetchproc	:PTR /*int32 (*unGetChProc)(int32 c, struct ALPOGetProcInfo *pi)*/
	{basePtr}	baseptr	:APTR
	{handlePtr}	handleptr	:APTR
	{key_otag}	key_otag	:/*STRPTR*/ ARRAY OF CHAR -> must have a size of at least TAGBUFFER_SIZE

	{encoding}	encoding	:ULONG  -> enum enALPOEncodings
ENDOBJECT

NATIVE {ALPOPutProcInfo} OBJECT alpoputprocinfo
	{putChProc}	putchproc	:PTR /*void (*putChProc)(int32 c, struct ALPOPutProcInfo *pi)*/
	{basePtr}	baseptr	:APTR
	{handlePtr}	handleptr	:APTR
	{tabDepth}	tabdepth	:VALUE  -> set to 0

	{encoding}	encoding	:ULONG -> enum enALPOEncodings
ENDOBJECT

NATIVE {ALPOString} OBJECT alpostring
	{string}	string	:/*STRPTR*/ ARRAY OF CHAR
	{length}	length	:ULONG
ENDOBJECT

-> --------------

NATIVE {enALPOType} DEF
NATIVE {ALPOT_None}       CONST ALPOT_NONE       = 0
NATIVE {ALPOT_String}     CONST ALPOT_STRING     = 1
NATIVE {ALPOT_Number}     CONST ALPOT_NUMBER     = 2
NATIVE {ALPOT_Date}       CONST ALPOT_DATE       = 3
NATIVE {ALPOT_Binary}     CONST ALPOT_BINARY     = 4
NATIVE {ALPOT_Array}      CONST ALPOT_ARRAY      = 5
NATIVE {ALPOT_Dictionary} CONST ALPOT_DICTIONARY = 6


NATIVE {enALPOErrorFlags} DEF
NATIVE {ALPOEF_INTERNAL_ERROR}     CONST ALPOEF_INTERNAL_ERROR     = $00000001
NATIVE {ALPOEF_UNKNOWN_METHOD}     CONST ALPOEF_UNKNOWN_METHOD     = $00000002
NATIVE {ALPOEF_MISSING_OBJECT}     CONST ALPOEF_MISSING_OBJECT     = $00000004
NATIVE {ALPOEF_IMPOSSIBLE_OP}      CONST ALPOEF_IMPOSSIBLE_OP      = $00000008
NATIVE {ALPOEF_WRONG_OBJECTTYPE}   CONST ALPOEF_WRONG_OBJECTTYPE   = $00000010
NATIVE {ALPOEF_ILLEGAL_PARAMETER}  CONST ALPOEF_ILLEGAL_PARAMETER  = $00000020
NATIVE {ALPOEF_MEMORY}             CONST ALPOEF_MEMORY             = $00000040
NATIVE {ALPOEF_NOTFOUND}           CONST ALPOEF_NOTFOUND           = $00000080
NATIVE {ALPOEF_DUPLICATE}          CONST ALPOEF_DUPLICATE          = $00000100
NATIVE {ALPOEF_DESERIALIZATION}    CONST ALPOEF_DESERIALIZATION    = $00000200
NATIVE {ALPOEF_READTAG}            CONST ALPOEF_READTAG            = $00000400
NATIVE {ALPOEF_READDATA}           CONST ALPOEF_READDATA           = $00000800
NATIVE {ALPOEF_WRONG_OTAG}         CONST ALPOEF_WRONG_OTAG         = $00001000
NATIVE {ALPOEF_WRONG_CTAG}         CONST ALPOEF_WRONG_CTAG         = $00002000
NATIVE {ALPOEF_WRONG_SERDATA}      CONST ALPOEF_WRONG_SERDATA      = $00004000
NATIVE {ALPOEF_FILEERROR}          CONST ALPOEF_FILEERROR          = $00008000
NATIVE {ALPOEF_XMLERROR}           CONST ALPOEF_XMLERROR           = $00010000
NATIVE {ALPOEF_WRONG_OBJECT}       CONST ALPOEF_WRONG_OBJECT       = $00020000


/*
** *** ID Scheme ********************************************************
**                 A B                                                   *
**     1         : n b ALPO_Alloc                                        *
**  1000 -  1999 : n c Alloc Object Methods without Param                *
**  2000         : n b ALPO_Release                                      *
**  2001         : n b ALPO_Copy                                         *
**  2002         : n b ALPO_Retain                                       *
**  2003 -  9999 : n b Other Base Methods without Param                  *
** 10000 - 19999 : n c Object Methods without Param (clear, free, ...)   *
** 20000         : p b ALPO_Identifiy                                    *
** 20001         : p b ALPO_Serialize                                    *
** 20002         : p b ALPO_Deserialize                                  *
** 20003         : p b ALPO_GetRetainCount                               *
** 20004 - 29999 : p b Other Base Methods with Param                     *
** 30000 - 39999 : p c Alloc Object Methods with Param                   *
** 40000 - 49999 : p c Object Methods with Param                         *
**                                                                       *
** A) n: no param               B) b: base methods                       *
**    p: with param                c: custom object methods              *
**                                                                       *
** **********************************************************************
*/


NATIVE {enALPOBaseMethods} DEF
NATIVE {ALPO_Alloc}                 CONST ALPO_ALLOC                 = TAG_USER +     1 -> -
NATIVE {ALPO_AllocWithString}       CONST ALPO_ALLOCWITHSTRING       = TAG_USER +     2 -> STRPTR
NATIVE {ALPO_Release}               CONST ALPO_RELEASE               = TAG_USER +  2000 -> -
NATIVE {ALPO_Copy}                  CONST ALPO_COPY                  = TAG_USER +  2001 -> -
NATIVE {ALPO_Retain}                CONST ALPO_RETAIN                = TAG_USER +  2002 -> -
NATIVE {ALPO_Identify}              CONST ALPO_IDENTIFY              = TAG_USER + 20000 -> uint32 *
NATIVE {ALPO_Serialize}             CONST ALPO_SERIALIZE             = TAG_USER + 20001 -> struct ALPOPutProcInfo *
NATIVE {ALPO_Deserialize}           CONST ALPO_DESERIALIZE           = TAG_USER + 20002 -> struct ALPOGetProcInfo *
NATIVE {ALPO_GetRetainCount}        CONST ALPO_GETRETAINCOUNT        = TAG_USER + 20003 -> int32 *

NATIVE {ALPO_SetWithString}         CONST ALPO_SETWITHSTRING         = TAG_USER + 20004 -> STRPTR
NATIVE {ALPO_GetAsString}           CONST ALPO_GETASSTRING           = TAG_USER + 20005 -> struct ALPOString *


-> --- PrefsString

NATIVE {ALPOUniString} OBJECT alpounistring
	{string}	string	:PTR TO ULONG
	{length}	length	:ULONG
ENDOBJECT

NATIVE {enALPOStringMethods} DEF
NATIVE {ALPOSTR_AllocSetString}     CONST ALPOSTR_ALLOCSETSTRING     = TAG_USER + 30000 -> STRPTR
NATIVE {ALPOSTR_AllocSetUniString}  CONST ALPOSTR_ALLOCSETUNISTRING  = TAG_USER + 30001 -> struct ALPOUniString *

NATIVE {ALPOSTR_Clear}              CONST ALPOSTR_CLEAR              = TAG_USER + 10000 -> -

NATIVE {ALPOSTR_GetLength}          CONST ALPOSTR_GETLENGTH          = TAG_USER + 40000 -> int32 *
NATIVE {ALPOSTR_SetString}          CONST ALPOSTR_SETSTRING          = TAG_USER + 40001 -> STRPTR
NATIVE {ALPOSTR_GetString}          CONST ALPOSTR_GETSTRING          = TAG_USER + 40002 -> STRPTR *
NATIVE {ALPOSTR_SetUniString}       CONST ALPOSTR_SETUNISTRING       = TAG_USER + 40003 -> struct ALPOUniString *
NATIVE {ALPOSTR_GetUniString}       CONST ALPOSTR_GETUNISTRING       = TAG_USER + 40004  -> struct ALPOUniString *


-> --- PrefsNumber

NATIVE {enALPONumberTypes} DEF
NATIVE {ALPONUMT_None}   CONST ALPONUMT_NONE   = 0
NATIVE {ALPONUMT_Long}   CONST ALPONUMT_LONG   = 1
NATIVE {ALPONUMT_Bool}   CONST ALPONUMT_BOOL   = 2
NATIVE {ALPONUMT_Double} CONST ALPONUMT_DOUBLE = 3


NATIVE {enALPONumberMethods} DEF
NATIVE {ALPONUM_AllocSetLong}       CONST ALPONUM_ALLOCSETLONG       = TAG_USER + 30000 -> int32
NATIVE {ALPONUM_AllocSetBool}       CONST ALPONUM_ALLOCSETBOOL       = TAG_USER + 30001 -> BOOL
NATIVE {ALPONUM_AllocSetDouble}     CONST ALPONUM_ALLOCSETDOUBLE     = TAG_USER + 30002 -> double *

NATIVE {ALPONUM_GetType}            CONST ALPONUM_GETTYPE            = TAG_USER + 40000 -> int32 *
NATIVE {ALPONUM_ConvertToType}      CONST ALPONUM_CONVERTTOTYPE      = TAG_USER + 40030 -> int32
NATIVE {ALPONUM_SetLong}            CONST ALPONUM_SETLONG            = TAG_USER + 40001 -> int32
NATIVE {ALPONUM_GetLong}            CONST ALPONUM_GETLONG            = TAG_USER + 40002 -> int32 *
NATIVE {ALPONUM_SetBool}            CONST ALPONUM_SETBOOL            = TAG_USER + 40011 -> BOOL
NATIVE {ALPONUM_GetBool}            CONST ALPONUM_GETBOOL            = TAG_USER + 40012 -> BOOL *
NATIVE {ALPONUM_SetDouble}          CONST ALPONUM_SETDOUBLE          = TAG_USER + 40021 -> double *
NATIVE {ALPONUM_GetDouble}          CONST ALPONUM_GETDOUBLE          = TAG_USER + 40022  -> double *


-> --- PrefsDate
NATIVE {enALPODateMethods} DEF
NATIVE {ALPODAT_AllocSetTimeVal}    CONST ALPODAT_ALLOCSETTIMEVAL    = TAG_USER + 30000 -> struct TimeVal *
NATIVE {ALPODAT_AllocSetCTime}      CONST ALPODAT_ALLOCSETCTIME      = TAG_USER + 30001 -> c_time

NATIVE {ALPODAT_SetCurrentTime}     CONST ALPODAT_SETCURRENTTIME     = TAG_USER + 10000 -> -
NATIVE {ALPODAT_SetTimeVal}         CONST ALPODAT_SETTIMEVAL         = TAG_USER + 40000 -> struct TimeVal *
NATIVE {ALPODAT_GetTimeVal}         CONST ALPODAT_GETTIMEVAL         = TAG_USER + 40001 -> struct TimeVal *
NATIVE {ALPODAT_SetSecsSince1978}   CONST ALPODAT_SETSECSSINCE1978   = TAG_USER + 40002 -> uint32
NATIVE {ALPODAT_GetSecsSince1978}   CONST ALPODAT_GETSECSSINCE1978   = TAG_USER + 40003 -> uint32 *
NATIVE {ALPODAT_SetClockData}       CONST ALPODAT_SETCLOCKDATA       = TAG_USER + 40004 -> struct ClockData *
NATIVE {ALPODAT_GetClockData}       CONST ALPODAT_GETCLOCKDATA       = TAG_USER + 40005 -> struct ClockData *

NATIVE {ALPODAT_SetDateStamp}       CONST ALPODAT_SETDATESTAMP       = TAG_USER + 40006 -> struct DateStamp *
NATIVE {ALPODAT_GetDateStamp}       CONST ALPODAT_GETDATESTAMP       = TAG_USER + 40007 -> struct DateStamp *


-> --- PrefsBinary

NATIVE {ALPOBinData} OBJECT alpobindata
	{data}	data	:PTR TO UBYTE
	{size}	size	:VALUE
ENDOBJECT

NATIVE {enALPOBinaryMethods} DEF
NATIVE {ALPOBIN_AllocWithSize}      CONST ALPOBIN_ALLOCWITHSIZE      = TAG_USER + 30000 -> int32
NATIVE {ALPOBIN_AllocWithData}      CONST ALPOBIN_ALLOCWITHDATA      = TAG_USER + 30001 -> struct ALPOBinData *

NATIVE {ALPOBIN_ClearData}          CONST ALPOBIN_CLEARDATA          = TAG_USER + 10000 -> -
NATIVE {ALPOBIN_GetData}            CONST ALPOBIN_GETDATA            = TAG_USER + 40001 -> uint8 **
NATIVE {ALPOBIN_GetSize}            CONST ALPOBIN_GETSIZE            = TAG_USER + 40003 -> int32 *
NATIVE {ALPOBIN_GetDataStruct}      CONST ALPOBIN_GETDATASTRUCT      = TAG_USER + 40002 -> struct ALPOBinData *
NATIVE {ALPOBIN_SetData}            CONST ALPOBIN_SETDATA            = TAG_USER + 40004  -> struct ALPOBinData *


-> --- PrefsDictionary, PrefsArray

NATIVE {ALPOObjIndex} OBJECT alpoobjindex
	{obj}	obj	:PTR TO PREFSOBJECT
	{index}	index	:VALUE
ENDOBJECT

-> --- PrefsDictionary

NATIVE {ALPOObjKey} OBJECT alpoobjkey
	{obj}	obj	:PTR TO PREFSOBJECT
	{key}	key	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT

NATIVE {ALPOObjKeyIndex} OBJECT alpoobjkeyindex
	{obj}	obj	:PTR TO PREFSOBJECT
	{key}	key	:/*STRPTR*/ ARRAY OF CHAR
	{index}	index	:VALUE
ENDOBJECT

NATIVE {enALPODictionaryMethods} DEF
NATIVE {ALPODICT_Clear}                CONST ALPODICT_CLEAR                = TAG_USER + 10000 -> -
NATIVE {ALPODICT_SortAscending}        CONST ALPODICT_SORTASCENDING        = TAG_USER + 10001 -> -
NATIVE {ALPODICT_SortDescending}       CONST ALPODICT_SORTDESCENDING       = TAG_USER + 10002 -> -
NATIVE {ALPODICT_GetCount}             CONST ALPODICT_GETCOUNT             = TAG_USER + 40000 -> int32 *

NATIVE {ALPODICT_SetObjForKey}         CONST ALPODICT_SETOBJFORKEY         = TAG_USER + 40010 -> struct ALPOObjKey *
NATIVE {ALPODICT_GetObjForKey}         CONST ALPODICT_GETOBJFORKEY         = TAG_USER + 40011 -> struct ALPOObjKey *
NATIVE {ALPODICT_RemoveObjForKey}      CONST ALPODICT_REMOVEOBJFORKEY      = TAG_USER + 40012 -> STRPTR
NATIVE {ALPODICT_ReplaceObjForKey}     CONST ALPODICT_REPLACEOBJFORKEY     = TAG_USER + 40013 -> struct ALPOObjKey *
NATIVE {ALPODICT_GetObjAndIndexForKey} CONST ALPODICT_GETOBJANDINDEXFORKEY = TAG_USER + 40014 -> struct ALPOObjKeyIndex *

NATIVE {ALPODICT_GetObjAtIndex}        CONST ALPODICT_GETOBJATINDEX        = TAG_USER + 40020 -> struct ALPOObjIndex *
NATIVE {ALPODICT_RemoveObjAtIndex}     CONST ALPODICT_REMOVEOBJATINDEX     = TAG_USER + 40021 -> int32
NATIVE {ALPODICT_ReplaceObjAtIndex}    CONST ALPODICT_REPLACEOBJATINDEX    = TAG_USER + 40022 -> struct ALPOObjIndex *
NATIVE {ALPODICT_GetObjAndKeyAtIndex}  CONST ALPODICT_GETOBJANDKEYATINDEX  = TAG_USER + 40023 -> struct ALPOObjKeyIndex *
NATIVE {ALPODICT_InsertObjAtIndex}     CONST ALPODICT_INSERTOBJATINDEX     = TAG_USER + 40024 -> struct ALPOObjKeyIndex *
NATIVE {ALPODICT_RemoveObj}            CONST ALPODICT_REMOVEOBJ            = TAG_USER + 40030 -> PrefsObject *
NATIVE {ALPODICT_GetKeyAndIndexForObj} CONST ALPODICT_GETKEYANDINDEXFOROBJ = TAG_USER + 40031 -> struct ALPOObjKeyIndex *


-> --- PrefsArray

NATIVE {enALPOArrayMethods} DEF
NATIVE {ALPOARR_Clear}              CONST ALPOARR_CLEAR              = TAG_USER + 10000 -> -
NATIVE {ALPOARR_GetCount}           CONST ALPOARR_GETCOUNT           = TAG_USER + 40001 -> int32 *

NATIVE {ALPOARR_AddObj}             CONST ALPOARR_ADDOBJ             = TAG_USER + 40010 -> PrefsObject *
NATIVE {ALPOARR_InsertObjAtIndex}   CONST ALPOARR_INSERTOBJATINDEX   = TAG_USER + 40011 -> struct ALPOObjIndex *
NATIVE {ALPOARR_GetObjAtIndex}      CONST ALPOARR_GETOBJATINDEX      = TAG_USER + 40012 -> struct ALPOObjIndex *
NATIVE {ALPOARR_RemoveObjAtIndex}   CONST ALPOARR_REMOVEOBJATINDEX   = TAG_USER + 40013 -> int32
NATIVE {ALPOARR_ReplaceObjAtIndex}  CONST ALPOARR_REPLACEOBJATINDEX  = TAG_USER + 40014 -> struct ALPOObjIndex *
NATIVE {ALPOARR_RemoveObj}          CONST ALPOARR_REMOVEOBJ          = TAG_USER + 40015 -> PrefsObject *
NATIVE {ALPOARR_GetIndexForObj}     CONST ALPOARR_GETINDEXFOROBJ     = TAG_USER + 40016  -> struct ALPOObjIndex *



-> --- ReadPrefs() tags
NATIVE {enALPOReadPrefsTags} DEF
NATIVE {READPREFS_AppID}            CONST READPREFS_APPID            = TAG_USER +  1 -> uint32
NATIVE {READPREFS_FileName}         CONST READPREFS_FILENAME         = TAG_USER +  2 -> STRPTR
NATIVE {READPREFS_GetProcInfo}      CONST READPREFS_GETPROCINFO      = TAG_USER +  3 -> struct ALPOGetProcInfo *
NATIVE {READPREFS_ReadENV}          CONST READPREFS_READENV          = TAG_USER + 10 -> BOOL (default: TRUE)
NATIVE {READPREFS_ReadENVARC}       CONST READPREFS_READENVARC       = TAG_USER + 11  -> BOOL (default: TRUE, done if ReadENV failed)


-> --- WritePrefs() tags
NATIVE {enALPOWritePrefsTags} DEF
NATIVE {WRITEPREFS_AppID}           CONST WRITEPREFS_APPID           = TAG_USER +  1 -> uint32
NATIVE {WRITEPREFS_FileName}        CONST WRITEPREFS_FILENAME        = TAG_USER +  2 -> STRPTR
NATIVE {WRITEPREFS_PutProcInfo}     CONST WRITEPREFS_PUTPROCINFO     = TAG_USER +  3 -> struct ALPOPutProcInfo *
NATIVE {WRITEPREFS_WriteENV}        CONST WRITEPREFS_WRITEENV        = TAG_USER + 10 -> BOOL (default: TRUE)
NATIVE {WRITEPREFS_WriteENVARC}     CONST WRITEPREFS_WRITEENVARC     = TAG_USER + 11  -> BOOL (default: FALSE)
