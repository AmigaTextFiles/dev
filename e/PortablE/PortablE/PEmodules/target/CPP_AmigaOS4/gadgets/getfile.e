/* $VER: getfile.h 53.21 (29.9.2013) */
OPT NATIVE, PREPROCESS
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
MODULE 'target/exec/types', 'target/intuition/intuition', 'target/exec/lists'
{#include <gadgets/getfile.h>}
NATIVE {GADGETS_GETFILE_H} CONST

/* Attributes defined by the getfile.gadget class
 */
NATIVE {GETFILE_Dummy}                   CONST GETFILE_DUMMY                   = (REACTION_DUMMY + $60000)

NATIVE {GETFILE_TitleText}               CONST GETFILE_TITLETEXT               = (GETFILE_DUMMY+1)
    /* (STRPTR) Requester title text (default: None) (OM_NEW, OM_SET) */

NATIVE {GETFILE_LeftEdge}                CONST GETFILE_LEFTEDGE                = (GETFILE_DUMMY+2)
NATIVE {GETFILE_TopEdge}                 CONST GETFILE_TOPEDGE                 = (GETFILE_DUMMY+3)
    /* (WORD) Requester coordinates  (default leftedge: 30, topedge: 20)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETFILE_Width}                   CONST GETFILE_WIDTH                   = (GETFILE_DUMMY+4)
NATIVE {GETFILE_Height}                  CONST GETFILE_HEIGHT                  = (GETFILE_DUMMY+5)
    /* (WORD) Requester dimensions (default height: 200, width: 300)
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETFILE_File}                    CONST GETFILE_FILE                    = (GETFILE_DUMMY+6)
    /* (STRPTR) Contents of File gadget (default: None)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETFILE_Drawer}                  CONST GETFILE_DRAWER                  = (GETFILE_DUMMY+7)
    /* (STRPTR) Contents of Drawer gadget (default: None)
       (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETFILE_FullFile}                CONST GETFILE_FULLFILE                = (GETFILE_DUMMY+8)
    /* (STRPTR) Complete file name. Replaces GETFILE_Drawer and
       GETFILE_File (default: None) (OM_NEW, OM_SET, OM_GET, OM_NOTIFY) */

NATIVE {GETFILE_FullFileExpand}          CONST GETFILE_FULLFILEEXPAND          = (GETFILE_DUMMY+9)
    /* (BOOL) GETFILE_FullFile will give complete file name(s) expanded
       with NameFromLock() to remove relative paths. (default: TRUE)
       (OM_NEW, OM_SET) */

NATIVE {GETFILE_Pattern}                 CONST GETFILE_PATTERN                 = (GETFILE_DUMMY+10)
    /* (STRPTR) Contents of Pattern gadget (default: "#?")
       (OM_NEW, OM_SET, OM_GET) */

NATIVE {GETFILE_DoSaveMode}              CONST GETFILE_DOSAVEMODE              = (GETFILE_DUMMY+11)
    /* (BOOL) Being used for saving? (default: FALSE) (OM_NEW, OM_SET) */

NATIVE {GETFILE_DoMultiSelect}           CONST GETFILE_DOMULTISELECT           = (GETFILE_DUMMY+12)
    /* (BOOL) Do multi-select? (default: FALSE) (OM_NEW, OM_SET) */

NATIVE {GETFILE_DoPatterns}              CONST GETFILE_DOPATTERNS              = (GETFILE_DUMMY+13)
    /* (BOOL) Display a Pattern gadget? (default: FALSE) (OM_NEW, OM_SET) */

NATIVE {GETFILE_DrawersOnly}             CONST GETFILE_DRAWERSONLY             = (GETFILE_DUMMY+14)
    /* (BOOL) Don't display files? (default: FALSE) (OM_NEW, OM_SET) */

NATIVE {GETFILE_FilterFunc}              CONST GETFILE_FILTERFUNC              = (GETFILE_DUMMY+15)
    /* Deprecated. Use GETFILE_FilterHook instead. */

NATIVE {GETFILE_RejectIcons}             CONST GETFILE_REJECTICONS             = (GETFILE_DUMMY+16)
    /* (BOOL) Display .info files? (default: FALSE) (OM_NEW, OM_SET)  */

NATIVE {GETFILE_RejectPattern}           CONST GETFILE_REJECTPATTERN           = (GETFILE_DUMMY+17)
    /* (UBYTE *) Don't display files matching pattern (default: None)
       (OM_NEW, OM_SET) */

NATIVE {GETFILE_AcceptPattern}           CONST GETFILE_ACCEPTPATTERN           = (GETFILE_DUMMY+18)
    /* (UBYTE *) Accept only files matching pattern (default: None)
       (OM_NEW, OM_SET) */

NATIVE {GETFILE_FilterDrawers}           CONST GETFILE_FILTERDRAWERS           = (GETFILE_DUMMY+19)
    /* (BOOL) Also filter drawers with pattern (default: FALSE)
       (OM_NEW, OM_SET) */

NATIVE {GETFILE_Filelist}                CONST GETFILE_FILELIST                = (GETFILE_DUMMY+20)
    /* (struct List *) If the GETFILE_DoMultiSelect tags was used, you can
       get a pointer to the list of selected files/drawers using this tag.
       The ln_Name part of each node will contain the filename/drawername
       for each selected file with a fully qualified path, even if you
       didn't use the GETFILE_FullFileExpand.
       In single-selected mode, the list will contain the single selected
       file for notification purposes. Don't forget to free the list using
       the GFILE_FREELIST method! (OM_GET, OM_NOTIFY) */

NATIVE {GETFILE_LBNodeStructs}           CONST GETFILE_LBNODESTRUCTS           = (GETFILE_DUMMY+21)
    /* (BOOL) GETFILE_Filelist will give a list with ListBrowserNodes
       instead of normal struct Node node structures (default: FALSE)
       (OM_NEW) */

NATIVE {GETFILE_ReadOnly}                CONST GETFILE_READONLY                = (GETFILE_DUMMY+22)
    /* (BOOL) If TRUE, a read-only recessed button gadget is used to
       present the file/drawer information. If FALSE, an editable string
       gadget is used. (default: TRUE) (OM_NEW) */

NATIVE {GETFILE_FilePartOnly}            CONST GETFILE_FILEPARTONLY            = (GETFILE_DUMMY+23)
    /* (BOOL) display file part only - valid ONLY in readonly mode! */

NATIVE {GETFILE_AllowEmptyFileSelection} CONST GETFILE_ALLOWEMPTYFILESELECTION = (GETFILE_DUMMY+24)
    /* (BOOL) Defaults to FALSE. (V50) */

NATIVE {GETFILE_FilterHook}              CONST GETFILE_FILTERHOOK              = (GETFILE_DUMMY+25)
    /* (struct Hook *) Function to filter files. (V53.2) */

NATIVE {GETFILE_InitialShowVolumes}      CONST GETFILE_INITIALSHOWVOLUMES      = (GETFILE_DUMMY+26)
    /* (BOOL) Show volumes initially. (V53.10) */

/*****************************************************************************/

/*
 * getfile.gadget methods
 */
NATIVE {GFILE_REQUEST}  CONST GFILE_REQUEST  = ($620001)
NATIVE {GFILE_FREELIST} CONST GFILE_FREELIST = ($620002)

/* The GFILE_REQUEST method should be called whenever you want to open
 * a file/dir requester.
 */

NATIVE {gfileRequest} OBJECT gfilerequest
    {MethodID}	methodid	:ULONG     /* GFILE_REQUEST */
    {gfile_Window}	window	:PTR TO window /* The window that will be locked
                                     when the requester is active.
                                     MUST be provided! */
ENDOBJECT

/* The GFILE_FREELIST method SHOULD be called when you are done doing a
 * multiselect a file/dir select using the tag GETFILE_DoMultiSelect and
 * have processed the result.
 * This method will free the list of struct Node structures.  If you do
 * not free this list using this method, the list will not be freed until
 * you dispose the class.
 */

NATIVE {gfileFreelist} OBJECT gfilefreelist
    {MethodID}	methodid	:ULONG       /* GFILE_FREELIST */
    {gfile_Filelist}	filelist	:PTR TO lh /* The list of struct Node obtained
                                     using the GETFILE_Filelist tag in
                                     OM_GET. Can be NULL, in which case
                                     this method will do nothing. */
ENDOBJECT

/* macros for calling the methods easily */

NATIVE {gfRequestFile} PROC
#define requestFile(obj/*:PTR TO /*Object*/ ULONG*/, win)   IdoMethod(obj, GFILE_REQUEST, win)

NATIVE {gfRequestDir} PROC
#define requestDir(obj/*:PTR TO /*Object*/ ULONG*/, win)    IdoMethod(obj, GFILE_REQUEST, win)

NATIVE {gfFreeFilelist} PROC
#define freeFilelist(obj/*:PTR TO /*Object*/ ULONG*/, list) IdoMethod(obj, GFILE_FREELIST, list)

/* ReAction synomym for End which can make layout groups easier to follow */

#ifndef GetFileEnd
NATIVE {GetFileEnd} CONST
#define GetFileEnd TAG_END]:tagitem)
#endif
