/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: popupmenu.e                                         -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Include for popupmenu.library for Amiga-E           -- *
 * -- Version.....: 9.00 (02.12.99)                                     -- *
 * -- ----------------------------------------------------------------- -- */

/* -- ----------------------------------------------------------------- -- *
 * --                              Options                              -- *
 * -- ----------------------------------------------------------------- -- */

OPT PREPROCESS       -> enable preprocessor
OPT MODULE           -> generate module
OPT EXPORT           -> export all


/* -- ----------------------------------------------------------------- -- *
 * --                              Modules                              -- *
 * -- ----------------------------------------------------------------- -- */

->»» LIST OF MODULES
MODULE 'utility/tagitem'     ,
       'utility/hooks'       ,
       'exec/libraries'      ,
       'intuition/intuition'

->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                              Macros                               -- *
 * -- ----------------------------------------------------------------- -- */

->»» LIST OF MACROS

#define POPUPMENU_VERSION       9
#define POPUPMENU_NAME          "popupmenu.library"

#define PMStartMenu     Pm_MenuA( [ PM_DUMMY, 0

#define PMMenu(t)       Pm_MenuA( [ PM_ITEM, Pm_ItemA( [ PM_HIDDEN, TRUE, TAG_END ] ),\
                        PM_ITEM, Pm_ItemA( [ PM_TITLE, t, PM_NOSELECT, TRUE, PM_SHINEPEN, TRUE, PM_SHADOWED, TRUE, PM_CENTER, TRUE, TAG_END ] ),\
                        PM_ITEM, Pm_ItemA( [ PM_WIDETITLEBAR, TRUE, TAG_END ] )

#define PMMenuID(t)     Pm_MenuA( [ PM_ITEM, Pm_ItemA( [ PM_HIDDEN, TRUE, TAG_END ] ),\
                        PM_ITEM, Pm_ItemA( [ PM_TITLEID, t, PM_NOSELECT, TRUE, PM_SHINEPEN, TRUE, PM_SHADOWED, TRUE, PM_CENTER, TRUE, TAG_END ] ),\
                        PM_ITEM, Pm_ItemA( [ PM_WIDETITLEBAR, TRUE, TAG_END ] )

#define PMSubMenu(t)    PM_SUB, Pm_MenuA( [ PM_ITEM, Pm_ItemA( [ PM_TITLE, t, PM_NOSELECT, TRUE, PM_SHINEPEN, TRUE, TAG_END ] ),\
                        PM_ITEM, Pm_ItemA( [ PM_WIDETITLEBAR, TRUE, TAG_END ] )

#define PMSimpleSub     PM_SUB, Pm_MenuA( [ PM_DUMMY, 0

#define PMItem(t)       PM_ITEM, Pm_ItemA( [ PM_TITLE, t

#define PMItemID(t)     PM_ITEM, Pm_ItemA( [ PM_TITLEID, t

#define PMInfo(t)       PM_ITEM, Pm_ItemA( [ PM_TITLE, t, PM_NOSELECT, TRUE, PM_SHINEPEN, TRUE

#define PMColBox(c)     PM_ITEM, Pm_ItemA( [ PM_COLOURBOX, c

#define PMBar           PM_ITEM, Pm_ItemA( [ PM_TITLEBAR, TRUE

-> For compatibility with old sources - DO NOT USE 
-> please replace following macros by "PMBar" if you have used
-> previous versions of "popupmenu.library"
->
-> PMTitleBar, PMNarrowBar, PMNarrowTitleBar
->

#define PMMenuTitle(t)  PM_ITEM, Pm_ItemA( [ PM_TITLE, t, PM_NOSELECT, TRUE, PM_SHINEPEN, TRUE, PM_SHADOWED, TRUE, PM_CENTER, TRUE, TAG_END ] ),\
                        PM_ITEM, Pm_ItemA( [ PM_WIDETITLEBAR, TRUE, TAG_END ] )

