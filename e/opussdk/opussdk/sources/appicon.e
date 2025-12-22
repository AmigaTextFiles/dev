/*****************************************************************************

 AppIcon, etc

 *****************************************************************************/

OPT MODULE
OPT EXPORT

MODULE 'workbench/workbench', 'intuition/intuition', 'graphics/gfx', 'utility/tagitem'

CONST DAE_Local         = TAG_USER + 0    -> Add to DOpus only, not WB
CONST DAE_SnapShot      = TAG_USER + 1    -> Supports snapshot
CONST DAE_Menu          = TAG_USER + 2    -> Menu item
CONST DAE_Close         = TAG_USER + 3    -> Close item
CONST DAE_Background    = TAG_USER + 4    -> Background colour
CONST DAE_ToggleMenu    = TAG_USER + 5    -> Toggle item
CONST DAE_ToggleMenuSel = TAG_USER + 6    -> Toggle item (selected)
CONST DAE_Info          = TAG_USER + 7    -> Supports Information
CONST DAE_Locked        = TAG_USER + 8    -> Position locked
CONST DAE_MenuBase      = TAG_USER + 9    -> Menu ID base


-> Messages sent from AppIcons

CONST MTYPE_APPSNAPSHOT = $3812      -> Snapshot message

OBJECT appSnapshotMsg
    msg:appmessage          -> Message
    position_x:LONG         -> Icon x-position
    position_y:LONG         -> Icon y-position
    window_pos:ibox         -> Window position
    flags:LONG              -> Flags
    id:LONG                 -> ID
ENDOBJECT

SET APPSNAPF_UNSNAPSHOT,      -> Set "no position"
    APPSNAPF_WINDOW_POS,      -> Window position supplied
    APPSNAPF_MENU,            -> Menu operation
    APPSNAPF_CLOSE,           -> Close command
    APPSNAPF_HELP,            -> Help on a command
    APPSNAPF_INFO             -> Information command


-> Change AppIcons

SET CAIF_RENDER,
    CAIF_SELECT,
    CAIF_TITLE,
    CAIF_LOCKED,
    CAIF_SET,
    CAIF_BUSY,
    CAIF_UNBUSY


-> AppWindow messages

OBJECT dOpusAppMessage
    msg:appmessage                  -> Message
    dropPos:PTR TO tpoint           -> Drop array
    dragOffset:tpoint               -> Mouse pointer offset
    flags:LONG                      -> Flags
    pad[2]:ARRAY OF LONG
ENDOBJECT

CONST DAPPF_ICON_DROP = $10000      -> Dropped with icon
