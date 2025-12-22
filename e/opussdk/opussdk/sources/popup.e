/*****************************************************************************

 Popup menus

 *****************************************************************************/

OPT MODULE
OPT EXPORT

MODULE '*locale', 'exec/nodes', 'exec/lists'

-> Defines an item in a menu
OBJECT popUpItem
    node:mln
    item_name:PTR TO CHAR       -> Menu item name
    id:INT                      -> Menu ID
    flags:INT                   -> Menu item flags
    data:LONG                   -> Menu item data
ENDOBJECT

SET POPUPF_LOCALE,           -> Item name is a locale ID
    POPUPF_CHECKIT,          -> Item can be checked
    POPUPF_CHECKED,          -> Item is checked
    POPUPF_SUB,              -> Item has sub-items
    POPUPF_DISABLED          -> Item is disabled

CONST POPUP_BARLABEL          = -1

CONST POPUP_HELPFLAG          = $8000 -> Set if help key pressed

-> Used to declare a callback for a menu

-> Defines a popup menu
OBJECT popUpMenu
    item_list:mlh               -> List of menu items
    locale:PTR TO dOpusLocale    -> Locale data
    flags:LONG                   -> Flags
    userdata:LONG                -> User data
    callback:LONG                -> Refresh callback
ENDOBJECT

SET POPUPMF_HELP,         -> Supports help
    POPUPMF_REFRESH,      -> Use refresh callback
    POPUPMF_ABOVE         -> Open above parent window