#define PMHoriz         PM_ITEM, Pm_ItemA( [ PM_NOSELECT, TRUE, PM_LAYOUTMODE, PML_HORIZONTAL

#define PMVert          PM_ITEM, Pm_ItemA( [ PM_NOSELECT, TRUE, PM_LAYOUTMODE, PML_VERTICAL

#define PMMembers       PM_MEMBERS, Pm_MenuA( [ PM_DUMMY, NIL

#define PMExcl(list)    PM_EXCLUDE, Pm_MakeIDListA(list)
#define ExID(id)        PM_EXCLUDEID, id
#define InID(id)        PM_INCLUDEID, id
#define RefID(id)       PM_REFLECTID, id
#define InvID(id)       PM_INVERSEID, id

#define PMCheckItem(t,id)   PM_ITEM, Pm_ItemA( [ PM_TITLE, t, PM_ID, id, PM_CHECKIT, TRUE

#define PMEnd           TAG_END ] )
#define End             TAG_END ] )

->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                             Constants                             -- *
 * -- ----------------------------------------------------------------- -- */

->»» LIST OF CONSTANTS

-> Tags passed to Pm_OpenPopupMenuA and Pm_FilterIMsgA

CONST PM_MENU           = TAG_USER + 004 , -> (PTR TO popupmenu) Pointer to menulist initialized by MakeMenu()
      PM_TOP            = TAG_USER + 012 , -> Top (Y) position
      PM_LEFT           = TAG_USER + 013 , -> Left (X) position
      PM_CODE           = TAG_USER + 014 , -> Read the documentation.
      PM_RIGHT          = TAG_USER + 015 ,
      PM_BOTTOM         = TAG_USER + 016 ,
      PM_MINWIDTH       = TAG_USER + 017 ,
      PM_MINHEIGHT      = TAG_USER + 018 ,
      PM_FORCEFONT      = TAG_USER + 019 ,
      PM_PULLDOWN       = TAG_USER + 090 , -> Make the menu a pulldown menu.
      PM_MENUHANDLER    = TAG_USER + 091 , -> (PTR TO hook) Hook that is called for each selected item, after the
                                           -> menu has been closed. This tag turns on MultiSelect.
      PM_AUTOPULLDOWN   = TAG_USER + 092 , -> Make an automatic pulldown menu. (PM_FilterIMsg only)
      PM_LOCALEHOOK     = TAG_USER + 093 , -> Locale "GetString()" hook. (Not yet implemented)
      PM_CENTERSCREEN   = TAG_USER + 094 , -> Center menu on the screen
      PM_USELMB         = TAG_USER + 095 , -> Left mouse button should be used to select an item
                                           -> (right button selects multiple items)
      PM_DRIPENSONLY    = TAG_USER + 096   -> Only use the screens DRI pens, revert to system images if necessary.
                                           -> Use with care as it overrides the users prefs !


-> Tags passed to Item

