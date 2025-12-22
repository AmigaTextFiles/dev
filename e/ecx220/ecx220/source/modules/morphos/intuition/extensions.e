OPT MODULE, EXPORT

-> intuition/extensions.e (MorphOS)
-> comments from original C source

MODULE 'morphos/intuition/diattr'
MODULE 'intuition/intuition'
MODULE 'utility/tagitem'
MODULE 'graphics/clip'
MODULE 'graphics/regions'
MODULE 'graphics/gfx'

/* new SYSIA_Which values (added some padding there) */

CONST ICONIFYIMAGE    = $12
CONST LOCKIMAGE       = $13
CONST MUIIMAGE        = $14
CONST POPUPIMAGE      = $15
CONST SNAPSHOTIMAGE   = $16
CONST JUMPIMAGE       = $17
CONST MENUTOGGLEIMAGE = $19
CONST SUBMENUIMAGE    = $1A


/* Flags for ExtraTitlebarGadgets!!! */
CONST ETG_ICONIFY             = $1  /* MUI iconify gadget */
CONST ETG_LOCK                = $2  /* lock gadget from Magellan */
CONST ETG_MUI                 = $4  /* MUI prefs gadget */
CONST ETG_POPUP               = $8  /* popup menu gadget */
CONST ETG_SNAPSHOT            = $10 /* MUI snapshot gadget */
CONST ETG_JUMP                = $20 /* MUI screen jump gadget */

/* Extra gadget ID's */
CONST ETI_Dummy               = $FFD0 /* you can change this base with WA_ExtraGadgetsStartID! */
CONST ETI_Iconify             = ETI_Dummy
CONST ETI_Lock                = ETI_Dummy + 1
CONST ETI_MUI                 = ETI_Dummy + 2
CONST ETI_PopUp               = ETI_Dummy + 3
CONST ETI_Snapshot            = ETI_Dummy + 4
CONST ETI_Jump                = ETI_Dummy + 5

/* for use with custom ETI_Dummy base... */
CONST ETD_Iconify           =  0
CONST ETD_Lock              =  1
CONST ETD_MUI               =  2
CONST ETD_PopUp             =  3
CONST ETD_Snapshot          =  4
CONST ETD_Jump              =  5

CONST SI_Dummy                = $8000000

/* Window border size */
CONST SI_BorderTop            = SI_Dummy + 1
CONST SI_BorderTopTitle       = SI_Dummy + 2 /* when you want a window with title/titlebar gadgets */
CONST SI_BorderLeft           = SI_Dummy + 3
CONST SI_BorderRight          = SI_Dummy + 4 /* std size of window border */
CONST SI_BorderRightSize      = SI_Dummy + 5 /* border with size gadgets */
CONST SI_BorderBottom         = SI_Dummy + 6
CONST SI_BorderBottomSize     = SI_Dummy + 7
CONST SI_ScreenTitlebarHeight = SI_Dummy + 8 /* real height of screen titlebar (no need to add 1 pixel there!)
                                               ** please use this instead of reading from struct Screen !!!*/

/* Titlebar gadgets positions/sizes */
CONST SI_RightPropWidth       = SI_Dummy + 10
CONST SI_BottomPropHeight     = SI_Dummy + 11
CONST SI_RightArrowBox        = SI_Dummy + 12 /* space used by arrows on right titlebar */
CONST SI_BottomArrowBox       = SI_Dummy + 13

/* window action methods */

CONST WAC_DUMMY                       = $0001
CONST WAC_HIDEWINDOW                  = WAC_DUMMY
CONST WAC_SHOWWINDOW                  = WAC_DUMMY + 1
CONST WAC_SENDIDCMPCLOSE              = WAC_DUMMY + 2
CONST WAC_MOVEWINDOW                  = WAC_DUMMY + 3
CONST WAC_SIZEWINDOW                  = WAC_DUMMY + 4
CONST WAC_CHANGEWINDOWBOX             = WAC_DUMMY + 5
CONST WAC_WINDOWTOFRONT               = WAC_DUMMY + 6
CONST WAC_WINDOWTOBACK                = WAC_DUMMY + 7
CONST WAC_ZIPWINDOW                   = WAC_DUMMY + 8
CONST WAC_MOVEWINDOWINFRONTOF         = WAC_DUMMY + 9
CONST WAC_ACTIVATEWINDOW              = WAC_DUMMY + 10

/* V51 */
CONST WAC_MAXIMIZEWINDOW              = (WAC_DUMMY + 11)
CONST WAC_MINIMIZEWINDOW              = (WAC_DUMMY + 12)
CONST WAC_RESTOREINITIALSIZEPOS       = (WAC_DUMMY + 13)
CONST WAC_OPENMENU                    = (WAC_DUMMY + 14)
CONST WAC_FAMILYTOFRONT               = (WAC_DUMMY + 15)
CONST WAC_FAMILYTOBACK                = (WAC_DUMMY + 16)

/* window action tags */

CONST WAT_DUMMY                       = TAG_USER
CONST WAT_MOVEWINDOWX                 = WAT_DUMMY + 1
CONST WAT_MOVEWINDOWY                 = WAT_DUMMY + 2
CONST WAT_SIZEWINDOWX                 = WAT_DUMMY + 3
CONST WAT_SIZEWINDOWY                 = WAT_DUMMY + 4
CONST WAT_WINDOWBOXLEFT               = WAT_DUMMY + 5
CONST WAT_WINDOWBOXTOP                = WAT_DUMMY + 6
CONST WAT_WINDOWBOXWIDTH              = WAT_DUMMY + 7
CONST WAT_WINDOWBOXHEIGHT             = WAT_DUMMY + 8
CONST WAT_MOVEWBEHINDWINDOW           = WAT_DUMMY + 9
CONST WAT_ACTIVATEWINDOW              = WAC_DUMMY + 10



/* window transparency */

OBJECT transparencymessage
   layer:PTR TO layer      /* the layer you're asked to provide transparency for */
   region:PTR TO region     /* create transparency in this region */
   newbounds:PTR TO rectangle  /* current layer boundaries */
   oldbounds:PTR TO rectangle  /* old layer boundaries, useful after layer resize */
ENDOBJECT

/* TransparencyControl tags and methods */
CONST TRANSPCONTROLMETHOD_INSTALLREGION      =   $1
/* Installs a new region, requires that you pass TRANSPCONTROL_REGION in tags. Setting this tag
** to NULL or not passing it at all removes currently installed. Passing TRANSPCONTROL_OLDREGION
** will write old region address to storagePtr passed in tag->ti_Data. Installing a region removes
** regionhook!
*/

CONST TRANSPCONTROLMETHOD_INSTALLREGIONHOOK   =  $2
/* Similar to TRANSPCONTROLMETHOD_INSTALLREGION */

CONST TRANSPCONTROLMETHOD_UPDATETRANSPARENCY   = $3
/* Calls your transparency hook to allow you to change the transparency whenever you want.
** This has no effect with transparency region installed.
*/

CONST TRANSPCONTROL_DUMMY            = TAG_USER
CONST TRANSPCONTROL_REGION           = TRANSPCONTROL_DUMMY + 1
CONST TRANSPCONTROL_REGIONHOOK       = TRANSPCONTROL_DUMMY + 2
CONST TRANSPCONTROL_OLDREGION        = TRANSPCONTROL_DUMMY + 3
CONST TRANSPCONTROL_OLDREGIONHOOK    = TRANSPCONTROL_DUMMY + 4