CONST PM_TITLE                = TAG_USER + 020 , -> Item title
      PM_USERDATA             = TAG_USER + 021 , -> Anything, returned by OpenPopupMenu when this item is selected
      PM_ID                   = TAG_USER + 022 , -> ID number, if you want to access this item later
      PM_SUB                  = TAG_USER + 023 , -> Pointer to submenu list (from MakeMenu)
      PM_FLAGS                = TAG_USER + 024 , -> For internal use
      PM_NOSELECT             = TAG_USER + 025 , -> Make the item unselectable
      PM_FILLPEN              = TAG_USER + 026 , -> Make the item appear in FILLPEN
      PM_CHECKIT              = TAG_USER + 027 , -> Leave space for a checkmark
      PM_CHECKED              = TAG_USER + 028 , -> Make this item is checked
      PM_ITALIC               = TAG_USER + 029 , -> Italic text
      PM_BOLD                 = TAG_USER + 030 , -> Bold text
      PM_UNDERLINED           = TAG_USER + 031 , -> Underlined text
      PM_TITLEBAR             = TAG_USER + 032 , -> Horizontal separator bar
      PM_WIDETITLEBAR         = TAG_USER + 033 , -> Same as above, but full width
      PM_SHADOWPEN            = TAG_USER + 034 , -> Draw text in SHADOWPEN
      PM_SHINEPEN             = TAG_USER + 035 , -> Draw text in SHINEPEN
      PM_CENTER               = TAG_USER + 036 , -> Center the text of this item
      PM_EXCLUDE              = TAG_USER + 037 , -> Items to unselect (or select) when this gets selected
      PM_DISABLED             = TAG_USER + 038 , -> Disable an item
      PM_IMAGESELECTED        = TAG_USER + 039 , -> Image when selected, PM_Title will be render on top of the image
      PM_IMAGEUNSELECTED      = TAG_USER + 040 , -> Image when unselected
      PM_ICONSELECTED         = TAG_USER + 041 , -> Icon when selected
      PM_ICONUNSELECTED       = TAG_USER + 042 , -> Icon when unselected
      PM_OBJECT               = TAG_USER + 043 , -> BOOPSI object
      PM_AUTOSTORE            = TAG_USER + 044 , -> Pointer to BOOL reflecting the current state of the item
      PM_TEXTPEN              = TAG_USER + 045 , -> Pen number for text colour of this item, if you want to allocate a pen yourself
      PM_USERDATASTRING       = TAG_USER + 046 , -> Allocates memory and copies the string.
      PM_COMMKEY              = TAG_USER + 047 , -> Keyboard shortcut for this item.
      PM_SHADOWED             = TAG_USER + 048 , -> Gives the text a shadow
      PM_TITLEID              = TAG_USER + 049 , -> Locale string ID (not yet implemented)
      PM_COLOURBOX            = TAG_USER + 060 , -> Filled rectangle
      PM_SUBCONSTRUCT         = TAG_USER + 061 , -> Constructor hook for submenus. Called before the menu is opened.
      PM_SUBDESTRUCT          = TAG_USER + 062 , -> Destructor hook for submenus. Called after the menu has been closed.
      PM_HIDDEN               = TAG_USER + 063 , -> This item is not to be drawn
      PM_LAYOUTMODE           = TAG_USER + 064 , -> Layout method ( PML_HORIZONTAL | PML_VERTICAL )
      PM_MEMBERS              = TAG_USER + 065   -> Members for this group

-> Tags passed to MakeMenu
CONST PM_ITEM    = TAG_USER + 050 , -> Item pointer from MakeItem
      PM_DUMMY   = TAG_USER + 051   -> Sometimes very useful


-> Tags passed to MakeIDList
CONST PM_EXCLUDEID = TAG_USER + 055 , -> ID number of menu to deselect when this gets selected
      PM_INCLUDEID = TAG_USER + 056 , -> ID number of menu to select when this gets selected
      PM_REFLECTID = TAG_USER + 057 , -> ID number of menu that should reflect the state of this one
      PM_INVERSEID = TAG_USER + 058   -> ID number of menu to inverse reflect the state of this one


-> Tags for Pm_InsertMenuItemA()
CONST PM_INSERT_BEFORE    = TAG_USER + 200 , -> (N/A) Insert before the item pointed to by the following argument (NOT AVAILABLE IN THE CURRENT VERSION)
      PM_INSERT_BEFOREID  = TAG_USER + 201 , -> (N/A) Insert before the first item with ID equal to the argument (NOT AVAILABLE IN THE CURRENT VERSION)
      PM_INSERT_AFTER     = TAG_USER + 202 , -> Insert after the item pointed to by the following argument
      PM_INSERT_AFTERID   = TAG_USER + 203 , -> Insert after the first item with ID equal to the argument
      PM_INSERT_LAST      = TAG_USER + 205 , -> Insert after the last item
      PM_INSERT_FIRST     = TAG_USER + 209 , -> Insert after the first item (which is usually invisible)
      PM_INSERTSUB_FIRST  = TAG_USER + 206 , -> Insert before the first item in the submenu pointed to by the argument
      PM_INSERTSUB_LAST   = TAG_USER + 207 , -> Insert at the and of a submenu
      PM_INSERTSUB_SORTED = TAG_USER + 208 , -> (N/A)
      PM_INSERT_ITEM      = TAG_USER + 210   -> Item to insert, may be repeated for several items


-> Layout methods
CONST PML_NONE            = 0     ,  -> Normal item
      PML_HORIZONTAL      = 1     ,  -> Horizontal group
      PML_VERTICAL        = 2     ,  -> Vertical group
      PML_TABLE           = 3     ,  -> Table group
      PML_DEFAULT         = 255      -> Don't use


CONST PMERR = -5

->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                            Structures                             -- *
 * -- ----------------------------------------------------------------- -- */

->»» OBJECT popupmenubase
OBJECT popupmenubase OF lib
  pmb_SegList         : LONG
  pmb_Flags           : LONG
  pmb_ExecBase        : PTR TO lib      -> These library
  pmb_UtilityBase     : PTR TO lib      -> pointers are
  pmb_IntuitionBase   : PTR TO lib      -> valid as long
  pmb_GfxBase         : PTR TO lib      -> as pm lib 
  pmb_DOSBase         : PTR TO lib      -> is open.      
  pmb_NewPrefs        : INT             -> (BOOL) Reload prefs.
  pmb_CxBase          : PTR TO lib      -> commodities.   
ENDOBJECT


-> PopupMenu structure
->
-> WARNING!
-> This structure may change in future versions.
-> I'm about to change EVERYTHING below "UserData" in
-> this structure to save some memory for items that do not
-> require all that stuff.
-> I might also move "Title", so the ONLY fields in this
-> structure that you can READ safely is "ID" and "UserData".
-> You can also write to "UserData" - this is entierly your
-> own field and is not used by any of the library functions.
->

->»» OBJECT popupmenu
OBJECT popupmenu
  ppm_Next           : PTR TO popupmenu
  ppm_Sub            : PTR TO popupmenu

  -> The following component is a union:
  ->
  ->    .ppm_TileID  : LONG
  -> or .ppm_Boopsi  : PTR TO object
  ->
  ppm_Title          : PTR TO CHAR       -> Title

  ppm_Flags          : LONG              -> Flags
  ppm_ID             : LONG              -> Item ID
  ppm_UserData       : LONG              -> UserData

PRIVATE
  ppm_Left           : INT               -> Position and dimensions of the item
  ppm_Top            : INT
  ppm_Width          : INT
  ppm_Height         : INT
PUBLIC

  -> NOTE:
  -> The fields below exist only when they are required !
  ppm_ExtFlags       : INT
  ppm_Layout         : CHAR
  ppm_ColBox         : CHAR
  ppm_Exclude        : PTR TO LONG     -> Exclude/Included/Reflected items
  ppm_AutoSetPtr     : PTR TO INT      -> Ptr to BOOL containing current state
  ppm_UnSelected     : PTR TO image    -> Unselected image or icon
  ppm_Selected       : PTR TO image    -> Selected image or icon
  ppm_Mask[2]        : ARRAY OF CHAR   -> Image/Icon blit masks
  pmm_CommKey        : CHAR            -> Command Key
  ppm_Weight         : CHAR            -> Weight
  ppm_TextPen        : LONG            -> Pen number for item's text
  ppm_SubConstruct   : PTR TO hook     -> SubMenu Constructor hook
  ppm_SubDestruct    : PTR TO hook     -> SubMenu Destructor hook
ENDOBJECT
->»»>
